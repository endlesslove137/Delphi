unit SelectSocket;

interface

uses
  Windows, SysUtils, Classes, WinSock, SockBind;

type
  TSocketErrorEvent = ( eeBind, eeListen, eeAccept, eeRecv, eeSend );

  TCustomSockManager = class;
  
  TAbstractSocket = class
  private
    m_nSocket       : TSocket;
    m_boBlock       : Boolean;
    m_boAvaliable   : Boolean;
    m_boConnected   : Boolean;
    m_boReportWrite : Boolean;
    m_RemoteAddrIn  : TSockAddrIn;  
    m_SockManager   : TCustomSockManager;   
    m_UserData      : TObject;
    function GetRemoteAddress: string;
    function GetRemotePort: Integer;
    procedure SetBlock(const Value: Boolean);
    procedure ErrorEvent(ErrorEvent: TSocketErrorEvent; ErrorCode: Integer);
    function GetRecvCacheSize: Integer;
    function GetSendCacheSize: Integer;
    procedure SetRecvCacheSize(Value: Integer);
    procedure SetSendCacheSize(Value: Integer);    
    function GetRecvLength(): Integer;
  protected
    procedure SetRemoteAddress(const Value: string);
    procedure SetRemotePort(const Value: Integer);
    procedure CanRead();virtual;
    procedure CanWrite();virtual;
  public
    constructor Create(SockManager: TCustomSockManager);virtual;
    destructor Destroy();override;

    procedure Disconnect();virtual;
    function RecvBuffer(var Buf; BufSize: Integer): Integer;
    function SendBuffer(var Buf; BufSize: Integer): Integer;   
                                                     
    property Socket: TSocket read m_nSocket;
    property Connected: Boolean read m_boConnected;
    property RemoteAddress: string read GetRemoteAddress;
    property RemotePort: Integer read GetRemotePort;
    property RemoteAddrIn: TSockAddrIn read m_RemoteAddrIn;
    property Block: Boolean read m_boBlock write SetBlock;
    property SockManager: TCustomSockManager read m_SockManager;
    property RecvCacheSize: Integer read GetRecvCacheSize write SetRecvCacheSize;
    property SendCacheSize: Integer read GetSendCacheSize write SetSendCacheSize;   
    property UserData : TObject read m_UserData write m_UserData;
    property RecvLength: Integer read GetRecvLength;
  end;

  TServerSocket = class(TAbstractSocket);

  TCustomBindSocket = class(TAbstractSocket)
  private
    m_boBinded : Boolean;
    m_SocketBind : TSocketBind;
    procedure SetSocketBind(const Value: TSocketBind);
  protected                         
    function AllocSocket(): Integer;
  public     
    constructor Create(SockManager: TCustomSockManager);override;
    function Bind(): Integer;
    
    property SocketBind: TSocketBind read m_SocketBind write SetSocketBind;
  end;

  TClientSocket = class(TCustomBindSocket)
  private
    m_boOldIsBlock: Boolean;
    m_boConnecting: Boolean;
  protected                     
    procedure CanWrite();override;
  public
    function Connect(): Integer;  
    procedure Disconnect();override;
  end;

  TListenSocket = class(TCustomBindSocket)
  protected
    procedure CanRead();override;
  public
    constructor Create(SockManager: TCustomSockManager);override;
    function Listen(): Integer;
    procedure Accept();
  end;

  TClassOfAbstractSocket = class of TAbstractSocket;

  TSocketEventType = ( seConnected, seDisconnected, seBind, seListen, seAccepted, seSocketError, seRead, seWrite );

  TAcceptedEventParam = record
    NewSocket: TAbstractSocket;
  end;

  TSocketErrorEventParam = record
    ErrorEvent : TSocketErrorEvent;
    ErrorNumber: Integer;
  end;
  
  PSocketEventParam = ^TSocketEventParam;
  TSocketEventParam = record
    case Integer of
      0: (ptr: Pointer;);
      1: (Obj: TObject;);
      2: (Accepted: TAcceptedEventParam;);
      3: (SocketError: TSocketErrorEventParam;);
  end;
  
  TSockManagerOnSocketError = procedure (Sender: TObject; Socket: TAbstractSocket; ErrorEvent: TSocketErrorEvent; 
    var ErrorCode : Integer) of Object;    
  TSockManagerCustomSocketEvent = procedure (Sender: TObject; Socket: TAbstractSocket) of Object;
  TSockManagerOnRead = TSockManagerCustomSocketEvent;   
  TSockManagerOnWrite = TSockManagerCustomSocketEvent;     
  TSockManagerOnConnected = TSockManagerCustomSocketEvent;    
  TSockManagerOnDisconnected = TSockManagerCustomSocketEvent;    
  TSockManagerOnBind = TSockManagerCustomSocketEvent;
  TSockManagerOnListen = TSockManagerCustomSocketEvent;    
  TSockManagerOnAccepted = procedure (Sender: TObject; ListenSocket, Socket: TAbstractSocket) of Object;
    
  TCustomSockManager = class(TComponent)
  private
    m_hSelectThread : THandle;
    m_SocketLock: TRTLCriticalSection;
    m_SocketList: TList;
    m_boBlock : Boolean;
    m_boStoping: Boolean;
    m_boSyncNotification: Boolean;
    m_boUserDrive: Boolean;
    m_dwRecvBufSize: DWord;
    m_dwSendBufSize: DWord;
    m_SocketBind : TSocketBind;
    m_nProcessIndex: Integer;

    m_pSyncNotifyLock: PInteger;        
    m_btEventType: TSocketEventType;
    m_EventSocket: TAbstractSocket;
    m_pEventParam: PSocketEventParam;

    m_OnSocketError : TSockManagerOnSocketError;   
    m_OnSocketRead : TSockManagerOnRead;   
    m_OnSocketWrite : TSockManagerOnWrite;     
    m_OnSocketConnected : TSockManagerOnConnected;    
    m_OnSocketDisconnected: TSockManagerOnDisconnected;    
    m_OnSocketBind : TSockManagerOnBind;  
    m_OnSocketListen: TSockManagerOnListen;  
    m_OnAccepted: TSockManagerOnAccepted;
    function CheckSelectThread():THandle;
    procedure TermiateSelectThread();
    procedure CloseAllSocket();
    procedure ProcessSocketEvents();
    function CreateSocket(ASocketClass: TClassOfAbstractSocket):TAbstractSocket;
    procedure AddToSocketList(ASocket: TAbstractSocket);
    procedure AdjustSocketOptions(ASocket: TAbstractSocket);

    procedure PostSocketEventNotification(EventType: TSocketEventType; Socket: TAbstractSocket; pParam: PSocketEventParam);
    procedure DoSyncSocketEventNotification();     
    procedure DoSocketEventNotification(EventType: TSocketEventType; Socket: TAbstractSocket; pParam: PSocketEventParam);
    procedure CheckClosedSockets;
  protected
    property Block: Boolean read m_boBlock write m_boBlock;
    property RecvBufSize: DWord read m_dwRecvBufSize write m_dwRecvBufSize;
    property SendBufSize: DWord read m_dwSendBufSize write m_dwSendBufSize;
    property SocketBind: TSocketBind read m_SocketBind write m_SocketBind;
    property SyncNotification: Boolean read m_boSyncNotification write m_boSyncNotification;
    property UserDrive: Boolean read m_boUserDrive write m_boUserDrive;
    
    property OnSocketError: TSockManagerOnSocketError read m_OnSocketError write m_OnSocketError;  
    property OnSocketRead : TSockManagerOnRead read m_OnSocketRead write m_OnSocketRead;   
    property OnSocketWrite : TSockManagerOnWrite read m_OnSocketWrite write m_OnSocketWrite;     
    property OnSocketConnected : TSockManagerOnConnected read m_OnSocketConnected write m_OnSocketConnected;    
    property OnSocketDisconnected: TSockManagerOnDisconnected read m_OnSocketDisconnected write m_OnSocketDisconnected;    
    property OnSocketBind : TSockManagerOnBind read m_OnSocketBind write m_OnSocketBind;   
    property OnSocketListen: TSockManagerOnListen read m_OnSocketListen write m_OnSocketListen; 
    property OnAccepted: TSockManagerOnAccepted read m_OnAccepted write m_OnAccepted;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy();override;

    function CreateClientSocket(RemoteAddress: string; RemotePort: Integer):TClientSocket;
    function CreateListenSocket():TListenSocket;  
    (* use for UserDrive is true  *)
    procedure ProcessSockets();
  end;

  TSocketManager = class(TCustomSockManager)
  published               
    property Block;
    property RecvBufSize;
    property SendBufSize;
    property SocketBind;
    property SyncNotification;
    property UserDrive;
    
    property OnSocketError;  
    property OnSocketRead;   
    property OnSocketWrite;     
    property OnSocketConnected;    
    property OnSocketDisconnected;    
    property OnSocketBind;   
    property OnSocketListen; 
    property OnAccepted;
  end;


