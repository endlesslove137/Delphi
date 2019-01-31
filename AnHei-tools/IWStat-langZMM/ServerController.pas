unit ServerController;

interface

uses
  SysUtils, Classes, IWServerControllerBase, IWBaseForm, HTTPApp,
  // For OnNewSession Event
  UserSessionUnit, IWApplication, IWAppForm, DBXMySQL, FMTBcd, DBClient,
  SimpleDS, DB, SqlExpr, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdCustomHTTPServer, IdHTTPServer, ExtCtrls, Windows, {AAServiceXML,}
  GSManageServer, ZGSManageServer, EDcode, IWTMSCheckList, Graphics, ActiveX,
  idHttp, ShellAPI, DateUtils, IWForm, IWContainer, ScktComp;

type
  pTStdItem = ^TStdItem;
  TStdItem = packed record
    Name: string[21];
    Dup: Byte;
    ItemDateTime: Integer;
  end;

  PTTask = ^TTask;
  TTask = packed record
    nTaskID: Integer;
    sTaskName: string[20];
    bType: Byte;
    nParentID: Integer;
    bAcceptLevel: Byte;
    bMaxLevel: Byte;
    sTaskMapName: string[32];
  end;

  TStringArray = array of string;
  PTStringArray = ^TStringArray;

  //TOperateType = (otActivityItem, otRoleActivityItem, otBonus,otSurpriseret,otIcksoft,otChatlevel);
  THTType = (htGlobalYuYing,htJOINYuYing,htMalaysia);


  PTServerListData = ^TServerListData;
  TServerListData = record
    spID: string;
    Ispid: Integer;
    Index: Integer;
    ServerID: Integer;
    SessionHostName: string;
    SessionHostName2: string;
    DataBase: string;
    LogHostName: string;
    RoleHostName: string;
    IsDisplay: Boolean;
    CurrencyRate: Double;
    PassKey: string;
    OpenTime: string;
    JoinIdx: Integer;
    BonusKey: string;
    //新增加自定义库名
    LogDB: string;
    Amdb: string;
    Amdb2: string;
    AccountDB: string;
    AccountDB2: string;
    GstaticDB: string;
  end;

  PTLogRecord=^TLogRecord;
  TLogRecord = record
    nIdent : Integer;  //行为
    nSrvIndex : Integer;
    nType: Integer;   //Para0:物品ID
    nChange: Integer; //Para1:变化前数值
    nCount: Integer;  //para2:变化后数值
    sSender: string;  //角色名
    sObjName: string; ///LongStr2:物品名称
    sObjId: string;  //LongStr1:物品序列号
    sRemark: string; //LongStr0:备注说明
    sDate: string;
    sMidStr0: string;  //目标
  end;

  TIWServerController = class(TIWServerControllerBase)
    TimerAutoRun: TTimer;
    IdHTTPServer: TIdHTTPServer;
    TimerAutoUpdate: TTimer;
    TimerNoticeRun: TTimer;
    SQLConnectionRAuto: TSQLConnection;
    quRobotInfo: TSQLQuery;
    SendTimer: TTimer;
    TimerStart: TTimer;
    ASumTime1: TTimer;
    SQLConnectionASumMoney: TSQLConnection;
    quASumMoney: TSQLQuery;
    SQLConnectionASumOL: TSQLConnection;
    quASumOL: TSQLQuery;
    quASumchg: TSQLQuery;
    SQLConnectionASumChg: TSQLConnection;
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication;
      var VMainForm: TIWBaseForm);
    procedure IWServerControllerBaseCreate(Sender: TObject);
    procedure IWServerControllerBaseDestroy(Sender: TObject);
    procedure TimerAutoRunTimer(Sender: TObject);
    procedure TimerAutoUpdateTimer(Sender: TObject);
    procedure IWServerControllerBaseBackButton(ASubmittedSequence,
      ACurrentSequence: Integer; AFormName: string; var VHandled,
      VExecute: Boolean);
    procedure IWServerControllerBaseCloseSession(ASession: TIWApplication);
    procedure IWServerControllerBaseBeforeDispatch(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure IWServerControllerBaseAfterRender(ASession: TIWApplication;
      AForm: TIWBaseForm);
    procedure TimerNoticeRunTimer(Sender: TObject);
    procedure SendTimerTimer(Sender: TObject);
    procedure ASumTime1Timer(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
  private
    m_SafetyPassLock: TRTLCriticalSection;
    m_SessionLoadLock: TRTLCriticalSection;

  //  ServiceXML: TAAServiceXML;
   // AcrossRankList: TStringList;
   // curAcrossIdx: Integer;
 //   AcrossIDBDataRetry: Integer;
    AuthIPList: TStringList;

    Bobusy: Boolean;
    BoRunClient: Boolean;
    CSocStr, CBufferStr: string;

    IWFClient: TClientSocket;
    procedure GSRequestResult(Sender: TObject; Connection: TGSConnection; const DefMsg: TDefaultMessage; Data: string);
    procedure ZGSRequestResult(Sender: TObject; Connection: TZGSConnection; const DefMsg: TDefaultMessage; Data: string);

    procedure DecodeMessagePacket (datablock: string);//客户端接收消息
  public
    function IsCheckTable(SQLQuery: TSQLQuery;sDBName,sTableName: string): Boolean;
    function DBExecSQL(SQLQuery: TSQLQuery;sSQL: string): Integer;
    procedure ConnectionRoleMysql(SQLConnection: TSQLConnection;sHostName,sDataBase: string); overload;
    procedure ConnectionRoleMysql(SQLConnection: TSQLConnection;sHostName,sDataBase,sUser,sPass: string;iPort: Integer); overload;
    procedure ConnectionLogMysql(SQLConnection: TSQLConnection;slog,sHostName: string);
    procedure ConnectionLocalLogMysql(SQLConnection: TSQLConnection; sHostName: string);
    procedure ConnectionSessionMysql(SQLConnection: TSQLConnection;sAccount,sHostName: string);


    procedure SetRobotMessage (spid: string; Idx, nMsgType, Num, nTick: Integer; sdata: string; daTime: TDateTime);

    procedure SendAddNotices(spid: string; Idx, nMsgType, nTick: Integer; sdata: string);
    procedure SendDelNotices(spid: string; Idx: Integer; sdata: string);
    procedure SendSetExpRates(spid: string; Idx, ExpRate, ExpTime: Integer; sdata: string);

    procedure SendCMSocket (sendstr: AnsiString);

    function PayAndOLTotal(sspid: string): Boolean;
    function PayAndOLTotal2(sspid: string): Boolean;
    procedure InsertPayAndOL(sdata: string);
    procedure InsertPayAndOL2(sdata: string);

    procedure OnRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnConnect(Sender: TObject;Socket: TCustomWinSocket);
    procedure OnDisconnect(Sender: TObject;Socket: TCustomWinSocket);
    procedure OnError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;var ErrorCode: Integer);
  end;

  function UserSession: TIWUserSession;
  function IWServerController: TIWServerController;
  function Move(AFormClass: TIWAppFormClass; IsRelease: Boolean = True): TIWAppForm;
  function NumberSort(List: TStringList; Index1,Index2: Integer): Integer;
  function GetCellName(sText: string): string;
  function ChangeZero(Value: Double): Double;overload;
  function ChangeZero(Value: Integer): Integer;overload;
  function DivZero(sValue,eValue: Double): Double;
  function GetServerIndex(ServerName: string): string;
  procedure ClearServerListData;
  procedure ClearShopListData(pList: TStringList);
  function GetHttpXML(sHttp: string): string;
  procedure LoadServerList;
  procedure LoadShopList;
  procedure LoadStdItems;
  procedure ClearStdItems;
  procedure LoadTasks;
  procedure ClearTasks;
  procedure LoadLogIdent;
  procedure LoadCommonList;
  procedure ClearWebGridDataList(DataList: TStringList);
  function GetServerListDataBySPID(const sSPID: string): PTServerListData;
  function GetServerListData(sServerName: string): PTServerListData; overload;
  function GetServerListData(iServerIndex: Integer): PTServerListData; overload;
  function GetServerListData(spid: string; iServerIndex: Integer): PTServerListData; overload;
  function GetServerListName(spid: string;iServerIndex: Integer; CheckJoin: Boolean = False): string;
  function GetServerListNameEx(iServerIndex: Integer; CheckJoin: Boolean = False): string;
  function GetRecordCount(sSQL: string; Query: TSQLQuery): Integer;
  function GetServerIsdisplay(spid: string;ServerIndex: Integer): Boolean;
  function OnGetStdItemName(const StdItemIdx: Integer): string;
  function OnGetTaskName(const StdTaskIdx: Integer): PTTask; overload;
  function GetZyName(zyID1,zyID2: Integer): string;
  function GetLogIdentStr(const nIdent: Integer): string;
  procedure WriteErrorFile(IsDate: Boolean; sText: string);
  function GetSessionDMessage(AppID: string): Integer;
  function GetSessionIWMessage(AppID: string): Integer;
  function GSResultStr(AppID, spid: string): string;
  function GSIWResultStr(AppID: string): string;
  procedure ClearGSMsgListData;
  procedure LoadGSServers(CheckListBox: TTIWCheckListBox; spID: string; IsDisplay: Boolean = True); overload;
  procedure LoadGSServers(StringList: TStringList; spID: string; IsDisplay: Boolean = True); overload;
  procedure AppExceptionLog(sClassName: string; E: Exception);
  function GetShopItemPrice(pList: TStringList;ItemName: string): Integer;
  function DecryptZJHTKey(sKey: string): AnsiString;
  function UrlEncode(const ASrc: AnsiString): AnsiString;
  function BuildSerialNO: string;
  function SecondToTime(I:integer):string;
  function GetSQLJob: string;
  function GetExtSysICon(sExt: string): HIcon;
  function QuerySQLStr(sFieldName: string): string;
  function QuerySQLStrEx(sFieldName: string): string;
  function ParameterIntValue(pStr: string): Integer;
  function ParameterStrValue(pStr: string): string;
  function ParameterStrValueEx(pStr: string): string;
  function GetJoinServerIndex(iServerIndex: Integer): string;
  function GetFirstOpenTime(spId: string): TDateTime;
  function InttoCurrType(num: Integer): string; //增加货币类型输出
  function Str_ToInt (Str: string; def: Longint): Longint;
  function Str_ToInt64(Str: string; def: Longint): Int64;
  function InttoKillType(num: Integer): string; //增加被杀类型
  function MsgTypestr(num: Integer): string; //公告类型
  function RobotTypestr(num: Integer): string;
  function ItemTypeStr(num: Integer): string;
  function BoolToIntStr(boo: Boolean): string;
  function GetVersionEx: string;
const
  AdminUser = 'admin';
  filesdir = 'files\';
  filesPath  = 'files\';
  UserPopFile = 'UserPopList.xml';
  ZJConfigINI = 'ZJConfig.ini';
  ZJServerINI = 'ZJServer.ini';
  NoticeFile = 'notice.txt';
  AuthIPListFile = 'AuthIPList.txt';
  UserIPListFile = 'UserIPList.txt';
  TopCount = 500;
  CurSection = '兑换率设置';
  GSLogInfo = '[%s] %s';
  sBind: array[0..1] of string = ('不绑定','绑定');
  sStack: array[0..1] of string = ('不叠加','叠加');
  THTTypeStr: array[THTType] of string = ('通用后台','联运商后台','马来西亚后台');
  TDBTableList: array[0..14] of string =
                ('actorbagitem','actorbinarydata','actorconsignment','actordepotitem',
                 'actorequipitem','actorfriends','actorguild','actormsg',
                 'actors','actorvariable','fubendata','goingquest',
                 'repeatquest','skill', 'useritem');
  sRoleJob : array [0..3] of Integer = (376, 267, 268, 269);
  RoleChartColor : array [0..8] of Integer = (clRed, clGreen, clBlack, clBlue, clLime, clFuchsia, clPurple, clOlive, clSilver);
  TOperateTypeStr: array[0..8] of string = ('发放账号活动物品','发放角色活动物品','发放红利','惊喜回馈','设置加速外挂','设置聊天等级','删除行会','删除装备','删除货币');
  ZyNameStr: array[0..3] of string = ('无阵营','无忌','逍遥','日月');
  TBugInfoStateStr: array[0..1] of Integer = (468,469);

var
  xmlText: string;
  xmlShop: string;
  xmlReputeShop: string;
  AppPathEx: string;
  ServerList: TStringList;
  FStdItemList: TStringList;
  TaskList: TStringList;
  ShopList: TStringList;
  LogIdentList: TStringList;
  CommonList: TStringList;
  FGSMServer : TGSManageServer;
  ZGSMServer : TZGSManageServer;
  SessionIDList: TStringList;
  GSMsgList: TStringList;
  FPrintMsgLock: TRTLCriticalSection;
  FPrintMsgLockIW: TRTLCriticalSection;
  SafetyPassHttpServer: TIdHTTPServer;
  m_WriteLogLock: TRTLCriticalSection;
  SerialNO: Integer;
 // IsAcrossRun: Boolean;
  BugTypeList: TStringList;
  NoticeMsgData: array[0..7, 0..1] of Byte =((1,0),(2,0),(4,0),(8,0),(16,0),(32,0),(64,0),(128,0));
  sNoticeMsgData: array [0..7] of string=('右侧提示栏','屏幕中央','弹出框','公告栏','短消息','温馨提示','GM提示信息','左侧聊天栏');

  AuthUserIPList: TStringList;
  AuthLangList: TStringList;

  GameStateList: TStringList;

  MyMsgList: TStringList;  //总后台管理消息


implementation

{$R *.dfm}

uses
  IWInit, IWGlobal, ConfigINI, ServerINI, GSProto, MSXML, SQLFileDecrypt, AES,
  uDataDispose, Share, ComCBPRead_TLB, AIWRobot, Forms;

function IWServerController: TIWServerController;
begin
  Result := TIWServerController(GServerController);
end;

function UserSession: TIWUserSession;
begin
  Result := TIWUserSession(WebApplication.Data);
end;

function TIWServerController.PayAndOLTotal(sspid: string): Boolean;
const
  sqlOnlineCount = 'SELECT MAX(onlinecount) AS onlinecount FROM log_onlinecount_%s ';
  sqlPayAndOLTotal = 'SELECT SUM(rmb) AS TotalMoney,COUNT(DISTINCT account) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND orderdate>="%s" AND orderdate<="%s 23:59:59"';
var
  psld: PTServerListData;
  TotalUser, TotalOnline, TotalMoney: Integer;
  sBuffer  : string;
  msg : TDefaultMessage;
  samdb, saccont: string;
begin
  Result := False;
 // TotalUser := 0; TotalOnline := 0; TotalMoney := 0;
  try
    sBuffer := '';
    psld := GetServerListDataBySPID(sspid);
    if psld = nil then Exit;
    ConnectionLogMysql(SQLConnectionASumOL,psld.LogDB,psld.LogHostName);
    ConnectionSessionMysql(SQLConnectionASumMoney,psld.AccountDB,psld.SessionHostName);
    try
      with quASumOL do //在线人数
      begin
        SQL.Text := Format(sqlOnlineCount,[FormatDateTime('yyyymmdd',Now)]);
        Open;
        TotalOnline := Fields[0].AsInteger;
        Close;
      end;

      with quASumMoney do
      begin
        SQL.Text := Format(sqlPayAndOLTotal,[psld.amdb,psld.spid, FormatDateTime('yyyy-mm-dd',Now),FormatDateTime('yyyy-mm-dd',Now)]);;
        Open;
       // TotalMoney := Trunc(Fields[0].AsFloat*psld^.CurrencyRate*10);
        TotalMoney := ROUND(DivZero(Fields[0].AsInteger,psld.CurrencyRate) * 10);

        TotalUser  := Fields[1].AsInteger;
        Close;
      end;

      //New Add
      if psld^.SessionHostName2 <> '127.0.0.1' then
      begin
        if psld^.AccountDB2 = 'cq_account' then saccont := 'cq_account'
        else  saccont := psld^.AccountDB2;

        if psld^.Amdb2 = 'amdb' then samdb := 'amdb'
        else  samdb := psld^.Amdb2;

        ConnectionSessionMysql(SQLConnectionASumMoney,saccont,psld.SessionHostName2);
        with quASumMoney do
        begin
          SQL.Text := Format(sqlPayAndOLTotal,[psld.amdb,psld.spid, FormatDateTime('yyyy-mm-dd',Now),FormatDateTime('yyyy-mm-dd',Now)]);;
          Open;
         // TotalMoney := TotalMoney + Trunc(Fields[0].AsFloat*psld^.CurrencyRate*10);
          TotalMoney := TotalMoney + ROUND(DivZero(Fields[0].AsInteger,psld.CurrencyRate) * 10);
          TotalUser  := TotalUser + Fields[1].AsInteger;
          Close;
        end;
      end;

      sBuffer := psld.spid +'/'+IntToStr(TotalMoney)+'/'+IntToStr(TotalUser)+'/'+IntToStr(TotalOnline);
      msg := MakeDefaultMsg (CM_IW_PAYALL, 0, 0, 0, 0);
      SendCMSocket(EncodeMessage(msg) + EncodeString(AnsiString(AnsiToUtf8(sBuffer))));
      Result := True;
    finally
      SQLConnectionASumOL.Close;
      SQLConnectionASumMoney.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

function TIWServerController.PayAndOLTotal2(sspid: string): Boolean;
const
  sqlOnlineCount = 'SELECT MAX(onlinecount) AS onlinecount FROM log_onlinecount_%s ';
  sqlPayAndOLTotal = 'SELECT SUM(rmb) AS TotalMoney,COUNT(DISTINCT account) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND orderdate>="%s" AND orderdate<="%s 23:59:59"';
var
  psld: PTServerListData;
  TotalUser, TotalOnline, TotalMoney: Integer;
  sBuffer  : string;
  msg : TDefaultMessage;
  samdb, saccont: string;
begin
  Result := False;
 // TotalUser := 0; TotalOnline := 0; TotalMoney := 0;
  try
    sBuffer := '';
    psld := GetServerListDataBySPID(sspid);
    if psld = nil then Exit;
    ConnectionLogMysql(SQLConnectionASumOL,psld.LogDB,psld.LogHostName);
    ConnectionSessionMysql(SQLConnectionASumMoney,psld.AccountDB,psld.SessionHostName);
    try
      with quASumOL do //在线人数
      begin
        SQL.Text := Format(sqlOnlineCount,[FormatDateTime('yyyymmdd',Now)]);
        Open;
        TotalOnline := Fields[0].AsInteger;
        Close;
      end;

      with quASumMoney do
      begin
        SQL.Text := Format(sqlPayAndOLTotal,[psld.amdb,psld.spid, FormatDateTime('yyyy-mm-dd',Now),FormatDateTime('yyyy-mm-dd',Now)]);;
        Open;
        //TotalMoney := Trunc(Fields[0].AsFloat*psld^.CurrencyRate*10);
        TotalMoney := ROUND(DivZero(Fields[0].AsInteger,psld.CurrencyRate) * 10);
        TotalUser  := Fields[1].AsInteger;
        Close;
      end;

      //New Add
      if psld^.SessionHostName2 <> '127.0.0.1' then
      begin
        if psld^.AccountDB2 = 'cq_account' then saccont := 'cq_account'
        else  saccont := psld^.AccountDB2;

        if psld^.Amdb2 = 'amdb' then samdb := 'amdb'
        else  samdb := psld^.Amdb2;

        ConnectionSessionMysql(SQLConnectionASumMoney,saccont,psld.SessionHostName2);
        with quASumMoney do
        begin
          SQL.Text := Format(sqlPayAndOLTotal,[psld.amdb,psld.spid, FormatDateTime('yyyy-mm-dd',Now),FormatDateTime('yyyy-mm-dd',Now)]);;
          Open;
        //  TotalMoney := TotalMoney + Trunc(Fields[0].AsFloat*psld^.CurrencyRate*10);
          TotalMoney := TotalMoney + ROUND(DivZero(Fields[0].AsInteger,psld.CurrencyRate) * 10);
          TotalUser  := TotalUser + Fields[1].AsInteger;
          Close;
        end;
      end;

      sBuffer := FormatDateTime('YYYY-MM-DD hh:mm:ss',Now)+'/'+psld.spid +'/'+IntToStr(TotalMoney)+'/'+IntToStr(TotalUser)+'/'+IntToStr(TotalOnline);
      msg := MakeDefaultMsg (CM_IW_PAYALL, 0, 0, 0, 0);
      SendCMSocket(EncodeMessage(msg) + EncodeString(AnsiString(AnsiToUtf8(sBuffer))));
      Result := True;
    finally
      SQLConnectionASumOL.Close;
      SQLConnectionASumMoney.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.InsertPayAndOL(sdata: string);
const
  sqlInsertPayUser = 'INSERT INTO %s.mypaydata VALUES ("%s","%s","%s",%d,%d)';
  sqlUpdatePayUser = 'UPDATE %s.mypaydata SET paytotal="%s",payuser=%d,globalonline=%d WHERE logdate>="%s" AND logdate<="%s 23:59:59" and spid="%s"';
  sqlCreatePayUser = 'CREATE TABLE %s.mypaydata (logdate datetime NOT NULL, spid varchar(3) NOT NULL, paytotal decimal(10) default NULL,payuser int(10) NOT NULL default "0", ' +
                     'globalonline int(10) NOT NULL default "0") ENGINE=MyISAM DEFAULT CHARSET=utf8;';
   function IsCheckResult(SQLQuery: TSQLQuery; gstatic, sspid, sdate: string): Boolean;
   const
    tSql = 'SELECT logdate FROM %s.mypaydata WHERE spid="%s" AND logdate>="%s" AND logdate<="%s 23:59:59"';
   var
    gtgold2: string;
   begin
     gtgold2:= Format(tSql,[gstatic, sspid, sdate, sdate]);
     with SQLQuery do
     begin
      SQL.Text := Format(tSql,[gstatic, sspid, sdate, sdate]);
      Open;
      Result := Fields[0].AsString <> '';
      Close;
     end;
   end;
var
  psld: PTServerListData;
  gspid, guol, gtusr, gtgold: string;
begin
  try
    sdata := GetValidStr3 (sdata, gspid, ['/']);
    sdata := GetValidStr3 (sdata, gtgold, ['/']);
    sdata := GetValidStr3 (sdata, gtusr, ['/']);
    sdata := GetValidStr3 (sdata, guol, ['/']);

    psld := GetServerListDataBySPID(objINI.IWServerSPID); //读取总后台结构
    if psld = nil then Exit;
    ConnectionLogMysql(SQLConnectionASumChg,psld.LogDB,psld.LogHostName);
    try
      if not IsCheckTable(quASumchg,psld.GstaticDB,'mypaydata') then
      begin
        DBExecSQL(quASumchg,Format(sqlCreatePayUser,[psld.GstaticDB]));
      end;

      if not IsCheckResult(quASumchg, psld.GstaticDB, gspid, FormatDateTime('YYYY-MM-DD',Now)) then
      begin
        with quASumchg do
        begin
          SQL.Text := Format(sqlInsertPayUser,[psld.GstaticDB,FormatDateTime('YYYY-MM-DD hh:mm:ss',now), gspid, gtgold, Str_ToInt(gtusr, 0), Str_ToInt(guol, 0)]);
          ExecSQL;
          Close;
        end;
      end
      else begin
        with quASumchg do
        begin
          SQL.Text := Format(sqlUpdatePayUser,[psld.GstaticDB, gtgold, Str_ToInt(gtusr, 0), Str_ToInt(guol, 0), FormatDateTime('YYYY-MM-DD',now), FormatDateTime('YYYY-MM-DD',now), gspid]);
          ExecSQL;
          Close;
        end;
      end;
    finally
      SQLConnectionASumChg.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.InsertPayAndOL2(sdata: string);
const
  sqlInsertPayUser = 'INSERT INTO %s.mypaydata VALUES ("%s","%s","%s",%d,%d)';
  sqlUpdatePayUser = 'UPDATE %s.mypaydata SET paytotal="%s",payuser=%d,globalonline=%d WHERE logdate>="%s" AND logdate<="%s 23:59:59" and spid="%s"';
  sqlCreatePayUser = 'CREATE TABLE %s.mypaydata (logdate datetime NOT NULL, spid varchar(3) NOT NULL, paytotal decimal(10) default NULL,payuser int(10) NOT NULL default "0", ' +
                     'globalonline int(10) NOT NULL default "0") ENGINE=MyISAM DEFAULT CHARSET=utf8;';
   function IsCheckResult(SQLQuery: TSQLQuery; gstatic, sspid, sdate: string): Boolean;
   const
    tSql = 'SELECT logdate FROM %s.mypaydata WHERE spid="%s" AND logdate>="%s" AND logdate<="%s 23:59:59"';
   var
    sidate: string;
   begin
     sdate := GetValidStr3 (sdate, sidate, [' ']);
     with SQLQuery do
     begin
      SQL.Text := Format(tSql,[gstatic, sspid, sidate, sidate]);
      Open;
      Result := Fields[0].AsString <> '';
      Close;
     end;
   end;
var
  psld: PTServerListData;
  gdate, gspid, guol, gtusr, gtgold, sidate: string;
begin
  try
    sdata := GetValidStr3 (sdata, gdate, ['/']);
    sdata := GetValidStr3 (sdata, gspid, ['/']);
    sdata := GetValidStr3 (sdata, gtgold, ['/']);
    sdata := GetValidStr3 (sdata, gtusr, ['/']);
    sdata := GetValidStr3 (sdata, guol, ['/']);

    psld := GetServerListDataBySPID(objINI.IWServerSPID); //读取总后台结构
    if psld = nil then Exit;
    ConnectionLogMysql(SQLConnectionASumChg,psld.LogDB,psld.LogHostName);
    try
      if not IsCheckTable(quASumchg,psld.GstaticDB,'mypaydata') then
      begin
        DBExecSQL(quASumchg,Format(sqlCreatePayUser,[psld.GstaticDB]));
      end;

      if not IsCheckResult(quASumchg, psld.GstaticDB, gspid, gdate) then
      begin
        with quASumchg do
        begin
          SQL.Text := Format(sqlInsertPayUser,[psld.GstaticDB,gdate, gspid, gtgold, Str_ToInt(gtusr, 0), Str_ToInt(guol, 0)]);
          ExecSQL;
          Close;
        end;
      end
      else begin
        gdate := GetValidStr3 (gdate, sidate, [' ']);
        with quASumchg do
        begin
          SQL.Text := Format(sqlUpdatePayUser,[psld.GstaticDB, gtgold, Str_ToInt(gtusr, 0), Str_ToInt(guol, 0), sidate, sidate, gspid]);
          ExecSQL;
          Close;
        end;
      end;
    finally
      SQLConnectionASumChg.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.ASumTime1Timer(Sender: TObject);
var
  I: Integer;
  psld: PTServerListData;
begin
  if not objINI.IWBoServer then //检测不是总后台
  begin
    if BoRunClient then //如果断开就不查询
    begin
      for I := 0 to ServerList.Count - 1 do
      begin
        psld := PTServerListData(ServerList.Objects[I]);
        if psld <> nil then
        begin
          if psld.Index <> 0 then Continue;

          if Pos(psld^.spID,objINI.DataDisposeSpid) <> 0 then
          begin
             PayAndOLTotal2(psld^.spID);
          end;
        end;
      end;
    end;
  end;
end;

procedure TIWServerController.OnError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
  BoRunClient := FALSE; //强制关闭
end;
//连接    OnDisconnect
procedure TIWServerController.OnConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
	BoRunClient := True;
  SendCMSocket (EncodeMessage(MakeDefaultMsg(CM_REGIST_SERVER_RET,0,objINI.IW_SID,0,0)) +  EncodeString(AnsiString(objINI.IW_SPID+ '|'+objINI.sAppTitle + ' V'+ GetVersionEx)));
  CSocStr := '';
  CBufferStr := '';
end;
//断开
procedure TIWServerController.OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
	BoRunClient := FALSE;
end;

//消息
procedure TIWServerController.OnRead(Sender: TObject; Socket: TCustomWinSocket);
var
   n: integer;
   data, data2: AnsiString;
begin
   data := Socket.ReceiveText;

   n := pos('*', string(data));
   if n > 0 then begin
      data2 := Copy (data, 1, n-1);
      data := data2 + Copy (data, n+1, Length(data));
      IWFClient.Socket.SendText ('*');
   end;
   CSocStr := CSocStr + string(data);
end;

procedure TIWServerController.ConnectionLogMysql(SQLConnection: TSQLConnection;
  slog,sHostName: string);
begin
  SQLConnection.Connected := False;
  SQLConnection.Params.Clear;
  SQLConnection.Params.Append('HostName='+sHostName);
  SQLConnection.Params.Append('Database=' + slog);
  SQLConnection.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnection.Params.Append('Password=' + UM_PASSWORD);
  SQLConnection.Params.Append('ServerCharset=utf-8');
  SQLConnection.Connected := True;
end;

procedure TIWServerController.ConnectionLocalLogMysql(SQLConnection: TSQLConnection;
  sHostName: string);
begin
  SQLConnection.Connected := False;
  SQLConnection.Params.Clear;
  SQLConnection.Params.Append('HostName='+sHostName);
  SQLConnection.Params.Append('Database=' + UM_DATA_LOCALLOG);
  SQLConnection.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnection.Params.Append('Password=' + UM_PASSWORD);
  SQLConnection.Params.Append('ServerCharset=utf-8');
  SQLConnection.Connected := True;
end;

procedure TIWServerController.ConnectionRoleMysql(SQLConnection: TSQLConnection;
  sHostName, sDataBase, sUser, sPass: string; iPort: Integer);
begin
  SQLConnection.Connected := False;
  SQLConnection.Params.Clear;
  SQLConnection.Params.Append('HostName='+sHostName);
  SQLConnection.Params.Append('Database='+sDataBase);
  SQLConnection.Params.Append('User_Name='+sUser);
  SQLConnection.Params.Append('Password='+sPass);
  SQLConnection.Params.Append('ServerCharset=utf-8');
  SQLConnection.Params.Append('Server Port='+IntToStr(iPort));
  SQLConnection.Connected := True;
end;

procedure TIWServerController.ConnectionRoleMysql(SQLConnection: TSQLConnection;
  sHostName, sDataBase: string);
begin
  SQLConnection.Connected := False;
  SQLConnection.Params.Clear;
  SQLConnection.Params.Append('HostName='+sHostName);
  SQLConnection.Params.Append('Database='+sDataBase);
  SQLConnection.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnection.Params.Append('Password=' + UM_PASSWORD);
  SQLConnection.Params.Append('ServerCharset=utf-8');
  SQLConnection.Connected := True;
end;

procedure TIWServerController.ConnectionSessionMysql(
  SQLConnection: TSQLConnection; sAccount,sHostName: string);
begin
  SQLConnection.Connected := False;
  SQLConnection.Params.Clear;
  SQLConnection.Params.Append('HostName='+sHostName);
  SQLConnection.Params.Append('Database=' + sAccount);
  SQLConnection.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnection.Params.Append('Password=' + UM_PASSWORD);
  SQLConnection.Params.Append('ServerCharset=utf-8');
  SQLConnection.Connected := True;
end;

function TIWServerController.DBExecSQL(SQLQuery: TSQLQuery;
  sSQL: string): Integer;
begin
  with SQLQuery do
  begin
    SQL.Text := sSQL;
    Result := ExecSQL;
    Close;
  end;
end;

procedure TIWServerController.DecodeMessagePacket (datablock: string);
var
   i, iPos: Integer;
   head, body: String;
   sstr, sdata: String;
   msg2, msgex : TDefaultMessage;
   m_Server: TGSConnection;
   GSConnection: TGSConnection;
begin
   head := Copy (datablock, 1, DEFBLOCKSIZE);
   body := Copy (datablock, DEFBLOCKSIZE+1, Length(datablock)-DEFBLOCKSIZE);
   msg2  := DecodeMessage (AnsiString(head));
   case msg2.Ident of
      SM_RELOADDATALL: //重新加载ServerList列表
         begin
            case msg2.Tag of
               0:
               begin
                  LoadServerList;
                  LoadShopList;
                  LoadStdItems;
                  LoadTasks;
                  LoadLogIdent;
                  LoadCommonList;
               end;
               1: LoadServerList;
               2: LoadShopList;
               3: LoadStdItems;
               4: LoadTasks;
               5: LoadLogIdent;
               6: LoadCommonList;
            end;
            msgex := MakeDefaultMsg (CM_RELOADDATALL, msg2.Recog, 0, 0, 0);
            SendCMSocket(EncodeMessage(msgex));
         end;
      SM_RELOADNPC:
         begin
            body := string(DecodeString(AnsiString(body)));

            iPos := Pos('/',body);
            sstr := Copy(body,1,iPos-1);
            sdata := Copy(body,iPos+1,Length(body));

            for i := 0 to FGSMServer.FConnectionList.Count-1 do
            begin
              GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
              m_Server := FGSMServer.GetServerByIndex(GSConnection.spid, GSConnection.ServerIndex);
              if m_Server <> nil then
              m_Server.SendReloadNPC(-1, sstr, sdata);
            end;
            msgex := MakeDefaultMsg (CM_RELOADNPC, msg2.Recog, 0, 0, 0);
            SendCMSocket (EncodeMessage(msgex));
         end;
      SM_RELOAD_FUNCTION:
         begin
            for i := 0 to FGSMServer.FConnectionList.Count-1 do
            begin
              GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
              m_Server := FGSMServer.GetServerByIndex(GSConnection.spid, GSConnection.ServerIndex);
              if m_Server <> nil then
                m_Server.SendReloadFunction(-1);
            end;
            msgex := MakeDefaultMsg (CM_RELOAD_FUNCTION, msg2.Recog, 0, 0, 0);
            SendCMSocket (EncodeMessage(msgex));
         end;
      SM_REFRESHCORSS:
         begin
            for i := 0 to FGSMServer.FConnectionList.Count-1 do
            begin
              GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
              m_Server := FGSMServer.GetServerByIndex(GSConnection.spid, GSConnection.ServerIndex);
              if m_Server <> nil then
                m_Server.SendSetReFreshcorss(-1);
            end;
            msgex := MakeDefaultMsg(CM_REFRESHCORSS, msg2.Recog, 0, 0, 0);
            SendCMSocket (EncodeMessage(msgex));
         end;
      SM_RELOADCONFIG:
         begin
            body := string(DecodeString(AnsiString(body)));
            for i := 0 to FGSMServer.FConnectionList.Count-1 do
            begin
              GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
              m_Server := FGSMServer.GetServerByIndex(GSConnection.spid, GSConnection.ServerIndex);
              if m_Server <> nil then
                 m_Server.SendSetReLoadConfig(-1, body);
            end;
            msgex := MakeDefaultMsg(CM_RELOADCONFIG, msg2.Recog, 0, 0, 0);
            SendCMSocket (EncodeMessage(msgex));
         end;
      SM_RELOADLANG:
         begin
            for i := 0 to FGSMServer.FConnectionList.Count-1 do
            begin
              GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
              m_Server := FGSMServer.GetServerByIndex(GSConnection.spid, GSConnection.ServerIndex);
              if m_Server <> nil then
                m_Server.SendSetReLoadLang(-1);
            end;
            msgex := MakeDefaultMsg(CM_RELOADLANG, msg2.Recog, 0, 0, 0);
            SendCMSocket (EncodeMessage(msgex));
         end;
   else
   end;
end;

procedure TIWServerController.GSRequestResult(Sender: TObject;
  Connection: TGSConnection; const DefMsg: TDefaultMessage; Data: string);
var
  RetData: string;
  pDefMsg: PTDefaultMessage;
begin
  EnterCriticalSection(FPrintMsgLock);
  try
    case DefMsg.Ident of
       MCS_VIEW_STATE: //接收系统状态返回消息
        begin
           RetData := UTF8ToString(DecodeString(AnsiString(Data)));
           GameStateList.Add(RetData);
        end;
    else
       begin
         New(pDefMsg);
         pDefMsg^ := DefMsg;
         RetData := UTF8ToString(DecodeString(AnsiString(Data)));
         GSMsgList.AddObject(IntToStr(Connection.ServerIndex) +'|'+RetData,TObject(pDefMsg));
       end;
    end;
  finally
    LeaveCriticalSection(FPrintMsgLock);
  end;
end;

procedure TIWServerController.ZGSRequestResult(Sender: TObject;
  Connection: TZGSConnection; const DefMsg: TDefaultMessage; Data: string);
var
  RetBody: string;
  pDefMsg: PTDefaultMessage;
begin
  EnterCriticalSection(FPrintMsgLockIW);
  try
    case DefMsg.Ident of
       CM_IW_PAYALL: //接收汇总信息
           begin
              RetBody := UTF8ToString(DecodeString(AnsiString(Data)));
              InsertPayAndOL2 (RetBody);
           end;
    else
       begin
          New(pDefMsg);
          pDefMsg^ := DefMsg;
          RetBody := UTF8ToString(DecodeString(AnsiString(Data)));
          MyMsgList.AddObject(IntToStr(Connection.ServerIndex) + '|'+ RetBody,TObject(pDefMsg));
              //    GSMsgList.AddObject(IntToStr(Connection.ServerIndex) +'|'+RetData,TObject(pDefMsg));
       end;
    end;
  finally
    LeaveCriticalSection(FPrintMsgLockIW);
  end;
end;

function TIWServerController.IsCheckTable(SQLQuery: TSQLQuery; sDBName,
  sTableName: string): Boolean;
const
  tSql = 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA="%s" AND TABLE_NAME="%s"';
begin
  with SQLQuery do
  begin
    SQL.Text := (Format(tSql,[sDBName,sTableName]));
    Open;
    Result := Fields[0].AsString<>'';
    Close;
  end;
end;

procedure TIWServerController.IWServerControllerBaseAfterRender(
  ASession: TIWApplication; AForm: TIWBaseForm);
begin
  ASession.SessionTimeOut := 300;
end;

procedure TIWServerController.IWServerControllerBaseBackButton(
  ASubmittedSequence, ACurrentSequence: Integer; AFormName: string;
  var VHandled, VExecute: Boolean);
Type
  TIWFormClass = class of TIWForm;
var
  LForm : TIWForm;
begin
  VHandled := True;
  VExecute := True;
  if AFormName = '' then Exit;
  if WebApplication.FindComponent(AFormName) <> nil then
  begin
    WebApplication.SetActiveForm(WebApplication.FindComponent(AFormName) as TIWContainer);
  end else
  begin
    try
      LForm := TIWFormClass(FindClass('T'+AFormName)).Create(WebApplication);
      WebApplication.SetActiveForm(LForm);
    except
      VHandled := False;
    end;
  end;
end;

procedure TIWServerController.IWServerControllerBaseBeforeDispatch(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
const
  OldURLPage = '/IWStat';
begin
  if Request.URL = OldURLPage then
  begin
    Response.SendRedirect(AnsiString(Format('http://%s:%d',[string(Request.Host),Request.ServerPort])));
    Handled :=  True;
    Exit;
  end;
end;

procedure TIWServerController.IWServerControllerBaseCloseSession(
  ASession: TIWApplication);
var
  Idx: Integer;
begin
  EnterCriticalSection( m_SessionLoadLock );
  try
    Idx := SessionIDList.IndexOf(ASession.AppID);
    if Idx <> -1 then
    begin
      SessionIDList.Delete(Idx);
    end;
  finally
   LeaveCriticalSection( m_SessionLoadLock );
  end;
end;

procedure TIWServerController.IWServerControllerBaseCreate(Sender: TObject);
begin
  SessionTimeout := 180;
  CoInitialize(nil);
  BoundIP := '0.0.0.0';
  try
    ServerList := TStringList.Create;
    FStdItemList := TStringList.Create;
    ShopList := TStringList.Create;
    LogIdentList := TStringList.Create;
    CommonList := TStringList.Create;
    SessionIDList := TStringList.Create;
    GSMsgList := TStringList.Create;
 //   AcrossRankList := TStringList.Create;
    objINI := TConfigINI.Create(AppPath+ZJConfigINI);
    Port := objINI.IW_Port;
    objServerINI := TServerINI.Create(AppPath+ZJServerINI);
    HTMLHeaders.Add('<link rel="shortcut icon" href="/files/favicon.ico">');
    AppPathEx := AppPath;
    AppName := objINI.sAppName;
    InitializeCriticalSection( m_SafetyPassLock );
    InitializeCriticalSection( m_SessionLoadLock );
    InitializeCriticalSection( m_WriteLogLock );

    IdHTTPServer.DefaultPort := objINI.SafetyPassPort;
    IdHTTPServer.Active := objINI.SafetyPassStart;
    SafetyPassHttpServer := IdHTTPServer;
    InitializeCriticalSection(FPrintMsgLock);
    InitializeCriticalSection(FPrintMsgLockIW);
    FGSMServer := TGSManageServer.Create;
    FGSMServer.ServiceName := '暗黑降魔录服务端管理中心';
    FGSMServer.BindPort := objINI.EngineConnectPort;
    FGSMServer.OnGSRequestResult := GSRequestResult;
    FGSMServer.Start();
    //总后台
    if objINI.IWBoServer then
    begin
      ZGSMServer := TZGSManageServer.Create;
      ZGSMServer.ServiceName := 'VSPK后台管理中心';
      ZGSMServer.BindPort := objINI.IWServerPort;
      ZGSMServer.OnGSRequestResult := ZGSRequestResult; //这需要改
      ZGSMServer.Start();
    end
    else begin
      IWFClient := TClientSocket.Create(nil);
      IWFClient.OnRead := OnRead;        //消息
      IWFClient.OnConnect := OnConnect;  //连接
      IWFClient.OnDisconnect := OnDisconnect;  //断开
      IWFClient.OnError := OnError;      //错误或断开
    end;
   // ServiceXML := TAAServiceXML.Create(AppPathEx);
    //IsAcrossRun := False;
   // AcrossIDBDataRetry := 0;
    AuthIPList := TStringList.Create;
    AuthLangList := TStringList.Create;
    GameStateList := TStringList.Create;
    AuthUserIPList := TStringList.Create;
    TaskList:= TStringList.Create;
    BugTypeList := TStringList.Create;
    LoadStdItems;
    LoadServerList;
    LoadShopList;
  //  ServiceXML.LoadAwardConfig;
    LoadTasks;
    LoadLogIdent;
    LoadCommonList;

    ARobots:= TFileRoot.Create;
    ARobots.LoadRobotList;

    if FileExists(AppPath+AuthIPListFile) then
    begin
      AuthIPList.LoadFromFile(AppPath+AuthIPListFile);
    end;
    if FileExists(AppPath+'LangList.txt') then
    begin
      AuthLangList.LoadFromFile(AppPath+'LangList.txt');
    end;

    if FileExists(AppPath+UserIPListFile) then
    begin
      AuthUserIPList.LoadFromFile(AppPath+UserIPListFile);
    end;

    DataDispose := TDataDispose.Create;

    MyMsgList := TStringList.Create;

    Bobusy:= False;

   	BoRunClient := FALSE;
    TimerStart.Enabled := True;

    TimerNoticeRun.Enabled := True; //手动初始化 防止报错
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.IWServerControllerBaseDestroy(Sender: TObject);
begin
  ClearServerListData;
  ServerList.Free;
  ClearStdItems;
  FStdItemList.Free;
  ClearShopListData(ShopList);
  ShopList.Free;
  objINI.Free;
  objServerINI.Free;
  LogIdentList.Free;
  CommonList.Free;
  TaskList.Free;
  DeleteCriticalSection( m_SafetyPassLock );
  FGSMServer.Stop;
  FGSMServer.Release();
  ZGSMServer.Stop;
  ZGSMServer.Release();
  DeleteCriticalSection(FPrintMsgLock);
  DeleteCriticalSection(FPrintMsgLockIW);
  SessionIDList.Free;
  ClearGSMsgListData;
  GSMsgList.Free;
  DeleteCriticalSection( m_SessionLoadLock );
  DeleteCriticalSection( m_WriteLogLock );
 // ServiceXML.Free;
 // AcrossRankList.Free;
  AuthIPList.Free;
  AuthLangList.Free;
  GameStateList.Free;
  AuthUserIPList.Free;
  BugTypeList.Free;
  DataDispose.Free;

  ARobots.Free;

  MyMsgList.Free;

  CoUninitialize;
end;

procedure TIWServerController.IWServerControllerBaseNewSession(
  ASession: TIWApplication; var VMainForm: TIWBaseForm);
begin
  if (AuthIPList.Count > 0) and (AuthIPList.IndexOf(ASession.IP) = -1) then
  begin
   // ASession.Terminate('未授权IP');
    ASession.Terminate('Unauthorized IP');
    Exit;
  end;
  try
    EnterCriticalSection( m_SessionLoadLock );
    try
      ASession.Data := TIWUserSession.Create(nil);
      SessionIDList.Add(ASession.AppID);
    finally
      LeaveCriticalSection( m_SessionLoadLock );
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.TimerAutoRunTimer(Sender: TObject);
begin
  if SameTime(StrToTime(TimeToStr(Time)),StrToTime(objINI.LossBuildTime)) then
  begin
    EnterCriticalSection( m_SessionLoadLock );
    try
      LoadServerList;
    finally
      LeaveCriticalSection( m_SessionLoadLock );
    end;
    DataDispose.ExecEverydayData;
  end;
  if (DayOf(Now) = 1) and (SameTime(StrToTime(TimeToStr(Time)),StrToTime('0:00:00'))) then
  begin
    EnterCriticalSection( m_SessionLoadLock );
    try
      LoadServerList;
    finally
      LeaveCriticalSection( m_SessionLoadLock );
    end;
    DataDispose.ExecMonthlyData;
  end;
end;

procedure TIWServerController.TimerAutoUpdateTimer(Sender: TObject);
begin
  LoadServerList;
  LoadLogIdent;
end;

procedure TIWServerController.TimerNoticeRunTimer(Sender: TObject);
begin
  ARobots.ProcessRun;
end;

procedure TIWServerController.TimerStartTimer(Sender: TObject);
begin
  if not objINI.IWBoServer then //检测不是总后台
  begin
     if not BoRunClient  then
     begin
        IWFClient.Close;
        IWFClient.Address := objINI.IWServerIP;
        IWFClient.Port := objINI.IWServerPort;
        IWFClient.Open;

        SendTimer.Enabled := True;
     end;
  end else
    TimerStart.Enabled := False;
end;

procedure TIWServerController.SetRobotMessage(spid: string; Idx, nMsgType, Num, nTick: Integer; sdata: string; daTime: TDateTime);
const
  sqlAdd = 'INSERT INTO %s.robotinfo VALUES ("%s",%d,%d,%s,%d,"%s",%d)';
  sqlUpdate = 'UPDATE %s.robotinfo SET numtype = %d , logdate = "%s" WHERE spid = "%s" and serverindex = %d and message = %s';
  sqlDel = 'DELETE FROM %s.robotinfo WHERE spid = "%s" and serverindex = %d and message=%s';
  sqlDel2 = 'DELETE FROM %s.robotinfo WHERE spid = "%s" and serverindex = %d and numtype in (3,4) and message=%s and logdate = "%s"';
  sqlDel3 = 'DELETE FROM %s.robotinfo WHERE spid = "%s" and serverindex = %d and numtype = 3 and logdate = "%s"';
var
  sSQL: string;
  psld: PTServerListData;
begin
  try
    psld := GetServerListData(spid, Idx);
    if psld = nil then Exit;
    ConnectionLogMysql(SQLConnectionRAuto,psld^.LogDB,psld^.LogHostName);
    try
      case Num of
        1, 2: //公告 1定时增加 2定时删除
        begin
          sSQL := Format(sqlAdd,[psld^.GstaticDB, spid, Idx, nMsgType, QuerySQLStr(sdata), Num, FormatDateTime('YYYY-MM-DD hh:mm:ss',daTime), nTick]);
        end;

        3, 4: //经验 3定时增加 4定时删除
        begin
          sSQL := Format(sqlAdd,[psld^.GstaticDB, spid, Idx, nMsgType, QuerySQLStr(sdata), Num, FormatDateTime('YYYY-MM-DD hh:mm:ss',daTime), nTick]);
        end;

        100: //删除 经验
        begin
          sSQL := Format(sqlDel2,[psld^.GstaticDB, spid, Idx, QuerySQLStr(sdata), FormatDateTime('YYYY-MM-DD hh:mm:ss',daTime)]);
        end;
        101: //删除 经验
        begin
          sSQL := Format(sqlDel3,[psld^.GstaticDB, spid, Idx, FormatDateTime('YYYY-MM-DD hh:mm:ss',daTime)]);
        end;
        102: //经验 修改
        begin
          sSQL := Format(sqlUpdate,[psld^.GstaticDB, 4, FormatDateTime('YYYY-MM-DD hh:mm:ss',daTime), spid, Idx, QuerySQLStr(sdata)]);
        end;

        103: //删除 公告
        begin
          sSQL := Format(sqlDel,[psld^.GstaticDB, spid, Idx, QuerySQLStr(sdata)]);
        end;
      end;
      quRobotInfo.SQL.Text := sSQL;
      quRobotInfo.ExecSQL;
      quRobotInfo.Close;
    finally
      SQLConnectionRAuto.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.SendAddNotices(spid: string; Idx, nMsgType, nTick: Integer; sdata: string);
var
  m_Server: TGSConnection;
begin
  m_Server := FGSMServer.GetServerByIndex(spid, Idx);
  if m_Server <> nil then
  begin
    m_Server.SendAddNotice(-1, nMsgType, nTick, sdata);
    ARobots.Delete(sdata, Idx);
    SetRobotMessage(spID, Idx, 0, 103, 0, sdata, Now);
  end;
end;

procedure TIWServerController.SendDelNotices(spid: string; Idx: Integer; sdata: string);
var
  m_Server: TGSConnection;
begin
  m_Server := FGSMServer.GetServerByIndex(spid, Idx);
  if m_Server <> nil then
  begin
    m_Server.SendDelNotice(-1, sdata);
    ARobots.Delete(sdata, Idx);
    SetRobotMessage(spID, Idx, 0, 103, 0, sdata, Now);
  end;
end;

procedure TIWServerController.SendSetExpRates(spid: string; Idx, ExpRate, ExpTime: Integer; sdata: string);
var
  m_Server: TGSConnection;
begin
  m_Server := FGSMServer.GetServerByIndex(spid, Idx);
  if m_Server <> nil then
  begin
    m_Server.SendSetExpRate(-1, ExpRate, ExpTime);
  end;
end;

procedure TIWServerController.SendCMSocket (sendstr: AnsiString);
begin
   if IWFClient.Socket.Connected then begin
      IWFClient.Socket.SendText ('#' + sendstr + '!');
   end;
end;


procedure TIWServerController.SendTimerTimer(Sender: TObject);
var
  data: string;
begin
   if Bobusy then exit;
   Bobusy := TRUE;
   try
      CBufferStr := CBufferStr + CSocStr;
      CSocStr := '';
      if CBufferStr <> '' then begin
         while Length(CBufferStr) >= 2 do begin
            if Pos('!', CBufferStr) <= 0 then break;
            CBufferStr := ArrestStringEx (CBufferStr, '#', '!', data);
            if data <> '' then begin
               DecodeMessagePacket (data);
            end else
               if Pos('!', CBufferStr) = 0 then
                  break;
         end;
      end;
   finally
      Bobusy := FALSE;
   end;
end;

function Move(AFormClass: TIWAppFormClass; IsRelease: Boolean = True): TIWAppForm;
var
  ComponentName: string;
begin
  ComponentName := Copy(AFormClass.ClassName,2,Length(AFormClass.ClassName)-1);
  if IsRelease then
    TIWAppForm(WebApplication.ActiveForm).Free
  else
    TIWAppForm(WebApplication.ActiveForm).Hide;
  if WebApplication.FindComponent(ComponentName) <> nil then begin
    Result := TIWAppForm(WebApplication.FindComponent(ComponentName));
  end else begin
    Result := AFormClass.Create(WebApplication);
  end;
end;

function NumberSort(List: TStringList; Index1,Index2: Integer): Integer;
var
  Value1,Value2:Double;
begin
  Value1:=StrToFloat(List[Index1]);
  Value2:=StrToFloat(List[Index2]);
  if   Value1> Value2   then
      Result:=-1
  else if Value1 <Value2 then
    Result:=1
  else
    Result:=0;
end;

function GetCellName(sText: string): string;
begin
  Result := sText;
  if Pos('</FONT>',sText) > 0 then
  begin
    Result := StringReplace(Result,'<FONT color=red>', '', [rfReplaceAll]);
    Result := StringReplace(Result,'</FONT>', '', [rfReplaceAll]);
  end;
end;

function ChangeZero(Value: Double): Double;overload;
begin
  Result := Value;
  if Value = 0 then Result := -1;
end;

function ChangeZero(Value: Integer): Integer;overload;
begin
  Result := Value;
  if Value = 0 then Result := -1;
end;

function DivZero(sValue,eValue: Double): Double;
begin
  Result := 0;
  if (sValue <> 0) and (eValue <> 0) then
  begin
    Result := sValue/eValue;
  end;
end;

function GetServerIndex(ServerName: string): string;
var
  SPos,EPos: Integer;
begin
  Result := '0';
  SPos := Pos('（',ServerName);
  if SPos > -1 then
  begin
    EPos := Pos('区',ServerName);
    if EPos > -1 then
    begin
      Result := Copy(ServerName,SPos+2,EPos-SPos-2);
    end;
  end;
end;

procedure ClearServerListData;
var
  I: Integer;
begin
  for I := 0 to ServerList.Count - 1 do
  begin
    System.DisPose(PTServerListData(ServerList.Objects[I]));
  end;
  ServerList.Clear;
end;

procedure ClearShopListData(pList: TStringList);
var
  I: Integer;
begin
  for I := 0 to pList.Count - 1 do
  begin
    TStringList(pList.Objects[I]).Free;
  end;
  pList.Clear;
end;

function GetHttpXML(sHttp: string): string;
var
  ResponseSteam: TStringStream;
  IdHttp: TIdHttp;
  hs: AnsiString;
begin
  Result := '';
  ResponseSteam := TStringStream.Create('',TEncoding.UTF8);
  IdHttp := TIdHttp.Create;
  IdHttp.HandleRedirects := True;
  try
    IdHttp.Get(sHttp,ResponseSteam);
    Result := ResponseSteam.DataString;
    SetLength(hs,3);
    ResponseSteam.Position := 0;
    ResponseSteam.Read(hs[1],3);
    if hs=#$EF#$BB#$BF then
    begin
      Result := ResponseSteam.ReadString(ResponseSteam.Size-3);
    end;
  finally
    IdHttp.Free;
    ResponseSteam.Free;
  end;
end;

procedure LoadServerList;
var
  I,J,n,iCount: Integer;
  sBonusKey,tmpXML, spD: string;
  xmlDoc : IXMLDOMDocument;
  xmlNode: IXMLDomNode;
  GroupList,NodeList: IXMLDomNodeList;
  psld: PTServerListData;
begin
  CoInitialize(nil);
  tmpXML := GetHttpXML(objINI.ServerListXML);
  if tmpXML <> '' then xmlText := tmpXML;
  xmlDoc := CoDOMDocument.Create();
  EnterCriticalSection(IWServerController.m_SessionLoadLock);
  try
    if xmlDoc.loadXML(xmlText) then
    begin
      ClearServerListData;
      objServerINI.ReadSections;
      xmlNode := xmlDoc.documentElement;
      GroupList := xmlNode.selectNodes('//Group');
      iCount:= 0;
      for I := 0 to objServerINI.SectionList.Count - 1 do
      begin
        New(psld);
        psld.Index := 0;
        psld.spid := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'运营商','wyi');
        spD := psld.spid;
        psld.ServerID := objServerINI.FConfigINI.ReadInteger(objServerINI.SectionList.Strings[I],'服务器ID值',0);
        psld.CurrencyRate := objServerINI.FConfigINI.ReadFloat(objServerINI.SectionList.Strings[I],'货币兑换率',1);
        psld.SessionHostName := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'会话服务器','127.0.0.1');
        psld.SessionHostName2 := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'会话服务器2','127.0.0.1');
        psld.LogHostName := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'日志服务器','127.0.0.1');
        psld.PassKey := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'安全接口Key','wyi');
        psld.BonusKey := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'红利接口Key','');

        psld.LogDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'LogDB','cq_log');
        psld.Amdb := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'Amdb','amdb');
        psld.Amdb2 := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'Amdb2','amdb');
        psld.AccountDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'AccountDB','cq_account');
        psld.AccountDB2 := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'AccountDB2','cq_account');
        psld.GstaticDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'GstaticDB','gstatic');
        sBonusKey :=  psld.BonusKey;
        psld.IsDisplay := True;
        ServerList.AddObject(objServerINI.SectionList.Strings[I],TObject(psld));

        if iCount > 0 then iCount := iCount + 1; //判断如果大于0 +1防止列表赋予出错

        for n := 0 to GroupList.length - 1 do
        begin
          NodeList := GroupList.item[n].selectNodes('Server');
          if spD = GroupList.item[n].attributes.getNamedItem('sp').nodeValue then
          begin
            PTServerListData(ServerList.Objects[iCount]).spID := GroupList.item[n].attributes.getNamedItem('sp').nodeValue;
            PTServerListData(ServerList.Objects[iCount]).Ispid := GroupList.item[n].attributes.getNamedItem('sid').nodeValue;
         //   sBonusKey := objServerINI.FConfigINI.ReadString(ServerList.Strings[i],'红利接口Key','');
            for J := 0 to NodeList.length - 1 do
            begin
              New(psld);
              psld.CurrencyRate := 1;
              if I<objServerINI.SectionList.Count then
              begin
                psld.ServerID := objServerINI.FConfigINI.ReadInteger(objServerINI.SectionList.Strings[i],'服务器ID值',0);
                psld.CurrencyRate := objServerINI.FConfigINI.ReadFloat(objServerINI.SectionList.Strings[i],'货币兑换率',1);

                psld.LogDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'LogDB','cq_log');
                psld.Amdb := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'Amdb','amdb');
                psld.Amdb2 := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'Amdb2','amdb');
                psld.AccountDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'AccountDB','cq_account');
                psld.AccountDB2 := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'AccountDB2','cq_account');
                psld.GstaticDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'GstaticDB','gstatic');
              end;
              psld.Index := NodeList.item[J].attributes.getNamedItem('index').nodeValue;
              psld.SessionHostName := NodeList.item[J].attributes.getNamedItem('ss').nodeValue;
              psld.SessionHostName2 := NodeList.item[J].attributes.getNamedItem('ss').nodeValue;
              psld.RoleHostName := NodeList.item[J].attributes.getNamedItem('db').nodeValue;
              psld.LogHostName := NodeList.item[J].attributes.getNamedItem('log').nodeValue;
              psld.IsDisplay := NodeList.item[J].attributes.getNamedItem('display').nodeValue;
              psld.OpenTime := NodeList.item[J].attributes.getNamedItem('time').nodeValue;
              psld.JoinIdx := NodeList.item[J].attributes.getNamedItem('join').nodeValue;
              psld.spID := GroupList.item[n].attributes.getNamedItem('sp').nodeValue;
              psld.Ispid := GroupList.item[n].attributes.getNamedItem('sid').nodeValue;
              psld.BonusKey := sBonusKey;
              psld.DataBase := NodeList.item[J].attributes.getNamedItem('database').nodeValue;
              ServerList.AddObject(NodeList.item[J].attributes.getNamedItem('name').text,TObject(psld));
              Inc(iCount, 1);
            end;
          end;
        end;
      end;
    end;
  finally
    xmlDoc := nil;
    LeaveCriticalSection( IWServerController.m_SessionLoadLock );
    CoUninitialize;
  end;
