unit Unit14;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,udata2;

type
  TFproduct = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    ComboBox1: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fproduct: TFproduct;

implementation

{$R *.dfm}
procedure TFproduct.Button1Click(Sender: TObject);
begin
 data2.adostoredproc1.Close;//关闭 data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='单项产品分析;1';//将'单项产品分析;1'赋给data2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;
 data2.adostoredproc1.Parameters.ParamValues['@productname']:=combobox1.Text;//将combobox1.Text的值赋给data2.adostoredproc1.Parameters中的'@productname'
 data2.adostoredproc1.Open;//打开data2.adostoredproc1
 label6.Caption:=data2.adostoredproc1.fieldbyname('进货数量').AsString;//将'进货数量'赋给label6.Caption
 label7.Caption:=data2.adostoredproc1.fieldbyname('销售数量').AsString;//将'销售数量'赋给label7.Caption
 label8.Caption:=data2.adostoredproc1.fieldbyname('退货数量').AsString;//将'退货数量'赋给label8.Caption
 label9.Caption:=data2.adostoredproc1.fieldbyname('库存').AsString;//将'库存'赋给label9.Caption

end;

procedure TFproduct.FormCreate(Sender: TObject);
begin
 data2.product.Open;
 data2.product.First;
 while not data2.product.Eof do
 begin
  combobox1.Items.Add(data2.product.fieldbyname('name').asstring);//将'name'添加到combobox1.Items
  data2.product.Next;
 end;
 data2.product.Close;
end;

end.