implementation

procedure InitSockLib;
var
  WSAData: TWSAData;
  nErr: Integer;
begin
  nErr := WSAStartup( $0202, WSAData );
  if nErr <> 0 then
    raise Exception.Create( 'WSAStartup Failure #' + IntToStr(GetLastError()) );
end;

procedure UninitSockLib();
begin
  WSACleanup();
end;

procedure SockManagerSelectRoutine(SockManager: TCustomSockManager);stdcall;
begin
  while not SockManager.m_boStoping do
  begin
    try
      SockManager.ProcessSocketEvents();
    except
      asm nop end;
    end;
    Sleep( 1 );
  end;
  ExitThread( 0 );
end;

{ TAbstractASyncSocket }

procedure TAbstractSocket.CanRead;
begin
  if RecvLength <= 0 then
    Disconnect()
  else m_SockManager.PostSocketEventNotification( seRead, Self, nil );
end;

procedure TAbstractSocket.CanWrite;
begin
  m_SockManager.PostSocketEventNotification( seWrite, Self, nil );
end;

constructor TAbstractSocket.Create;
begin
  m_nSocket := INVALID_SOCKET;
  m_boConnected := False;        
  m_boBlock := True;
  m_boAvaliable := True;
  m_boReportWrite := True;
  m_RemoteAddrIn.sin_family := AF_INET;
  m_SockManager := SockManager;
