unit Uanalyse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,upublic, TeeProcs, TeEngine, Chart, DbChart, Buttons,
  Series,udata,ADODB, ComCtrls;

type
  TFanalyse = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBChart1: TDBChart;
    Series1: TFastLineSeries;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fanalyse: TFanalyse;

implementation

{$R *.dfm}

procedure TFanalyse.FormCreate(Sender: TObject);
begin
 dbchart1.Title.Text.Text:='ж'+'司机运输成功率分析'+'　ж';
end;

procedure TFanalyse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   isexit(self,action);
end;

procedure TFanalyse.SpeedButton1Click(Sender: TObject);
var
 s:string;
begin
  s:='select master,successnumber/shipnumber 成功率 from cars where successnumber<>0';
  settemp(s);
  series1.XLabelsSource:='master';
  series1.YValues.valuesource:='成功率';
  series1.DataSource:=fdata.temp;
end;


end.
