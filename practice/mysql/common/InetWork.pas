unit InetWork;

interface

uses
  Windows, Sysutils, Classes, WinINet, SyncObjs, FuncUtil, crc;

//{$DEFINE _USE_SEND_REQUEST_EX_}

type
  TOnOperateException = procedure (Sender: TObject; E: Exception) of Object;
  TOnOperateStatus = procedure (Sender: TObject; StatusText: string) of Object;
  TOnOperateStart = procedure (Sender: TObject; MaxProgress: Int64) of Object;
  TOnOperateProgress = procedure (Sender: TObject; Progress: Int64) of Object;
  TOnOperationComplete = TNotifyEvent;
  
  TSyncCallType = (scNone, scException, scStatus, scStart,
    scProgress, scComplete);

  TInetAccessType = (iaPreConfig, iaDirect, iaProxy, iaPreConfigWithoutAutoProxy);

  TInetOption = (oiASync, oiFromCache, oiOffLine);
  TInetOptions = set of TInetOption;

  TConnectionOption = (ouExistsConnect, ouHyperLink, ouIgnorCertCNInvalid,
    ouIgnorCertDataInvalid, ouIgnorRedirectToHttp, ouIgnorRedirectToHttps,
    ouKeepConnection, ouNeedFile, ouNoAuth, ouNoAutoRedirect, ouNoCacheWrite,
    ouNoCookies, ouNoUI, ouFTPPassive, ouPragmaNoCache, ouRawData, ouReload,
    ouReSynchronize, ouSecure);
  TConnectionOptions = set of TConnectionOption;

  TINetVerbType = ( vbGet, vbPut );
       

  EInvalidURL = class(Exception)
  public
    constructor Create(URL: string);
  end;

  EInvalidServiceType = class(Exception)
  public
    constructor Create(Service: string);
  end;

  EHTTPRequestError = class(Exception)     
  public
    constructor Create(ResponeCode: Integer; ResponeText: string);
  end;
  
  TInet = class(TThread)
  private
    m_DownLock: TCriticalSection;
    m_hInet: HINTERNET;     
    m_hConnection: HINTERNET;
    m_hDataInetHandle: HINTERNET;
    m_boNotifySync: Boolean;
    m_boOperating: Boolean;
    m_boAborting: Boolean;
    m_boConnectionClosed: Boolean;
    m_boASyncRequestComplete: Boolean;
    m_boCompleted: Boolean;
    m_btInetAccessType: TInetAccessType;   
    m_btVerb: TINetVerbType;
    m_InetOptions: TInetOptions;
    m_dwConnectTimeOut: DWord;
    m_dwRecvTimeOut: DWord;
    m_dwStartTick: DWord;
    m_dwCallBackSleep: DWord;
    m_dwDataCRC: DWord;
    m_nCompletedSize: Int64;
    m_nTotalSize: Int64;
    m_ASyncOpenINetResult: TInternetAsyncResult;
    m_sUrl: string;
    m_sWorkUrl: string;
    FAgent: string;
    m_WorkStream: TStream;
    m_pNotifyParam: Pointer;
    m_btSyncCallType: TSyncCallType;
    FOnException: TOnOperateException;
    FOnStatus: TOnOperateStatus;
    FOnDownloadStart: TOnOperateStart;
    FOnDownloadProgress: TOnOperateProgress;
    FOnDownloadComplete: TOnOperationComplete;
    procedure CreateInetHandle;
    procedure ReadINetData(AStream: TStream);
    procedure WriteINetData(AStream: TStream);
    procedure SetInetOption(hInet: HINTERNET; Option: DWord; var Data;
      const DataSize: DWord);
  private
    procedure CallNotify(CallType: TSyncCallType; CallParam: Pointer);
    procedure SyncCallNotify();
    function GetIsOperating: Boolean;
    function GetOperationTick: DWord;
    function GetBytesPerSecond: DWord;
    function GetEstimatedRemainTick: DWord;
    procedure CannotSetupPropertyAfterHandleCreated(Handle: HINTERNET);
    procedure SetInetAccessType(const Value: TInetAccessType);
    procedure SetInetOptions(const Value: TInetOptions);
    procedure SetConnectTimeOut(const Value: DWord);
    procedure SetRecvTimeOut(const Value: DWord);
    function ReadINetFile(var Buf; SizeToRead: DWord): DWord;
    function ReadINetASyncFile(var Buf; SizeToRead: DWord): DWord;
  protected
    procedure CreateHandles();virtual;
    procedure CloseHandles;virtual;
    procedure SetInetStatusCallBack;virtual;
    procedure ParseURL(const AURL: string);virtual;
    procedure CreateConnection();virtual;abstract;
    procedure ConnectionCreated(hCon: HINTERNET);virtual;abstract;
    procedure SendRequest();virtual;
    procedure QueryRequestInfo;virtual;
    procedure SeekingRequest();virtual;
    procedure CheckRequestRespone();virtual;
    procedure QueryDataAvailable;virtual;
    procedure EndRequest();virtual;
    procedure ReadyForASyncRequest();virtual;
    procedure ASyncInetRequestComplete(InetASyncResult: TInternetAsyncResult);virtual;
    procedure CheckASyncCompleteCode(const FnName: string);
    procedure WinINetASyncStatusNotify(const StatusText: string);
  protected
    function GetLastWinINetErrorString(dwErrorNo: DWord): string;
    procedure ThrowLastWinINetError(const fnName: string);
    procedure ASyncRequestCompleteWithOutHandle();
    procedure WinINetOperate(AStream: TStream);
    procedure Execute();override;
  public
    constructor Create();reintroduce;virtual;
    destructor Destroy();override;

    procedure Get(URL: string; Stream: TStream);virtual;
    procedure Put(URL: string; Stream: TStream; ASize: Int64 = 0);virtual;
    procedure Cancel();
    procedure Terminate();

    property CallbackSleep: DWord read m_dwCallBackSleep write m_dwCallBackSleep;
    property InetAccessType: TInetAccessType read m_btInetAccessType write SetInetAccessType;
    property InetOptions: TInetOptions read m_InetOptions write SetInetOptions default[];
    property ConnectTimeOut: DWord read m_dwConnectTimeOut write SetConnectTimeOut;
    property RecvTimeOut: DWord read m_dwRecvTimeOut write SetRecvTimeOut;
    property Operating : Boolean read GetIsOperating;
    property CompletedSize: Int64 read m_nCompletedSize;
    property TotalSize: Int64 read m_nTotalSize;
    property OperationTick: DWord read GetOperationTick;
    property BytesPerSecond: DWord read GetBytesPerSecond;
    property EstimatedRemainTick: DWord read GetEstimatedRemainTick;
    property Completed: Boolean read m_boCompleted;
    property DataCRC: DWord read m_dwDataCRC;
    property Agent: string read FAgent write FAgent;
    property NotifySync: Boolean read m_boNotifySync write m_boNotifySync;

    property OnException: TOnOperateException read FOnException write FOnException;
    property OnStatus: TOnOperateStatus read  FOnStatus write FOnStatus;
    property OnWorkStart: TOnOperateStart read FOnDownloadStart write FOnDownloadStart;
    property OnWorkProgress: TOnOperateProgress read FOnDownloadProgress write FOnDownloadProgress;
    property OnWorkComplete: TOnOperationComplete read FOnDownloadComplete write FOnDownloadComplete;
  end;

  TINetConnection = class(TInet)
  private                         
    m_sServiceType: string;
    m_sHost: string;
    m_nPort: Integer;
    m_sParams: string;
    m_nDefaultPort: Integer;
    FUserName: string;
    FPassWord: string;
    m_ConnectionOptions: TConnectionOptions;
  private
    procedure SetConnectionOptions(const Value: TConnectionOptions);
    function MakeConnectionFlags(): DWord;
    procedure SetUserName(const Value: string);
    procedure SetPassWord(const Value: string);
  protected
    procedure ParseURL(const AURL: string);override;
    procedure CheckRequestRespone();override;
    procedure CreateConnection();override;
    procedure ConnectionCreated(hCon: HINTERNET);override;
    procedure WaitCreateHandle(var hInetHandle: HINTERNET);
    function GetServiceType(): Integer;
  public
    property ConnectionOptions: TConnectionOptions read m_ConnectionOptions write SetConnectionOptions default [];
    property DefaultPort: Integer read m_nDefaultPort write m_nDefaultPort;
    property UserName: string read FUserName write SetUserName;
    property PassWord: string read FPassWord write SetPassWord;
  end;

  TInetURL = class(TINetConnection)
  protected
    procedure CreateConnection();override;
  end;

  TInetHttpRequest = class(TInetConnection)
  private
    m_hRequest: HINTERNET;
    m_sHTTPVersion: string;
    m_sReferURL: string;
    m_sAcceptType: string;    
    m_sAcceptTypeStr: string;
    m_pAcceptTypeStr: LPSTR;
    m_pOptionalData: Pointer;
    m_nOptionalSize: Integer;
    procedure SetHTTPVersion(const Value: string);
    procedure SetReferURL(const Value: string);
    procedure SetAcceptType(const Value: string);
    procedure MakeRequestHeaderBuf(InBuf: INTERNET_BUFFERSA);
  protected                           
    procedure CreateHandles();override;
    procedure CloseHandles;override;
    procedure CreateRequest();
    procedure RequestCreated(hReq: HINTERNET);
    procedure SendRequest();override;
    procedure SeekingRequest();override;
    procedure EndRequest();override;
  public
    constructor Create();override;

    property Version: string read m_sHTTPVersion write SetHTTPVersion;
    property ReferURL: string read m_sReferURL write SetReferURL;
    property AcceptType: string read m_sAcceptType write SetAcceptType;
  end;

