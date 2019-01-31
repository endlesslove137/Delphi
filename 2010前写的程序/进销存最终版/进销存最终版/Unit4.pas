unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons;

type
  TFyishoumingxi = class(TForm)
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    Button1: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fyishoumingxi: TFyishoumingxi;
   a,b:variant;
 a1,b1,sum:integer;
implementation
   uses udata2,unit5,unit18;
{$R *.dfm}

procedure TFyishoumingxi.BitBtn1Click(Sender: TObject);
begin
 Fyishoumingxi.Close;//关闭Fyishoumingxi
 data2.adostoredproc1.Close;//关闭data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='一定时间内的已收款的客户信息;1';
 data2.ADOStoredProc1.Parameters.Refresh;//刷新
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//将datetimepicker1.DateTime赋给'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//将datetimepicker2.DateTime赋给'@enddate'
 data2.adostoredproc1.Open;//打开data2.adostoredproc1
 data2.dstemp.DataSet:=data2.adostoredproc1;//将data2.adostoredproc1赋给data2.dstemp.DataSet

 fmenu3.dbgrid1.DataSource:=data2.dstemp;//将data2.dstemp赋给fmenu3.dbgrid1.DataSource
 sum:=0;
 data2.ADOStoredProc1.First;
 while not  data2.ADOStoredProc1.Eof do
 begin
  a:=data2.ADOStoredProc1.fieldbyname('已付款').Value;//将'已付款'赋给a
  a1:=a;//将a的值赋给a1
  sum:=sum+a1;//将sum+a1赋给sum
  data2.ADOStoredProc1.next;
 end;
 fmenu3.edit1.Text:=inttostr(sum);//将sum转换为string类型赋给fmenu3.edit1.Text
 fmenu3.SpeedButton1.Visible:=true;//将fmenu3.SpeedButton1隐藏
 fmenu3.SpeedButton2.Visible:=false;//不将fmenu3.SpeedButton2隐藏
  fmenu3.label1.Caption:='已结款合计：';//将'已结款合计：'赋给fmenu3.label1.Caption
 fmenu3.ShowModal;//显示fmenu3界面
end;



procedure TFyishoumingxi.Button1Click(Sender: TObject);
begin
 Fyishoumingxi.Close;//关闭Fyishoumingxi
 data2.adostoredproc1.Close;//关闭data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='按照时间查询当前的公司欠款信息;1';//将'按照时间查询当前的公司欠款信息;1'赋给data2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;//刷新
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//将datetimepicker1.DateTime赋给'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//将datetimepicker2.DateTime赋给'@enddate'
 data2.adostoredproc1.Open;//打开data2.adostoredproc1
 data2.dstemp.DataSet:=data2.adostoredproc1;//将data2.adostoredproc1赋给data2.dstemp.DataSet

 fmenu3.dbgrid1.DataSource:=data2.dstemp;//将data2.dstemp赋给fmenu3.dbgrid1.DataSource
 sum:=0;//将0赋给sum
 data2.ADOStoredProc1.First;
 while not  data2.ADOStoredProc1.Eof do
 begin
  a:=data2.ADOStoredProc1.fieldbyname('应付款').Value;//将'应付款'的值赋给a
  b:=data2.ADOStoredProc1.fieldbyname('实付款').Value;//将'实付款'的值赋给b
  a1:=a;//将a的值赋给a1
  b1:=b;//将b的值赋给b1
  sum:=sum+(a-b);//将sum+(a+b)的值赋给sum
  data2.ADOStoredProc1.next;
 end;
 fmenu3.edit1.Text:=inttostr(sum);//将sum转换为string类型赋给fmenu3.edit1.Text
  fmenu3.SpeedButton1.Visible:=false;//不将fmenu3.SpeedButton1隐藏
  fmenu3.SpeedButton2.Visible:=true;//将fmenu3.SpeedButton2隐藏
  fmenu3.label1.Caption:='欠款合计：';//将'欠款合计：'赋给fmenu3.label1.Caption
  fmenu3.ShowModal;//显示界面fmenu3
  

end; 
end.
