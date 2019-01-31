unit ConsoleApp;

interface

uses
  Windows, SysUtils, Classes;

type
  TOnStdIORead = procedure (Sender: TObject; Data: string) of Object;
  TOnWaitForEvent = procedure (Sender: TObject; UserData: TObject) of Object;
  
  TShowWindowMode = ( swHide, swNormal, swShowMinimized, swShowMaximized, swShowNoActive,
    swShow, swMinimize, swMinNoActive, swShowNA, swRestore, swShowDefault );
  
  TConsoleApplication = class(TComponent)
  private
    FModuleFile: string;
    FWorkDirectory: string;
    FParams: string;
    FShowMode: TShowWindowMode;
    FProcessInfo: TProcessInformation;
    FStdInRead: THandle;
    FStdInWrite: THandle;
    FStdOutRead: THandle;
    FStdOutWrite: THandle;
    FStdErrRead: THandle;
    FStdErrWrite: THandle;
    FSecurityAttrs: TSecurityAttributes;
    FStartupInfo: TStartupInfo;
    FOnStdInRead: TOnStdIORead;
    FOnStdOutRead: TOnStdIORead;
    FOnStdErrRead: TOnStdIORead;
    FOnStartup: TNotifyEvent;
    FOnTerminate: TNotifyEvent;
    procedure CreateStdIO();
    procedure ReleaseStdIO();
    procedure CannotChangeOnStarted();
    procedure SetModuleFile(const Value: string);
    procedure SetWorkDirectory(const Value: string);
    procedure SetStartParams(const Value: string);
    procedure SetShowMode(const Value: TShowWindowMode);
    function GetIsProcessRuning: Boolean;
    function GetExitCode: DWord;
    procedure TestRead(HStdIO: THandle; NotifyEvent: TOnStdIORead);
    procedure CheckIOData();
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy();override;
    function WriteStdIn(Data: string): Integer;
    procedure Start();
    procedure Abort(dwExitCode: DWord);
    procedure WaitFor(CallBack: TOnWaitForEvent; UserData: TObject);
    
    property Runing: Boolean read GetIsProcessRuning;
    property ExitCode: DWord read GetExitCode;
  published
    property ModuleFile: string read FModuleFile write SetModuleFile;
    property WorkDirectory: string read FWorkDirectory write SetWorkDirectory;
    property StartParams: string read FParams write SetStartParams;
    property ShowMode: TShowWindowMode read FShowMode write SetShowMode default swHide;
    
    property OnStdInRead: TOnStdIORead read FOnStdInRead write FOnStdInRead;  
    property OnStdOutRead: TOnStdIORead read FOnStdOutRead write FOnStdOutRead;
    property OnStdErrRead: TOnStdIORead read FOnStdErrRead write FOnStdErrRead;
    property OnStartup: TNotifyEvent read FOnStartup write FOnStartup;
    property OnTerminate: TNotifyEvent read FOnTerminate write FOnTerminate;
  end;

implementation

uses  Forms;

type
  TAppWatchThread = class(TThread)
  private
    { private declarations }
    m_AddProcessLock: TRTLCriticalSection;
    m_ProcProcessLock: TRTLCriticalSection;
    m_NewProcessList: TList;
    m_ProcessList: TList;    
    procedure ResumeNewProcess();
    procedure TestProcess();
    function GetProcessCount: Integer;
  protected
    { protected declarations }
    procedure Execute();override;
  public
    { public declarations }
    constructor Create();reintroduce;
    destructor Destroy();override;

    procedure RemoveApp(App: TConsoleApplication);
    procedure AddApp(App: TConsoleApplication);

    property ProcessCount: Integer read GetProcessCount;
  end;

var
  AppWatchThreadLock: TRTLCriticalSection;
  AppWatchThread: TAppWatchThread;

const
  StdIOBufferSize = 1024;