implementation


{ Call back Functions }

function GetWinInetStatusString(UrlDown: TInet;
  const dwInternetStatus: DWord; const lpvStatusInformation: Pointer;
  const dwStatusInformationLength: DWord): string;
begin
  case dwInternetStatus of
    INTERNET_STATUS_CLOSING_CONNECTION: Result := '即将断开与服务器的连接';
    INTERNET_STATUS_CONNECTED_TO_SERVER: Result := '已成功连接到服务器';
    INTERNET_STATUS_CONNECTING_TO_SERVER: Result := '正在连接服务器';
    INTERNET_STATUS_CONNECTION_CLOSED: Result := '已断开与服务器的连接';
    INTERNET_STATUS_INTERMEDIATE_RESPONSE: Result := '已从服务器接受到返回的状态码';
    INTERNET_STATUS_NAME_RESOLVED: Result := '解析域名成功';
    INTERNET_STATUS_RECEIVING_RESPONSE: if UrlDown.m_nCompletedSize = 0 then Result := '正在等待服务器回应';
    INTERNET_STATUS_REDIRECT: Result := '重定向到:' + PChar(lpvStatusInformation);
//    INTERNET_STATUS_REQUEST_COMPLETE: Result := '异步请求已完成';
    INTERNET_STATUS_REQUEST_SENT: Result := '发送请求数据成功';
    INTERNET_STATUS_RESOLVING_NAME: Result := '正在解析:' + PChar(lpvStatusInformation);
    INTERNET_STATUS_RESPONSE_RECEIVED: if UrlDown.m_nCompletedSize = 0 then Result := '已从服务器收到请求回应';
    INTERNET_STATUS_SENDING_REQUEST: Result := '正在发送请求数据';
    INTERNET_STATUS_STATE_CHANGE: Result := '状态已改变';
  end;