end;

procedure LoadShopList;
var
  I,J: Integer;
  cbp: IComBinaryProperty;
  ValueField,ItemsField,TableField,LuaField: ILuaField;
  tmpList: TStringList;
begin
  cbp := CreateLocalComBinaryProperty;
  EnterCriticalSection(IWServerController.m_SessionLoadLock);
  try
    LuaField := cbp.LoadHttpCBP(objINI.ShopListXML);
    ClearShopListData(ShopList);
    for I := 0 to LuaField.FieldCount-1 do
    begin
      TableField := LuaField.FieldIndex[I].AsTable;  //子列表

      if TableField <> nil then
      begin
        ItemsField := TableField.Fields['Items'].AsTable;   //子子列表
        tmpList := TStringList.Create;
        for J:= 0 to ItemsField.FieldCount-1 do
        begin
          ValueField := ItemsField.FieldIndex[J];  //这里需要取子子子列表
          tmpList.AddObject(OnGetStdItemName(ValueField.Fields['Item'].AsInteger),TObject(ValueField.Fields['Price'].FieldIndex[0].Fields['Price'].AsInteger));
        end;
        ShopList.AddObject(TableField.Fields['Name'].AsString,TObject(tmpList));
      end;
    end;
  finally
    cbp := nil;
    LeaveCriticalSection( IWServerController.m_SessionLoadLock );
  end;