procedure AddToAppWatchThread(App: TConsoleApplication);
begin     
  EnterCriticalSection( AppWatchThreadLock );
  try
    if AppWatchThread = nil then AppWatchThread := TAppWatchThread.Create;
    AppWatchThread.AddApp( App );   
  finally
    LeaveCriticalSection( AppWatchThreadLock );
  end;
end;

procedure RemoveFreeAppWatchThread(App: TConsoleApplication);
begin
  EnterCriticalSection( AppWatchThreadLock );
  try
    if AppWatchThread <> nil then
    begin
      AppWatchThread.RemoveApp( App );
      if AppWatchThread.ProcessCount <= 0 then
      begin
        AppWatchThread.Terminate;
        AppWatchThread := nil;
      end;
    end;
  finally
    LeaveCriticalSection( AppWatchThreadLock );
  end;
end;

{ TConsoleApplication }

procedure TConsoleApplication.Abort(dwExitCode: DWord);
begin
  if Runing then
  begin
    if not TerminateProcess( FProcessInfo.hProcess, dwExitCode ) then
      Raise Exception.CreateFmt( '无法终止进程[%d]', [GetLastError()] );
  end;
end;

procedure TConsoleApplication.CannotChangeOnStarted;
begin
  if FProcessInfo.hProcess <> 0 then
  begin
    Raise Exception.Create( '不能在进程启动后更改启动数据' );
  end;
end;

procedure TConsoleApplication.CheckIOData;
begin
  if @FOnStdInRead <> nil then TestRead( FStdInRead, FOnStdInRead );
  if @FOnStdOutRead <> nil then TestRead( FStdOutRead, FOnStdOutRead );
  if @FStdErrRead <> nil then TestRead( FStdErrRead, FOnStdErrRead );
end;

constructor TConsoleApplication.Create(AOwner: TComponent);
begin
  inherited;

  CreateStdIO();

  FStartupInfo.cb := sizeof(FStartupInfo);
  FStartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
  FStartupInfo.hStdInput := FStdInRead;
  FStartupInfo.hStdOutput := FStdOutWrite;
  FStartupInfo.hStdError := FStdErrWrite;
end;

destructor TConsoleApplication.Destroy;
begin
  RemoveFreeAppWatchThread( Self );
  ReleaseStdIO();
  if FProcessInfo.hThread <> 0 then
    CloseHandle( FProcessInfo.hThread );
  if FProcessInfo.hProcess <> 0 then
    CloseHandle( FProcessInfo.hProcess );
  inherited;
end;

function TConsoleApplication.GetExitCode: DWord;
var
  dwExitCode: DWord;
begin
  if FProcessInfo.hProcess <> 0 then
  begin
    if GetExitCodeProcess( FProcessInfo.hProcess, dwExitCode ) then
    begin
      if dwExitCode = STILL_ACTIVE then
      begin
        if WaitForSingleObject( FProcessInfo.hProcess, 1 ) = WAIT_TIMEOUT then
          Raise Exception.Create( '进程尚未终止' )
      end;
      Result := dwExitCode;
    end
    else Raise Exception.CreateFmt( '无法获取进程退出代码[%d]', [GetLastError()] );
  end
  else Raise Exception.Create( '尚未启动进程' );
end;

function TConsoleApplication.GetIsProcessRuning: Boolean;
var
  dwExitCode: DWord;
begin
  Result := False;
  if FProcessInfo.hProcess <> 0 then
  begin
    if GetExitCodeProcess( FProcessInfo.hProcess, dwExitCode ) then
    begin
      if dwExitCode = STILL_ACTIVE then
      begin
        if WaitForSingleObject( FProcessInfo.hProcess, 1 ) = WAIT_TIMEOUT then
          Result := True;
      end
      else Result := False;
    end
    else Raise Exception.CreateFmt( '无法获取进程退出代码[%d]', [GetLastError()] );
  end;
end;

