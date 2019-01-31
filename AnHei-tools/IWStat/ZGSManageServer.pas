unit ZGSManageServer;

interface

uses
  Windows, SysUtils, Classes, COMSockSrvModle, ComSockSrv, GSProto, EDCode;

type
  TZGSConnection = class(TCustomCOMServerConnection)
  private
    m_boRegisted: Boolean;
    m_nServerIndex: Integer;
    m_spid: string;
    m_sServerName: string;
    procedure DispatchRecvMsg(const DefMsg: TDefaultMessage; sData: string);
  protected
    procedure ReadSocketData(const lpPackData: PAnsiChar; dwSizeInBytes: DWord);override;
  public
    constructor Create(AServer: TCustomCOMSocketServer; AConnection: IClientConnection);override;
    destructor Destroy();override;

    procedure SendDefMessage(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; sMsg: string);
    procedure SendSocket(const DefMsg: TDefaultMessage; sEncodedData: string);

    procedure SendReLoadDatAll(SessionID: Integer; const nValue: Integer);
    procedure SendReloadNPC(SessionID: Integer; const sMessage: string);
    procedure SendReloadFunction(SessionID: Integer);
    procedure SendSetReFreshcorss(SessionID: Integer);
    procedure SendSetReLoadConfig(SessionID: Integer;const sMessage: string);
    procedure SendSetReLoadLang(SessionID: Integer);

    property Server;
    property Connection;
    property UserData;
    property RemoteAddress;
    property RemotePort;
    property Connected;
    property Registed: Boolean read m_boRegisted;
    property ServerIndex: Integer read m_nServerIndex;
    property ServerName: string read m_sServerName;
    property spid: string read m_spid;
  end;

  TZGSRequestResult = procedure (Sender: TObject; Connection: TZGSConnection; const DefMsg: TDefaultMessage; Data: string) of Object;
  
  TZGSManageServer = class(TCustomCOMSocketServer)
  private        
    FOnGSRequestResult: TZGSRequestResult;
  protected
    function CreateConnection(AConnection: IClientConnection): TCustomCOMServerConnection;override;
    procedure DestroyConnection(AConnection: TCustomCOMServerConnection);override;
  public
    FConnectionList: TList;
    constructor Create();reintroduce;
    destructor Destroy();override;

    function GetServerByIndex(spid: string; const nIndex: Integer): TZGSConnection;
    function GetServerByName(const sName: string): TZGSConnection;

    property ServiceName;
    property BindAddress;
    property BindPort;
    property OnSerivceStarted;
    property OnServiceStoped;
    property OnWorkThreadStarted;
    property OnWorkThreadStoped;
    property OnConnectionOpen;
    property OnConnectionClose;
    property OnResponConnection;     
    property OnGSRequestResult: TZGSRequestResult read FOnGSRequestResult write FOnGSRequestResult;
  end;


implementation

{ THttpConnection }

constructor TZGSConnection.Create(AServer: TCustomCOMSocketServer; AConnection: IClientConnection);
begin
  Inherited Create(AServer, AConnection);
end;

destructor TZGSConnection.Destroy;
begin
  inherited;
end;

procedure TZGSConnection.DispatchRecvMsg(const DefMsg: TDefaultMessage;
  sData: string);
var
  S: string;
begin
  case DefMsg.Ident of
    //向服务器注册(param=服务器ID，数据段为编码后的服务器名称)
    CM_REGIST_SERVER_RET:
    begin
      if not m_boRegisted then
      begin
        m_boRegisted := True;
        m_nServerIndex := DefMsg.Param;
        S := string(DecodeString(AnsiString(sData)));
        m_spid := Copy(S,1,Pos('|',S)-1);
        m_sServerName := Copy(S,Pos('|',S)+1,Length(S));
      end;
    end;
  else
    begin
      if Assigned(TZGSManageServer(Server).OnGSRequestResult) then
        TZGSManageServer(Server).OnGSRequestResult(Server, Self, DefMsg, sData);
    end;
  end;
end;

procedure TZGSConnection.ReadSocketData(const lpPackData: PAnsiChar;
  dwSizeInBytes: DWord);