end;

procedure LoadStdItems;
var
  I: Integer;
  pStdItem: pTStdItem;
  cbp: IComBinaryProperty;
  TableField,LuaField: ILuaField;
begin
  cbp := CreateLocalComBinaryProperty;
  EnterCriticalSection(IWServerController.m_SessionLoadLock);
  try
    LuaField := cbp.LoadHttpCBP(objINI.ItemListXML);
    ClearStdItems;
    for I := 0 to LuaField.FieldCount-1 do
    begin
      TableField := LuaField.FieldIndex[I].AsTable;
      if TableField <> nil then
      begin
        New(pStdItem);
        FillChar(pStdItem^,SizeOf(pStdItem^),0);
        pStdItem^.Name := ShortString(TableField.Fields['name'].AsString);
        if TableField.FieldExists['dup'] then
        begin
          pStdItem^.Dup := TableField.Fields['dup'].AsInteger;
        end;
        pStdItem^.ItemDateTime := 0;
        FStdItemList.AddObject(string(pStdItem^.Name),TObject(pStdItem));
      end;
    end;
  finally
    cbp := nil;
    LeaveCriticalSection( IWServerController.m_SessionLoadLock );
  end;
end;

procedure ClearStdItems;
var
  I: Integer;
begin
  for I := 0 to FStdItemList.Count - 1 do
  begin
    System.Dispose(pTStdItem(FStdItemList.Objects[I]));
  end;
  FStdItemList.Clear;