procedure TConsoleApplication.ReleaseStdIO;
begin
  CloseHandle( FStdInRead );
  FStdInRead := 0;   
  CloseHandle( FStdInWrite );
  FStdInWrite := 0;
  CloseHandle( FStdOutRead );
  FStdOutRead := 0;
  CloseHandle( FStdOutWrite );
  FStdOutWrite := 0;
  CloseHandle( FStdErrRead );
  FStdErrRead := 0;
  CloseHandle( FStdErrWrite );
  FStdErrWrite := 0;
end;

procedure TConsoleApplication.SetModuleFile(const Value: string);
begin
  CannotChangeOnStarted();
  FModuleFile := Value;
end;

procedure TConsoleApplication.SetShowMode(const Value: TShowWindowMode);
begin        
  CannotChangeOnStarted();
  FShowMode := Value;
  FStartupInfo.wShowWindow := Integer(Value);
end;

procedure TConsoleApplication.SetWorkDirectory(const Value: string);
begin                  
  CannotChangeOnStarted();
  FWorkDirectory := Value;
end;

procedure TConsoleApplication.SetStartParams(const Value: string);
begin              
  CannotChangeOnStarted();
  FParams := Value;
end;

procedure TConsoleApplication.Start;
var
  boResult: Boolean;
begin
  if Runing then
  begin
    Raise Exception.Create( '进程已经启动' );
  end; 
  
  if FProcessInfo.hThread <> 0 then
  begin
    CloseHandle( FProcessInfo.hThread );
    FProcessInfo.hThread := 0;
  end;
  
  if FProcessInfo.hProcess <> 0 then
  begin
    CloseHandle( FProcessInfo.hProcess );
    FProcessInfo.hProcess := 0;
  end;

  boResult := CreateProcess( PChar(FModuleFile),
    PChar('"' + FModuleFile + '" ' + FParams), nil, nil, True,
    CREATE_SUSPENDED, nil, PChar(FWorkDirectory), FStartupInfo, FProcessInfo );
  if not boResult then
  begin
    raise Exception.CreateFmt( '创建进程失败[%d]', [GetLastError()] );
  end;

  AddToAppWatchThread( Self );

  if @FOnStartup <> nil then
    FOnStartup( Self );
end;

procedure TConsoleApplication.TestRead(HStdIO: THandle; NotifyEvent: TOnStdIORead);
var
  Buf: Array[0..StdIOBufferSize] of Char;
  dwBytesAvaliable, dwBytesRead: Cardinal;
begin
  dwBytesAvaliable := GetFileSize( hStdIO, nil );
  if (dwBytesAvaliable > 0) and (dwBytesAvaliable <> INVALID_FILE_SIZE) then
  begin
    if dwBytesAvaliable > StdIOBufferSize then
      dwBytesAvaliable := StdIOBufferSize;
    ReadFile( HStdIO, Buf[0], dwBytesAvaliable, dwBytesRead, nil );
    Buf[dwBytesRead] := #0;
    NotifyEvent( Self, StrPas(Buf) );
  end;
end;

procedure TConsoleApplication.WaitFor(CallBack: TOnWaitForEvent; UserData: TObject);
begin
  while Runing do
  begin
    if @CallBack <> nil then
      CallBack( Self, UserData )
    else if (Application <> nil) and not (Application.Terminated) then
      Application.ProcessMessages()
    else Sleep( 1 );
  end;
  CheckIOData();
end;

function TConsoleApplication.WriteStdIn(Data: string): Integer;
var
  BytesWritten: DWord;
begin
  if WriteFile( FStdInWrite, Data[1], Length(Data), BytesWritten, nil) then
  begin
    FlushFileBuffers( FStdInWrite );
    Result := BytesWritten;
  end
  else Result := 0;
end;

