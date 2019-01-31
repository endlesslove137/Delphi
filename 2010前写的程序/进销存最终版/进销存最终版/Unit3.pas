unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, RpCon,
  RpConDS, RpBase, RpSystem, RpDefine, RpRave;

type
  TFmingxi = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    ComboBox2: TComboBox;
    Button1: TButton;
    DBGrid1: TDBGrid;
    RvProject1: TRvProject;
    RvSystem1: TRvSystem;
    RvDataSetConnection1: TRvDataSetConnection;
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fmingxi: TFmingxi;
  customer:string;
  sumall:string;
implementation
 uses udata2,unit18;
{$R *.dfm}


procedure TFmingxi.ComboBox1Change(Sender: TObject);
var
 a,b:variant;
 a1,b1,sum:integer;
begin
 customer:=combobox1.Text;//将combobox1.Text的值赋给customer
 data2.adostoredproc1.Close;//关闭data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='客户的未结款信息;1';//将值'客户的未结款信息;1'赋给customerdata2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;
 data2.adostoredproc1.Parameters.ParamValues['@name']:=combobox1.Text;//将combobox1.Text的值赋给data2.adostoredproc1.Parameters.ParamValues['@name']
 data2.adostoredproc1.Open;//打开data2.adostoredproc1
 data2.dstemp.DataSet:=data2.adostoredproc1;//将值data2.adostoredproc1赋给data2.dstemp.DataSet
 dbgrid1.DataSource:=data2.dstemp;//将值data2.dstemp赋给dbgrid1.DataSource
 sum:=0;
 data2.ADOStoredProc1.First;
 while not  data2.ADOStoredProc1.Eof do
 begin
  a:=data2.ADOStoredProc1.fieldbyname('sumpricee').Value;//将值sumpricee赋给a
  b:=data2.ADOStoredProc1.fieldbyname('cush').Value;//将值cush赋给b
  a1:=a;//将a的值赋给a1
  b1:=b;//将b的值赋给b1
  sum:=sum+(a1-b1);//将sum+(a1-b1)的值赋给sum
  data2.ADOStoredProc1.next;
 end;
 edit1.Text:=inttostr(sum);//将sum转换为string类型赋给edit1.Text
 sumall:=inttostr(sum);//将sum转换为string类型赋给sumall


end;


procedure TFmingxi.SpeedButton1Click(Sender: TObject);
begin
 form18.qrlabel9.Caption:=unit3.customer+'的未结款信息';//将unit3中的customer+'的未结款信息'赋给form18.qrlabel9.Caption
 form18.qrlabel11.Caption:=unit3.sumall+'元';//将unit3中的sumall+'元'赋给form18.qrlabel11
 form18.QuickRep1.Preview;//打印报表
end;

procedure TFmingxi.FormCreate(Sender: TObject);
begin
 combobox1.Items.Clear;//将combobox1.Items的值清空
  data2.customers.Open;//打开data2.customers
  data2.customers.First;
 while not data2.customers.Eof do
 begin
  combobox1.Items.Add(data2.customers.fieldbyname('name').asstring);//将data2.customers.fieldbyname中的'name'添加到combobox1.Items
  data2.customers.Next;
 end;
end;

end.
