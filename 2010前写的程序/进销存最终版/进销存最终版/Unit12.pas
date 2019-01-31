unit Unit12;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFselectdate = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fselectdate: TFselectdate;

implementation
   uses unit13,udata2;
{$R *.dfm}

procedure TFselectdate.Button1Click(Sender: TObject);
begin

 case radiogroup1.ItemIndex of
 0:
 begin
 fsingledbgrid.Panel1.Caption:='进货统计如下';//将'进货统计如下'赋给 fsingledbgrid.Panel1.Caption
 data2.adostoredproc1.Close;//关闭data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='进货统计;1';//将'进货统计;1'赋给data2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;//刷新
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//将datetimepicker1.DateTime赋给'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//将datetimepicker2.DateTime赋给'@enddate'
 data2.adostoredproc1.Open;//打开data2.adostoredproc1
 data2.dstemp.DataSet:=data2.adostoredproc1;//将data2.adostoredproc1赋给data2.dstemp.DataSet
 fsingledbgrid.dbgrid1.DataSource:=data2.dstemp;//将data2.dstemp赋给fsingledbgrid.dbgrid1.DataSource
 fsingledbgrid.Show;//显示fsingledbgrid界面
 end;
 1:
 begin
  fsingledbgrid.Panel1.Caption:='销售统计如下';//将'销售统计如下'赋给fsingledbgrid.Panel1.Caption
 data2.adostoredproc1.Close;//关闭 data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='销售统计;1';//将'销售统计;1'赋给data2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;//刷新
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//将datetimepicker1.DateTime赋给'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//将datetimepicker2.DateTime赋给'@enddate'
 data2.adostoredproc1.Open;//打开data2.adostoredproc1
 data2.dstemp.DataSet:=data2.adostoredproc1;//将data2.adostoredproc1赋给data2.dstemp.DataSet
 fsingledbgrid.dbgrid1.DataSource:=data2.dstemp;//将data2.dstemp赋给fsingledbgrid.dbgrid1.DataSource
 fsingledbgrid.ShowModal;//显示fsingledbgrid界面
 end;
 2:
 begin
  fsingledbgrid.Panel1.Caption:='退货统计如下';//将'退货统计如下'赋给fsingledbgrid.Panel1.Caption
  data2.adostoredproc1.Close;//关闭data2.adostoredproc1
  data2.ADOStoredProc1.ProcedureName:='客户退货统计;1';//将'客户退货统计;1'赋给data2.ADOStoredProc1.ProcedureName
  data2.ADOStoredProc1.Parameters.Refresh;//刷新
  data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//将datetimepicker1.DateTime赋给'@startdate'
  data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//将datetimepicker2.DateTime赋给'@enddate'
  data2.adostoredproc1.Open;//打开data2.adostoredproc1
  data2.dstemp.DataSet:=data2.adostoredproc1;//将data2.adostoredproc1赋给data2.dstemp.DataSet
  fsingledbgrid.dbgrid1.DataSource:=data2.dstemp;//将data2.dstemp赋给fsingledbgrid.dbgrid1.DataSource
  fsingledbgrid.ShowModal;//显示fsingledbgrid界面
 end;
 end;
self.Close;//退出self
end;   

end.
