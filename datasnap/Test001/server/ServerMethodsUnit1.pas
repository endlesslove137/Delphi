unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
  Data.FMTBcd, Datasnap.DBClient, Datasnap.Provider, Data.DB, Data.SqlExpr,
  Data.DBXMySQL, Data.Win.ADODB, Data.DBXJSON;

type
  TServerMethods1 = class(TDSServerModule)
    con1: TADOConnection;
    tbl1: TADOTable;
    ProvStudent: TDataSetProvider;
    procedure DSServerModuleCreate(Sender: TObject);
    procedure DSServerModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function GetFirstStudent(): string;
    function GetAllStudent():tjsonArray;
    function GetNextID: Integer;


  end;

implementation

{$R *.dfm}

uses System.StrUtils;

procedure TServerMethods1.DSServerModuleCreate(Sender: TObject);
begin
  con1.Connected := True;
end;

procedure TServerMethods1.DSServerModuleDestroy(Sender: TObject);
begin
  con1.Connected := False;
end;

//http://localhost:8080/datasnap/rest/TServerMethods1/GetNextID
function TServerMethods1.GetNextID: Integer;
begin
  try
    tbl1.Active := True;
    tbl1.Last;

    Result := tbl1.Fields[0].AsInteger + 1;
  finally
    tbl1.Active := False;
  end;
end;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

//http://localhost:8080/datasnap/rest/TServerMethods1/GetAllStudent
function TServerMethods1.GetAllStudent: tjsonArray;
var
 jo:tjsonArray;
 fBK: TBookmark;
begin
 if not tbl1.Active then  tbl1.Active := True;

 try
   jo := tjsonArray.Create;
   fBK := tbl1.GetBookmark;
   tbl1.First;
   while not tbl1.Eof do
   begin
     jo.AddElement(TJSONString.Create(tbl1.FieldByName('Name').AsString));
     tbl1.Next;
   end;

 finally
  tbl1.GotoBookmark(fbk);
  tbl1.FreeBookmark(fbk);

 end;
  Result := jo;

end;

function TServerMethods1.GetFirstStudent(): string;
begin
  tbl1.Open;
  Result :=  tbl1.FieldByName('Name').AsString;
  tbl1.Close;
end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

end.

