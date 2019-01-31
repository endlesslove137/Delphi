unit uDataDispose;

interface

uses SqlExpr, Classes, SysUtils;

type
  TDataDispose = class(TObject)
  private
    procedure EverydayDataDispose;
    procedure DisposePayUser(sgstatic, samdb: string; ServerIndex: Integer;RoleConnect,SessionConnect: TSQLConnection);
    procedure DisposeFPVersion(LogConnect: TSQLConnection;sgstatic:string);

    procedure MonthlyDataDispose;
    procedure DisposeStockGold(LogConnect,RoleConnect: TSQLConnection;sgstatic:string);

    function BatchInsertData(SelectQuery,ExecQuery: TSQLQuery;sSQL: string): string;
  public
    IsRunEverydayData: Boolean;
    IsRunMonthlyData: Boolean;
    procedure ExecEverydayData;
    procedure ExecMonthlyData;
  end;

var
  DataDispose: TDataDispose;

implementation

uses ConfigINI, ServerController;

{ TDataDispose }

function TDataDispose.BatchInsertData(SelectQuery, ExecQuery: TSQLQuery;
  sSQL: string): string;
var
  I,iCount: Integer;
  strValue,strField: string;
begin
  strValue := ''; iCount := 0;
  while not SelectQuery.Eof do
  begin
    if SelectQuery.Fields[0].AsString <> '' then
    begin
      Inc(iCount);
      strField := '';
      for I := 0 to SelectQuery.FieldCount - 1 do
      begin
        strField := strField+QuerySQLStr(Utf8ToString(SelectQuery.Fields[I].AsAnsiString))+',';
      end;
      Delete(strField,Length(strField),1);
      strValue := strValue+'('+strField+'),';
      if iCount = 200 then
      begin
        Delete(strValue,Length(strValue),1);
        ExecQuery.SQL.Text := Format(sSQL,[strValue]);
        ExecQuery.ExecSQL;
        strValue := '';
        iCount := 0;
      end;
    end;
    SelectQuery.Next;
  end;
  if iCount > 0 then
  begin
    Delete(strValue,Length(strValue),1);
    ExecQuery.SQL.Text := Format(sSQL,[strValue]);
    ExecQuery.ExecSQL;
  end;
end;

procedure TDataDispose.DisposeFPVersion(LogConnect: TSQLConnection;sgstatic:string);
const
  sqlDelFPVersion = 'DELETE FROM %s.fpversion WHERE rptdate<="%s"';
var
  quFPVersion: TSQLQuery;
begin
  quFPVersion := TSQLQuery.Create(nil);
  quFPVersion.SQLConnection := LogConnect;
  try
    IWServerController.DBExecSQL(quFPVersion,Format(sqlDelFPVersion,[sgstatic,DateToStr(Date-7)]));
  finally
    quFPVersion.Free;
  end;
end;

procedure TDataDispose.DisposePayUser(sgstatic,samdb: string; ServerIndex: Integer; RoleConnect,
  SessionConnect: TSQLConnection);
const
  sqlCreatePayUser = 'CREATE TABLE %s.payuser (account varchar(64) NOT NULL, PRIMARY KEY (account)) ENGINE=MyISAM DEFAULT CHARSET=utf8';
  sqlPayUser = 'SELECT DISTINCT(account) FROM %s.payorder WHERE serverid in (%s) AND type in (1,3)';
  sqlTruncateTable = 'DELETE FROM %s';
  sqlInsertPayUser = 'INSERT INTO %s.payuser VALUES';// %s';
var
  quRolePayUser,quSSPayUser: TSQLQuery;
begin
  quRolePayUser := TSQLQuery.Create(nil);
  quSSPayUser := TSQLQuery.Create(nil);
  quRolePayUser.SQLConnection := RoleConnect;
  quSSPayUser.SQLConnection := SessionConnect;
  try
    if not IWServerController.IsCheckTable(quRolePayUser,sgstatic,'payuser') then
    begin
      IWServerController.DBExecSQL(quRolePayUser,Format(sqlCreatePayUser,[sgstatic]));
    end;
    IWServerController.DBExecSQL(quRolePayUser,Format(sqlTruncateTable,[ sgstatic+'.payuser']));
    with quSSPayUser do
    begin
      SQL.Text := Format(sqlPayUser,[samdb,GetJoinServerIndex(ServerIndex)]);
      Open;
      BatchInsertData(quSSPayUser,quRolePayUser,Format(sqlInsertPayUser,[sgstatic]) + ' %s');
      Close;
    end;
  finally
    quRolePayUser.Free;
    quSSPayUser.Free;
  end;
end;

