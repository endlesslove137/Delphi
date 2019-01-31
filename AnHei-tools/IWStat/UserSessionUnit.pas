unit UserSessionUnit;

{
  This is a DataModule where you can add components or declare fields that are specific to 
  ONE user. Instead of creating global variables, it is better to use this datamodule. You can then
  access the it using UserSession.
}
interface

uses
  IWUserSessionBase, SysUtils, Classes, DBXMySQL, FMTBcd, DB, SqlExpr, IWLang;

type
  TIWUserSession = class(TIWUserSessionBase)
    SQLConnectionLog: TSQLConnection;
    quOnlineCount: TSQLQuery;
    SQLConnectionRole: TSQLConnection;
    quConsume: TSQLQuery;
    quCommon: TSQLQuery;
    quCountryCount: TSQLQuery;
    quRoleCount: TSQLQuery;
    quRoleLevel: TSQLQuery;
    quLevelRole: TSQLQuery;
    quLoginCount: TSQLQuery;
    quAccountCount: TSQLQuery;
    SQLConnectionSession: TSQLConnection;
    quUserCount: TSQLQuery;
    quAccountLoss: TSQLQuery;
    quPay: TSQLQuery;
    quPayOrder: TSQLQuery;
    quUserConsume: TSQLQuery;
    quUserConsumeOrder: TSQLQuery;
    quGlobalOnline: TSQLQuery;
    quGlobalPay: TSQLQuery;
    quHumLog: TSQLQuery;
    quLoginLog: TSQLQuery;
    quItemTrace: TSQLQuery;
    quCurOnline: TSQLQuery;
    quShop: TSQLQuery;
    quWebGrid: TSQLQuery;
    quLoss: TSQLQuery;
    quItems: TSQLQuery;
    quRole: TSQLQuery;
    quRoleStayTime: TSQLQuery;
    quCreateAccount: TSQLQuery;
    quAccountType: TSQLQuery;
    quSCommon: TSQLQuery;
    quPayUser: TSQLQuery;
    quPayAllUser: TSQLQuery;
    quRoleAction: TSQLQuery;
    quAcross: TSQLQuery;
    quActivityItem: TSQLQuery;
    quReputeShop: TSQLQuery;
    quAvgOnline: TSQLQuery;
    quGlobalAccount: TSQLQuery;
    quGiftLog: TSQLQuery;
    SQLConnectionTest: TSQLConnection;
    quTest: TSQLQuery;
    quLoginStatus: TSQLQuery;
    quActivityRItem: TSQLQuery;
    quOperateLog: TSQLQuery;
    quBugInfo: TSQLQuery;
    quSeedGold: TSQLQuery;
    quDmkjGold: TSQLQuery;
    quInsiderAccount: TSQLQuery;
    quExrtGoldTotal: TSQLQuery;
    quMapOnline: TSQLQuery;
    quHumDie: TSQLQuery;
    quCopytrack: TSQLQuery;
    quMondie: TSQLQuery;
    quMonKillhum: TSQLQuery;
    quExrtHonourTotal: TSQLQuery;
    quAccountAgain: TSQLQuery;
    quUserInfo: TSQLQuery;
    SQLConnectionLocalLog: TSQLConnection;
    quHumLogEx: TSQLQuery;
    quItemTraceEx: TSQLQuery;
    quExrtGoldTotalEx: TSQLQuery;
    quMondieEx: TSQLQuery;
    quHumDieEx: TSQLQuery;
    quMapOnlineEx: TSQLQuery;
    quCopytrackEx: TSQLQuery;
    quMonKillhumEx: TSQLQuery;
    quCommonEx: TSQLQuery;
    quRobotInfo: TSQLQuery;
    quVaser: TSQLQuery;
    quConsumeEx: TSQLQuery;
    quASunPay: TSQLQuery;
    procedure IWUserSessionBaseDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    pServerName,UserName: string;
    UserPopList: string;
    UserSpid: string;
    curTB: Integer;

    iLangNum: Integer;
    ALangs: TLangFile;
    //增加检测数据库是否可连接
    function IsCheckConnectionLogMysql(slog, sHostName: string): Boolean;
    function IsCheckConnectionSessionMysql(sAccount, sHostName: string): Boolean;

    procedure ConnectionLogMysql(slog, sHostName: string);
    procedure ConnectionLocalLogMysql(sHostName: string);
    procedure ConnectionRoleMysql(sHostName,sDataBase: string);
    procedure ConnectionSessionMysql(sAccount,sHostName: string);
    function IsCheckTable(sDBName,sTableName: string): Boolean;
    function IsCheckTableEx(sDBName,sTableName: string): Boolean;
    function IsCheckConTable(sDBName,sTableName: string): Boolean;
    function IsCheckOnlineTable(sDBName,sTableName: string): Boolean;
    function OpenSQL(SQLQuery: TSQLQuery;sSQL: string): TSQLQuery;
    function ExecSQL(SQLQuery: TSQLQuery;sSQL: string): Integer;
    function GetModulePrivilege(ModuleID: Integer): Boolean;
    procedure AddHTOperateLog(opType: Integer;sAccount,sAction,sRemark: string);
    procedure LoadLangFile(Num: Integer = 0);
  end;

