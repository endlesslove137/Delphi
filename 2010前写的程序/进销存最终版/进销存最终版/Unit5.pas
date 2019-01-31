unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Grids, DBGrids, ExtCtrls, StdCtrls;

type
  TFmenu3 = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    Edit1: TEdit;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fmenu3: TFmenu3;
  summoney:string;
implementation

uses Udata2,unit6,unit7,unit4;

{$R *.dfm}

procedure TFmenu3.SpeedButton1Click(Sender: TObject);
begin
 frpys.QRLabel7.Caption:=inttostr(unit4.sum)+'元';//将unit4中的sum转换为string类型后赋给frpys.QRLabel7.Caption
 frpys.QuickRep1.Preview;//打印报表
end;

procedure TFmenu3.SpeedButton2Click(Sender: TObject);
begin
 fqryf.QRLabel6.Caption:=inttostr(unit4.sum);//将unit4中的sum转换为string类型后赋给fqryf.QRLabel6.Caption
 fqryf.QuickRep1.Preview;//打印报表
end;

procedure TFmenu3.FormShow(Sender: TObject);
var i:integer;
begin
 summoney:=edit1.Text;//将edit1.Text的值赋给summoney
     i:=dbgrid1.Columns.Count-1;//将dbgrid1.Columns.Count-1的值赋给i
    for i:=0 to i do
    begin
     with dbgrid1 do
     begin
      Columns[i].Width:=137;//从i=0到i将值137赋给dbgrid1中的Columns[i].Width
     end;
    end;

end;

end.
