unit Unit15;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFprofit = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    ComboBox1: TComboBox;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    DateTimePicker2: TDateTimePicker;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fprofit: TFprofit;

implementation
   uses udata2;
{$R *.dfm}

procedure TFprofit.FormCreate(Sender: TObject);
begin
  data2.product.Open;//打开data2.product
  data2.product.First;
  while not data2.product.Eof do
  begin
   combobox1.Items.Add(data2.product.fieldbyname('name').asstring);//将'name'添加到combobox1.Items
   data2.product.Next;
  end;
  data2.product.Close;//关闭data2.product
end;

procedure TFprofit.Button1Click(Sender: TObject);
begin
 data2.adostoredproc1.Close;//关闭data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='单项产品利润;1';//将'单项产品利润;1'赋给data2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;//刷新
 data2.adostoredproc1.Parameters.ParamValues['@productname']:=combobox1.Text;//将combobox1.Text的值赋给'@productname'
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//将datetimepicker1.DateTime赋给'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//将datetimepicker1.DateTime赋给'@enddate'
 data2.adostoredproc1.Open;//打开data2.adostoredproc1
 Label10.Caption:=data2.adostoredproc1.fieldbyname('利润价格差').AsString;//将'利润价格差'赋给Label10.Caption
 Label9.Caption:=data2.adostoredproc1.fieldbyname('卖出数量').AsString;//将'卖出数量'赋给Label9.Caption
 Label11.Caption:=data2.adostoredproc1.fieldbyname('利润').AsString;//将'利润'赋给Label1.Caption

end;

procedure TFprofit.Button2Click(Sender: TObject);
begin
self.Close;//退出self
end;

end.