implementation

uses ServerController, Share;

{$R *.dfm}

{ TIWUserSession }

procedure TIWUserSession.LoadLangFile(Num: Integer);
begin
   ALangs:= TLangFile.Create;
   ALangs.LoadLangFile(Num);
end;

procedure TIWUserSession.AddHTOperateLog(opType: Integer; sAccount, sAction,
  sRemark: string);
const
  sqlOperateLog = 'INSERT INTO %s.operatelog (username,optype,account,action,logdate,remark) VALUES (%s,%d,%s,%s,"%s",%s)';
var
  psld: PTServerListData;
begin
  psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(pServerName))]);
  ConnectionLogMysql(psld^.LogDB,psld^.LogHostName);
  try
    with quOperateLog do
    begin
      Close;
      SQL.Text := Format(sqlOperateLog,[psld.GstaticDB,QuerySQLStr(UserName),opType,QuerySQLStr(sAccount),QuerySQLStr(sAction),DateTimeToStr(Now),QuerySQLStr(sRemark)]);
      ExecSQL;
      Close;
    end;
  finally
    SQLConnectionLog.Close;
  end;
end;

function TIWUserSession.IsCheckConnectionLogMysql(slog, sHostName: string): Boolean;
begin
  Result := False;
  try
    try
      SQLConnectionLog.Connected := False;
      SQLConnectionLog.Params.Clear;
      SQLConnectionLog.Close;
      SQLConnectionLog.Params.Append('HostName='+sHostName);
      SQLConnectionLog.Params.Append('Database=' + slog);
      SQLConnectionLog.Params.Append('User_Name=' + UM_USERNAME);
      SQLConnectionLog.Params.Append('Password=' + UM_PASSWORD);
      SQLConnectionLog.Params.Append('ServerCharset=utf-8');
      SQLConnectionLog.Connected := True;
      Result := True;
    finally
      SQLConnectionLog.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

function TIWUserSession.IsCheckConnectionSessionMysql(sAccount, sHostName: string): Boolean;
begin
  Result := False;
  try
    try
      SQLConnectionSession.Connected := False;
      SQLConnectionSession.Params.Clear;
      SQLConnectionSession.Close;
      SQLConnectionSession.Params.Append('HostName=' + sHostName);
      SQLConnectionSession.Params.Append('Database=' + sAccount);
      SQLConnectionSession.Params.Append('User_Name=' + UM_USERNAME);
      SQLConnectionSession.Params.Append('Password=' + UM_PASSWORD);
      SQLConnectionSession.Params.Append('ServerCharset=utf-8');
      SQLConnectionSession.Connected := True;
      Result := True;
    finally
      SQLConnectionSession.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWUserSession.ConnectionLogMysql(slog, sHostName: string);
begin
  SQLConnectionLog.Connected := False;
  SQLConnectionLog.Params.Clear;
  SQLConnectionLog.Params.Append('HostName='+sHostName);
  SQLConnectionLog.Params.Append('Database=' + slog);
  SQLConnectionLog.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnectionLog.Params.Append('Password=' + UM_PASSWORD);
  SQLConnectionLog.Params.Append('ServerCharset=utf-8');
  SQLConnectionLog.Connected := True;