end;

destructor TAbstractSocket.Destroy;
begin
  Disconnect();
  inherited;
end;

procedure TAbstractSocket.Disconnect;
begin
  if m_boAvaliable  then
  begin
    m_boAvaliable := False;
  end;
  if m_boConnected then
  begin
    m_boConnected := False;     
    m_SockManager.PostSocketEventNotification( seDisconnected, Self, nil );
  end;
  if m_nSocket <> INVALID_SOCKET then
  begin
    closesocket( m_nSocket );
    m_nSocket := INVALID_SOCKET;
  end;
end;

procedure TAbstractSocket.ErrorEvent(ErrorEvent: TSocketErrorEvent; ErrorCode: Integer);
var
  Param: TSocketEventParam;
begin
  Param.SocketError.ErrorEvent := ErrorEvent;
  Param.SocketError.ErrorNumber := ErrorCode;               
  m_SockManager.PostSocketEventNotification( seSocketError, Self, @Param );
  if Param.SocketError.ErrorNumber <> 0 then
  begin
    Disconnect();
  end;
end;

function TAbstractSocket.GetRecvCacheSize: Integer;
var
  nValue, nSize: Integer;
begin
  nSize := sizeof(nValue);
  if getsockopt( m_nSocket, SOL_SOCKET, SO_RCVBUF, @nValue, nSize ) = 0 then
    Result := nValue
  else Result := 0;
end;

function TAbstractSocket.GetRecvLength: Integer;
var
  nErr, nSize: Integer;
begin
  if not m_boConnected then
  begin
    Result := 0
  end
  else begin
    nErr := ioctlsocket( m_nSocket, FIONREAD, nSize );
    if nErr <> 0 then
    begin
      Result := 0;
      nErr := WSAGetLastError();
      if nErr <> WSAEWOULDBLOCK then
      begin
        ErrorEvent( eeRecv, nErr );
      end;
    end
    else Result := nSize;
  end;
end;

function TAbstractSocket.GetRemoteAddress: string;
begin
  Result := inet_ntoa(m_RemoteAddrIn.sin_addr);
end;

function TAbstractSocket.GetRemotePort: Integer;
begin
  Result := htons( m_RemoteAddrIn.sin_port );
end;

function TAbstractSocket.GetSendCacheSize: Integer;
var
  nValue, nSize: Integer;
begin
  nSize := sizeof(nValue);
  if getsockopt( m_nSocket, SOL_SOCKET, SO_SNDBUF, @nValue, nSize ) = 0 then
    Result := nValue
  else Result := 0;