end;

procedure WinINetInternetStatusCallBack(const hInternet: HINTERNET;
  const lpContext: Pointer; const dwInternetStatus: DWord;
  const lpvStatusInformation: Pointer; const dwStatusInformationLength: DWord);
  stdcall;
var
  UrlDown: TInet;
  sErrDesc: string;     
  ASyncResult: TInternetAsyncResult;
begin
  UrlDown := TInet(lpContext);
  case dwInternetStatus of
{    INTERNET_STATUS_HANDLE_CREATED: begin
      if dwStatusInformationLength >= sizeof(ASyncResult) then
      begin
        ASyncResult := PInternetAsyncResult(lpvStatusInformation)^;
        if ASyncResult.dwError <> ERROR_SUCCESS then
        begin
          UrlDown.m_ASyncOpenINetResult.dwError := ASyncResult.dwError;
        end;
      end;
    end;  }
    INTERNET_STATUS_REQUEST_COMPLETE:begin
      if dwStatusInformationLength >= sizeof(ASyncResult) then
      begin                            
        ASyncResult := PInternetAsyncResult(lpvStatusInformation)^;
        UrlDown.ASyncInetRequestComplete(ASyncResult);
      end
      else begin
        asm nop end;
      end;
    end;
  end;
  
  sErrDesc := GetWinInetStatusString( UrlDown, dwInternetStatus,
    lpvStatusInformation, dwStatusInformationLength );
  if sErrDesc <> '' then
  begin
    UrlDown.WinINetASyncStatusNotify( sErrDesc );
  end;
//  Sleep( 0 );
end;

{ TUrlDown }

procedure TInet.Cancel;
begin
  try
    m_boAborting := True;
  except
  end;
end;

procedure TInet.CannotSetupPropertyAfterHandleCreated(Handle: HINTERNET);
begin
  if Handle <> nil then
    Raise Exception.Create('不能在句柄创建后调整此属性');
end;

procedure TInet.CheckASyncCompleteCode(const FnName: string);
begin
  if m_ASyncOpenINetResult.dwError <> ERROR_SUCCESS then
  begin
    SetLastError( m_ASyncOpenINetResult.dwError );
    ThrowLastWinINetError(FnName);
  end;
end;

constructor TInet.Create;
begin
  Inherited Create(True);
  m_DownLock := TCriticalSection.Create;
  m_dwCallBackSleep := INFINITE;
  m_dwConnectTimeOut := INFINITE;
  m_dwRecvTimeOut := INFINITE;
  m_boNotifySync := True;
  FAgent := 'WinInet Component';
  Resume();
end;

procedure TInet.CreateHandles;
begin
  CreateInetHandle();
                    
  if m_boAborting then Exit;

  SetInetStatusCallBack();

  if m_boAborting then Exit;

  CreateConnection();

  if m_boAborting then Exit;

  ConnectionCreated(m_hConnection);
end;

destructor TInet.Destroy;
begin
  Cancel();
  m_DownLock.Free;
  inherited Destroy;
end;

procedure TInet.Get(URL: string; Stream: TStream);
begin
  m_DownLock.Enter();
  try
    if Operating then
      raise Exception.Create('操作正在进行中');
    m_sUrl := URL;
    m_WorkStream := Stream;
    m_boOperating := True;
    m_boCompleted := False;
    m_btVerb := vbGet;
  finally
    m_DownLock.Leave();
  end;
end;

procedure TInet.EndRequest;
begin

end;

procedure TInet.Execute;
var
  Stream: TStream;
begin
  while not Terminated do
  begin
    Sleep( 16 );

    if m_boOperating then
    begin
      m_sWorkUrl := m_sUrl;
      Stream := m_WorkStream;

      m_dwStartTick := GetTickCount();
      m_nCompletedSize := 0;
      m_boAborting := False;
      try          
        try
          WinINetOperate( Stream );
        except
          on E: Exception do
          begin
            CallNotify(scException, E);
          end;
        end;
      finally
        m_boOperating := False;
        m_sWorkUrl := '';
      end;
    end;
  end;
end;

function TInet.GetBytesPerSecond: DWord;
var
  dwTick: DWord;
begin
  dwTick := OperationTick;
  if dwTick < 1000 then
  begin
    Result := CompletedSize;
  end
  else begin
    Result := Round(CompletedSize / dwTick * 1000);
  end;
end;

function TInet.GetOperationTick: DWord;
begin
  Result := GetTickCount() - m_dwStartTick;
end;

function TInet.GetEstimatedRemainTick: DWord;
var
  dwTick: Integer;