end;

procedure LoadTasks;
var
  i: Integer;
  pTask: PTTask;
  cbp: IComBinaryProperty;
  TableField,TableField2,LuaField: ILuaField;
begin
  cbp := CreateLocalComBinaryProperty;
  EnterCriticalSection(IWServerController.m_SessionLoadLock);
  try
    LuaField := cbp.LoadHttpCBP(objINI.TaskListXML);
    ClearTasks;
    for I := 0 to LuaField.FieldCount-1 do
    begin
      TableField := LuaField.FieldIndex[I].AsTable;
      try
        if TableField <> nil then
        begin
          New(pTask);
          pTask^.nTaskID := TableField.Fields['Id'].AsInteger;
          pTask^.sTaskName := ShortString(TableField.Fields['Name'].AsString);
          pTask^.bType := TableField.Fields['Type'].AsInteger;
          pTask^.nParentID :=  TableField.Fields['ParentID'].AsInteger;

          if TableField.FieldExists['conds'] then  //读取子列表..
          begin
             TableField2:=  TableField.Fields['conds'].FieldIndex[0].AsTable;
             if TableField2 <> nil then
             begin
               pTask^.bAcceptLevel := TableField2.Fields['count'].AsInteger;
               pTask^.bMaxLevel := TableField2.Fields['id'].AsInteger;
             end;
          end;
          if TableField.FieldExists['prom'] then  //读取子列表..
          begin
            pTask^.sTaskMapName := ShortString(TableField.Fields['prom'].Fields['scene'].AsString);
          end;

          TaskList.AddObject(string(pTask^.sTaskName),TObject(pTask))
        end;
      except
        continue;
      end;

    end;
  finally
    cbp := nil;
    LeaveCriticalSection( IWServerController.m_SessionLoadLock );
  end;