end;

function TAbstractSocket.RecvBuffer(var Buf; BufSize: Integer): Integer;       
var
  nErr: Integer;
begin
  if not m_boConnected then 
  begin
    Result := 0;
  end
  else begin
    Result := recv( m_nSocket, Buf, BufSize, 0 );
    if Result = SOCKET_ERROR then
    begin       
      nErr := WSAGetLastError();
      if nErr <> WSAEWOULDBLOCK then
      begin
        ErrorEvent( eeRecv, WSAGetLastError() );
      end;
    end
    else if Result = 0 then
    begin
      Disconnect();
    end;
  end;
end;

function TAbstractSocket.SendBuffer(var Buf; BufSize: Integer): Integer;
var
  nErr: Integer;
begin
  if not m_boConnected then 
  begin
    Result := 0;
  end
  else begin
    Result := send( m_nSocket, Buf, BufSize, 0 );
    if Result = SOCKET_ERROR then
    begin
      nErr := WSAGetLastError();
      if nErr <> WSAEWOULDBLOCK then
      begin
        ErrorEvent( eeSend, WSAGetLastError() );
      end;
    end
    else if Result = 0 then
    begin
      Disconnect();
    end;
  end;
end;

procedure TAbstractSocket.SetBlock(const Value: Boolean);
var
  uValue: u_long;
  nErr: Integer;
begin
  if m_boBlock <> Value then
  begin        
    uValue := u_long(not Value);
    //改变阻塞方式
    nErr := ioctlsocket( m_nSocket, FIONBIO, uValue );
    if nErr = 0 then
    begin
      m_boBlock := Value;
    end;
  end;
end;

procedure TAbstractSocket.SetRecvCacheSize(Value: Integer);
var
  nSize: Integer;
begin
  nSize := sizeof(Value);
  if 0 <> setsockopt( m_nSocket, SOL_SOCKET, SO_RCVBUF, @Value, nSize ) then
  begin   
  end;
end;

procedure TAbstractSocket.SetRemoteAddress(const Value: string);
begin
  m_RemoteAddrIn.sin_addr.S_addr := inet_addr(PChar(Value));
end;

procedure TAbstractSocket.SetRemotePort(const Value: Integer);
begin
  m_RemoteAddrIn.sin_port := htons(Value);
end;

procedure TAbstractSocket.SetSendCacheSize(Value: Integer);
var
  nSize: Integer;
begin
  nSize := sizeof(Value);
  if 0 <> setsockopt( m_nSocket, SOL_SOCKET, SO_SNDBUF, @Value, nSize ) then
  begin   
  end;
end;

{ TCustomBindSocket }

function TCustomBindSocket.AllocSocket: Integer;
begin
  if m_nSocket <> INVALID_SOCKET then
    closesocket( m_nSocket );
  m_nSocket := Winsock.socket( AF_INET, SOCK_STREAM, IPPROTO_IP );
  if m_nSocket = INVALID_SOCKET then
  begin
    Result := WSAGetLastError();
    m_boAvaliable := False;
  end
  else Result := 0;
end;

function TCustomBindSocket.Bind: Integer;
var
  I: Integer;
  nErr: Integer;
  SockAddrIn: TSockAddrIn;
begin
  Result := 0;

  if not m_boBinded and not m_boConnected and m_boAvaliable then
  begin
    nErr := 0;
    m_boBinded := True;
    if m_SocketBind <> nil then
    begin
      for I := 0 to m_SocketBind.Binds.Count - 1 do
      begin
        nErr := Winsock.bind( m_nSocket, PSockAddr(@m_SocketBind.Binds[I].BindAddrIn)^, sizeof(m_SocketBind.Binds[I].BindAddrIn) );
        if nErr <> 0 then
        begin
          Result := WSAGetLastError();
          ErrorEvent( eeBind, Result );
          break;
        end;
      end;
    end
    else begin
      SockAddrIn.sin_family := AF_INET;
      SockAddrIn.sin_addr.S_addr := INADDR_ANY;
      SockAddrIn.sin_port := INADDR_ANY;     
      nErr := Winsock.bind( m_nSocket, PSockAddr(@SockAddrIn)^, sizeof(SockAddrIn) );
      if nErr <> 0 then
      begin
        Result := WSAGetLastError();
        ErrorEvent( eeBind, Result );
      end;
    end;
    if nErr = 0 then
    begin
      m_SockManager.PostSocketEventNotification( seBind, Self, nil );
    end;
  end;