procedure TDataDispose.DisposeStockGold(LogConnect,RoleConnect: TSQLConnection;sgstatic:string);
const
  CreateStockGold = 'CREATE TABLE %s.stockgold (`serverindex` int(10) NOT NULL DEFAULT "0", `account` varchar(64) NOT NULL, `charname` varchar(32) NOT NULL, `gold` int(10) NOT NULL DEFAULT "0", `logdate` date NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8';
  InsertStockGold = 'INSERT INTO %s.stockgold VALUES';// %s';
  SelectStockGold = 'SELECT serverindex,accountname,actorname,nonbindyuanbao,"%s" FROM actors WHERE nonbindyuanbao>0 ';
var
  quLogStockGold,quRoleStockGold: TSQLQuery;
begin
  quLogStockGold := TSQLQuery.Create(nil);
  quRoleStockGold := TSQLQuery.Create(nil);
  quLogStockGold.SQLConnection := LogConnect;
  quRoleStockGold.SQLConnection := RoleConnect;
  if not IWServerController.IsCheckTable(quLogStockGold, sgstatic,'stockgold') then
  begin
    IWServerController.DBExecSQL(quLogStockGold,Format(CreateStockGold,[sgstatic]));
  end;
  try
    quRoleStockGold.SQL.Text := Format(SelectStockGold,[DateToStr(Date-1)]);
    quRoleStockGold.Open;
    BatchInsertData(quRoleStockGold,quLogStockGold, Format(InsertStockGold,[sgstatic]) + ' %s');
    quRoleStockGold.Close;
  finally
    quLogStockGold.Free;
    quRoleStockGold.Free;
  end;
end;

procedure TDataDispose.EverydayDataDispose;
var
  I: Integer;
  psld: PTServerListData;
  ConnectLog,ConnectRole,ConnectSession: TSQLConnection;
begin
  ConnectLog := TSQLConnection.Create(nil);
  ConnectRole := TSQLConnection.Create(nil);
  ConnectSession := TSQLConnection.Create(nil);
  ConnectSession.DriverName := 'MySQL';
  ConnectRole.DriverName := 'MySQL';
  ConnectLog.DriverName := 'MySQL';
  IsRunEverydayData := True;
  try
    for I := 0 to ServerList.Count - 1 do
    begin
      psld := PTServerListData(ServerList.Objects[I]);
      if Pos(psld^.spID,objINI.DataDisposeSpid) = 0 then continue;
      try
        if (psld^.Index = 0) then
        begin
          IWServerController.ConnectionLogMysql(ConnectLog,psld^.LogDB,psld^.LogHostName);
          DisposeFPVersion(ConnectLog, psld.GstaticDB);
        end;
        if (psld^.Index <> 0) and psld^.IsDisplay and (psld^.OpenTime <> '') then
        begin
          IWServerController.ConnectionLogMysql(ConnectLog,psld^.LogDB,psld^.LogHostName);
          IWServerController.ConnectionRoleMysql(ConnectRole,psld^.RoleHostName,psld^.DataBase);
          IWServerController.ConnectionSessionMysql(ConnectSession,psld^.AccountDB,psld^.SessionHostName);
          DisposePayUser(psld^.GstaticDB,psld^.Amdb,psld^.Index,ConnectRole,ConnectSession);
        end;
      except On E: Exception do
        AppExceptionLog(ClassName+Format('.EverydayDataDispose(%d)',[psld^.Index]),E);
      end;
    end;
  finally
    IsRunEverydayData := False;
    ConnectLog.Free;
    ConnectRole.Free;
    ConnectSession.Free;
  end;
end;

procedure TDataDispose.ExecEverydayData;
begin
  TThread.CreateAnonymousThread(EverydayDataDispose).Start;
end;

procedure TDataDispose.ExecMonthlyData;
begin
  TThread.CreateAnonymousThread(MonthlyDataDispose).Start;
end;

procedure TDataDispose.MonthlyDataDispose;
var
  I: Integer;
  psld: PTServerListData;
  ConnectLog,ConnectRole: TSQLConnection;
begin
  ConnectLog := TSQLConnection.Create(nil);
  ConnectRole := TSQLConnection.Create(nil);
  ConnectLog.DriverName := 'MySQL';
  ConnectRole.DriverName := 'MySQL';
  IsRunMonthlyData := True;
  try
    for I := 0 to ServerList.Count - 1 do
    begin
      psld := PTServerListData(ServerList.Objects[I]);
      if Pos(psld^.spID,objINI.DataDisposeSpid) = 0 then continue;
      if (psld^.Index <> 0) and psld^.IsDisplay and (psld^.OpenTime <> '') then
      begin
        try
          IWServerController.ConnectionRoleMysql(ConnectRole,psld^.RoleHostName,psld^.DataBase);
          IWServerController.ConnectionLogMysql(ConnectLog,psld^.LogDB,psld^.LogHostName);
          DisposeStockGold(ConnectLog,ConnectRole, psld^.GstaticDB);
        except On E: Exception do
          AppExceptionLog(ClassName+Format('.MonthlyDataDispose(%d)',[psld^.Index]),E);
        end;
      end;
    end;
  finally
    IsRunMonthlyData := False;
    ConnectLog.Free;
    ConnectRole.Free;
  end;
end;

end.