end;

procedure ClearTasks;
var
  I: Integer;
begin
  for I := 0 to TaskList.Count - 1 do
  begin
    System.Dispose(pTTask(TaskList.Objects[I]));
  end;
  TaskList.Clear;
end;

procedure LoadLogIdent;
var
  tmpXML: string;
begin
  tmpXML := GetHttpXML(objINI.LogIdentFile);
  if tmpXML <> '' then LogIdentList.Text := tmpXML;
end;

procedure LoadCommonList;
var
  tmpXML: string;
begin
  tmpXML := GetHttpXML(objINI.CommandFile);
  if tmpXML <> '' then CommonList.Text := tmpXML;
end;

procedure ClearWebGridDataList(DataList: TStringList);
var
  I: Integer;
begin
  for I := 0 to DataList.Count - 1 do
  begin
    System.Dispose(PTStringArray(DataList.Objects[I]));
  end;
  DataList.Clear;
end;

function GetServerListDataBySPID(const sSPID: string): PTServerListData;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ServerList.Count - 1 do
  begin
    if PTServerListData(ServerList.Objects[I]).spID = sSPID then
    begin
      Result := PTServerListData(ServerList.Objects[I]);
      break;
    end;
  end;
end;

function GetServerListData(sServerName: string): PTServerListData; overload;
begin
  Result := PTServerListData(ServerList.Objects[ServerList.IndexOf(sServerName)]);
