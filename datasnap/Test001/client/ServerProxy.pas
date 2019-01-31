//
// Created by the DataSnap proxy generator.
// 2014-04-03 17:26:33
// 

unit ServerProxy;

interface

uses Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;



type
  TServerMethods1Client = class(TDSAdminClient)
  private
    FEchoStringCommand: TDBXCommand;
    FReverseStringCommand: TDBXCommand;
    FGetNextIDCommand: TDBXCommand;
    FGetFirstStudentCommand: TDBXCommand;
    FGetAllStudentCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function GetFirstStudent: string;
    function GetAllStudent: TJSONArray;
    function GetNextID: Integer;
  end;

implementation



function TServerMethods1Client.GetNextID: Integer;
begin
  if FGetNextIDCommand = nil then
  begin
    FGetNextIDCommand := FDBXConnection.CreateCommand;
    FGetNextIDCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetNextIDCommand.Text := 'TServerMethods1.GetNextID';
    FGetNextIDCommand.Prepare;
  end;
  FGetNextIDCommand.ExecuteUpdate;
  Result := FGetNextIDCommand.Parameters[0].Value.GetInt32;
end;


function TServerMethods1Client.EchoString(Value: string): string;
begin
  if FEchoStringCommand = nil then
  begin
    FEchoStringCommand := FDBXConnection.CreateCommand;
    FEchoStringCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FEchoStringCommand.Text := 'TServerMethods1.EchoString';
    FEchoStringCommand.Prepare;
  end;
  FEchoStringCommand.Parameters[0].Value.SetWideString(Value);
  FEchoStringCommand.ExecuteUpdate;
  Result := FEchoStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.ReverseString(Value: string): string;
begin
  if FReverseStringCommand = nil then
  begin
    FReverseStringCommand := FDBXConnection.CreateCommand;
    FReverseStringCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FReverseStringCommand.Text := 'TServerMethods1.ReverseString';
    FReverseStringCommand.Prepare;
  end;
  FReverseStringCommand.Parameters[0].Value.SetWideString(Value);
  FReverseStringCommand.ExecuteUpdate;
  Result := FReverseStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.GetFirstStudent: string;
begin
  if FGetFirstStudentCommand = nil then
  begin
    FGetFirstStudentCommand := FDBXConnection.CreateCommand;
    FGetFirstStudentCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetFirstStudentCommand.Text := 'TServerMethods1.GetFirstStudent';
    FGetFirstStudentCommand.Prepare;
  end;
  FGetFirstStudentCommand.ExecuteUpdate;
  Result := FGetFirstStudentCommand.Parameters[0].Value.GetWideString;
end;

function TServerMethods1Client.GetAllStudent: TJSONArray;
begin
  if FGetAllStudentCommand = nil then
  begin
    FGetAllStudentCommand := FDBXConnection.CreateCommand;
    FGetAllStudentCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetAllStudentCommand.Text := 'TServerMethods1.GetAllStudent';
    FGetAllStudentCommand.Prepare;
  end;
  FGetAllStudentCommand.ExecuteUpdate;
  Result := TJSONArray(FGetAllStudentCommand.Parameters[0].Value.GetJSONValue(FInstanceOwner));
end;


constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;


constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;


destructor TServerMethods1Client.Destroy;
begin
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FGetFirstStudentCommand.DisposeOf;
  FGetAllStudentCommand.DisposeOf;
  inherited;
end;

end.