begin
  dwTick := OperationTick;
  if (m_nCompletedSize = 0) or (dwTick = 0) then
  begin
    Result := INFINITE;
  end
  else begin
    Result := Round((m_nTotalSize - m_nCompletedSize) / (m_nCompletedSize/dwTick));
  end;
end;

function TInet.GetIsOperating: Boolean;
begin
  Result := m_boOperating;
end;

function TInet.GetLastWinINetErrorString(dwErrorNo: DWord): string;
var
  dwLen: DWord;
  Buf: array [0..1024] of Char;
begin
  dwLen := sizeof(Buf)-1;
  if InternetGetLastResponseInfo( dwErrorNo, Buf, dwLen ) then
  begin
    Result := StrPas(Buf);
    if Result = '' then
    begin
      Result := SysErrorMessage(dwErrorNo);
    end;
    Exit;
  end;
  if (GetLastError() = ERROR_INSUFFICIENT_BUFFER) and (dwLen > 0) then
  begin
    SetLength( Result, dwLen );
    if not InternetGetLastResponseInfo( dwErrorNo, @Result[1], dwLen ) then
      Result := ''; 
    if Result = '' then
    begin
      Result := SysErrorMessage(dwErrorNo);
    end;
  end;
end;

procedure TInet.ParseURL(const AURL: string);
begin

end;

procedure TInet.Put(URL: string; Stream: TStream; ASize: Int64);
begin
  Raise Exception.Create('尚未实现此功能');
end;

procedure TInet.SyncCallNotify;
begin
  case m_btSyncCallType of
    scNone: ;
    scException: if @FOnException <> nil then FOnException( Self, Exception(m_pNotifyParam) );
    scStatus: if @FOnStatus <> nil then FOnStatus( Self, PString(m_pNotifyParam)^ );
    scStart: if @FOnDownloadStart <> nil then FOnDownloadStart( Self, PInt64(m_pNotifyParam)^ );
    scProgress: if @FOnDownloadProgress <> nil then FOnDownloadProgress( Self, PInt64(m_pNotifyParam)^ );
    scComplete: if @FOnDownloadComplete <> nil then FOnDownloadComplete(Self);
  end;
end;

procedure TInet.Terminate;
begin
  Cancel();
  Inherited ;
  WaitFor();
end;

procedure TInet.CloseHandles;
begin          
  if m_hConnection <> nil then
  begin
    InternetCloseHandle( m_hConnection );
    m_hConnection := nil;
  end;
  if m_hInet <> nil then
  begin
    InternetCloseHandle(m_hInet);
    m_hInet := nil;
  end;
  m_hDataInetHandle := nil;
end;

function TInet.ReadINetASyncFile(var Buf; SizeToRead: DWord): DWord;
var
  IBuffers: INTERNET_BUFFERS;
begin
  ReadyForASyncRequest();
  
  IBuffers.dwStructSize := sizeof(IBuffers);
  IBuffers.Next := nil;
  IBuffers.lpcszHeader := nil;
  IBuffers.dwHeadersLength := 0;
  IBuffers.dwHeadersTotal := 0;
  IBuffers.lpvBuffer := @Buf;
  IBuffers.dwBufferLength := SizeToRead;
  IBuffers.dwBufferTotal := 0;
  IBuffers.dwOffsetLow := 0;
  IBuffers.dwOffsetHigh := 0;

  if not InternetReadFileEx(m_hDataInetHandle, @IBuffers, SizeToRead, DWord(Self)) then
  begin
    if GetLastError() = ERROR_IO_PENDING then
    begin   
      while not m_boAborting and not m_boConnectionClosed do
      begin
        Sleep( 16 );
        if m_boASyncRequestComplete then
        begin
          CheckASyncCompleteCode( 'InternetReadFileEx' );
          break;
        end;
      end;
    end
    else begin     
      ThrowLastWinINetError('InternetReadFileEx');
    end;
  end;

  Result := IBuffers.dwBufferLength;
end;

procedure TInet.ReadINetData(AStream: TStream);
const
  ReadBufferSize = 8192;
var
  dwBytesReaded: Cardinal;
  Buf: PChar;
begin
  m_dwDataCRC := $FFFFFFFF;
  
  GetMem( Buf, ReadBufferSize );
  try
    while not m_boAborting and not m_boConnectionClosed do
    begin
      if oiAsync in m_InetOptions then
        dwBytesReaded := ReadInetASyncFile(Buf^, ReadBufferSize)
      else dwBytesReaded := ReadINetFile(Buf^, ReadBufferSize);
      if m_boAborting or m_boConnectionClosed then
        break;
      if dwBytesReaded = 0 then
      begin
        if m_nCompletedSize >= m_nTotalSize then
        begin
          CallNotify(scComplete, nil);
        end;
        break;
      end;
      Inc(m_nCompletedSize, dwBytesReaded);
      m_dwDataCRC := crc32( m_dwDataCRC, @Buf[0], dwBytesReaded );
      AStream.Write(Buf[0], dwBytesReaded);
      CallNotify(scProgress, @m_nCompletedSize);
    end;
  finally
    FreeMem( Buf );
  end;

  m_dwDataCRC := not m_dwDataCRC;
end;

function TInet.ReadINetFile(var Buf; SizeToRead: DWord): DWord;
var
  dwBytesAvailable: Cardinal;
begin
  while not InternetReadFile(m_hDataInetHandle, @Buf, SizeToRead, dwBytesAvailable) do
  begin
    if GetLastError = ERROR_IO_PENDING then
    begin
      if m_boAborting or m_boConnectionClosed then
        break;
      Sleep(16);
      continue;
    end;
    ThrowLastWinINetError('InternetReadFile');
  end;
  Result := dwBytesAvailable;