end;

function GetServerListData(iServerIndex: Integer): PTServerListData; overload;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ServerList.Count - 1 do
  begin
    if PTServerListData(ServerList.Objects[I]).Index = iServerIndex then
    begin
      Result := PTServerListData(ServerList.Objects[I]);
      break;
    end;
  end;
end;
//新增加 SPID 与 服务器ID判断
function GetServerListData(spid: string; iServerIndex: Integer): PTServerListData; overload;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ServerList.Count - 1 do
  begin
    if (PTServerListData(ServerList.Objects[I]).Index = iServerIndex) and
       (PTServerListData(ServerList.Objects[I]).spID = spid)
    then
    begin
      Result := PTServerListData(ServerList.Objects[I]);
      break;
    end;
  end;
end;

function GetServerListName(spid: string;iServerIndex: Integer; CheckJoin: Boolean = False): string;
var
  I: Integer;
  psld: PTServerListData;
begin
  Result := '';
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := PTServerListData(ServerList.Objects[I]);
    if (psld^.Index = iServerIndex) and (psld^.spID = spid) then
    begin
      Result := ServerList.Strings[I];
      if CheckJoin then
      begin
        if psld^.JoinIdx > 0 then
        begin
          Result := GetServerListName(psld^.spID, psld^.JoinIdx);
        end;
      end;
      break;
    end;
  end;
end;

function GetServerListNameEx(iServerIndex: Integer; CheckJoin: Boolean = False): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to ServerList.Count - 1 do
  begin
    if PTServerListData(ServerList.Objects[I]).Index = iServerIndex then
    begin
      Result := ServerList.Strings[I];
      if CheckJoin then
      begin
        if PTServerListData(ServerList.Objects[I]).JoinIdx > 0 then
        begin
          Result := GetServerListNameEx(PTServerListData(ServerList.Objects[I]).JoinIdx);
        end;
      end;
      break;
    end;
  end;
end;


function GetRecordCount(sSQL: string; Query: TSQLQuery): Integer;
begin
  with Query do
  begin
    SQL.Text := sSQL;
    Open;
    Result := Query.Fields.FieldByNumber(1).AsInteger;
    Close;
  end;
end;

function GetServerIsdisplay(spid: string;ServerIndex: Integer): Boolean;
var
  I: Integer;
  pServerListData: PTServerListData;
begin
  Result := False;
  for I := 0 to ServerList.Count - 1 do
  begin
    pServerListData := PTServerListData(ServerList.Objects[I]);
    if (pServerListData^.Index = ServerIndex) and (pServerListData^.spID = spid) then
    begin
      Result := PTServerListData(ServerList.Objects[I]).IsDisplay;
      break;
    end;
  end;
end;

function OnGetStdItemName(const StdItemIdx: Integer): string;
begin
  if (StdItemIdx <= 0) or (StdItemIdx >= FStdItemList.Count) then
    Result := ''
  else Result := FStdItemList[StdItemIdx];
end;

function OnGetTaskName(const StdTaskIdx: Integer): PTTask; overload;
var
  I: Integer;
  pTask: PTTask;
begin
  Result := nil;
  for I := 0 to TaskList.Count - 1 do
  begin
    pTask := PTTask(TaskList.Objects[I]);
    if pTask^.nTaskID = StdTaskIdx then
    begin
      Result := pTask;
      break;
    end;
  end;
end;

function GetZyName(zyID1,zyID2: Integer): string;
begin
  if (zyID1 <> 0) and (zyID2 <> 0) then
  begin
    Result := ZyNameStr[zyID1] + '或者' + ZyNameStr[zyID2];
  end
  else begin
    Result := ZyNameStr[zyID1];
    if zyID1 = 0 then Result := ZyNameStr[zyID2];
    if Result = ZyNameStr[0] then Result := '不限制';
  end;
end;

function GetLogIdentStr(const nIdent: Integer): string;
var
  I,iPos,iValue: Integer;
  strTmp: string;
begin
  Result := 'N/A('+IntToStr(nIdent)+')';
  for I := 0 to LogIdentList.Count - 1 do
  begin
    strTmp := LogIdentList.Strings[I];
    iPos := Pos('、',strTmp);
    if iPos > 0 then
    begin
      iValue := StrToInt(Copy(strTmp,1,iPos-1));
      if iValue = nIdent then
      begin
        Result := Copy(strTmp,iPos+1,length(strTmp));
        break;
      end;
    end;
  end;
end;

procedure WriteErrorFile(IsDate: Boolean; sText: string);
const
  ErrorDir = 'Error\';
var
  F: TextFile;
  sDate: string;
  Logfile: string;
begin
  if not DirectoryExists(AppPathEx + ErrorDir) then
  begin
    CreateDir(AppPathEx + ErrorDir);
  end;
  LogFile := AppPathEx + ErrorDir + FormatDateTime('YYYYMMDD',Date)+'.txt';
  AssignFile(F, LogFile);
  if FileExists(LogFile) then
    Append(F)
  else
    Rewrite(F);
  sDate := DateTimeToStr(Now) + ':';
  if not IsDate then sDate := '';
  Writeln(F, sDate + sText);
  CloseFile(F);
end;

function GetSessionDMessage(AppID: string): Integer;
var
  I,Recog: Integer;
  pDefMsg: PTDefaultMessage;
begin
  Result := -1;
  Recog := SessionIDList.IndexOf(AppID);
  for I := 0 to GSMsgList.Count - 1 do
  begin
    pDefMsg := PTDefaultMessage(GSMsgList.Objects[I]);
    if Recog = pDefMsg.Recog then
    begin
      Result := I;
      break;
    end;
  end;
end;

function GetSessionIWMessage(AppID: string): Integer;
var
  I,Recog: Integer;
  pDefMsg: PTDefaultMessage;
begin
  Result := -1;
  Recog := SessionIDList.IndexOf(AppID);
  for I := 0 to MyMsgList.Count - 1 do
  begin
    pDefMsg := PTDefaultMessage(MyMsgList.Objects[I]);
    if Recog = pDefMsg.Recog then
    begin
      Result := I;
      break;
    end;
  end;
end;

function GSIWResultStr(AppID: string): string;
const
  SuccessStr: array [0..1] of string = ('成功', '失败');
  ResultStr = '%d<%s> %s';
var
  Idx,IsSuccess: Integer;
  ServerName: string;
  pDefMsg: PTDefaultMessage;
