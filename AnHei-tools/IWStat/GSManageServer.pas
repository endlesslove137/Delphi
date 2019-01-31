unit GSManageServer;

interface

uses
  Windows, SysUtils, Classes, COMSockSrvModle, ComSockSrv, GSProto, EDCode;

type
  TGSConnection = class(TCustomCOMServerConnection)
  private
    m_boRegisted: Boolean;
    m_nServerIndex: Integer;
    m_spid: string;
    m_sServerName: string;
    procedure DispatchRecvMsg(const DefMsg: TDefaultMessage; sData: string);
  protected
    procedure ReadSocketData(const lpPackData: PAnsiChar; dwSizeInBytes: DWord);override;
    procedure SendKeepAlive();override;
  public
    constructor Create(AServer: TCustomCOMSocketServer; AConnection: IClientConnection);override;
    destructor Destroy();override;

    procedure SendDefMessage(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; sMsg: string);
    procedure SendSocket(const DefMsg: TDefaultMessage; sEncodedData: string);

    procedure SendReloadNPC(SessionID: Integer; const sMapName, sNPCName: string);
    procedure SendReloadNotice(SessionID: Integer);
    procedure SendKickPlayer(SessionID: Integer;const sCharName: string);
    procedure SendKickUser(SessionID: Integer;const sAccount: string);
    procedure SendQueryPlayerOnline(SessionID: Integer;const sCharName: string);
    procedure SendQueryUserOnline(SessionID: Integer;const sAccount: string);
    procedure SendAddNotice(SessionID, msgType, nTime: Integer;const sNotice: string);
    procedure SendDelNotice(SessionID: Integer;const sNotice: string);
    procedure SendDelayUphole(SessionID: Integer;const nWaitSeconds: Integer = SecsPerMin * 10);
    procedure SendCancelUphole(SessionID: Integer);
    procedure SendSetExpRate(SessionID: Integer;const nExpRate,nTime: Integer);
    procedure SendSetOpenCompen(SessionID: Integer;const nidx,nTime: Integer);
    procedure SendSetAbuse(SessionID, nidx, num: Integer;const sMessage: string);
    procedure SendSetCloseompen(SessionID: Integer);
    procedure SendSetDropRete(SessionID: Integer;const nidx, nValue: Integer);
    procedure SendSetQuicksoft(SessionID: Integer;const nidx, nValue: Integer);
    procedure SendChatLevel(SessionID: Integer;const nidx, nValue: Integer);
    procedure SendSetDelGuild(SessionID: Integer;const sMessage: string);
    procedure SendSetHunderd(SessionID: Integer;const nidx,nValue: Integer; sMessage: string);
    procedure SendSetReLoadConfig(SessionID: Integer;const sMessage: string);
    procedure SendSetReMoveItem(SessionID: Integer;const nidx: Integer; sCharName, sGuid: string);
    procedure SendSetReMoveMoney(SessionID: Integer;const nidx: Integer; sCharName, sValue: string);
    procedure SendDelayComBine(SessionID: Integer;const nValue: Integer; sMessage: string);
    procedure SendGetNoticeStr(SessionID: Integer);
    procedure SendSetReFreshcorss(SessionID: Integer);
    procedure SendSetCommonSrvid(SessionID: Integer; const nidx: Integer);
    procedure SendGetCommonSrvid(SessionID: Integer);
    procedure SendSetSurpRiseret(SessionID: Integer;const nidx,nValue: Integer; sMessage: string);
    procedure SendSetGamble(SessionID: Integer);
    procedure SendSetChangeName(SessionID: Integer; const nidx: Integer);
    procedure SendSetOldPlayerBack(SessionID: Integer; const nidx: Integer);
    procedure SendSetReLoadLang(SessionID: Integer);
    procedure SendSetGroupon(SessionID: Integer;const nidx,nValue: Integer; sMessage: string);
    procedure SendSetCrossBattle(SessionID: Integer; const nidx: Integer);
    procedure SendSetCrossBattleNum(SessionID: Integer; const nidx: Integer);
    procedure SendReLoadItmeFunction(SessionID: Integer);
    procedure SendViewState(SessionID: Integer);

    procedure SendShutup(SessionID, nWaitMinute: Integer;const sCharName: string);
    procedure SendReleaseShutup(SessionID: Integer;const sCharName: string);
    procedure SendReloadFunction(SessionID: Integer);
    procedure SendReloadLoginScript(SessionID: Integer);
    procedure SendReloadRobotnpc(SessionID: Integer);
    procedure SendReloadShop(SessionID: Integer);
    procedure SendApplyAcross(Tag: Integer; charname: string);
    procedure SendArenaScoreRank();
    procedure SendCurProcessMemUsed(SessionID: Integer);
    procedure SendPlayerResultPoint(SessionID,nBindGold: Integer;const sCharName: string);
    procedure SendAbuseInfoRmation(SessionID: Integer);
    procedure SendMonsterScript(SessionID: Integer;const sMonName: string);
    procedure SendOpenGamble(SessionID: Integer;bValue: Boolean);
    procedure SendOpenCommonServer(SessionID: Integer;bValue: Boolean);
    procedure SendGMOfflineMessage(SessionID: Integer;sCharname,sMessage: string);

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

  TGSRequestResult = procedure (Sender: TObject; Connection: TGSConnection; const DefMsg: TDefaultMessage; Data: string) of Object;
  
  TGSManageServer = class(TCustomCOMSocketServer)
  private        
    FOnGSRequestResult: TGSRequestResult;
  protected
    function CreateConnection(AConnection: IClientConnection): TCustomCOMServerConnection;override;
    procedure DestroyConnection(AConnection: TCustomCOMServerConnection);override;
  public
    FConnectionList: TList;
    constructor Create();reintroduce;
    destructor Destroy();override;

    function GetServerByIndex(spid: string;const nIndex: Integer): TGSConnection;
    function GetServerByIndex2(const nIndex: Integer): TGSConnection;
    function GetServerByName(const sName: string): TGSConnection;

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
    property OnGSRequestResult: TGSRequestResult read FOnGSRequestResult write FOnGSRequestResult;  
  end;


