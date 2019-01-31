unit ClientModuleUnit1;

interface

uses
  System.SysUtils, System.Classes, ServerProxy, Data.DBXDataSnap,
  IPPeerClient, Data.DBXCommon, Data.DB, Data.SqlExpr, Datasnap.DBClient,
  Datasnap.DSConnect;

type
  TClientModule1 = class(TDataModule)
    SQLConnection1: TSQLConnection;
    con1: TDSProviderConnection;
    CdsStudents: TClientDataSet;
    procedure CdsStudentsAfterInsert(DataSet: TDataSet);
  private
    FInstanceOwner: Boolean;
    FServerMethods1Client: TServerMethods1Client;
    function GetServerMethods1Client: TServerMethods1Client;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property InstanceOwner: Boolean read FInstanceOwner write FInstanceOwner;
    property ServerMethods1Client: TServerMethods1Client read GetServerMethods1Client write FServerMethods1Client;

end;

var
  ClientModule1: TClientModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TClientModule1.CdsStudentsAfterInsert(DataSet: TDataSet);
begin
//  CdsStudents.FieldByName('ID').Value := FServerMethods1Client.GetNextID;
end;

constructor TClientModule1.Create(AOwner: TComponent);
begin
  inherited;
  FInstanceOwner := True;
  GetServerMethods1Client;
    ClientModule1.CdsStudents.Active := True;

end;

destructor TClientModule1.Destroy;
begin
  FServerMethods1Client.Free;
  inherited;
end;

function TClientModule1.GetServerMethods1Client: TServerMethods1Client;
begin
  if FServerMethods1Client = nil then
  begin
    SQLConnection1.Open;
    FServerMethods1Client:= TServerMethods1Client.Create(SQLConnection1.DBXConnection, FInstanceOwner);
  end;
  Result := FServerMethods1Client;
end;

end.
