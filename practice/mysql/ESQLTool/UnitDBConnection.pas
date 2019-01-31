unit UnitDBConnection;

interface

uses SqlExpr, SysUtils;

type
  TMysqlConnection = class
  private
    SQLConnection: TSQLConnection;
    quSQLRun: TSQLQuery;
  public
    constructor Create;
    destructor  Destroy();override;
    function ConnectionMysql(sHostName,sDatabase,sUserName,sPassword: string;iPort:Integer): string;
    function RunScript(sSQL: string): Integer;
    procedure NoteMessage(sMessage: string);
  end;

implementation

uses UnitSQLParser;

{ TMysqlConnection }

function TMysqlConnection.ConnectionMysql(sHostName, sDatabase, sUserName,
  sPassword: string; iPort: Integer): string;
begin
  Result := '';
  try
    SQLConnection.DriverName := 'dbxmysql';
    SQLConnection.GetDriverFunc := 'getSQLDriverMYSQL50';
    SQLConnection.LibraryName := 'dbxopenmysql50.dll';
    SQLConnection.VendorLib := 'libmysql.dll';
    SQLConnection.LoginPrompt := false;
    SQLConnection.Connected := False;
    SQLConnection.Params.Clear;
    SQLConnection.Params.Append(Format('HostName=%s',[sHostName]));
    SQLConnection.Params.Append(Format('Database=%s',[sDatabase]));
    SQLConnection.Params.Append(Format('User_Name=%s',[sUserName]));
    SQLConnection.Params.Append(Format('Password=%s',[sPassword]));
    SQLConnection.Params.Append(Format('Port=%d',[iPort]));
    SQLConnection.Connected := True;
  except
    on E: Exception do
      Result := '连接数据库错误' + ':' + E.Message;
  end;
end;

constructor TMysqlConnection.Create;
begin
  SQLConnection := TSQLConnection.Create(nil);
  quSQLRun := TSQLQuery.Create(nil);
  quSQLRun.SQLConnection := SQLConnection;
end;

destructor TMysqlConnection.Destroy;
begin
  SQLConnection.Free;
  quSQLRun.Free;
  inherited;
end;

procedure TMysqlConnection.NoteMessage(sMessage: string);
begin
  System.Writeln(sMessage);
end;

function TMysqlConnection.RunScript(sSQL: string): Integer;
begin
  with quSQLRun do
  begin
    SQL.Text := sSQL;
    Result := ExecSQL(True);
    Close;
  end;
end;

end.