begin
  Result := '';
  EnterCriticalSection(FPrintMsgLockIW);
  try
    pDefMsg := nil; IsSuccess := 1;
    Idx := GetSessionIWMessage(AppID);
    if Idx <> -1 then
    begin
      pDefMsg := PTDefaultMessage(MyMsgList.Objects[Idx]);
      ServerName := GetServerListName(PTServerListData(ServerList.Objects[0])^.spID, 0);
    end;
    if pDefMsg <> nil then
    begin
      if pDefMsg^.Tag > 1 then pDefMsg^.Tag := 1;
      case pDefMsg^.Ident of
        CM_RELOADDATALL:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'重新加载所有数据' + SuccessStr[pDefMsg^.Tag]]);
        end;
        CM_RELOADNPC:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'刷新NPC' + SuccessStr[pDefMsg^.Tag]]);
        end;
        CM_RELOAD_FUNCTION:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'刷新功能脚本' + SuccessStr[pDefMsg^.Tag]]);
        end;
        CM_REFRESHCORSS:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'刷新跨服配置' + SuccessStr[pDefMsg^.Tag]]);
        end;
        CM_RELOADCONFIG:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'刷新引擎配置' + SuccessStr[pDefMsg^.Tag]]);
        end;
        CM_RELOADLANG:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'刷新语言包' + SuccessStr[pDefMsg^.Tag]]);
        end;
      end;
      if Idx < MyMsgList.Count then
      begin
        System.Dispose(pDefMsg);
        MyMsgList.Delete(Idx);
      end;
    end;
  finally
    LeaveCriticalSection(FPrintMsgLockIW);
  end;
end;

function GSResultStr(AppID, spid: string): string;
const
  SuccessStr: array [0..3] of string = ('成功', '失败', '已开启', '未开启');
  SuccessStrEx: array [0..2] of string = ('成功','已存在', '失败');
  ResultStr = '%d<%s> %s';
var
  Idx,IsSuccess,ServerIndex: Integer;
  ServerName,sData,sStr: string;
  pDefMsg: PTDefaultMessage;
begin
  Result := '';
  EnterCriticalSection(FPrintMsgLock);
  try
    pDefMsg := nil; IsSuccess := 1;
    Idx := GetSessionDMessage(AppID);
    if Idx <> -1 then
    begin
      pDefMsg := PTDefaultMessage(GSMsgList.Objects[Idx]);
      sStr := GSMsgList.Strings[Idx];
      ServerIndex := StrToInt(Copy(sStr,1,Pos('|',sStr)-1));
      sData := Copy(sStr,Pos('|',sStr)+1,Length(sStr));
      ServerName := GetServerListName(spid, ServerIndex);
    end;

    if pDefMsg <> nil then
    begin
      //if pDefMsg^.Tag > 1 then pDefMsg^.Tag := 1; Old
      if pDefMsg^.Tag > 3 then pDefMsg^.Tag := 3;
      case pDefMsg^.Ident of
        //返回刷新NPC结果(tag为0表示成功，否则表示失败。param表示加载的NPC数量)
        MCS_RELOADNPC_RET:
        begin
          Result := Format(ResultStr,[1,ServerName,'刷新NPC' + SuccessStr[1]]);
          if (pDefMsg^.Tag = 0) and (pDefMsg^.Param > 0) then
          begin
            Result := Format(ResultStr,[0,ServerName,'刷新NPC' + SuccessStr[0]]);
          end;
        end;
        //返回刷新公告结果(tag为0表示成功,否则表示失败，当失败时数据段为编码后的错误描述字符串)
        MCS_RELOADNOTICE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'重新加载公告' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //返回踢角色下线结果(tag为0表示成功，1表示角色不在线)
        MCS_KICKPLAY_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'踢角色下线' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //返回题账号下线结果(tag为0表示成功，1表示角色不在线)
        MCS_KICKUSER_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'踢用户下线' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //返回查询角色是否在线结果(tag为1表示在线)
        MCS_QUERYPLAYONLINE_RET:
        begin
          IsSuccess := 0;
          if pDefMsg^.Tag = 1 then Result := Format(ResultStr,[IsSuccess,ServerName,'角色在线']) else Result := Format(ResultStr,[IsSuccess,ServerName,'角色不在线']);
        end;
        //返回查询账号是否在线结果(tag为1表示在线)
        MCS_QUERYUSERONLINE_RET:
        begin
          IsSuccess := 0;
          if pDefMsg^.Tag = 1 then Result := Format(ResultStr,[IsSuccess,ServerName,'用户在线']) else Result := Format(ResultStr,[IsSuccess,ServerName,'用户不在线']);
        end;
        //返回添加公告结果(tag为0表示成功)
        MCS_ADDNOTICE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;

          Result := Format(ResultStr,[IsSuccess,ServerName,'添加公告' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //返回删除公告结果(tag为0表示成功，1表示不存在此公告内容)
        MCS_DELNOTICE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'删除公告' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //返回进入倒计时维护结果(tag为0表示成功)
        MCS_DELAY_UPHOLE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'倒计时维护' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //返回取消倒计时维护状态结果(tag为0表示成功)
        MCS_CANLCE_UPHOLE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'取消倒计时维护' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //返回设置经验倍率结果(tag为0表示成功，param为实际设置的倍率，可能不同于请求设置的倍率)
        MCS_SET_EXPRATE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;

          Result := Format(ResultStr,[IsSuccess,ServerName,'设置经验倍率' + SuccessStr[pDefMsg^.Tag] +'，经验倍率为：' + IntToStr(pDefMsg^.Param)]);
        end;
        //返回禁言结果(tag为0表示成功)
        MCS_SHUTUP_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'设置禁言' + SuccessStr[pDefMsg^.Tag] +'，禁言时长为：' + IntToStr(pDefMsg^.Param)+ '分钟']);
        end;
        //返回解禁言结果(tag为0表示成功)
        MCS_RELEASESHUTUP_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'解除禁言' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //刷新功能脚本结果(tag为0表示成功)
        MCS_RELOAD_FUNCTION_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'刷新功能脚本' + SuccessStr[pDefMsg^.Tag]]);
        end;
         //后台重新加载登陆脚本结果(tag为0表示成功)
        MCS_RELOAD_LOGIN_SCRIPT_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'刷新登陆脚本' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //后台重新加载机器人脚本结果(tag为0表示成功)
        MCS_RELOAD_ROBOTNPC_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'刷新机器人脚本' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //后台重新加载商城物品结果(tag为0表示成功)
        MCS_RELOAD_SHOP_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'刷新商城物品' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //获取引擎当前的内存使用量结果(tag为0表示成功,此时Param为内存使用量,单位: MB)
        MCS_GET_CURR_PROCESS_MEM_USED_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,Format('当前内存使用量(%d MB)',[pDefMsg^.Param])]);
        end;
        //后台给玩家增加返点(绑定元宝)的返回结果(tag为0表示成功, 1表示人物不在线或者角色名不正确)
        MCS_ADD_PLAYER_RESULTPOINT_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          if pDefMsg^.Tag = 0 then
          begin
            Result := Format(ResultStr,[IsSuccess,ServerName,'增加绑定元宝'+SuccessStr[pDefMsg^.Tag]+'，增加：' + IntToStr(pDefMsg^.Param)+'绑定元宝']);
          end
          else begin
            Result := Format(ResultStr,[IsSuccess,ServerName,'增加绑定元宝'+SuccessStr[pDefMsg^.Tag]+'，人物不在线或者角色名不正确']);
          end;
        end;
        //重新加载文字发言过滤信息库(tag为0表示成功)
        MCS_RELOAD_ABUSEINFORMATION_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'重新加载文字发言过滤信息库' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //重新加载怪物脚本(tag为0表示成功)
        MCS_RELOAD_MONSTER_SCRIPT_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'重新加载怪物脚本' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //开启赌博系统返回(tag为0表示成功)
        MCS_OPEN_GAMBLE:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'开启赌博系统' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //关闭赌博系统返回(tag为0表示成功)
        MCS_CLOSE_GAMBLE:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'关闭赌博系统' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //开启跨服系统返回(tag为0表示成功)
        MCS_OPEN_COMMONSERVER:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'开启跨服系统' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //关闭跨服系统返回(tag为0表示成功)
        MCS_CLOSE_COMMONSERVER:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'关闭跨服系统' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //返回后台给玩家直接发送离线消息结果(tag为0表示成功)
        MCS_SEND_OFFMSGTOACOTOR:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'给玩家发送离线消息' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //后台开启补偿返回 (tag为0表示成功 否则返回当前开启的补偿方案ID)
        MCS_OPEN_COMPENSATE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'设置补偿方案ID' + SuccessStr[pDefMsg^.Tag] +'，方案ID为：' + IntToStr(pDefMsg^.Param)]);
        end;

        //后台关闭补偿返回 (tag为0表示成功)
        MCS_CLOSE_COMPENSATE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'后台关闭补偿' + SuccessStr[pDefMsg^.Tag] +'，当前方案ID为：' + IntToStr(pDefMsg^.Param)]);
        end;
        //后台添加屏蔽字（Param为0表示成功，1 表示已存在屏蔽字，2 表示失败）
        MCS_RETURN_FILTER_RET:
        begin
          if pDefMsg^.Param > 2 then pDefMsg^.Param:= 2;
          if pDefMsg^.Param = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'后台操作屏蔽字' + SuccessStrEx[pDefMsg^.Param]]);
        end;
        //返回后台设置玩家死亡掉落概率结果(tag为0表示成功，1表示设置失败)
        MCS_RETURN_DROPRATE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'后台设置玩家死亡掉落概率' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //返回外挂的设置  (tag为0表示成功，1表示设置失败)
        MCS_RETURN_QUICKSOFT_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'返回外挂的设置' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //设置聊天等级 (tag为0表示成功，1表示设置失败)
        MCS_RETURN_CHATLEVEL_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'设置聊天等级' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //返回后台删除行会 (tag为0表示成功，1表示设置失败)
        MCS_RETURN_DELGUILD_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'后台删除行会' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //返回设置的百服活动结果 (tag为0表示成功，1表示设置失败 )
        MCS_RETURN_HUNDREDSERVER:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'设置百服活动' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //返回后台加载引擎配置结果 (tag为0表示成功，1表示设置失败)
        MCS_RETURN_RELOADCONFIG:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'后台加载引擎配置' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //返回后台设置合服倒计时 (tag为0表示成功，1表示设置失败)
        MSS_DELAY_COMBINE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'合服倒计时' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //返回后台刷新跨服配置(tag为0表示成功，1表示设置失败)
        MCS_RETURN_REFRESHCORSS:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'刷新跨服配置' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //返回设置跨服的服务器ID(tag为0表示成功，1表示设置失败)
        MCS_RETURN_SET_COMMON_SRVID:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'设置跨服服务器ID' + SuccessStr[pDefMsg^.Tag] +'，跨服ID：' + IntToStr(pDefMsg^.Param)]);
        end;
        //返回获取跨服的服务器Id(tag为0表示成功，1表示设置失败)
        MCS_RETURN_GET_COMMON_SRVID:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'获取跨服的服务器ID' + SuccessStr[pDefMsg^.Tag] +'，跨服ID：' + IntToStr(pDefMsg^.Param)]);
        end;
        //后台设置惊喜回馈返回(tag为0表示成功，1表示设置失败，2表示已开启)
        MCS_RETURN_SET_SURPRISERET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'设置惊喜回馈' + SuccessStr[pDefMsg^.Tag]+'，回馈ID：' + IntToStr(pDefMsg^.Param)]);
        end;
        //重置寻宝元宝消耗(tag为0表示成功，1表示设置失败)
        MCS_RESET_GAMBLE:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'重置寻宝元宝消耗' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //返回后台改名功能(tag为0表示成功，1表示设置失败)
        MCS_RETURN_CHANGENAME:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'返回后台改名功能' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //返回老玩家回归结果(tag为0表示成功，1表示设置失败)
        MCS_RETURN_OLDPLYBACK:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'返回老玩家回归' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //返回加载语言包(tag为0表示成功，1表示设置失败)
        MCS_RETURN_RELOADLAND:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'返回加载语言包' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //后台设置团购返回(tag为0表示成功，1表示设置失败，2表示已开启)
        MCS_RETURN_SET_GROUPON:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'设置团购ID' + SuccessStr[pDefMsg^.Tag]+'，回馈ID：' + IntToStr(pDefMsg^.Param)]);
        end;
        //返回后台开启跨服降魔战场(tag为0表示成功，1表示设置失败)
        MCS_RETURN_CROSSBATTLE:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'返回跨服降魔战场' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //返回获取跨服的服务器Id(tag为0表示成功，1表示设置失败)
        MSS_RETURN_CROSSBATTLENUM:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'返回设置跨服降魔战场人数' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //返回刷新功能脚本(tag为0表示成功，1表示设置失败)
        MCS_RELOAD_ITMEFUNCTION:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'返回刷新功能脚本' + SuccessStr[pDefMsg^.Tag] ]);
        end;
      end;
      if Idx < GSMsgList.Count then
      begin
        System.Dispose(pDefMsg);
        GSMsgList.Delete(Idx);
      end;
    end;
  finally
    LeaveCriticalSection(FPrintMsgLock);
  end;
