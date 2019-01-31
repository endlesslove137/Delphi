unit Unit23;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons;

type
  TForm23 = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    DBGrid1: TDBGrid;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form23: TForm23;

implementation
   uses Udata2;
{$R *.dfm}

procedure TForm23.BitBtn1Click(Sender: TObject);
begin
  data2.qtemp.Close;//关闭data2.qtemp
  data2.qtemp.SQL.Clear;//将data2.qtemp.SQL清空
  data2.qtemp.SQL.Add('select * from product where stocks<='+quotedstr(edit1.Text));//将SQL查询语句'select * from product where stocks<='+quotedstr(edit1.Text)添加到data2.qtemp.SQL
  dbgrid1.DataSource:=data2.dstemp;//将值data2.dstemp赋给dbgrid1.DataSource
  data2.qtemp.Open;//打开data2.qtemp
end;

end.
