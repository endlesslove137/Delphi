unit PipeClient;

interface

uses
  Windows, SysUtils, Classes;

type
  TNamedPipeClientOnError = procedure (Sender: TObject; var ErrorCode: Integer) of object;
  
  TNamedPipeClient = class (TComponent)
  private
    FHandle   : THandle;
    FPipeName : string;
    FActive   : Boolean;
    FTimeOut  : DWord;
    FOnOpen   : TNotifyEvent;
    FOnClose  : TNotifyEvent;
    FOnError  : TNamedPipeClientOnError;
    procedure SetActive(const Value: Boolean);
    procedure SetPipeName(const Value: string); 
    procedure PipeError(nErr: Integer);
    procedure SetTimeOut(const Value: DWord);
  protected
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy();override; 
    procedure Open();
    procedure Close();

    function ReadBuf(var Buf; const BufSize: Integer): Integer;
    function TryReadBuf(var Buf; const BufSize: Integer): Integer;
    function WriteBuf(const Buf; const BufSize: Integer): Integer;
    function GetAvaliableReadSize: Integer;

    property Handle: THandle read FHandle;
  published
    property PipeName: string read FPipeName write SetPipeName;
    property Active: Boolean read FActive write SetActive;
    property TimeOut: DWord read FTimeOut write SetTimeOut;

    property OnOpen : TNotifyEvent read FOnOpen write FOnOpen;
    property OnClose : TNotifyEvent read FOnClose write FOnClose;
    property OnError : TNamedPipeClientOnError read FOnError write FOnError;
  end;

implementation

{ TNamedPipeClient }

procedure TNamedPipeClient.Close;
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

constructor TNamedPipeClient.Create(AOwner: TComponent);
begin
  inherited;
  FHandle := INVALID_HANDLE_VALUE;
  FPipeName := '\\.\pipe\default';
  FTimeOut := NMPWAIT_WAIT_FOREVER;
end;

destructor TNamedPipeClient.Destroy;
begin
  Close();
  inherited;
end;

function TNamedPipeClient.GetAvaliableReadSize: Integer;
begin
  if not FActive then
    Result := 0
  else Result := GetFileSize( FHandle, nil );
end;

procedure TNamedPipeClient.Open;
var
  nErr: Integer;
begin
  if FActive then Exit;
  while True do
  begin
    FHandle := CreateFile( PChar(FPipeName), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0 );
    if FHandle <> INVALID_HANDLE_VALUE then
    begin
      FActive := True;

      if @FOnOpen <> nil then
        FOnOpen( Self );
      break;
    end;

    nErr := GetLastError();
    if nErr <> ERROR_PIPE_BUSY then
    begin
      PipeError( nErr );
      break;
    end;

    if not WaitNamedPipe( PChar(FPipeName), FTimeOut ) then
    begin
      PipeError( GetLastError() );
      break;
    end;
  end;
end;

procedure TNamedPipeClient.PipeError(nErr: Integer);
var
  S: string;
begin
  if @FOnError <> nil then
    FOnError( Self, nErr );
    
  case nErr of
    ERROR_SUCCESS: Exit;
    ERROR_FILE_NOT_FOUND: S := '管道“' + FPipeName + '”不存在。';
    else S := '命名管道错误:' + IntToStr(nErr);
  end;
  Raise Exception.Create( S  )
end;

function TNamedPipeClient.ReadBuf(var Buf; const BufSize: Integer): Integer;
var
  BytesReaded: DWord;
  nErr: Integer;
begin
  Result := -1;
  if not ReadFile( FHandle, Buf, BufSize, BytesReaded, nil ) then
  begin
    nErr := GetLastError();
    case nErr of
      ERROR_NO_DATA: Result := 0;
      else PipeError( nErr );
    end;
  end
  else Result := BytesReaded;
end;

procedure TNamedPipeClient.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    if Value then
      Open()
    else Close();
  end;
end;

procedure TNamedPipeClient.SetPipeName(const Value: string);
begin
  if FActive then
    Raise Exception.Create( '命名管道已被创建' );
  FPipeName := Value;
end;

procedure TNamedPipeClient.SetTimeOut(const Value: DWord);
begin 
  if FActive then
    Raise Exception.Create( '不能在命名管道建立后修改超时时间' );
  FTimeOut := Value;
end;

function TNamedPipeClient.TryReadBuf(var Buf; const BufSize: Integer): Integer;
begin
  if GetFileSize( FHandle, nil ) > 0 then
  begin
    Result := ReadBuf( BUf, BufSize );
  end
  else Result := 0;
end;

function TNamedPipeClient.WriteBuf(const Buf; const BufSize: Integer): Integer;
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
