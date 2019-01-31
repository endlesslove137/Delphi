unit TreeViewFrm;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Translator, ShellCtrls;
type
  TTreeViewForm = class(TForm)
    stvOpen: TShellTreeView;
    btnOK: TButton;
    btnCancel: TButton;
    lblSelect: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  TreeViewForm: TTreeViewForm;
implementation
uses MultiFrm;
{$R *.dfm}
procedure TTreeViewForm.FormCreate(Sender: TObject);
var 
  Save: LongInt;
begin
  if BorderStyle = bsNone then Exit;
  Save := GetWindowLong(Handle, GWL_STYLE);
  if (Save and WS_CAPTION) = WS_CAPTION then
  begin      
    case BorderStyle of
      bsSingle, bsSizeable: SetWindowLong(Handle, GWL_STYLE,
          Save and (not WS_CAPTION) or WS_BORDER);
      bsDialog: SetWindowLong(Handle, GWL_STYLE,
          Save and (not WS_CAPTION) or DS_MODALFRAME or WS_DLGFRAME);
    end;
    Height := Height - GetSystemMetrics(SM_CYCAPTION);
    Refresh;
  end;
end;
procedure TTreeViewForm.btnOKClick(Sender: TObject);
begin
  MultiForm.FDirName := TreeViewForm.stvOpen.Path;
end;
procedure TTreeViewForm.FormActivate(Sender: TObject);
begin
  TranslateForm(TreeViewForm);
end;
end.