end;

procedure ClearGSMsgListData;
var
  I: Integer;
begin
  for I := 0 to GSMsgList.Count - 1 do
  begin
    System.DisPose(PTDefaultMessage(GSMsgList.Objects[I]));
  end;
  GSMsgList.Clear;
end;

procedure LoadGSServers(CheckListBox: TTIWCheckListBox; spID: string; IsDisplay: Boolean = True); overload;
var
  I: Integer;
  psld: PTServerListData;
begin
  CheckListBox.Items.Clear;
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := PTServerListData(ServerList.Objects[I]);
    if (psld.Index<>0) and (psld.spID=spID) then
    begin
      if IsDisplay then
      begin
        if psld.IsDisplay then
        begin
          CheckListBox.Items.AddObject(ServerList.Strings[I],TObject(psld.Index));
          CheckListBox.Selected[CheckListBox.Items.Count-1] := IsDisplay;
        end;
      end
      else begin
        CheckListBox.Items.AddObject(ServerList.Strings[I],TObject(psld.Index));
        CheckListBox.Selected[CheckListBox.Items.Count-1] := IsDisplay;
      end;
    end;
  end;
end;

procedure LoadGSServers(StringList: TStringList; spID: string; IsDisplay: Boolean = True); overload;
var
  I: Integer;
  psld: PTServerListData;
begin
  StringList.Clear;
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := PTServerListData(ServerList.Objects[I]);
    if (psld.Index<>0) and (psld.spID=spID) then
    begin
      if IsDisplay then
      begin
        if psld.IsDisplay then
        begin
          StringList.AddObject(ServerList.Strings[I],TObject(psld.Index));
        end;
      end
      else begin
        StringList.AddObject(ServerList.Strings[I],TObject(psld.Index));
      end;
    end;
  end;
end;

procedure AppExceptionLog(sClassName: string; E: Exception);
begin
  EnterCriticalSection( m_WriteLogLock );
  try
    WriteErrorFile(True,Format('%s单元发生了一个未预料的异常，异常类为：%s', [sClassName,E.ClassName]) + #13#10+
                 #9'异常内容为：' + E.Message);
  finally
    LeaveCriticalSection( m_WriteLogLock );
  end;
end;

function GetShopItemPrice(pList: TStringList;ItemName: string): Integer;
var
  I,Idx: Integer;
  tmpList: TStringList;
begin
  Result := 0;
  for I := 0 to pList.Count - 1 do
  begin
    tmpList := TStringList(pList.Objects[I]);
    Idx := tmpList.IndexOf(ItemName);
    if Idx <> -1 then
    begin
      Result := Integer(tmpList.Objects[Idx]);
      break;
    end;
  end;
end;

function DecryptZJHTKey(sKey: string): AnsiString;
begin
  Result := '';
  if sKey <> '' then
  begin
    Result := DecryptString(AnsiString(sKey),AnsiString(GetRealKey(DBLogin_AESKey)));
  end;
end;

function UrlEncode(const ASrc: AnsiString): AnsiString;
const
  UnsafeChars = '*#%<>+ []';
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(ASrc) do begin
    if (AnsiPos(string(ASrc[i]), UnsafeChars) > 0) or (ASrc[i]< #32) or (ASrc[i] > #127) then begin
      Result := Result + '%' + AnsiString(IntToHex(Ord(ASrc[i]), 2));
    end else begin
      Result := Result + ASrc[i];
    end;
  end;
end;

function BuildSerialNO: string;
var
  strTmp: string;
begin
  Inc(SerialNO);
  if SerialNO > 9999 then SerialNO := 1;
  strTmp := StringOfChar('0',4-Length(IntToStr(SerialNO)))+IntToStr(SerialNO);
  Result := 'HT'+FormatDateTime('YYYYMMDDHHMMSS',Now())+strTmp;
end;

function SecondToTime(I:integer):string;
const
  DayS = 86400;
var
  iDay,iSecond: Integer;
begin
  iDay := (I div DayS);
  iSecond := I;
  if iDay > 0 then
  begin
    iSecond := I-(iDay*DayS);
  end;
  Result := Format('%d天%s',[iDay,TimeToStr(iSecond/DayS)]);
end;

function GetSQLJob: string;
var
  I: Integer;
begin
  Result := 'CASE job ';
  for I := Low(sRoleJob) to High(sRoleJob) do
  begin
    Result := Result+Format(' WHEN %d THEN "%s" ',[I, UserSession.ALangs.Find(UserSession.iLangNum, sRoleJob[I])]);
  end;
  Result := Result+' ELSE "未知职业" END';
end;

function GetExtSysICon(sExt: string): HIcon;
var
  sinfo: SHFILEINFO;
begin
  ZeroMemory(@sinfo,   sizeof(sinfo));
  SHGetFileInfo(PChar(sExt),   FILE_ATTRIBUTE_NORMAL,
  sinfo,   sizeof(sinfo),   SHGFI_USEFILEATTRIBUTES   or   SHGFI_ICON);
  Result := sinfo.hIcon;
end;

function StrToHex(str: string; AEncoding: TEncoding): string;
var
  ss: TStringStream;
  i: Integer;
begin
  Result := '';
  ss := TStringStream.Create(str, AEncoding);
  for i := 0 to ss.Size - 1 do
    Result := Result + Format('%.2x', [ss.Bytes[i]]);
  ss.Free;
end;

function QuerySQLStr(sFieldName: string): string;
const
  CONVERTEncoding = 'convert(0x%s using latin1)';
begin
  Result := '""';
  if sFieldName <> '' then
  begin
    Result := Format(CONVERTEncoding,[StrToHex(sFieldName,TEncoding.UTF8)]);
  end;
end;

function QuerySQLStrEx(sFieldName: string): string;
const
  CONVERTEncoding = 'CONCAT("%s",convert(0x%s using latin1),"%s")';
var
  iLen: Integer;
  sValue,eValue: string;
begin
  Result := '""';
  if sFieldName <> '' then
  begin
    iLen := Length(sFieldName);
    sValue := ''; eValue := '';
    if sFieldName[1] = '%' then sValue := '%';
    if sFieldName[iLen] = '%' then eValue := '%';
    Result := Format(CONVERTEncoding,[sValue,StrToHex(sFieldName,TEncoding.UTF8),eValue]);
  end;
end;

function ParameterIntValue(pStr: string): Integer;
var
  iPos,iTmp: Integer;
begin
  Result := 0;
  iPos := Pos(#32,pStr);
  if iPos = 0 then
  begin
    iPos := Pos(#9,pStr);
  end;
  if iPos > 0 then
  begin
    if TryStrToInt(Copy(pStr,iPos+1,Length(pStr)),iTmp) then
    begin
      Result := iTmp;
    end;
  end;
end;

function ParameterStrValue(pStr: string): string;
var
  iPos: Integer;
begin
  Result := '';
  iPos := Pos(#32,pStr);
  if iPos = 0 then
  begin
    iPos := Pos(#9,pStr);
  end;
  if iPos > 0 then
  begin
    Result := Copy(pStr,1,iPos-1);
  end;
end;
//取空格后的字符串
function ParameterStrValueEx(pStr: string): string;
var
  iPos: Integer;
begin
  Result := '';
  iPos := Pos(#32,pStr);
  if iPos = 0 then
  begin
    iPos := Pos(#9,pStr);
  end;
  if iPos > 0 then
  begin
    Result := Copy(pStr,iPos+1,Length(pStr));
  end;
end;

function GetJoinServerIndex(iServerIndex: Integer): string;
var
  I: Integer;
  psld: PTServerListData;
begin
  psld := GetServerListData(iServerIndex);
  Result := IntToStr(iServerIndex-psld^.ServerID);
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := PTServerListData(ServerList.Objects[I]);
    if psld^.JoinIdx = iServerIndex then
    begin
      Result := Result+','+IntToStr(psld^.Index-psld^.ServerID);
    end;
  end;
end;

function GetFirstOpenTime(spId: string): TDateTime;
var
  I: Integer;
  pServerListData: PTServerListData;
begin
  Result := Now;
  for I := 0 to ServerList.Count - 1 do
  begin
    pServerListData := PTServerListData(ServerList.Objects[I]);
    if (pServerListData^.spID = spId) and (pServerListData^.Index <> 0) then
    begin
      if pServerListData^.OpenTime <> '' then
      begin
        Result := StrToDateTime(pServerListData^.OpenTime);
      end;
      break;
    end;
  end;
end;

function InttoCurrType(num: Integer): string; //增加货币类型输出
begin
  case num of
     0: Result:= '绑定金币';
     1: Result:= '金币';
     2: Result:= '礼券';
     3: Result:= '元宝';
     4: Result:= '积分';
     5: Result:= '荣誉';
  else
     Result:= '未知';
  end;
end;

function Str_ToInt (Str: string; def: Longint): Longint; //字符串转int
begin
   Result := def;
   if Str <> '' then begin
      if ((word(Str[1]) >= word('0')) and (word(str[1]) <= word('9'))) or
         (str[1] = '+') or (str[1] = '-')
      then
      try
         Result := StrToInt (Str);
      except
         Result := def;
      end;
   end;
end;

function Str_ToInt64(Str: string; def: Longint): Int64;
begin
  Result := def;
  if Str <> '' then
  begin
    if ((word(Str[1]) >= word('0')) and (word(str[1]) <= word('9'))) or
      (str[1] = '+') or (str[1] = '-') then
    try
      Result := StrToInt64(Str);
    except
    end;
  end;
end;

function InttoKillType(num: Integer): string; //增加被杀类型
begin
  case num of
     503: Result:= '玩家';
     504: Result:= '怪物';
  else
     Result:= '未知';
  end;
end;

function MsgTypestr(num: Integer): string;
var
  I: Integer;
begin
  Result:= '';
  for I := High(NoticeMsgData) downto 0 do
  begin
     NoticeMsgData[i,1]:= num div NoticeMsgData[i,0];
     num := num mod NoticeMsgData[i,0];
  end;
  for I := 0 to High(NoticeMsgData) do
  begin
    if NoticeMsgData[i,1] > 0 then
     Result:= Result + sNoticeMsgData[i] + '、';
  end;
end;

function RobotTypestr(num: Integer): string;
begin
  case num of
     0 : Result := '正常';
     1 : Result := '<a style="color:Blue">增加</a>';
     2 : Result := '<a style="color:red">删除</a>';
     3 : Result := '<a style="color:Blue">增加</a>';
     4 : Result := '<a style="color:Red">结束</a>';
  else
     Result := '其他';
  end;
end;

function ItemTypeStr(num: Integer): string;
begin
  case num of
     0 : Result := '武器';
     1 : Result := '衣服';
     2 : Result := '头盔';
     3 : Result := '项链';
     4 : Result := '勋章';
     5 : Result := '左手镯';
     6 : Result := '右手镯';
     7 : Result := '左戒指';
     8 : Result := '右戒指';
     9 : Result := '腰带';
    10 : Result := '鞋子';
    11 : Result := '宝石';
    12 : Result := '材料';
    13 : Result := '时装';
    14 : Result := '翅膀';
    15 : Result := '幻武';
  else
     Result := '新道具';
  end;
end;

function BoolToIntStr(boo: Boolean): string;
begin
  Result := IntToStr(Integer(boo));
end;

function GetVersionEx: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  Result := '0.0.0.0';

  VerInfoSize := GetFileVersionInfoSize(PWideChar(Application.ExeName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    dwProductVersionMS := dwFileVersionMS;
    dwProductVersionLS := dwFileVersionLS;
    Result :=Format('%d.%d.%d.%d', [
      dwProductVersionMS shr 16,
      dwProductVersionMS and $FFFF,
      dwProductVersionLS shr 16,
      dwProductVersionLS and $FFFF
      ]);
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

initialization
  TIWServerController.SetServerControllerClass;

end.

