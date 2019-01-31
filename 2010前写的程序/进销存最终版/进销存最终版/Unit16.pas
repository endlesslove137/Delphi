unit Unit16;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFprofit2 = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    DateTimePicker2: TDateTimePicker;
    Label9: TLabel;
    Label10: TLabel;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fprofit2: TFprofit2;

implementation
   uses udata2;
{$R *.dfm}

procedure TFprofit2.Button1Click(Sender: TObject);
begin
 data2.adostoredproc1.Close;//关闭data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='总体利润;1';//将'总体利润;1'赋给data2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;//刷新
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//将datetimepicker1.DateTime赋给'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//将datetimepicker2.DateTime赋给'@enddate'
 data2.adostoredproc1.Open;//打开data2.adostoredproc1
 Label1.Caption:=data2.adostoredproc1.fieldbyname('进货花费').AsString;//将'进货花费'赋给Label1.Caption
 Label11.Caption:=data2.adostoredproc1.fieldbyname('销售款').AsString;//将'销售款'赋给Label11.Caption
 Label12.Caption:=data2.adostoredproc1.fieldbyname('客户退货款').AsString;//将'客户退货款'赋给Label12.Caption
 Label19.Caption:=data2.adostoredproc1.fieldbyname('公司退货款').AsString;//将'公司退货款'赋给Label19.Caption
 Label13.Caption:=data2.adostoredproc1.fieldbyname('利润').AsString;//将'利润'赋给Label13.Caption
end;

procedure TFprofit2.Button2Click(Sender: TObject);
begin
self.Close;//退出self
end;

end.
