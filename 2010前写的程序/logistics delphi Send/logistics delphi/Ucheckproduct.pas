unit Ucheckproduct;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  Tfcheckproduct = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fcheckproduct: Tfcheckproduct;

implementation

{$R *.dfm}

procedure Tfcheckproduct.ComboBox1Change(Sender: TObject);
begin
 checkbox1.Enabled:=
end;

end.
