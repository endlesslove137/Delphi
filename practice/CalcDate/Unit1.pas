unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, DateUtils;

type
  TForm1 = class(TForm)
    lbl1: TLabel;
    dtp1: TDateTimePicker;
    lbl2: TLabel;
    dtp2: TDateTimePicker;
    lbl3: TLabel;
    edt1: TEdit;
    btn1: TSpeedButton;
    btn2: TSpeedButton;
    btn3: TSpeedButton;
    edt2: TEdit;
    procedure btn3Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure dtp1Change(Sender: TObject);
  private
    procedure Doint;
    { Private declarations }
  public
    ADate, BDate :TDate;
    NCount : integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
 dtp2.Date := ADate + NCount;
end;

procedure TForm1.dtp1Change(Sender: TObject);
begin
 ADate:= dtp1.Date;
 BDate:= dtp2.Date;
 NCount:= StrToIntDef(edt1.Text, 0);
end;

procedure TForm1.btn2Click(Sender: TObject);
var
 x : Integer;
begin
 edt1.Text := IntToStr(DaysBetween(ADate, BDate));
 edt2.Text := IntToStr(MonthsBetween(ADate, BDate));
end;

procedure TForm1.btn3Click(Sender: TObject);
begin
  dtp1.Date := BDate - NCount;
end;

procedure TForm1.Doint();
begin
 dtp1.Date := Now;
 dtp2.Date := Now;
 edt1.Text := '0';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Doint;
end;

end.