procedure TConsoleApplication.CreateStdIO;
begin  
  FillChar( FSecurityAttrs, SizeOf(FSecurityAttrs), 0);
  FSecurityAttrs.nLength := SizeOf(FSecurityAttrs);
  FSecurityAttrs.lpSecurityDescriptor := nil;
  FSecurityAttrs.bInheritHandle := True;

  if not CreatePipe( FStdInRead, FStdInWrite, @FSecurityAttrs, StdIOBufferSize ) then
    Raise Exception.Create( '无法创建输入管道' );
  if not CreatePipe( FStdOutRead, FStdOutWrite, @FSecurityAttrs, StdIOBufferSize ) then
    Raise Exception.Create( '无法创建输出管道' );
  if not CreatePipe( FStdErrRead, FStdErrWrite, @FSecurityAttrs, StdIOBufferSize ) then
    Raise Exception.Create( '无法创建错误管道' );
end;

{ TAppWatchThread }

procedure TAppWatchThread.AddApp(App: TConsoleApplication);
begin
  EnterCriticalSection( m_AddProcessLock );
  try
    m_NewProcessList.Add( App );
  finally
    LeaveCriticalSection( m_AddProcessLock );
  end;
end;

constructor TAppWatchThread.Create();
begin
  inherited Create( True );
  FreeOnTerminate := True;
  InitializeCriticalSection( m_AddProcessLock );
  InitializeCriticalSection( m_ProcProcessLock );
  m_NewProcessList := TList.Create;
  m_ProcessList := TList.Create;
  Resume();
end;

destructor TAppWatchThread.Destroy;
begin
  m_NewProcessList.Free;
  m_ProcessList.Free;      
  DeleteCriticalSection( m_AddProcessLock );
  DeleteCriticalSection( m_ProcProcessLock );
  inherited;
end;

procedure TAppWatchThread.Execute;
begin
  while not Terminated do
  begin      
    EnterCriticalSection( m_ProcProcessLock );
    try
      Sleep( 1 );
      ResumeNewProcess();
      TestProcess;
    finally
      LeaveCriticalSection( m_ProcProcessLock );
    end;
  end;
end;

function TAppWatchThread.GetProcessCount: Integer;
begin
  EnterCriticalSection( m_ProcProcessLock );
  Result := m_ProcessList.Count + m_NewProcessList.Count;
  LeaveCriticalSection( m_ProcProcessLock );
end;

procedure TAppWatchThread.RemoveApp(App: TConsoleApplication);
var
  nIdx: Integer;
begin
  EnterCriticalSection( m_ProcProcessLock );
  nIdx := m_ProcessList.IndexOf( App );
  if nIdx > -1 then m_ProcessList.Delete( nIdx );   
  nIdx := m_NewProcessList.IndexOf( App );
  if nIdx > -1 then m_NewProcessList.Delete( nIdx );
  LeaveCriticalSection( m_ProcProcessLock );
end;

procedure TAppWatchThread.ResumeNewProcess;
var
  I: Integer;
  App: TConsoleApplication;
begin
  if m_NewProcessList.Count > 0 then
  begin
    EnterCriticalSection( m_AddProcessLock );
    try
      for I := 0 to m_NewProcessList.Count - 1 do
      begin
        App := TConsoleApplication(m_NewProcessList[I]);
        ResumeThread( App.FProcessInfo.hThread );
        m_ProcessList.Add( App )
      end;
      m_NewProcessList.Clear;
    finally
      LeaveCriticalSection( m_AddProcessLock );
    end;
  end;
end;

procedure TAppWatchThread.TestProcess;
var
  I: Integer;       
  App: TConsoleApplication;
begin
  for I := m_ProcessList.Count - 1 downto 0 do
  begin
    App := TConsoleApplication(m_ProcessList[I]);

    App.CheckIOData();
    
    if not App.Runing then
    begin          
      m_ProcessList.Delete( I );   
      if @App.FOnTerminate <> nil then
        App.FOnTerminate( App );
    end;
  end;
end;

Initialization
  InitializeCriticalSection( AppWatchThreadLock );

Finalization
  DeleteCriticalSection( AppWatchThreadLock );

end.
