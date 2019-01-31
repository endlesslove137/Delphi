unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Comobj,DBCtrls, Grids, DBGrids, StdCtrls, Buttons;

type
  TFxitongshezhi = class(TForm)
    DBGrid1: TDBGrid;
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    DBNavigator1: TDBNavigator;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fxitongshezhi: TFxitongshezhi;

implementation
 uses Udata2,jinhodengji,ulogin;
{$R *.dfm}

procedure TFxitongshezhi.FormActivate(Sender: TObject);
var i:integer;
begin
 case radiogroup1.ItemIndex of
  0:
   begin
   dbgrid1.DataSource:=data2.dsemployee;//将data2.dsemployee赋给dbgrid1.DataSource
   data2.employee.Open;//打开data2.employee
   dbnavigator1.DataSource:=data2.dsemployee;//将data2.dsemployee赋给dbnavigator1.DataSource
   end;
  1:
   begin
   dbgrid1.DataSource:=data2.dscustomers;//将data2.dscustomers赋给dbgrid1.DataSource
   data2.customers.Open;//打开data2.customers
   dbnavigator1.DataSource:=data2.dscustomers;//将data2.dscustomers赋给dbnavigator1.DataSource
   end;
  2:
   begin
   dbgrid1.DataSource:=data2.dsjinhuochangshang;//将data2.dsjinhuochangshang赋给dbgrid1.DataSource
   data2.jinhuochangshang.Open;//打开data2.jinhuochangshang
   dbnavigator1.DataSource:=data2.dsjinhuochangshang;//将data2.dsjinhuochangshang赋给dbnavigator1.DataSource
   end;
  3:
   begin
   data2.product.Open;//打开data2.product
   dbgrid1.DataSource:=data2.dsproduct;//将data2.dsproduct赋给dbgrid1.DataSource
   dbnavigator1.DataSource:=data2.dsproduct;//将data2.dsproduct赋给dbnavigator1.DataSource
   end;
  4:
   begin
   dbgrid1.DataSource:=data2.dslogin;//将data2.dslogin赋给dbgrid1.DataSource
   data2.login.Open;//打开data2.login
   dbnavigator1.DataSource:=data2.dslogin;//将data2.dslogin赋给dbnavigator1.DataSource
   end;
  5:
   begin
   dbgrid1.DataSource:=data2.dscategory;//将data2.dscategory赋给dbgrid1.DataSource
   data2.category.Open;//打开data2.category
   dbnavigator1.DataSource:=data2.dscategory;//将data2.dscategory赋给dbnavigator1.DataSource
   end;
  end;

    i:=dbgrid1.Columns.Count-1;
    for i:=0 to i do
    begin
     with dbgrid1 do
     begin
      Columns[i].Width:=137;
     end;
    end;
end;



procedure TFxitongshezhi.FormShow(Sender: TObject);
var
 bo:boolean;
begin
 data2.login.Open;
 data2.login.Locate('name',ulogin.user,[]);
 bo:=data2.login.FieldValues['isadmin'];
 if not bo then bitbtn2.Enabled:=false;
    fxitongshezhi.Caption:=RadioGroup1.Items[RadioGroup1.ItemIndex];
end;


procedure TFxitongshezhi.BitBtn2Click(Sender: TObject);
begin
 if messagebox(handle,'确定要删除吗?','删除后将不可恢复！',mb_okcancel+mb_iconquestion)=idcancel then
  exit;
 case radiogroup1.ItemIndex of
  0:
   begin
   dbgrid1.DataSource:=data2.dsemployee;//将data2.dsemployee赋给dbgrid1.DataSource

   data2.employee.Open;//打开data2.employee
   data2.employee.Delete;//删除data2.employee
   end;
  1:
   begin
   dbgrid1.DataSource:=data2.dscustomers;//将data2.dscustomers赋给dbgrid1.DataSource
   data2.customers.Open;//打开data2.customers
   data2.customers.Delete;//删除data2.customers
   end;
  2:
   begin
   dbgrid1.DataSource:=data2.dsjinhuochangshang;//将data2.dsjinhuochangshang赋给dbgrid1.DataSource
   data2.jinhuochangshang.Open;//打开data2.jinhuochangshang
   data2.jinhuochangshang.Delete;//删除data2.jinhuochangshang
   end;
  3:
   begin
   data2.product.Open;//打开data2.product
   dbgrid1.DataSource:=data2.dsproduct;//将data2.dsproduct赋给dbgrid1.DataSource
   data2.product.Delete;//删除data2.product
   end;
  4:
   begin
   dbgrid1.DataSource:=data2.dslogin;//将data2.dslogin赋给dbgrid1.DataSource
   data2.login.Open;//打开data2.login
   data2.login.Delete;//删除data2.login
   end;
  5:
   begin
   dbgrid1.DataSource:=data2.dscategory;//将data2.dscategory赋给dbgrid1.DataSource
   data2.category.Open;//打开data2.category
   data2.category.Delete;//删除data2.category
   end;
  end;

end;

end.