end;

procedure TInet.ReadyForASyncRequest;
begin
  m_ASyncOpenINetResult.dwResult := 0;
  m_ASyncOpenINetResult.dwError := ERROR_SUCCESS;
  m_boASyncRequestComplete := False;
end;

procedure TInet.CheckRequestRespone;
begin
end;

procedure TInet.QueryRequestInfo;
var
  dwPramaSize: Cardinal;
  dwIndex: Cardinal;
  Buf: array [0..255] of Char;
begin
  dwIndex := 0;
  dwPramaSize := sizeof(Buf) - 1;
  if not HttpQueryInfo(m_hDataInetHandle, HTTP_QUERY_CONTENT_LENGTH, @Buf[0],
    dwPramaSize, dwIndex) then
  begin
    if GetLastError() = 12150 then  //当服务器不返回Content-Length的时候为12150错误
      m_nTotalSize := -1
    else ThrowLastWinINetError('HttpQueryInfo');
  end
  else begin
    m_nTotalSize := StrToIntDef(Buf, 0);
  end;
  CallNotify(scStart, @m_nTotalSize);
  m_nCompletedSize := 0;
  CallNotify(scProgress, @m_nCompletedSize);
end;

procedure TInet.QueryDataAvailable;
var
  dwErrNo: Cardinal;
  dwBytesAvailable: Cardinal;
begin
  while not m_boAborting and not m_boConnectionClosed
  and not InternetQueryDataAvailable(m_hDataInetHandle, dwBytesAvailable, 0, 0) do
  begin
    dwErrNo := GetLastError;
    if dwErrNo = ERROR_IO_PENDING then
    //正在获取数据
    begin
      Sleep(1);
      continue;
    end;
    if dwErrNo = ERROR_NO_MORE_FILES then
    begin
      raise Exception.Create('文件不存在');
    end;
    ThrowLastWinINetError('InternetQueryDataAvailable');
  end;
end;

procedure TInet.SeekingRequest;
begin

end;

procedure TInet.SendRequest;
begin

end;

procedure TInet.SetConnectTimeOut(const Value: DWord);
begin
  CannotSetupPropertyAfterHandleCreated(m_hConnection);
  m_dwConnectTimeOut := Value;
end;

procedure TInet.SetInetAccessType(const Value: TInetAccessType);
begin
  CannotSetupPropertyAfterHandleCreated(m_hInet);
  m_btInetAccessType := Value;
end;

procedure TInet.SetInetOption(hInet: HINTERNET; Option: DWord; var Data;
  const DataSize: DWord);
begin
  if not InternetSetOption( hInet, Option, @Data, DataSize ) then
  begin
    Raise Exception.CreateFmt('InternetSetOption(%d) Failure[%d]',
      [Option, GetLastError()]);
  end;
end;      

procedure TInet.SetInetOptions(const Value: TInetOptions);
begin
  CannotSetupPropertyAfterHandleCreated(m_hInet);
  m_InetOptions := Value;
end;

procedure TInet.SetInetStatusCallBack;
var
  lpCallBackFn: PFNInternetStatusCallback;
begin
  lpCallBackFn := InternetSetStatusCallback(m_hInet, @WinINetInternetStatusCallBack);
  if Integer(lpCallBackFn) = INTERNET_INVALID_STATUS_CALLBACK then
  begin
    ThrowLastWinINetError('InternetSetStatusCallback');
  end;
end;

procedure TInet.SetRecvTimeOut(const Value: DWord);
begin
  CannotSetupPropertyAfterHandleCreated(m_hConnection);
  m_dwRecvTimeOut := Value;
end;

procedure TInet.CreateInetHandle;
var
  dwAccessType, dwFlags: DWord;
  pAgent: PChar;
begin
  dwAccessType := INTERNET_OPEN_TYPE_PRECONFIG;
  case m_btInetAccessType of
    iaDirect: dwAccessType := INTERNET_OPEN_TYPE_DIRECT;       
    iaProxy: dwAccessType := INTERNET_OPEN_TYPE_PROXY;
    iaPreConfigWithoutAutoProxy: dwAccessType := INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY;
  end;
  
  dwFlags := 0;
  if oiASync in m_InetOptions then dwFlags := dwFlags or INTERNET_FLAG_ASYNC;
  if oiFromCache in m_InetOptions then dwFlags := dwFlags or INTERNET_FLAG_FROM_CACHE;
  if oiOffLine in m_InetOptions then dwFlags := dwFlags or INTERNET_FLAG_OFFLINE;

  if FAgent = '' then pAgent := nil
  else pAgent := PChar(FAgent);
  m_hInet := InternetOpen(pAgent, dwAccessType, nil, nil, dwFlags);
  if m_hInet = nil then
  begin
    raise Exception.CreateFmt('InternetOpen Failure[%d]', [GetLastError]);
  end;  
   
  SetInetOption( m_hInet, INTERNET_OPTION_CONNECT_TIMEOUT, m_dwConnectTimeOut, sizeof(m_dwConnectTimeOut) );
  SetInetOption( m_hInet, INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT, m_dwRecvTimeOut, sizeof(m_dwRecvTimeOut) );
  SetInetOption( m_hInet, INTERNET_OPTION_DATA_RECEIVE_TIMEOUT, m_dwRecvTimeOut, sizeof(m_dwRecvTimeOut) );