end;

constructor TCustomBindSocket.Create(SockManager: TCustomSockManager);
begin
  inherited;
  AllocSocket();
  m_SocketBind := SockManager.m_SocketBind;
end;

procedure TCustomBindSocket.SetSocketBind(const Value: TSocketBind);
begin
  if Value <> m_SocketBind then
  begin
    if m_boAvaliable and not m_boConnected then
    begin
      m_SocketBind := Value;
    end;
  end;
end;

{ TClientSocket }

procedure TClientSocket.CanWrite;
begin
  if not m_boConnected and m_boConnecting then
  begin
    m_boConnecting := False;
    m_boConnected := True;    
    if Block <> m_boOldIsBlock then
      Block := m_boOldIsBlock;   
    m_SockManager.PostSocketEventNotification( seConnected, Self, nil );
  end;
  Inherited;
end;

function TClientSocket.Connect: Integer;
begin
  if m_boConnected or not m_boAvaliable then
  begin
    Result := 0;
    Exit;
  end;

  Result := Bind();
  if Result <> 0 then Exit;
  
  m_boOldIsBlock := Block;
  Block := False;
  
  Result := WinSock.connect( m_nSocket, PSockAddr(@m_RemoteAddrIn)^, sizeof(m_RemoteAddrIn) );
  if Result = -1 then
  begin
    Result := WSAGetLastError();
    if Result <> WSAEWOULDBLOCK then Exit;
    Result := 0;
    m_boConnecting := True;
  end;
end;

procedure TClientSocket.Disconnect;
begin
  if m_boConnecting or m_boConnected then
  begin
    m_boConnecting := False;
    m_boConnected := False;     
    m_SockManager.PostSocketEventNotification( seDisconnected, Self, nil );
  end;
  Inherited;
end;

{ TAcceptSocket }

procedure TListenSocket.Accept;
var
  AddrIn: TSockAddrIn;
  nErr, addrLen: Integer;
  ServerSocket: TServerSocket;
  Param: TSocketEventParam;
begin
  while True do
  begin
    addrLen := Sizeof(AddrIn);
    nErr := Winsock.accept( Socket, @AddrIn, @addrLen );
    if nErr <> INVALID_SOCKET then
    begin
      ServerSocket := TServerSocket(m_SockManager.CreateSocket(TServerSocket));  
      ServerSocket.m_nSocket := nErr;
      ServerSocket.m_RemoteAddrIn := AddrIn;
      ServerSocket.m_boConnected := True;
      m_SockManager.AdjustSocketOptions(ServerSocket);
      m_SockManager.AddToSocketList( ServerSocket );

      Param.Accepted.NewSocket := ServerSocket;
      m_SockManager.PostSocketEventNotification( seAccepted, Self, @Param );
    end
    else begin
      nErr := WSAGetLastError();
      if nErr <> WSAEWOULDBLOCK then
      begin
        ErrorEvent( eeAccept, nErr );
      end;
      break;
    end;
  end;
end;

procedure TListenSocket.CanRead;
begin
  Accept();
end;

constructor TListenSocket.Create(SockManager: TCustomSockManager);
begin
  inherited;
  m_boReportWrite := False;
end;

function TListenSocket.Listen: Integer;
begin
  if m_boConnected or not m_boAvaliable then
  begin
    Result := 0;
    Exit;
  end;
  
  Result := Bind();
  if Result <> 0 then Exit;

  if 0 <> Winsock.listen( m_nSocket, 5 ) then
  begin                            
    Result := WSAGetLastError();
    ErrorEvent( eeListen, Result );
  end
  else begin
    m_boConnected := True;
    m_SockManager.PostSocketEventNotification( seListen, Self, nil );
  end;
end;

{ TCustomSockManager }

procedure TCustomSockManager.AddToSocketList(ASocket: TAbstractSocket);
begin
  if not m_boUserDrive then CheckSelectThread();
  EnterCriticalSection( m_SocketLock );
  try
    if m_SocketList.IndexOf(ASocket) < 0 then
    begin
      m_SocketList.Add( ASocket );
    end;
  finally
    LeaveCriticalSection( m_SocketLock );
  end;
