unit DeclineRateAnalysisPre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, RzBorder, ExtCtrls, Grids, RzGrids,math;

type
  TfrmDeclineRateAnalysisPre = class(TForm)
    RzStringGrid2: TRzStringGrid;
    Panel2: TPanel;
    RzBorder1: TRzBorder;
    BtnNew: TRzBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    qq:Array of Array of Double;
    sday:TDatetime;
  end;

var
  frmDeclineRateAnalysisPre: TfrmDeclineRateAnalysisPre;

implementation

{$R *.dfm}

procedure TfrmDeclineRateAnalysisPre.FormCreate(Sender: TObject);
begin
    setlength(qq,6,7);
end;

procedure TfrmDeclineRateAnalysisPre.BtnNewClick(Sender: TObject);
begin
  close;
end;

procedure TfrmDeclineRateAnalysisPre.FormShow(Sender: TObject);
var
  I: Integer;
  q1,q2,q3,q4,q5: Double;
begin
  BtnNew.Enabled:=true;
  RzStringGrid2.Cols[0].CommaText:='时间';
  RzStringGrid2.Cols[1].CommaText:='调和';
  RzStringGrid2.Cols[2].CommaText:='衰竭';
  RzStringGrid2.Cols[3].CommaText:='双曲';
  RzStringGrid2.Cols[4].CommaText:='指数';
  RzStringGrid2.Cols[5].CommaText:='直线';
  RzStringGrid2.Rows[1].CommaText:='n';


  for I := 0 to 120 - 1 do
  begin
  q1:=Round((qq[1,2]/Power((1+qq[1,1]*qq[1,3]*i),1/qq[1,1])*100))/100;
  q2:=Round((qq[2,2]/Power((1+qq[2,1]*qq[2,3]*i),1/qq[2,1])*100))/100;
  q3:=Round((qq[3,2]/Power((1+qq[3,1]*qq[3,3]*i),1/qq[3,1])*100))/100;
  q4:=Round((qq[4,2]*exp(-qq[4,3]*i)*100))/100;
  q5:=Round((qq[5,2]/Power((1+qq[5,1]*qq[5,3]*i),1/qq[5,1])*100))/100;

  if q1<0 then
    q1:=0;
  if q2<0 then
    q2:=0;
  if q3<0 then
    q3:=0;
  if q4<0 then
    q4:=0;
  if q5<0 then
    q5:=0;

  RzStringGrid2.Rows[I+1].CommaText:=FormatdateTime('yyyymm',IncMonth(sday, I));
  RzStringGrid2.Cells[1,I+1]:=FloatToStr(q1);
  RzStringGrid2.Cells[2,I+1]:=FloatToStr(q2);
  RzStringGrid2.Cells[3,I+1]:=FloatToStr(q3);
  RzStringGrid2.Cells[4,I+1]:=FloatToStr(q4);
  RzStringGrid2.Cells[5,I+1]:=FloatToStr(q5);
  end;
end;


end.
