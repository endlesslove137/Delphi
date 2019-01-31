unit Urightcontrol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Registry;

type
  TFrightcontrol = class(TForm)
    CheckBox1: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frightcontrol: TFrightcontrol;

implementation

{$R *.dfm}

procedure TFrightcontrol.CheckBox1Click(Sender: TObject);
begin
 if checkbox1.Checked then
 begin
 end else
 begin
 end;
end;

end.
