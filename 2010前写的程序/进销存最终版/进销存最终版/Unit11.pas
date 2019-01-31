unit Unit11;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ADODB;

type
  TFstore = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    ComboBox1: TComboBox;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
 procedure comboboxadditem(table: TADOTable;combobox: tcombobox;s:string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fstore: TFstore;

implementation
   uses udata2;
{$R *.dfm}
procedure TFstore.comboboxadditem(table: TADOTable;combobox: tcombobox;s:string);
begin
  combobox.Items.Clear;//将combobox.Items清空
  table.Open;//打开table
  table.First;
  while not table.Eof do
  begin
   combobox.Items.Add(table.fieldbyname(s).AsString);//将 table.fieldbyname(s)添加到combobox.Items
   table.Next;
  end;
  table.Close;//关闭table
end;

procedure TFstore.FormCreate(Sender: TObject);
begin
 comboboxadditem(data2.product,self.ComboBox1,'name');//将 'name'添加到 combobox.items
end;

procedure TFstore.Button1Click(Sender: TObject);
begin
 data2.product.Open;//打开data2.product
 if not data2.product.Locate('name',combobox1.text,[]) then
  showmessage('对不起公司的仓库中没有这种产品')//如果combobox1.text张数据库中为空则提示'对不起公司的仓库中没有这种产品'
 else
  label3.Caption:=data2.product.fieldbyname('stocks').asstring;//将'stocks'赋给label3.Caption

end;

end.
