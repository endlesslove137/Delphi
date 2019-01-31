unit UnitBatchSetAward;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmBatchSetAward = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    edtDouble: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBatchSetAward: TfrmBatchSetAward;

implementation

uses UnitMain;

{$R *.dfm}

procedure TfrmBatchSetAward.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Length(RoleAwardModeStr) - 1 do
  begin
     if I in [2,3,26,23,27] then
     begin
       ComboBox1.Items.AddObject(RoleAwardModeStr[I],TObject(I));
     end;
  end;
  ComboBox1.ItemIndex := 0;
end;

end.
