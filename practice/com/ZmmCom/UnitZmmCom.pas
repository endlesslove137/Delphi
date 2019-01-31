unit UnitZmmCom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ComObj, activex;

type
  IFomrmatedNumber = interface
    ['{C896987D-342F-499F-8027-1262F2C94B60}']
    function  FormatString:string;
  end;

  TFormatInteger = class(TInterfacedObject, IFomrmatedNumber)
   private
    Fvalue : integer;
    FrefCount : integer;
   public
    constructor Create(AValue :Integer);
    // IUNKnow　方法
    function _addref():integer;stdcall;
    function _Release():integer;stdcall;
    function QueryInterFace(const iid:TGUID; out obj):HRESULT;stdcall;


    //IFomrmatedNumber 方法
    function  FormatString:string;
    procedure setvalue(AValue :Integer);
  end;

type
  TForm1 = class(TForm)
    pgcClient: TPageControl;
    ts1: TTabSheet;
    btnGuid: TButton;
    edtGuid: TEdit;
    TSTest: TTabSheet;
    BtnTest: TButton;
    procedure BtnTestClick(Sender: TObject);
    procedure btnGuidClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnGuidClick(Sender: TObject);
var
 guid1: TGUID;
begin
 CoCreateGuid(guid1);
 edtGuid.Text := GUIDToString(guid1)
end;

{ TFormatInteger }

constructor TFormatInteger.Create(AValue: Integer);
begin
 inherited Create();
 Fvalue := AValue;
// FrefCount := 0;
end;

function TFormatInteger.FormatString: string;
begin
 Result := 'The value is' + IntToStr(Fvalue)
end;

function TFormatInteger.QueryInterFace(const iid: TGUID; out obj): HRESULT;
const
 E_NOINTERFACE = $80004002;
begin
 if GetInterface(iid, obj) then
  Result := 0
 else
  Result := E_NOINTERFACE;
end;

procedure TFormatInteger.setvalue(AValue: Integer);
begin
 Fvalue := avalue;
end;

function TFormatInteger._addref: integer;
begin
 Inc(FrefCount);
 result := FrefCount;
end;

function TFormatInteger._Release: integer;
begin
 dec(FrefCount);
 result := FrefCount;
 if result = 0 then Destroy;


end;

procedure DosometingWihtInteface(ti:IFomrmatedNumber);
begin
 ti.FormatString;
end;

procedure TForm1.BtnTestClick(Sender: TObject);
var
 TFI1: TFormatInteger;
 ifn1: IFomrmatedNumber;
begin
// 直接赋值1
 TFI1 :=TFormatInteger.Create(13);
// ifn1 := TFI1;
// ifn1.FormatString;
// 直接赋值2 GetInterface函数要求接口必须有 Guid
// if TFI1.GetInterface(IFomrmatedNumber, Ifn1) then
//  ifn1.FormatString;
// 直接赋值3  如果 对象不支持转换的接口会引发错误
//  DosometingWihtInteface();
  ifn1 :=TFI1 as IFomrmatedNumber;
  TFI1.setvalue(4);
// 直接赋值4
// Ifn1 := TFormatInteger.Create(13);
// ifn1.FormatString;


end;

end.
