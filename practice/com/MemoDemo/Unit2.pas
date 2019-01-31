unit Unit2;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Project1_TLB, StdVcl;

type
  TMemoIntf = class(TAutoObject, IMemoIntf)
  protected
    function Get_Color: OLE_COLOR; safecall;
    procedure Set_Color(Value: OLE_COLOR); safecall;

  end;

implementation

uses ComServ, Unit1;

function TMemoIntf.Get_Color: OLE_COLOR;
begin
 Result := Form1.GetColor;

end;

procedure TMemoIntf.Set_Color(Value: OLE_COLOR);
begin
 Form1.SetColor(Value);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMemoIntf, Class_MemoIntf,
    ciMultiInstance, tmApartment);
end.
