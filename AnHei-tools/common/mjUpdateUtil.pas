unit mjUpdateUtil;

interface

uses
  Windows, SysUtils, Classes, msxml, SevenZipVCL;
            
ResourceString
  LocalUpdateIndexFile = '.\liveidx';

type  
  TUpdateCommandType = (
    ucNOP,
    ucDownloadFile,
    ucRemoveFile,
    ucRenameFile,
    ucCreateDir,
    ucRemoveDir,
    ucDecompress,       //解压
    ucUpdateGBLib,
    ucGLibAddEmptyTerm, //作废
    ucGLibDelTerm,      //作废
    ucAbortGame,
    ucStartGame,
    ucExecute,
    ucRestartUpdate,
    ucResetUpdateVersion,  //已不再使用
    ucRunScript         //执行脚本
  );

  PTUpdateCommand=^TUpdateCommand;
  TUpdateCommand = record
    Action    : TUpdateCommandType;
    btRsv     : array [1..3] of Byte;
    sSrcName  : string;
    sDestName : string;
    nFlag1    : Integer;
    nFlag2    : Integer;
  end;

  
  TRenovatorOnStatus = procedure (Sender: TObject; const StatusText: string) of Object;
  TRenovatorOnUpdateStart = procedure (Sender: TObject; InstructionCount: Int64) of Object;
  TRenovatorOnUpdateProgress = procedure (Sender: TObject; Process: Int64) of Object;
  TRenovatorOnUpdateComplete = TNotifyEvent;
  TRenovatorOnCommandStart = TRenovatorOnUpdateStart;
  TRenovatorOnCommandProgress = TRenovatorOnUpdateProgress;
  TRenovatorOnCommandComplete = TNotifyEvent;
  
  TMJClientRenovator = class
  private
    m_nLiveIdx: Integer;
    m_LiveIdxStream: TStream;
    m_boCanceled : Boolean;
    m_boUpdating: Boolean;
    m_OnStatus: TRenovatorOnStatus;
    m_OnUpdateStart: TRenovatorOnUpdateStart;
    m_OnUpdateProgress: TRenovatorOnUpdateProgress;
    m_OnUpdateComplete: TRenovatorOnUpdateComplete;
    m_OnCommandStart: TRenovatorOnCommandStart;
    m_OnCommandProgress: TRenovatorOnCommandProgress;
    m_OnCommandComplete: TRenovatorOnCommandComplete;
    m_SevenZIP: TSevenZIP;
    function LastErrorStr(): string;
    function ExecuteProcess(sFile, sParamLine: string; boWaitFor: Boolean;
      nCmdShow: Integer): Boolean;
    function ExecCommand(var Command: TUpdateCommand): Boolean;
    procedure Decompress(const sSrcFile, sBaseDir: string);
    function GetSerisedArchiveSize(sArchiveFile: string): Int64;
    procedure WriteLiveIdx();
  protected
    m_CmdDoc: IXMLDOMDocument;
    function DownloadFile(ServerFile, LocalFile: string; dwCheckCRC: DWord):Boolean;virtual;abstract;
    procedure RestartUpdateProgram();virtual;abstract;
    function RunScript(ScriptFileName: string): Boolean;virtual;abstract;
  protected
    procedure CheckDiskSpace(const nSize: Int64);
  protected
    procedure GBUpdateStart(Sender: TObject; MaxCount: Int64);
    procedure GBUpdateProgress(Sender: TObject; Progress: Int64);
    procedure GBUpdateComplete(Sender: TObject);
    procedure DecompressStart(Sender: TObject; MaxProgress: int64);
    procedure DecompressProgress(Sender: TObject; Filename: Widestring; FilePosArc,FilePosFile: int64);
  protected
    procedure DoStatus(StatusText: string);virtual;
    procedure DoUpdateStart(Max: Int64);virtual;
    procedure DoUpdateProgress(Progress: Int64);virtual;
    procedure DoUpdateComplete();virtual;
    procedure DoCommandStart(Max: Int64);virtual;
    procedure DoCommandProgress(Progress: Int64);virtual;
    procedure DoCommandComplete();virtual;
  public
    constructor Create();virtual;
    destructor Destroy();override;
    procedure RunUpdate;
    procedure CancelUpdate();

    property ComandDocument: IXMLDOMDocument read m_CmdDoc write m_CmdDoc;
    property Updating: Boolean read m_boUpdating write m_boUpdating;
    property OnUpdateStatus: TRenovatorOnStatus read m_OnStatus write m_OnStatus;
    property OnUpdateStart: TRenovatorOnUpdateStart read m_OnUpdateStart write m_OnUpdateStart;
    property OnUpdateProgress: TRenovatorOnUpdateProgress read m_OnUpdateProgress write m_OnUpdateProgress;
    property OnUpdateComplete: TRenovatorOnUpdateComplete read m_OnUpdateComplete write m_OnUpdateComplete;
    property OnCommandStart: TRenovatorOnCommandStart read m_OnCommandStart write m_OnCommandStart;
    property OnCommandProgress: TRenovatorOnCommandProgress read m_OnCommandProgress write m_OnCommandProgress;
    property OnCommandComplete: TRenovatorOnCommandComplete read m_OnCommandComplete write m_OnCommandComplete;
  end;