end;

procedure TInet.ThrowLastWinINetError(const fnName: string);
var
  dwErrNo: DWord;
  sErrDesc: string;
begin
  dwErrNo := GetLastError();
  sErrDesc := GetLastWinInetErrorString(dwErrNo);
  if sErrDesc <> '' then
    raise Exception.CreateFmt('%s Failure[%d:%s]', [fnName, dwErrNo, sErrDesc])
  else raise Exception.CreateFmt('%s Failure[%d]', [fnName, dwErrNo]);
end;

procedure TInet.WinINetASyncStatusNotify(const StatusText: string);
begin
  CallNotify(scStatus, @StatusText);
end;

procedure TInet.WinINetOperate(AStream: TStream);
begin
  try
    m_nCompletedSize := 0;
    m_nTotalSize := 0;

    ParseURL(m_sWorkURL);

    CreateHandles();
    
    if m_boAborting then Exit;

    SendRequest();
    if m_boAborting then Exit;

    try
      CheckRequestRespone();
      if m_boAborting then Exit;

      QueryDataAvailable();

      if m_boAborting then Exit;

      QueryRequestInfo();

      if m_boAborting then Exit;

      SeekingRequest();

      if m_boAborting then Exit;

      m_dwStartTick := GetTickCount();

      if m_btVerb = vbGet then
        ReadINetData(AStream)
      else WriteINetData(AStream);

      m_boCompleted := True;
    finally
      EndRequest();
    end;
  finally
    CloseHandles();
  end;
end;

procedure TInet.WriteINetData(AStream: TStream);
begin
  Raise Exception.Create('尚未实现此功能');
end;

procedure TInet.ASyncInetRequestComplete(InetASyncResult: TInternetAsyncResult);
begin
  m_boASyncRequestComplete := True;
  m_ASyncOpenINetResult := InetASyncResult;
end;

procedure TInet.ASyncRequestCompleteWithOutHandle;
begin
  Raise Exception.Create('异步请求虽已完成，但没有返回有效的句柄。');
end;

procedure TInet.CallNotify(CallType: TSyncCallType; CallParam: Pointer);
begin
  m_btSyncCallType := CallType;
  m_pNotifyParam := CallParam;
  if m_boNotifySync then
  begin
    Synchronize( SyncCallNotify );     
    if m_dwCallBackSleep <> INFINITE then
      Sleep( m_dwCallBackSleep );
  end
  else begin
    SyncCallNotify();
  end;
end;

{ TINetHttpGet }

procedure TINetConnection.ParseURL(const AURL: string);
var
  S, sURL: string;
  I, nLen: Integer;
  procedure InvalidURL;
  begin
    Raise EInvalidURL.Create(AURL);
  end;
begin
  m_sServiceType := 'HTTP';
  m_sHost := '';
  m_nPort := m_nDefaultPort;

  sURL := AURL;