end;

procedure TCustomSockManager.AdjustSocketOptions(ASocket: TAbstractSocket);
begin
  ASocket.Block := m_boBlock;
  if m_dwRecvBufSize <> 0 then ASocket.RecvCacheSize := m_dwRecvBufSize;
  if m_dwSendBufSize <> 0 then ASocket.SendCacheSize := m_dwRecvBufSize;
end;

procedure TCustomSockManager.CheckClosedSockets;
var
  I: Integer;
  Socket: TAbstractSocket;
begin
  EnterCriticalSection( m_SocketLock );
  try
    for I := m_SocketList.Count - 1 downto 0 do
    begin
      Socket := TAbstractSocket(m_SocketList[I]);
      if not Socket.m_boAvaliable then
      begin
        m_SocketList.Delete(I);
        Socket.Free;
      end;
    end;
  finally
    LeaveCriticalSection( m_SocketLock );
  end;
end;

function TCustomSockManager.CheckSelectThread: THandle;
begin
  if m_hSelectThread = 0 then
  begin
    m_boStoping := False;
    Result := CreateThread( nil, 0, @SockManagerSelectRoutine, Self, 0, Cardinal(nil^) );
    m_hSelectThread := Result;
  end
  else Result := m_hSelectThread;
end;

procedure TCustomSockManager.CloseAllSocket;
var
  I: Integer;
  Socket: TAbstractSocket;
begin
  EnterCriticalSection( m_SocketLock );
  try
    for I := 0 to m_SocketList.Count - 1 do
    begin
      Socket := TAbstractSocket(m_SocketList[I]);
      Socket.Free;
    end;
    m_SocketList.Clear();
  finally
    LeaveCriticalSection( m_SocketLock );
  end;
end;

constructor TCustomSockManager.Create(AOwner: TComponent);
begin
  inherited;
  InitializeCriticalSection( m_SocketLock );
  m_SocketList := TList.Create;

  m_pSyncNotifyLock := PInteger(LocalAlloc( LPTR, sizeof(m_pSyncNotifyLock^) ));
  m_pSyncNotifyLock^ := 0;
end;

function TCustomSockManager.CreateClientSocket(RemoteAddress: string; RemotePort: Integer): TClientSocket;
begin
  Result := TClientSocket(CreateSocket(TClientSocket));
  if Result <> nil then
  begin
    Result.SetRemoteAddress( RemoteAddress );
    Result.SetRemotePort( RemotePort );   
  end;
end;

function TCustomSockManager.CreateListenSocket: TListenSocket;
begin
  Result := TListenSocket(CreateSocket(TListenSocket));
end;

function TCustomSockManager.CreateSocket(ASocketClass: TClassOfAbstractSocket): TAbstractSocket;
begin
  Result := ASocketClass.Create( Self );
  if Result.m_nSocket <> INVALID_SOCKET then
  begin
    AdjustSocketOptions(Result);
  end;
  if not Result.m_boAvaliable then
  begin
    Result.Free;
    Result := nil;
  end
  else AddToSocketList( Result );
end;

destructor TCustomSockManager.Destroy;
begin
  TermiateSelectThread();
  CloseAllSocket();
  m_SocketList.Free;
  LocalFree( Cardinal(m_pSyncNotifyLock) );
  DeleteCriticalSection( m_SocketLock );
  inherited;
end;

procedure TCustomSockManager.DoSocketEventNotification(EventType: TSocketEventType; Socket: TAbstractSocket;
  pParam: PSocketEventParam);
begin
  case EventType of
    seConnected: if @m_OnSocketConnected <> nil then m_OnSocketConnected( Self, Socket );
    seDisconnected: if @m_OnSocketDisconnected <> nil then m_OnSocketDisconnected( Self, Socket );
    seBind: if @m_OnSocketBind <> nil then m_OnSocketBind( Self, Socket );
    seListen: if @m_OnSocketListen <> nil then m_OnSocketListen( Self, Socket );
    seAccepted: if @m_OnAccepted <> nil then m_OnAccepted( Self, Socket, pParam^.Accepted.NewSocket );
    seSocketError: if @m_OnSocketError <> nil then m_OnSocketError( Self, Socket, pParam^.SocketError.ErrorEvent, pParam^.SocketError.ErrorNumber );
    seRead: if @m_OnSocketRead <> nil then m_OnSocketRead( Self, Socket );
    seWrite: if @m_OnSocketWrite <> nil then m_OnSocketWrite( Self, Socket );
  end;
