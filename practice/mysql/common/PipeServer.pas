unit PipeServer;

interface

uses
  Windows, SysUtils, Classes;

type                        
  TNamedPipeServerOnError = procedure (Sender: TObject; var ErrorCode: Integer) Of Object;
  TNamedPipeServer = class(TComponent)
  private
    FHandle   : THandle;
    FPipeName : string;
    FActive   : Boolean;
    FOutBufferSize : DWord;
    FInBufferSize  : DWord;
    FTimeOut       : DWord;     
    FOnOpen   : TNotifyEvent;
    FOnClose  : TNotifyEvent;
    FOnError  : TNamedPipeServerOnError;
    procedure SetPipeName(const Value: string);
    procedure SetActive(const Value: Boolean);
    procedure SetInBufferSize(const Value: DWord);
    procedure SetOutBufferSize(const Value: DWord);
    procedure SetTimeOut(const Value: DWord);
    procedure PipeError(nErr: Integer);
  protected
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy();override;
    procedure Open();
    procedure Close();

    function ReadBuf(var Buf; const BufSize: Integer): Integer;
    function WriteBuf(const Buf; const BufSize: Integer): Integer;
    function GetAvaliableReadSize():Integer;

    property Handle: THandle read FHandle;
  published
    property PipeName: string read FPipeName write SetPipeName;
    property Active: Boolean read FActive write SetActive;
    property InBufferSize: DWord read FInBufferSize write SetInBufferSize;
    property OutBufferSize: DWord read FOutBufferSize write SetOutBufferSize;
    property TimeOut: DWord read FTimeOut write SetTimeOut;  

    property OnOpen : TNotifyEvent read FOnOpen write FOnOpen;
    property OnClose : TNotifyEvent read FOnClose write FOnClose;
    property OnError : TNamedPipeServerOnError read FOnError write FOnError;
  end;

implementation

{ TPiepeServer }

procedure TNamedPipeServer.Close;
begin
  if FActive then
  begin
    FActive := False;
    if @FOnClose <> nil then
      FOnClose( Self );
    CloseHandle( FHandle );
    FHandle := INVALID_HANDLE_VALUE;
  end;
end;

constructor TNamedPipeServer.Create(AOwner: TComponent);
begin
  Inherited;
  FHandle := INVALID_HANDLE_VALUE;
  FPipeName := '\\.\pipe\default';
  FActive := False;
  FInBufferSize := 8192;
  FOutBufferSize := 8192;
  FTimeOut := NMPWAIT_USE_DEFAULT_WAIT;
end;

destructor TNamedPipeServer.Destroy;
begin
  Close();
  inherited;
end;

function TNamedPipeServer.GetAvaliableReadSize: Integer;
begin
  if not FActive then
    Result := 0
  else Result := GetFileSize( FHandle, nil );
end;

procedure TNamedPipeServer.Open;
begin
  if FActive then Exit;
  FHandle := CreateNamedPipe( PChar(FPipeName), PIPE_ACCESS_DUPLEX, PIPE_NOWAIT,
    PIPE_UNLIMITED_INSTANCES, FOutBufferSize, FInBufferSize, FTimeOut, nil );
  if FHandle = INVALID_HANDLE_VALUE then
  begin
    PipeError( GetLastError() );
  end
  else begin
    FActive := True;
    if @FOnOpen <> nil then
      FOnOpen( Self );
  end;
end;

procedure TNamedPipeServer.PipeError(nErr: Integer);
var
  S: string;
begin
  if @FOnError <> nil then
    FOnError( Self, nErr );
    
  case nErr of
    ERROR_SUCCESS: Exit;
    else S := '命名管道错误:' + IntToStr(nErr);
  end;
  Raise Exception.Create( S  )
end;

function TNamedPipeServer.ReadBuf(var Buf; const BufSize: Integer): Integer;
var
  BytesReaded: DWord;
  nErr: Integer;
begin
  Result := -1;
  if not ReadFile( FHandle, Buf, BufSize, BytesReaded, nil ) then
  begin
    nErr := GetLastError();
    case nErr of
      ERROR_NO_DATA,
      ERROR_PIPE_LISTENING: Result := 0;
      else PipeError( nErr );
    end;
  end
  else Result := BytesReaded;
end;

procedure TNamedPipeServer.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    if Value then
      Open()
    else Close();
  end;
end;

procedure TNamedPipeServer.SetInBufferSize(const Value: DWord);
begin
  if FActive then
    Raise Exception.Create( '不能在命名管道建立后修改“读取”缓冲大小' );
  FInBufferSize := Value;
end;

procedure TNamedPipeServer.SetOutBufferSize(const Value: DWord);
begin         
  if FActive then
    Raise Exception.Create( '不能在命名管道建立后修改“写入”缓冲大小' );
  FOutBufferSize := Value;
end;

procedure TNamedPipeServer.SetPipeName(const Value: string);
begin
  if FActive then
    Raise Exception.Create( '命名管道已被创建' );
  FPipeName := Value;
end;

procedure TNamedPipeServer.SetTimeOut(const Value: DWord);
begin                
  if FActive then
    Raise Exception.Create( '不能在命名管道建立后修改超时时间' );
  FTimeOut := Value;
end;

function TNamedPipeServer.WriteBuf(const Buf; const BufSize: Integer): Integer;
var
  BytesWriten: DWord;    
  nErr: Integer;
begin          
  Result := -1;
  if not WriteFile( FHandle, Buf, BufSize, BytesWriten, nil ) then
  begin
    nErr := GetLastError();
    PipeError( nErr );
  end
  else Result := BytesWriten;
end;

end.