(*  分析协议头   *)
  nLen := Length(sURL);
  I := 1;
  while I <= nLen do
  begin
    if sURL[I] = ':' then
    begin
      if CompareTextN('HTTP', sURL, I - 1) then
        m_sServiceType := 'HTTP'
      else if CompareTextN('FTP', sURL, I - 1) then
        m_sServiceType := 'FTP'
      else Raise EInvalidServiceType.Create(Copy(sURL, 1, I - 1)); 
      if (sURL[I + 1] <> '/') and (sURL[I + 1] <> '\') then InvalidURL;
      if (sURL[I + 2] <> '/') and (sURL[I + 2] <> '\') then InvalidURL;
      Delete( sURL, 1, I + 2 );
      break;
    end;
    if sURL[I] in ['A'..'Z'] then
    begin
      Inc( I );
      continue;
    end;   
    if sURL[I] in ['a'..'z'] then
    begin
      Inc( I );
      continue;
    end;   
    if sURL[I] in ['0'..'9'] then
    begin
      Inc( I );
      continue;
    end;
    if Byte(sURL[I]) >= $7F then
    begin
      Inc( I );
      continue;
    end;
    break;
  end;

(*   分析地址   *)
  nLen := Length(sURL);
  if nLen < 1 then InvalidURL;
  for I := 1 to nLen do
  begin
    if (sURL[i] = '/') or (sURL[I] = '\') then
    begin
      m_sHost := Copy( sURL, 1, I - 1 );
      Delete( sURL, 1, I - 1 );
      break;
    end;
  end;
  if m_sHost = '' then
  begin
    m_sHost := sURL;
    if m_sHost = '' then InvalidURL;
    sURL := '/';
  end;

(*  从地址中分析端口    *)
  I := Pos(':', m_sHost);
  if I = 1 then InvalidURL;
  if I > 1 then
  begin
    nLen := Length(m_sHost);
    S := Copy(m_sHost, I + 1, nLen - 2 );
    Delete( m_sHost, I, nLen - I );
    I := StrToIntDef(S, -1);
    if I < 0 then InvalidURL;
    m_nPort := I;
  end;

  m_sParams := sURL;
end;

procedure TINetConnection.CheckRequestRespone;
var
  dwPramaSize: Cardinal;
  dwIndex: Cardinal;
  Buf: array [0..255] of Char;
  nStatusCode: Integer;
begin
  if m_sServiceType = 'HTTP' then
  begin
    dwIndex := 0;
    dwPramaSize := sizeof(Buf) - 1;
    //HTTP_QUERY_STATUS_TEXT
    if not HttpQueryInfo(m_hDataInetHandle, HTTP_QUERY_STATUS_CODE, @Buf[0],
      dwPramaSize, dwIndex) then
    begin
      ThrowLastWinINetError('TINetConnection.CheckRequestRespone.HttpQueryInfo');
      Exit;
    end;
    nStatusCode := StrToIntDef(Buf, 0);
    if nStatusCode = 200 then Exit;
                                     
    dwPramaSize := sizeof(Buf) - 1;
    if not HttpQueryInfo(m_hDataInetHandle, HTTP_QUERY_STATUS_TEXT, @Buf[0],
      dwPramaSize, dwIndex) then
    begin
      Buf[0] := #0;
    end;
    Raise EHTTPRequestError.Create(nStatusCode, StrPas(Buf));
  end;
end;

procedure TINetConnection.ConnectionCreated(hCon: HINTERNET);
begin
  SetInetOption( hCon, INTERNET_OPTION_CONNECT_TIMEOUT, m_dwConnectTimeOut, sizeof(m_dwConnectTimeOut) );
  SetInetOption( hCon, INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT, m_dwRecvTimeOut, sizeof(m_dwRecvTimeOut) );
  SetInetOption( hCon, INTERNET_OPTION_DATA_RECEIVE_TIMEOUT, m_dwRecvTimeOut, sizeof(m_dwRecvTimeOut) );
end;

procedure TINetConnection.WaitCreateHandle(var hInetHandle: HINTERNET);
var
  dwErrNo: Cardinal;
begin
  dwErrNo := GetLastError;
  if dwErrNo = ERROR_IO_PENDING then
  begin
    while not m_boAborting do
    begin
      Sleep(1);
      if m_boASyncRequestComplete then
      begin
        if m_ASyncOpenINetResult.dwError <> ERROR_SUCCESS then
        begin
          ThrowLastWinINetError('CreateConnection');
        end;
        if (m_ASyncOpenINetResult.dwResult <> 0) then
        begin
          hInetHandle := HINTERNET(m_ASyncOpenINetResult.dwResult);
        end
        else ASyncRequestCompleteWithOutHandle();
        break;
      end;
    end;
  end
  else begin
    ThrowLastWinINetError('CreateConnection');
  end;
end;

procedure TINetConnection.CreateConnection;
var
  dwFlags: DWord;
begin
  ReadyForASyncRequest();

  dwFlags := MakeConnectionFlags();

  m_hConnection := InternetConnect( m_hInet, PChar(m_sHost), m_nPort,
    PChar(FUserName), PChar(FPassWord), GetServiceType(), dwFlags,
    Integer(Self) );
  if m_hConnection = nil then
  begin
    WaitCreateHandle(m_hConnection);
  end;
  
  m_boConnectionClosed := False;
end;

function TINetConnection.GetServiceType: Integer;
begin
  if CompareText(m_sServiceType, 'GOPHER') = 0 then
    Result := INTERNET_SERVICE_GOPHER
  else if CompareText(m_sServiceType, 'FTP') = 0 then
    Result := INTERNET_SERVICE_FTP
  else Result := INTERNET_SERVICE_HTTP;
end;

function TINetConnection.MakeConnectionFlags(): DWord;
begin
  Result := 0;
  
  if ouExistsConnect in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_EXISTING_CONNECT;
  if ouHyperLink in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_HYPERLINK;
  if ouIgnorCertCNInvalid in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_IGNORE_CERT_CN_INVALID;
  if ouIgnorCertDataInvalid in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_IGNORE_CERT_DATE_INVALID;
  if ouIgnorRedirectToHttp in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP;
  if ouIgnorRedirectToHttps in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS;
  if ouKeepConnection in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_KEEP_CONNECTION;
  if ouNeedFile in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_NEED_FILE;
  if ouNoAuth in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_NO_AUTH;
  if ouNoAutoRedirect in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_NO_AUTO_REDIRECT;
  if ouNoCacheWrite in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_NO_CACHE_WRITE;
  if ouNoCookies in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_NO_COOKIES;
  if ouNoUI in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_NO_UI;
  if ouFTPPassive in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_PASSIVE;
  if ouPragmaNoCache in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_PRAGMA_NOCACHE;
  if ouRawData in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_RAW_DATA;
  if ouReload in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_RELOAD;
  if ouReSynchronize in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_RESYNCHRONIZE;
  if ouSecure in m_ConnectionOptions then
    Result := Result or INTERNET_FLAG_SECURE;
end;

procedure TINetConnection.SetConnectionOptions(const Value: TConnectionOptions);
begin
  CannotSetupPropertyAfterHandleCreated(m_hConnection);
  m_ConnectionOptions := Value;
end;

procedure TINetConnection.SetPassWord(const Value: string);
begin
  CannotSetupPropertyAfterHandleCreated(m_hConnection);
  FPassWord := Value;
end;

procedure TINetConnection.SetUserName(const Value: string);
begin                    
  CannotSetupPropertyAfterHandleCreated(m_hConnection);
  FUserName := Value;
end;

{ EInvalidServiceType }

constructor EInvalidServiceType.Create(Service: string);
begin
  Inherited Create( '无效的服务类型：' + Service );
end;

{ EInvalidURL }

constructor EInvalidURL.Create(URL: string);
begin
  Inherited Create( '无效的URL地址：' + URL );
end;

{ TInetURL }

procedure TInetURL.CreateConnection;
var
  dwFlags: DWord;
begin
  ReadyForASyncRequest();

  dwFlags := MakeConnectionFlags();

  m_hConnection := InternetOpenUrl(m_hInet, PChar(m_sWorkUrl), nil, 0, dwFlags, DWord(Self));
  if m_hConnection = nil then
  begin
    WaitCreateHandle(m_hConnection);
  end;
  
  m_hDataInetHandle := m_hConnection;
  m_boConnectionClosed := False;
end;

{ TInetHttpRequest }

procedure TInetHttpRequest.CloseHandles;
begin
  if m_hRequest <> nil then
  begin
    InternetCloseHandle( m_hRequest );
    m_hRequest := nil;
  end;
  inherited;
end;

constructor TInetHttpRequest.Create;
begin
  inherited;
  m_sHTTPVersion := 'HTTP/1.1';
  m_nDefaultPort := 80;
  m_sAcceptType := '*/*';
end;

procedure TInetHttpRequest.MakeRequestHeaderBuf(InBuf: INTERNET_BUFFERSA);
const
  szPostHeader = 'Content-Type: application/x-www-form-urlencoded';
begin
  if m_btVerb = vbPut then
  begin
    InBuf.lpcszHeader := szPostHeader;
    InBuf.dwHeadersLength := Length(szPostHeader);
    InBuf.lpvBuffer := m_pOptionalData;
    InBuf.dwBufferLength := m_nOptionalSize;
  end;
end;

procedure TInetHttpRequest.CreateHandles;
begin
  inherited;
  CreateRequest();
  RequestCreated(m_hRequest);
end;

procedure TInetHttpRequest.CreateRequest;
const
  VerbStr : array [TINetVerbType] of PChar = ( 'GET', 'POST' );
var
  dwFlags: DWord;
begin
  ReadyForASyncRequest();

  dwFlags := MakeConnectionFlags();

  m_sAcceptTypeStr := 'Accept: ' + m_sAcceptType;
  m_pAcceptTypeStr := PChar(m_sAcceptTypeStr);
  m_hRequest := HttpOpenRequest( m_hConnection, VerbStr[m_btVerb], PChar(m_sParams),
    PChar(m_sHTTPVersion), PChar(m_sReferURL), @m_pAcceptTypeStr, dwFlags,
    Integer(Self) );
  if m_hRequest = nil then
  begin
    WaitCreateHandle(m_hRequest);
  end;   
  m_hDataInetHandle := m_hRequest;
end;

procedure TInetHttpRequest.EndRequest;
begin
{$IFDEF _USE_SEND_REQUEST_EX_}
  if not HttpEndRequest( m_hRequest, nil, 0, 0 ) then
  begin
    ThrowLastWinINetError('HttpEndRequest');
  end;
{$ENDIF}
end;

procedure TInetHttpRequest.RequestCreated(hReq: HINTERNET);
begin
  ConnectionCreated(hReq);
end;

procedure TInetHttpRequest.SeekingRequest;
begin
  //TODO: 如果需要支持断点续传，则需要在QueryRequestInfo的时候判断文件的修改时间
  //并在此处关闭现有Request并创建新的Request并发送RANGE: bytes=？？的请求
end;

procedure TInetHttpRequest.SendRequest;
var
  dwErrNo: Cardinal;
  InBuf: INTERNET_BUFFERS;
begin
  FillChar( InBuf, sizeof(InBuf), 0 );
  InBuf.dwStructSize := sizeof(InBuf);
  MakeRequestHeaderBuf(InBuf);

  ReadyForASyncRequest();

{$IFDEF _USE_SEND_REQUEST_EX_}
  if HttpSendRequestEx( m_hRequest, @InBuf, nil, 0, Integer(Self) ) then
  begin
    Exit;
  end;
{$ELSE}
  if HttpSendRequest( m_hRequest, InBuf.lpcszHeader, InBuf.dwHeadersLength,
    InBuf.lpvBuffer, InBuf.dwBufferLength ) then
  begin
    Exit;
  end;
{$ENDIF}

  dwErrNo := GetLastError();
  if dwErrNo <> ERROR_IO_PENDING then
  begin
    ThrowLastWinINetError('HttpSendRequestEx');
  end;

  while not m_boAborting and not m_boConnectionClosed do
  begin
    if m_boASyncRequestComplete then
    begin
      if m_ASyncOpenINetResult.dwError <> ERROR_SUCCESS then
      begin
        ThrowLastWinINetError('HttpSendRequestEx');
      end;
      break;
    end;    
    Sleep(1);
  end;
end;

procedure TInetHttpRequest.SetAcceptType(const Value: string);
begin
  CannotSetupPropertyAfterHandleCreated( m_hRequest );
  m_sAcceptType := Value;
end;

procedure TInetHttpRequest.SetHTTPVersion(const Value: string);
begin
  CannotSetupPropertyAfterHandleCreated( m_hRequest );
  m_sHTTPVersion := Value;
end;

procedure TInetHttpRequest.SetReferURL(const Value: string);
begin
  CannotSetupPropertyAfterHandleCreated( m_hRequest );
  m_sReferURL := Value;
end;

{ EHTTPRequestError }

constructor EHTTPRequestError.Create(ResponeCode: Integer;
  ResponeText: string);
begin
  Inherited CreateFmt('%d %s.', [ResponeCode, ResponeText]);
end;

end.
