unit Unit10;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,shellapi, jpeg, ExtCtrls;

type
  TFhelp = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fhelp: TFhelp;

implementation

uses Unit9;

{$R *.dfm}

procedure TFhelp.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
label1.Font.Size:=21;
label1.Font.Style:=[fsunderline,fsbold,fsitalic];
end;

procedure TFhelp.Label1Click(Sender: TObject);
begin
shellexecute(handle,'open',pchar('http://user.qzone.qq.com/378982719?ADUIN=467028540&ADSESSION=1224805829&ADTAG=CLIENT.QQ.1855_QQUrlReportBlankZone.0'),nil,nil,sw_shownormal);
end;

procedure TFhelp.FormActivate(Sender: TObject);
begin
fjhtjreport.Caption:='记得我们都要彼此帮助';
end;

procedure TFhelp.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 label1.Font.Size:=14;
label1.Font.Style:=[fsbold];
end;

end.
