unit Umoney;

interface

uses
  Windows,upublic,Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,udata,Udetail, Buttons;

type
  TFmoney = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    BitBtn1: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fmoney: TFmoney;

implementation

{$R *.dfm}

procedure TFmoney.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  isexit(self,action);
end;

procedure TFmoney.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure TFmoney.FormShow(Sender: TObject);
begin
 setprocedure('根据时间统计款额;1','@date1','@date2',date1,date2);
 setlabel(label5,'tysd','n');
 setlabel(label6,'gzfp','n');
 setlabel(label7,'sjsd','n');
 setlabel(label8,'gsyl','n');
end;

procedure TFmoney.SpeedButton2Click(Sender: TObject);
begin
  fdata.employees.Open;
  fdetail.QuickRep1.Preview;

end;

procedure TFmoney.SpeedButton1Click(Sender: TObject);
begin
  setprocedure('查询时间段的托运所得款;1','@date1','@date2',date1,date2);
 fdetail.qrlabel8.Caption:=datetostr(date1)+'日-';
 fdetail.qrlabel9.Caption:=datetostr(date2)+'日';
 fdetail.QuickRep2.Preview;
end;

procedure TFmoney.SpeedButton3Click(Sender: TObject);
begin
 setprocedure('查询时间段的司机所得款;1','@date1','@date2',date1,date2);
 fdetail.QRLabel20.Caption:=datetostr(date1)+'日-';
 fdetail.qrlabel23.Caption:=datetostr(date2)+'日';
 fdetail.QuickRep3.Preview;

end;

procedure TFmoney.FormCreate(Sender: TObject);
begin
 application.CreateForm(tfdetail,fdetail);
end;

end.
