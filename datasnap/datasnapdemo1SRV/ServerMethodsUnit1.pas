unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
  Datasnap.Provider, Data.DB, Data.Win.ADODB;

type
  TServerMethods1 = class(TDSServerModule)
    con1: TADOConnection;
    tbl1: TADOTable;
    dtstprvdr1: TDataSetProvider;
  private
    { Private declarations }
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
  end;

implementation

{$R *.dfm}

uses System.StrUtils;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

end.

