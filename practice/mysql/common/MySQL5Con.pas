unit MySQL5Con;

interface

uses
  SysUtils, Classes, DB, SqlExpr;

type
  TMySQL5Connection = class(TSQLConnection)
  private
    FHostName: string;  
    FSrvPort: Integer;
    FDataBase: string;
    FUserName: string;
    FPassWord: string;
    FCharset: string;
    procedure SetDataBase(const Value: string);
    procedure SetHostName(const Value: string);
    procedure SetPassWord(const Value: string);
    procedure SetUserName(const Value: string);
    procedure SetCharset(const Value: string);
    procedure SetServerPort(const Value: Integer);
  public
    constructor Create(AOwner: TComponent);override;

  published
    property HostName: string read FHostName write SetHostName;
    property ServerPort: Integer read FSrvPort write SetServerPort;
    property DataBase: string read FDataBase write SetDataBase;
    property UserName: string read FUserName write SetUserName;
    property PassWord: string read FPassWord write SetPassWord;
    property Charset: string read FCharset write SetCharset;
  end;

implementation

uses SqlConst;

{ TMySQL5Connection }

constructor TMySQL5Connection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ConnectionName := 'MySQLConnection';
  DriverName := 'dbxmysql';
  LoginPrompt := False;
  GetDriverFunc := 'getSQLDriverMYSQL50';
  LibraryName := 'dbxopenmysql50.dll';
  VendorLib := 'libmysql.dll';
end;

procedure TMySQL5Connection.SetCharset(const Value: string);
begin
  if Value <> FCharset then
  begin
    FCharset := Value;
    Params.Values[SQLSERVER_CHARSET_KEY] := Value;
    Params.Values['CharSet'] := Value;        
  end;
end;

procedure TMySQL5Connection.SetDataBase(const Value: string);
begin
  FDataBase := Value;
  Params.Values[DATABASENAME_KEY] := Value;
end;

procedure TMySQL5Connection.SetHostName(const Value: string);
begin
  FHostName := Value;
  Params.Values[HOSTNAME_KEY] := Value;
end;

procedure TMySQL5Connection.SetPassWord(const Value: string);
begin
  FPassWord := Value;
  Params.Values[szPASSWORD] := FPassWord;
end;

procedure TMySQL5Connection.SetServerPort(const Value: Integer);
begin
  FSrvPort := Value;
  Params.Values[SqlConst.SERVERPORT] := IntToStr(Value);
end;

procedure TMySQL5Connection.SetUserName(const Value: string);
begin
  FUserName := Value;
  Params.Values[szUSERNAME] := Value;
end;

end.
