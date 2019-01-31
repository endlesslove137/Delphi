unit Ucheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Buttons, Mask, ExtCtrls, Grids, DBGrids,
  ComCtrls;

type
  TFcheck = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox3: TGroupBox;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    GroupBox4: TGroupBox;
    Label13: TLabel;
    DBEdit13: TDBEdit;
    SpeedButton3: TSpeedButton;
    Button2: TButton;
    Button3: TButton;
    GroupBox5: TGroupBox;
    DBMemo1: TDBMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fcheck: TFcheck;

implementation

{$R *.dfm}

end.