var
  DefMsg: TDefaultMessage;
begin
  if dwSizeInBytes >= DEFBLOCKSIZE then
  begin
    Decode6BitBuf(lpPackData, @DefMsg, DEFBLOCKSIZE, Sizeof(DefMsg));
    DispatchRecvMsg(DefMsg, string(lpPackData + DEFBLOCKSIZE));
  end;
end;

procedure TZGSConnection.SendDefMessage(wIdent: Word; nRecog: Integer; nParam,
  nTag, nSeries: Word; sMsg: string);
var
  Defmsg: TDefaultMessage;
begin
  Defmsg := MakeDefaultMsg(wIdent, nRecog, nParam, nTag, nSeries);
  if sMsg = '' then
    SendSocket(DefMsg, '')
  else SendSocket(DefMsg, string(EncodeString(AnsiString(AnsiToUtf8(sMsg)))));
end;

procedure TZGSConnection.SendSocket(const DefMsg: TDefaultMessage;
  sEncodedData: string);
var
  S: AnsiString;
begin
  if Registed and Connected then
  begin
    S := '#' + EncodeMessage(DefMsg) + AnsiString(sEncodedData) + '!';
    Connection.Send(@S[1], Length(S), 0);
  end;
end;

procedure TZGSConnection.SendReLoadDatAll(SessionID: Integer; const nValue: Integer);
begin
  SendDefMessage(SM_RELOADDATALL, SessionID, 0, nValue, 0, '');
end;

procedure TZGSConnection.SendReloadNPC(SessionID: Integer;const sMessage: string);
begin
  SendDefMessage(SM_RELOADNPC, SessionID, 0, 0, 0, sMessage);
end;

procedure TZGSConnection.SendReloadFunction(SessionID: Integer);
begin
  SendDefMessage(SM_RELOAD_FUNCTION, SessionID, 0, 0, 0, '');
end;

procedure TZGSConnection.SendSetReFreshcorss(SessionID: Integer);
begin
  SendDefMessage(SM_REFRESHCORSS, SessionID, 0, 0, 0, '');
end;

procedure TZGSConnection.SendSetReLoadConfig(SessionID: Integer;const sMessage: string);
begin
  SendDefMessage(SM_RELOADCONFIG, SessionID, 0, 0, 0, sMessage);
end;

procedure TZGSConnection.SendSetReLoadLang(SessionID: Integer);
begin
  SendDefMessage(SM_RELOADLANG, SessionID, 0, 0, 0, '');
end;


{ THttpServer }

constructor TZGSManageServer.Create;
begin
  Inherited Create(svZJProtoDecServer);
  FConnectionList := TList.Create;
end;

function TZGSManageServer.CreateConnection(
  AConnection: IClientConnection): TCustomCOMServerConnection;
begin
  Result := TZGSConnection.Create(Self, AConnection);
  FConnectionList.Add(Result);
end;

destructor TZGSManageServer.Destroy;
begin
  FConnectionList.Free;
  inherited;
end;

procedure TZGSManageServer.DestroyConnection(AConnection: TCustomCOMServerConnection);
begin
  FConnectionList.Delete(FConnectionList.IndexOf(AConnection));
  AConnection.Free;
end;

function TZGSManageServer.GetServerByIndex(spid: string;const nIndex: Integer): TZGSConnection;
var
  I: Integer;
  Connection: TZGSConnection;
begin
  Result := nil;
  for I := 0 to FConnectionList.Count - 1 do
  begin
    Connection := TZGSConnection(FConnectionList.List^[I]);
    if (Connection.m_spid = spid) and (Connection.ServerIndex = nIndex) then
    begin
      Result := FConnectionList.List^[I];
      break;
    end;
  end;
end;

function TZGSManageServer.GetServerByName(const sName: string): TZGSConnection;
var
  I: Integer;
begin        
  Result := nil;
  for I := 0 to FConnectionList.Count - 1 do
  begin
    if CompareText(TZGSConnection(FConnectionList.List^[I]).ServerName, sName) = 0 then
    begin
      Result := FConnectionList.List^[I];
    end;
  end;
end;

end.
