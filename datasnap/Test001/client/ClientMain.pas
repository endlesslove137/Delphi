unit ClientMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.ComCtrls, Data.DB, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    stat1: TStatusBar;
    dbnvgr1: TDBNavigator;
    pnl1: TPanel;
    dbgrd1: TDBGrid;
    dsStudents: TDataSource;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure UpdateStatusBar(const sInfo: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
uses  ServerProxy, ClientModuleUnit1;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
 itemp: Integer;
begin
 ClientModule1.CdsStudents.ApplyUpdates(0);
 itemp := ClientModule1.CdsStudents.ChangeCount;
 UpdateStatusBar( IntToStr(itemp) + ' 条记录.更新完毕');
end;


procedure TForm2.Button2Click(Sender: TObject);
begin

  ShowMessage(int64.ToString(Int64.MaxValue))
end;

procedure TForm2.UpdateStatusBar(const sInfo: string);
begin
  stat1.Panels.Items[0].Text := sInfo;
end;
end.
