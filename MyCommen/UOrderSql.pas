unit UOrderSql;
////////////////////////////////////////////////////////
///                 Announce                        ////
///      Author: ÕÅÃ÷Ã÷/zmm                         ////
///      QQ    : 378982719                          ////
///      Email : 378982719@qq.com                   ////
///                                                 ////
///      Power by zmm  20100713                     ////
///                                                 ////
////////////////////////////////////////////////////////

interface

uses
  Classes,ADODB;

type

  TSqlLinkParameter = class;

  TSqlServer = class
  private
    function CopyFileTo(const Source, Destination: string): Boolean;
  public
    function ServersList:TStrings;
    function SetupPath:string;
    function LinkHost(MacineName,DataBaseName:string):String;overload;
    function LinkHost(UserName,MacineName,DataBaseName:string):string;overload;
    function LinkHost(UserName,PassWord,MacineName,DataBaseName:string):String;overload;
    function LinkHostTest(ConStr:string):Boolean;
    function DataBaseExists(SqlAdo:TADOConnection;DataBaseName:string):Boolean;
    function BackUpToFile(SqlAdo:TADOConnection;DbName,BakFileName:string):Boolean;
    function RestoreFromFile(BackFileName:string):Boolean;
    function SqlLinkConfig:string;
  end;

  TSqlLinkParameter = class(TPersistent)
  private
    FMachineName: String;
    FDataBaseName: string;
    FPassWord: String;
    FUserName: String;
    FIsWinValiDate: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;    
    property UserName:String read FUserName write FUserName;
    property PassWord:String read FPassWord Write FPassWord;
    property DataBaseName:string read FDataBaseName write FDataBaseName;
    property MachineName:String read FMachineName write FMachineName;
    property IsWinValiDate:Boolean read FIsWinValiDate write FIsWinValiDate;
  end;

implementation

uses ComObj, Variants, Windows,Registry, DB, Dialogs, SysUtils,

     Controls,USysConst;
         //  UFrmSqlLinkSet,
{ TServerSql }

function TSqlServer.ServersList: TStrings;
var
  SQLServer: Variant;
  MachineNameList: Variant;
  I, nServers: integer;
  Sr: TStrings;
begin
  Result := nil;
  try
    SQLServer := CreateOleObject('SQLDMO.Application');
    MachineNameList := SQLServer.ListAvailableSQLServers;
    nServers := MachineNameList.Count;
    Sr := TStringList.Create;
    for i := 1 to nservers do
      Sr.Add(MachineNameList.Item(i));
    SQLServer := NULL;
    MachineNameList := NULL;
  except
  end;
  Result := Sr;
end;

function TSqlServer.LinkHost(MacineName,DataBaseName: string): String;
begin
  Result:= 'Provider=SQLOLEDB.1;Integrated Security=SSPI;' +
           'Persist Security Info=False;User ID=sa;'+
           'Initial Catalog='+
           DataBaseName+
           ';Data Source=' +
           MacineName;
end;

function TSqlServer.LinkHost(UserName, MacineName,DataBaseName: string): string;
begin
  Result := 'Provider=SQLOLEDB.1;Persist Security Info=False;' +
            'User ID=' +
            UserName +
            ';Initial Catalog='+
            DataBaseName+
            ';Data Source=' +
            MacineName;
end;

function TSqlServer.LinkHost(UserName, PassWord, MacineName,DataBaseName: string): String;
begin
  Result := 'Provider=SQLOLEDB.1;Password=' +
            PassWord +
            ';Persist Security Info=True;' +
            'User ID=' +
            UserName +
            ';Initial Catalog='+
            DataBaseName+
            ';Data Source=' +
            MacineName;
end;

function TSqlServer.LinkHostTest(ConStr: string): Boolean;
var
  AdoCon: TADOConnection;
