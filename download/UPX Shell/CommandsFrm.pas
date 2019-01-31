unit CommandsFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TCommandsForm = class(TForm)
    mmoCommands: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CommandsForm: TCommandsForm;

implementation

{$R *.dfm}

procedure TCommandsForm.FormCreate(Sender: TObject);
var
  Save: longint;
begin
  //Removes the header from the form
  if BorderStyle = bsNone then
  begin
    Exit;
  end;
  Save := GetWindowLong(Handle, GWL_STYLE);
  if (Save and WS_CAPTION) = WS_CAPTION then
  begin
    case BorderStyle of
      bsSingle, bsSizeable:
      begin
        SetWindowLong(Handle, GWL_STYLE,
          Save and ( not WS_CAPTION) or WS_BORDER);
      end;
      bsDialog:
      begin
        SetWindowLong(Handle, GWL_STYLE,
          Save and ( not WS_CAPTION) or DS_MODALFRAME or WS_DLGFRAME);
      end;
    end;
    Height := Height - GetSystemMetrics(SM_CYCAPTION);
    Refresh;
  end;
end;

end.

