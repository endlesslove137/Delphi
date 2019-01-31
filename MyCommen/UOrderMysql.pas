unit UOrderMysql;

interface
uses
 SqlExpr, SysUtils, dialogs,Classes;

const
  //战千雄数据库密码
  UM_USERNAME	     =	'gamestatic'; //用户名称
  UM_PASSWORD      =	'xianhaiwangluo'; //密码
  SS_DataBase      =  '5eglobal';//会话数据库
  SS_DBDataBase      =  'amdb';//会话数据库
  Log_database     =  'globallog';//日志数据库

type
PserverData = ^TServerData;
 TServerData = record
  ServerName: string;
  SessionIP: string;
  LogIP: string;
  SessionDB: string;
  LogDB: string;
  Spid: string;
  MaxServerId:integer;
  MinServerID:integer;
  BOffLine: boolean;
  SessionCanUse: boolean;
  LogCanUse: boolean;
  SumText: Tstringlist;
  orderlist: Tstringlist;
  orderTemp: Tstringlist;
  SessionCon: TSQLConnection;
  LogCon:TSQLConnection;
  SQ:Tsqlquery;
  rate: Currency;
 end;




function IsCheckTable(SQLQuery: TSQLQuery; sDBName,sTableName: string): Boolean;
function ConnectionSessionDB(var TargetSC:TSQLConnection; sHostName: string):boolean;overload;
function ConnectionSessionDB(var TargetSC:TSQLConnection; Serverdata: PserverData):boolean;overload;
function ConnectionLogDB(var TargetSC:TSQLConnection; sHostName: string):boolean;overload;
function ConnectionLogDB(var TargetSC:TSQLConnection; Serverdata: PserverData):boolean;overload;

implementation

function IsCheckTable(SQLQuery: TSQLQuery; sDBName,sTableName: string): Boolean;
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


function ConnectionSessionDB(var TargetSC:TSQLConnection; sHostName: string):boolean;
begin
  try
    TargetSC.Connected := False;
    targetsc.DriverName := 'MySQL';
    targetsc.GetDriverFunc := 'getSQLDriverMYSQL';
    TargetSC.LibraryName := 'dbxmys.dll';
    targetsc.VendorLib := 'LIBMYSQL.dll';
    TargetSC.Params.Clear;
    TargetSC.Params.Append('HostName='+sHostName);
    TargetSC.Params.Append('Database=' + SS_DBDataBase);
    TargetSC.Params.Append('User_Name=' + UM_USERNAME);
    TargetSC.Params.Append('Password=' + UM_PASSWORD);
    TargetSC.Params.Append('ServerCharset=utf-8');
    TargetSC.Connected := True;
    TargetSC.KeepConnection := true;
    result := true;
  except
   on e:exception do
   begin
    showmessage(e.Message);
    result := false;
   end;
  end;
end;

function ConnectionSessionDB(var TargetSC:TSQLConnection; Serverdata: PserverData):boolean;
begin
  try
    TargetSC.Connected := False;
    targetsc.DriverName := 'MySQL';
    targetsc.GetDriverFunc := 'getSQLDriverMYSQL';
    TargetSC.LibraryName := 'dbxmys.dll';
    targetsc.VendorLib := 'LIBMYSQL.dll';
    TargetSC.Params.Clear;
    TargetSC.Params.Append('HostName='+Serverdata.SessionIP);
    TargetSC.Params.Append('Database=' + Serverdata.SessionDB);
    TargetSC.Params.Append('User_Name=' + UM_USERNAME);
    TargetSC.Params.Append('Password=' + UM_PASSWORD);
    TargetSC.Params.Append('ServerCharset=utf-8');
    TargetSC.Connected := True;
    TargetSC.KeepConnection := true;
    result := true;
  except
   on e:exception do
   begin
//    showmessage(e.Message);
    result := false;
   end;
  end;
end;


function ConnectionLogDB(var TargetSC:TSQLConnection; sHostName: string):boolean;
begin
  try
    TargetSC.Connected := False;
    targetsc.DriverName := 'MySQL';
    targetsc.GetDriverFunc := 'getSQLDriverMYSQL';
    TargetSC.LibraryName := 'dbxmys.dll';
    targetsc.VendorLib := 'LIBMYSQL.dll';
    TargetSC.Params.Clear;
    TargetSC.Params.Append('HostName='+sHostName);
    TargetSC.Params.Append('Database=' + Log_database);
    TargetSC.Params.Append('User_Name=' + UM_USERNAME);
    TargetSC.Params.Append('Password=' + UM_PASSWORD);
    TargetSC.Params.Append('ServerCharset=utf-8');
    TargetSC.Connected := True;
    TargetSC.KeepConnection := true;
    result := true;
  except
   on e:exception do
   begin
    showmessage(e.Message);
    result := false;
   end;
  end;
end;

function ConnectionLogDB(var TargetSC:TSQLConnection; Serverdata: PserverData):boolean;overload;
begin
  try
    TargetSC.Connected := False;
    targetsc.DriverName := 'MySQL';
    targetsc.GetDriverFunc := 'getSQLDriverMYSQL';
    TargetSC.LibraryName := 'dbxmys.dll';
    targetsc.VendorLib := 'LIBMYSQL.dll';
    TargetSC.Params.Clear;
    TargetSC.Params.Append('HostName='+Serverdata.LogIP);
    TargetSC.Params.Append('Database=' + Serverdata.LogDB);
    TargetSC.Params.Append('User_Name=' + UM_USERNAME);
    TargetSC.Params.Append('Password=' + UM_PASSWORD);
    TargetSC.Params.Append('ServerCharset=utf-8');
    TargetSC.Connected := True;
    TargetSC.KeepConnection := true;
    result := true;
  except
   on e:exception do
   begin
//    showmessage(e.Message);
    result := false;
   end;
  end;
end;


end.