begin
  AdoCon := TADOConnection.Create(nil);
  try
    AdoCon.ConnectionString := ConStr;
    AdoCon.LoginPrompt := False;
    AdoCon.Connected := True;
    Result := AdoCon.Connected;
  finally
    AdoCon.Free;
  end;
end;

function TSqlServer.SqlLinkConfig: string;
var
  FrmSqlLinkSet: TFrmSqlLinkSet;
begin
  FrmSqlLinkSet:=TFrmSqlLinkSet.Create(nil);
  try
    FrmSqlLinkSet.SqlLinkParameter := SysParameter.SqlLinkParameter;
    if FrmSqlLinkSet.ShowModal = mrok then
    begin
      SysParameter.SqlLinkParameter.Assign(FrmSqlLinkSet.SqlLinkParameter);
      ConfigFile.Save;
    end;
  finally
    FrmSqlLinkSet.Free;
  end;
end;

function TSqlServer.SetupPath: string;
var
  SqlServerReg: TRegistry;
begin
  SqlServerReg := TRegistry.Create;
  with SqlServerReg do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('Software\Microsoft\MSSQLServer\Setup\', False) then
      Result := ReadString('SQLDataRoot') + '\Data\'
    else
      Result := '';
  finally
    CloseKey;
    Free;
  end;
end;

function TSqlServer.DataBaseExists(SqlAdo: TADOConnection;DataBaseName: string): Boolean;
var
  ADODataSet:TADODataSet;
begin
  if not SqlAdo.Connected then Exit;
  ADODataSet:=TADODataSet.Create(nil);
  ADODataSet.Connection:=SqlAdo;
  with ADODataSet do
  begin
    Close;
    CommandText := 'SELECT * FROM sysdatabases WHERE name = ''' +
                   DataBaseName +
                    '''';
    Open;
    if isEmpty then
      Result := False
    else
      Result := True;
  end;
  ADODataSet.Close;
  ADODataSet.Free;
end;

function TSqlServer.RestoreFromFile(BackFileName: string): Boolean;
begin

end;

function TSqlServer.BackUpToFile(SqlAdo: TADOConnection;
                                 DbName,BakFileName: string): Boolean;
var
  Qry: TADOQuery;
  Sr: TStrings;
begin
  Result := False;
  Qry := TADOQuery.Create(nil);
  try
    Qry.Connection := SqlAdo;
    Qry.SQL.Add('Select * From Sysdatabases');
    Qry.Active := True;
    while not Qry.Eof do
    begin
     if DbName=Qry.FieldByName('Name').AsString then
       Result:=True;
     Qry.Next;
    end;
    Qry.Close;

    if Result then
    begin
      Qry.SQL.Clear;
      Qry.SQL.Add('BACKUP DATABASE ' +
                '"'+DbName +'"'+
                ' TO DISK ='+
                ''''+BakFileName+'''');
      Qry.ExecSQL;
    end;
  finally
    Qry.Free;
  end;
end;

function TSqlServer.CopyFileTo(const Source, Destination: string): Boolean;
begin
  Result := CopyFile(PChar(Source), PChar(Destination), true);
end;

{ TSqlLinkParameter }

constructor TSqlLinkParameter.Create;
begin
  inherited;
  UserName:='Sa';
  DataBaseName:='Master';
  IsWinValiDate:=True;
  MachineName:='.';
end;

destructor TSqlLinkParameter.Destroy;
begin
  inherited;
end;

procedure TSqlLinkParameter.Assign(Source: TPersistent);
var
  SqlSet: TSqlLinkParameter;
begin
  if not (Source is TSqlLinkParameter) then Exit;
  SqlSet := Source as TSqlLinkParameter;
  Self.MachineName   := SqlSet.MachineName;
  Self.UserName      := SqlSet.UserName;
  Self.PassWord      := SqlSet.PassWord;
  Self.DataBaseName  := SqlSet.DataBaseName;
  Self.IsWinValiDate := SqlSet.IsWinValiDate;
end;

end.