end;

procedure TIWUserSession.ConnectionLocalLogMysql(sHostName: string);
begin
  SQLConnectionLocalLog.Connected := False;
  SQLConnectionLocalLog.Params.Clear;
  SQLConnectionLocalLog.Params.Append('HostName='+sHostName);
  SQLConnectionLocalLog.Params.Append('Database=' + UM_DATA_LOCALLOG);
  SQLConnectionLocalLog.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnectionLocalLog.Params.Append('Password=' + UM_PASSWORD);
  SQLConnectionLocalLog.Params.Append('ServerCharset=utf-8');
  SQLConnectionLocalLog.Connected := True;
end;

procedure TIWUserSession.ConnectionRoleMysql(sHostName, sDataBase: string);
begin
  SQLConnectionRole.Connected := False;
  SQLConnectionRole.Params.Clear;
  SQLConnectionRole.Params.Append('HostName='+sHostName);
  SQLConnectionRole.Params.Append('Database='+sDataBase);
  SQLConnectionRole.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnectionRole.Params.Append('Password=' + UM_PASSWORD);
  SQLConnectionRole.Params.Append('ServerCharset=utf-8');
  SQLConnectionRole.Connected := True;
end;

procedure TIWUserSession.ConnectionSessionMysql(sAccount,sHostName: string);
begin
  SQLConnectionSession.Connected := False;
  SQLConnectionSession.Params.Clear;
  SQLConnectionSession.Params.Append('HostName='+sHostName);
  SQLConnectionSession.Params.Append('Database=' + sAccount);
  SQLConnectionSession.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnectionSession.Params.Append('Password=' + UM_PASSWORD);
  SQLConnectionSession.Params.Append('ServerCharset=utf-8');
  SQLConnectionSession.Connected := True;
end;

function TIWUserSession.ExecSQL(SQLQuery: TSQLQuery; sSQL: string): Integer;
begin
  with SQLQuery do
  begin
    SQL.Text := sSQL;
    Result := ExecSQL;
    Close;
  end;
end;

function TIWUserSession.GetModulePrivilege(ModuleID: Integer): Boolean;
begin
  Result := UserName = AdminUser;
  if not Result then
    begin
      Result := Length(UserPopList) >= ModuleID;
      if Result then
        Result := UserPopList[ModuleID] = '1';
    end;
end;

function TIWUserSession.IsCheckTable(sDBName, sTableName: string): Boolean;
const
  tSql = 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA="%s" AND TABLE_NAME="%s"';
begin
  with OpenSQL(quCommon,format(tSql,[sDBName,sTableName])) do
    Result := Fields[0].AsString <> '';
end;

function TIWUserSession.IsCheckTableEx(sDBName, sTableName: string): Boolean;
const
  tSql = 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA="%s" AND TABLE_NAME="%s"';
begin
  with OpenSQL(quCommonEx,format(tSql,[sDBName,sTableName])) do
    Result := Fields[0].AsString <> '';
end;

procedure TIWUserSession.IWUserSessionBaseDestroy(Sender: TObject);
begin
   ALangs.Free;
end;

function TIWUserSession.IsCheckConTable(sDBName, sTableName: string): Boolean;
const
  tSql = 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA="%s" AND TABLE_NAME="%s"';
begin
  with OpenSQL(quConsume,format(tSql,[sDBName,sTableName])) do
    Result := Fields[0].AsString <> '';
end;

function TIWUserSession.IsCheckOnlineTable(sDBName, sTableName: string): Boolean;
const
  tSql = 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA="%s" AND TABLE_NAME="%s"';
begin
  with OpenSQL(quOnlineCount,format(tSql,[sDBName,sTableName])) do
    Result := Fields[0].AsString <> '';
end;

function TIWUserSession.OpenSQL(SQLQuery: TSQLQuery;sSQL: string): TSQLQuery;
begin
  with SQLQuery do
  begin
    Close;
    Fields.Clear;
    SQL.Text := sSQL;
    Open;
    Result := SQLQuery;
  end;
end;

end.