implementation

{ THttpConnection }

constructor TGSConnection.Create(AServer: TCustomCOMSocketServer; AConnection: IClientConnection);
begin
  Inherited Create(AServer, AConnection);
end;

destructor TGSConnection.Destroy;
begin
  inherited;
end;

procedure TGSConnection.DispatchRecvMsg(const DefMsg: TDefaultMessage;
  sData: string);
var
  S: string;
begin
  case DefMsg.Ident of
    //向服务器注册(param=服务器ID，数据段为编码后的服务器名称)
    MCS_REGIST_SERVER:
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
    //客户端回应保持连接
    MCS_KEEP_ALIVE:
    begin
    end;
  else
    begin
      if Assigned(TGSManageServer(Server).OnGSRequestResult) then
        TGSManageServer(Server).OnGSRequestResult(Server, Self, DefMsg, sData);
    end;
  end;
end;

procedure TGSConnection.ReadSocketData(const lpPackData: PAnsiChar;
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

procedure TGSConnection.SendAbuseInfoRmation(SessionID: Integer);
begin
  SendDefMessage(MSS_RELOAD_ABUSEINFORMATION, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendAddNotice(SessionID, msgType, nTime: Integer;const sNotice: string);
begin
  SendDefMessage(MSS_ADDNOTICE, SessionID, msgType, nTime, 0, sNotice);
end;

procedure TGSConnection.SendApplyAcross(Tag: Integer; charname: string);
begin
  SendDefMessage(MSS_APPLY_ACROSS_SERVER_RET, 0, 0, Tag, 0, charname);
end;

procedure TGSConnection.SendArenaScoreRank;
begin
  SendDefMessage(MSS_GET_ARENA_SCORE_RANK, 0, 0, 0, 0, '');
end;

procedure TGSConnection.SendCancelUphole(SessionID: Integer);
begin
  SendDefMessage(MSS_CANLCE_UPHOLE, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendCurProcessMemUsed(SessionID: Integer);
begin
  SendDefMessage(MSS_GET_CURR_PROCESS_MEM_USED, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendDefMessage(wIdent: Word; nRecog: Integer; nParam,
  nTag, nSeries: Word; sMsg: string);
var
  Defmsg: TDefaultMessage;
begin
  Defmsg := MakeDefaultMsg(wIdent, nRecog, nParam, nTag, nSeries);
  if sMsg = '' then
    SendSocket(DefMsg, '')
  else SendSocket(DefMsg, string(EncodeString(AnsiString(AnsiToUtf8(sMsg)))));
end;

procedure TGSConnection.SendDelayUphole(SessionID: Integer;const nWaitSeconds: Integer);
begin
  SendDefMessage(MSS_DELAY_UPHOLE, SessionID, nWaitSeconds, 0, 0, '');
end;

procedure TGSConnection.SendDelNotice(SessionID: Integer;const sNotice: string);
begin
  SendDefMessage(MSS_DELNOTICE, SessionID, 0, 0, 0, sNotice);
end;

procedure TGSConnection.SendGMOfflineMessage(SessionID: Integer; sCharname,
  sMessage: string);
begin
  SendDefMessage(MSS_SEND_OFFMSGTOACOTOR, SessionID, 0, 0, 0, sCharname+#13+sMessage);
end;

procedure TGSConnection.SendKeepAlive;
begin
  SendDefMessage(MSS_KEEP_ALIVE, 0, 0, 0, 0, '');
end;

procedure TGSConnection.SendKickPlayer(SessionID: Integer;const sCharName: string);
begin 
  SendDefMessage(MSS_KICKPLAY, SessionID, 0, 0, 0, sCharName);
end;

procedure TGSConnection.SendKickUser(SessionID: Integer;const sAccount: string);
begin
  SendDefMessage(MSS_KICKUSER, SessionID, 0, 0, 0, sAccount);
end;

procedure TGSConnection.SendMonsterScript(SessionID: Integer;
  const sMonName: string);
begin
  SendDefMessage(MSS_RELOAD_MONSTER_SCRIPT, SessionID, 0, 0, 0, sMonName);
end;

procedure TGSConnection.SendOpenCommonServer(SessionID: Integer;
  bValue: Boolean);
begin
  if bValue then
  begin
    SendDefMessage(MSS_OPEN_COMMONSERVER, SessionID, Integer(bValue), 0, 0, '');
  end
  else begin
    SendDefMessage(MSS_CLOSE_COMMONSERVER, SessionID, Integer(bValue), 0, 0, '');
  end;
end;

procedure TGSConnection.SendOpenGamble(SessionID: Integer; bValue: Boolean);
begin
  if bValue then
  begin
    SendDefMessage(MSS_OPEN_GAMBLE, SessionID, Integer(bValue), 0, 0, '');
  end
  else begin
    SendDefMessage(MSS_CLOSE_GAMBLE, SessionID, Integer(bValue), 0, 0, '');
  end;
end;

procedure TGSConnection.SendPlayerResultPoint(SessionID,nBindGold: Integer;
  const sCharName: string);
begin
  SendDefMessage(MSS_ADD_PLAYER_RESULTPOINT, SessionID, nBindGold, 0, 0, sCharName);
end;

procedure TGSConnection.SendQueryPlayerOnline(SessionID: Integer;const sCharName: string);
begin
  SendDefMessage(MSS_QUERYPLAYONLINE, SessionID, 0, 0, 0, sCharName);
end;

procedure TGSConnection.SendQueryUserOnline(SessionID: Integer;const sAccount: string);
begin
  SendDefMessage(MSS_QUERYUSERONLINE, SessionID, 0, 0, 0, sAccount);
end;

procedure TGSConnection.SendReleaseShutup(SessionID: Integer;
  const sCharName: string);
begin
  SendDefMessage(MSS_RELEASESHUTUP, SessionID, 0, 0, 0, sCharName);
end;

procedure TGSConnection.SendReloadFunction(SessionID: Integer);
begin
  SendDefMessage(MSS_RELOAD_FUNCTION, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendReloadLoginScript(SessionID: Integer);
begin
  SendDefMessage(MSS_RELOAD_LOGIN_SCRIPT, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendReloadNotice(SessionID: Integer);
begin
  SendDefMessage(MSS_RELOADNOTICE, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendReloadNPC(SessionID: Integer;const sMapName, sNPCName: string);
begin
  SendDefMessage(MSS_RELOADNPC, SessionID, 0, 0, 0, sMapName + #10 + sNPCName);
end;

procedure TGSConnection.SendReloadRobotnpc(SessionID: Integer);
begin
  SendDefMessage(MSS_RELOAD_ROBOTNPC, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendReloadShop(SessionID: Integer);
begin
  SendDefMessage(MSS_RELOAD_SHOP, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendSetExpRate(SessionID: Integer;const nExpRate,nTime: Integer);
begin
  SendDefMessage(MSS_SET_EXPRATE, SessionID, nExpRate, nTime, 0, '');
end;

procedure TGSConnection.SendSetOpenCompen(SessionID: Integer;const nidx,nTime: Integer);
begin
  SendDefMessage(MSS_OPEN_COMPENSATE, SessionID, nidx, nTime, 0, '');
end;

procedure TGSConnection.SendSetAbuse(SessionID, nidx, num: Integer;const sMessage: string);
begin
  SendDefMessage(MSS_ADD_FILTERWORDS, SessionID, nidx, num, 0, sMessage);
end;

procedure TGSConnection.SendSetCloseompen(SessionID: Integer);
begin
  SendDefMessage(MSS_CLOSE_COMPENSATE, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendSetDropRete(SessionID: Integer;const nidx, nValue: Integer);
begin
  SendDefMessage(MSS_SET_DROPRATE, SessionID, nidx, nValue, 0, '');
end;

procedure TGSConnection.SendSetQuicksoft(SessionID: Integer;const nidx, nValue: Integer);
begin
  SendDefMessage(MSS_SET_QUICKSOFT, SessionID, nidx, nValue, 0, '');
end;

procedure TGSConnection.SendChatLevel(SessionID: Integer;const nidx, nValue: Integer);
begin
  SendDefMessage(MSS_SET_CHATLEVEL, SessionID, nidx, nValue, 0, '');
end;

procedure TGSConnection.SendSetDelGuild(SessionID: Integer;const sMessage: string);
begin
  SendDefMessage(MSS_SET_DELGUILD, SessionID, 0, 0, 0, sMessage);
end;

procedure TGSConnection.SendSetHunderd(SessionID: Integer;const nidx,nValue: Integer; sMessage: string);
begin
  SendDefMessage(MSS_SET_HUNDREDSERVER, SessionID, nidx, nValue, 0, sMessage);
end;

procedure TGSConnection.SendSetReLoadConfig(SessionID: Integer;const sMessage: string);
begin
  SendDefMessage(MSS_SET_RELOADCONFIG, SessionID, 0, 0, 0, sMessage);
end;

procedure TGSConnection.SendSetReMoveItem(SessionID: Integer;const nidx: Integer; sCharName, sGuid: string);
begin
  SendDefMessage(MSS_SET_REMOVEITEM, SessionID, nidx, 0, 0, sCharName + #10 + sGuid);
end;

procedure TGSConnection.SendSetReMoveMoney(SessionID: Integer;const nidx: Integer; sCharName, sValue: string);
begin
  SendDefMessage(MSS_SET_REMOVEMONEY, SessionID, nidx, 0, 0, sCharName + #10 + sValue);
end;

procedure TGSConnection.SendDelayComBine(SessionID: Integer;const nValue: Integer; sMessage: string);
begin
  SendDefMessage(MSS_DELAY_COMBINE, SessionID, nValue, 0, 0, sMessage);
end;

procedure TGSConnection.SendGetNoticeStr(SessionID: Integer);
begin
  SendDefMessage(MSS_GET_NOTICESTR, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendSetReFreshcorss(SessionID: Integer);
begin
  SendDefMessage(MSS_SET_REFRESHCORSS, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendSetCommonSrvid(SessionID: Integer; const nidx: Integer);
begin
  SendDefMessage(MSS_SET_COMMON_SRVID, SessionID, nidx, 0, 0, '');
end;

procedure TGSConnection.SendGetCommonSrvid(SessionID: Integer);
begin
  SendDefMessage(MSS_GET_COMMON_SRVID, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendSetSurpRiseret(SessionID: Integer;const nidx, nValue: Integer; sMessage: string);
begin
  SendDefMessage(MSS_SET_SURPRISERET, SessionID, nidx, nValue, 0, sMessage);
end;

procedure TGSConnection.SendSetGamble(SessionID: Integer);
begin
  SendDefMessage(MSS_RESET_GAMBLE, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendSetChangeName(SessionID: Integer; const nidx: Integer);
begin
  SendDefMessage(MSS_SET_CHANGENAME, SessionID, nidx, 0, 0, '');
end;

procedure TGSConnection.SendSetOldPlayerBack(SessionID: Integer; const nidx: Integer);
begin
  SendDefMessage(MSS_SET_OLDPLAYERBACK, SessionID, nidx, 0, 0, '');
end;

procedure TGSConnection.SendSetReLoadLang(SessionID: Integer);
begin
  SendDefMessage(MSS_SET_RELOADLANG, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendSetGroupon(SessionID: Integer;const nidx,nValue: Integer; sMessage: string);
begin
  SendDefMessage(MSS_SET_GROUPON, SessionID, nidx, nValue, 0, sMessage);
end;

procedure TGSConnection.SendSetCrossBattle(SessionID: Integer; const nidx: Integer);
begin
  SendDefMessage(MSS_SET_CROSSBATTLE, SessionID, nidx, 0, 0, '');
end;

procedure TGSConnection.SendSetCrossBattleNum(SessionID: Integer; const nidx: Integer);
begin
  SendDefMessage(MSS_SET_CROSSBATTLENUM, SessionID, nidx, 0, 0, '');
end;

procedure TGSConnection.SendReLoadItmeFunction(SessionID: Integer);
begin
  SendDefMessage(MSS_RELOAD_ITMEFUNCTION, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendViewState(SessionID: Integer);
begin
  SendDefMessage(MSS_VIEW_STATE, SessionID, 0, 0, 0, '');
end;

procedure TGSConnection.SendShutup(SessionID, nWaitMinute: Integer;
  const sCharName: string);
begin
  SendDefMessage(MSS_SHUTUP, SessionID, nWaitMinute, 0, 0, sCharName);
end;

procedure TGSConnection.SendSocket(const DefMsg: TDefaultMessage;
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

{ THttpServer }

constructor TGSManageServer.Create;
begin
  Inherited Create(svZJProtoDecServer);
  FConnectionList := TList.Create;
end;

function TGSManageServer.CreateConnection(
  AConnection: IClientConnection): TCustomCOMServerConnection;
begin
  Result := TGSConnection.Create(Self, AConnection);
  FConnectionList.Add(Result);
end;

destructor TGSManageServer.Destroy;
begin
  FConnectionList.Free;
  inherited;
end;

procedure TGSManageServer.DestroyConnection(AConnection: TCustomCOMServerConnection);
begin
  FConnectionList.Delete(FConnectionList.IndexOf(AConnection));
  AConnection.Free;
end;

function TGSManageServer.GetServerByIndex(spid: string;const nIndex: Integer): TGSConnection;
var
  I: Integer;
  Connection: TGSConnection;
begin
  Result := nil;
  for I := 0 to FConnectionList.Count - 1 do
  begin
    Connection := TGSConnection(FConnectionList.List^[I]);
    if (Connection.m_spid = spid) and (Connection.ServerIndex = nIndex) then
    begin
      Result := FConnectionList.List^[I];
      break;
    end;
  end;
end;

function TGSManageServer.GetServerByIndex2(const nIndex: Integer): TGSConnection;
var
  I: Integer;
  Connection: TGSConnection;
begin
  Result := nil;
  for I := 0 to FConnectionList.Count - 1 do
  begin
    Connection := TGSConnection(FConnectionList.List^[I]);
    if (Connection.ServerIndex = nIndex) then
    begin
      Result := FConnectionList.List^[I];
      break;
    end;
  end;
end;

function TGSManageServer.GetServerByName(const sName: string): TGSConnection;
var
  I: Integer;
begin        
  Result := nil;
  for I := 0 to FConnectionList.Count - 1 do
  begin
    if CompareText(TGSConnection(FConnectionList.List^[I]).ServerName, sName) = 0 then
    begin
      Result := FConnectionList.List^[I];
    end;
  end;
end;

end.