implementation

uses FuncUtil;

{ TTC2ClientRenovator }

procedure TMJClientRenovator.CancelUpdate;
begin
  m_boCanceled := True;
end;

procedure TMJClientRenovator.WriteLiveIdx;
begin
  m_LiveIdxStream.Position := 0;
  m_LiveIdxStream.Write(m_nLiveIdx, sizeof(m_nLiveIdx));
end;

procedure TMJClientRenovator.CheckDiskSpace(const nSize: Int64);
var
  FreeBytes, TotalBytes: TLargeInteger;
  S: string;
begin
  if not GetDiskFreeSpaceEx(PChar(ExpandFileName('.\')), FreeBytes, TotalBytes, nil) then
  begin
    S := Format('无法获取工作目录空闲空间大小： LastError:%d %s',
      [GetLastError(), SysErrorMessage(GetLastError())] );
    DoStatus(S);
    Raise Exception.Create(S);
  end;
  if FreeBytes < nSize * 2 then
  begin
    S := Format('工作目录空闲空间大小，至少需要%s', [FormatSizeStr(nSize * 2)] );
    DoStatus(S);
    Raise Exception.Create(S);
  end;
end;

constructor TMJClientRenovator.Create;
begin                                 
  m_SevenZIP := TSevenZIP.Create(nil);
  m_CmdDoc := CoDOMDocument.Create;
end;

procedure TMJClientRenovator.Decompress(const sSrcFile, sBaseDir: string);
var
  nRet: Integer;
  S: string;
begin
  m_SevenZIP.SZFileName := sSrcFile;
  m_SevenZIP.ExtrBaseDir := sBaseDir;
  m_SevenZIP.ExtractOptions := m_SevenZIP.ExtractOptions + [ExtractOverwrite];
  m_SevenZIP.OnPreProgress := DecompressStart;
  m_SevenZIP.OnProgress := DecompressProgress;
  nRet := m_SevenZIP.Extract();
  if FAILED(nRet) then
  begin
    S := '解压' + sSrcFile + '失败' + SysErrorMessage(nRet);
    DoStatus( S );
    raise Exception.Create(S);
  end;
end;

procedure TMJClientRenovator.DecompressProgress(Sender: TObject;
  Filename: Widestring; FilePosArc, FilePosFile: int64);
begin
  DoCommandProgress(FilePosArc);
end;

procedure TMJClientRenovator.DecompressStart(Sender: TObject;
  MaxProgress: int64);
begin
  DoCommandStart(MaxProgress);
end;

destructor TMJClientRenovator.Destroy;
begin               
  m_CmdDoc := nil;
  m_SevenZIP.Free;
  inherited;
end;

procedure TMJClientRenovator.DoUpdateComplete;
begin
  if @m_OnUpdateComplete <> nil then
    m_OnUpdateComplete( Self );
end;

procedure TMJClientRenovator.DoUpdateProgress(Progress: Int64);
begin
  if @m_OnUpdateProgress <> nil then
    m_OnUpdateProgress( Self, Progress );
end;

procedure TMJClientRenovator.DoUpdateStart(Max: Int64);
begin
  if @m_OnUpdateStart <> nil then
    m_OnUpdateStart( Self, Max );
end;

function TMJClientRenovator.ExecCommand(var Command: TUpdateCommand): Boolean;
var
  S: string;
begin
  Result := True;
  case Command.Action of
    ucNOP: ;
    ucDownloadFile: Result := DownloadFile( Command.sSrcName, Command.sDestName, Command.nFlag1 );
    ucRemoveFile:begin
      DoStatus( Format('正在删除文件:"%s"', [Command.sDestName]) );
      Result := not FileExists( Command.sDestName ) or DeleteFile( Command.sDestName );
      if not Result then
      begin
        S := '无法删除文件:' + Command.sDestName + ' ' + LastErrorStr();
        DoStatus( S );
        Raise Exception.Create(S);
      end;
    end;                                 
    ucRenameFile:begin
      DoStatus( Format('正在移动文件文件:从"%s"到"%s"', [Command.sSrcName, Command.sDestName]) );
      if FileExists(Command.sSrcName) then
      begin
        Result := RenameFile( Command.sSrcName, Command.sDestName );
        if not Result then
        begin
          S := Format('无法移动文件:'#10'从"%s"'#10'到"%s"',
            [Command.sSrcName, Command.sDestName]);
          S := S + ' ' + LastErrorStr();
          DoStatus( S );
          Raise Exception.Create(S);
        end;
      end;     
    end;
    ucCreateDir:begin    
      DoStatus( Format('正在创建目录:"%s"', [Command.sDestName]) );
      Result := DirectoryExists( Command.sDestName ) or CreateDir( Command.sDestName );
      if not Result then
      begin
        S := '无法创建目录:' + Command.sDestName + ' ' + LastErrorStr();
        DoStatus( S );
        Raise Exception.Create(S);
      end;
    end;
    ucRemoveDir:begin
      DoStatus( Format('正在删除目录:"%s"', [Command.sDestName]) );
      if DirectoryExists( Command.sDestName ) then DeleteDirectory( Command.sDestName );
      if not Result then
      begin
        S := '无法删除目录:' + Command.sDestName + ' ' + LastErrorStr();
        DoStatus( S );
        Raise Exception.Create(S);
      end;
    end;
    ucDecompress: begin
      if DWord(Command.nFlag1) > 1 then   //不使用>0因为在将此字段用于描述原始文件大小之前，此指令的nFlag1的值已经为1
        CheckDiskSpace( Command.nFlag1 + 16 * 1024 * 1024 )
      else CheckDiskSpace( GetSerisedArchiveSize(Command.sSrcName) + 16 * 1024 * 1024 );
      DoStatus( Format('正在解压:"%s"到"%s"', [Command.sSrcName, Command.sDestName]) );
      Decompress(Command.sSrcName, Command.sDestName);
    end;
    ucUpdateGBLib: begin
      Raise Exception.Create('此更新执行在当前程序中无效');
    end;
    ucGLibAddEmptyTerm: ;
    ucGLibDelTerm: ;
    ucAbortGame: ;
    ucStartGame: ;
    ucExecute:begin        
      DoStatus( Format('正在执行:%s %s', [Command.sSrcName, Command.sDestName]) );
      Result := ExecuteProcess( Command.sSrcName, Command.sDestName,
        Command.nFlag1 <> 0, Command.nFlag2 );
      if not Result then
      begin
        S := '无法执行更新:' + Command.sSrcName + ' ' + Command.sDestName
          + ' ' + LastErrorStr();
        DoStatus( S );
        Raise Exception.Create(S);
      end;
    end;
    ucRestartUpdate: begin
      WriteLiveIdx();
      DoStatus( '正在重新启动更新程序' );
      RestartUpdateProgram();
    end;
    ucResetUpdateVersion: ;
    ucRunScript: begin
      DoStatus( '正在执行脚本:' + Command.sSrcName );
      Result := RunScript( Command.sSrcName );
    end
    else begin
      S := '无效的更新指令:' + IntToStr(Integer(Command.Action));
      DoStatus( S );
      Raise Exception.Create(S);
    end;
  end;
end;

function SafeGetAttribute(Element: IXMLDOMElement; AttrName: string;
  Def: OleVariant): OleVariant;
begin
  if Element.attributes.getNamedItem(AttrName) <> nil then
    Result := Element.getAttribute(AttrName)
  else Result := Def;
end;

procedure TMJClientRenovator.RunUpdate;
var
  Nodes: IXMLDOMNodeList;
  I, nMax, nIdx: Integer;
  CmdElement: IXMLDOMElement;
  Command: TUpdateCommand;
begin
  m_boCanceled := False;
  Nodes := m_CmdDoc.documentElement.selectNodes( 'term' );
  nMax := Nodes.length;
  m_LiveIdxStream := TFileStream.Create( LocalUpdateIndexFile, fmOpenReadWrite );
  try
    m_LiveIdxStream.Position := 0;
    m_LiveIdxStream.Read( m_nLiveIdx, sizeof(m_nLiveIdx) );

    m_boUpdating := True;
    DoUpdateStart( nMax );
    for I := 0 to nMax - 1 do
    begin         
      if m_boCanceled then break;

      CmdElement := Nodes.item[I] as IXMLDOMElement;
      nIdx := CmdElement.getAttribute( 'idx' );
      if (nIdx > m_nLiveIdx) or (nIdx = 0) then
      begin
        Command.Action := CmdElement.getAttribute( 'cmd' );
        Command.sSrcName := SafeGetAttribute(CmdElement, 'src', '');
        Command.sDestName := SafeGetAttribute(CmdElement, 'dest', '');
        Command.nFlag1 := SafeGetAttribute(CmdElement, 'flag1', 0);
        Command.nFlag2 := SafeGetAttribute(CmdElement, 'flag2', 0);
        //需要在执行更新之前改变m_nLiveIdx的值，以便于执行重启指令前可以保存liveidx
        if nIdx > 0 then
        begin
          m_nLiveIdx := nIdx;
        end;
        if ExecCommand( Command ) and (nIdx > 0) then
        begin
          WriteLiveIdx();
        end;
      end;
      DoUpdateProgress( I + 1 );
    end;
    if not m_boCanceled then
    begin
      DoUpdateComplete();
    end;
  finally
    m_boUpdating := False;
    m_LiveIdxStream.Free;
    m_LiveIdxStream := nil;
  end;
end;

function TMJClientRenovator.ExecuteProcess(sFile, sParamLine: string;
  boWaitFor: Boolean; nCmdShow: Integer): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  FillChar( StartupInfo, sizeof(StartupInfo), 0 );
  StartupInfo.cb := sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := nCmdShow; 
  Result := CreateProcess( PChar(sFile), PChar('"' + sFile + '" ' + sParamLine),
    nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo );
  if Result then
  begin
    if boWaitFor then
    begin
      while WAIT_TIMEOUT = WaitForSingleObject( ProcessInfo.hProcess, 1000 ) do
      begin
        if m_boCanceled then
          break;
      end;
    end;
    CloseHandle( ProcessInfo.hThread );
    CloseHandle( ProcessInfo.hProcess ); 
  end;
end;

procedure TMJClientRenovator.GBUpdateComplete(Sender: TObject);
begin
  DoCommandComplete()
end;

procedure TMJClientRenovator.GBUpdateProgress(Sender: TObject;
  Progress: Int64);
begin
  DoCommandProgress(Progress);
end;

procedure TMJClientRenovator.GBUpdateStart(Sender: TObject; MaxCount: Int64);
begin
  DoCommandStart(MaxCount);
end;

function TMJClientRenovator.GetSerisedArchiveSize(sArchiveFile: string): Int64;
var
  Sc: TSearchRec;
  sPath: string;
begin
  Result := 0;
  sArchiveFile := ExpandFileName(sArchiveFile);
  sPath := ExtractFilePath(sArchiveFile);
  sArchiveFile := DeleteFileExt(sArchiveFile);
  if FindFirst(sArchiveFile + '*', faAnyFile, Sc) = 0 then
  begin
    repeat
      if (Sc.Name = '.') or (Sc.Name = '..') then
        continue;
      Result := Result + GetFileSize(sPath + '\' + Sc.Name);
    until FindNext(Sc) <> 0;
    FindClose(Sc);
  end;
end;

function TMJClientRenovator.LastErrorStr: string;
begin
  Result := 'LastError:' + IntToStr(GetLastError()) + ' ' + SysErrorMessage(GetLastError());
end;

procedure TMJClientRenovator.DoCommandComplete;
begin
  if @m_OnCommandComplete <> nil then
    m_OnCommandComplete( Self );
end;

procedure TMJClientRenovator.DoCommandProgress(Progress: Int64);
begin
  if @m_OnCommandProgress <> nil then
    m_OnCommandProgress( Self, Progress );
end;

procedure TMJClientRenovator.DoCommandStart(Max: Int64);
begin
  if @m_OnCommandStart <> nil then
    m_OnCommandStart( Self, Max );
end;

procedure TMJClientRenovator.DoStatus(StatusText: string);
begin
  if @m_OnStatus <> nil then
    m_OnStatus( Self, StatusText );
end;


end.