end;

procedure TCustomSockManager.DoSyncSocketEventNotification;
var
  EventType: TSocketEventType;
  EventSocket: TAbstractSocket;
  EventParam: PSocketEventParam;
begin
  EventType := m_btEventType;
  EventSocket := m_EventSocket;
  EventParam := m_pEventParam;
  m_pSyncNotifyLock^ := 0;
  
  DoSocketEventNotification( EventType, EventSocket, EventParam );
end;

procedure TCustomSockManager.PostSocketEventNotification(EventType: TSocketEventType; Socket: TAbstractSocket;
  pParam: PSocketEventParam);
begin
  if m_boSyncNotification then
  begin
    if csDestroying in ComponentState then Exit;
    if GetCurrentThreadId = MainThreadId then
    begin
      DoSocketEventNotification( EventType, Socket, pParam );
    end
    else begin
      while 0 <> InterlockedCompareExchange( m_pSyncNotifyLock^, 1, 0 ) do;
      m_btEventType := EventType;
      m_EventSocket := Socket;
      m_pEventParam := pParam;
      TThread.Synchronize(nil, DoSyncSocketEventNotification);
    end;
  end
  else begin
    DoSocketEventNotification( EventType, Socket, pParam );
  end;
end;

procedure TCustomSockManager.ProcessSocketEvents;
var
  nSocketCount, nFdCount, nErr: Integer;
  readfds, writefds, exptfds: TFDSet;
  Socket: TAbstractSocket;
  SocketArr: array [0..FD_SETSIZE-1] of TAbstractSocket;
  tv: TTimeVal;
begin
  nSocketCount := m_SocketList.Count;
  if nSocketCount > 0 then
  begin
    if m_nProcessIndex >= nSocketCount then m_nProcessIndex := 0;

    FD_ZERO( readfds );
    FD_ZERO( writefds );
    FD_ZERO( exptfds );
    nFdCount := 0;
    while m_nProcessIndex < nSocketCount do
    begin
      Socket := TAbstractSocket(m_SocketList[m_nProcessIndex]);  
      Inc( m_nProcessIndex );
      
      if Socket.m_boAvaliable then
      begin
        SocketArr[nFdCount] := Socket;
        FD_SET( Socket.m_nSocket, readfds );
        if Socket.m_boReportWrite then
        begin
          FD_SET( Socket.m_nSocket, writefds );
        end;
        FD_SET( Socket.m_nSocket, exptfds ); 
        Inc( nFdCount );    
        if nFdCount >= FD_SETSIZE then
          break;
      end;
    end;

    if nFdCount > 0 then
    begin
      tv.tv_sec := 0;
      tv.tv_usec := 16000;
      nErr := Winsock.select( 0, @readfds, @writefds, @exptfds, @tv );
      if nErr > 0 then
      begin
        while nFdCount > 0 do
        begin
          Dec( nFdCount );
          Socket := SocketArr[nFdCount];
          if FD_ISSET( Socket.m_nSocket, exptfds ) then
          begin
            Socket.Disconnect();
            continue;
          end;
          if FD_ISSET( Socket.m_nSocket, writefds ) then
          begin               
            Socket.m_boReportWrite := False;
            Socket.CanWrite();
          end;
          if FD_ISSET( Socket.m_nSocket, readfds ) then
          begin
            Socket.CanRead();
          end;
        end;
      end;
    end;

    if m_nProcessIndex >= nSocketCount then
    begin
      CheckClosedSockets();
    end;
  end;
end;

procedure TCustomSockManager.ProcessSockets;
begin
  if m_boUserDrive then
    ProcessSocketEvents();
end;

procedure TCustomSockManager.TermiateSelectThread;
begin
  m_boStoping := True;
  if m_hSelectThread <> 0 then
  begin
    WaitForSingleObject( m_hSelectThread, INFINITE );
    CloseHandle( m_hSelectThread );
    m_hSelectThread := 0; 
  end;
end;

{ TServerSocket }

initialization
begin
  InitSockLib();
end;

finalization
begin
  UninitSockLib();
end;

end.
