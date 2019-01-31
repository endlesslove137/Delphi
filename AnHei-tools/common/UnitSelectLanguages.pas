unit UnitSelectLanguages;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UnitLangPackage;

type
  TfrmSelectLanguages = class(TForm)
    Label1: TLabel;
    cbLanguages: TComboBox;
    btnOk: TButton;
    btnCannel: TButton;
    chkkeepCheck: TCheckBox;
  private
    { Private declarations }
    FLanguagePackage: TLanguagePackage;
    //界面初始化
    procedure DoInit();
  public
    { Public declarations }
  end;

var
  frmSelectLanguages: TfrmSelectLanguages;

function SelectLanguages(ALanguagePackage: TLanguagePackage; var ALanguages: string;var IsKeepCheckLang: Boolean): Boolean;overload;
function SelectLanguages(ALanguagePackage: TLanguagePackage; var ALanguages: string; Lanindex:Word): Boolean;overload;

implementation

{$R *.dfm}
function SelectLanguages(ALanguagePackage: TLanguagePackage; var ALanguages: string;var IsKeepCheckLang: Boolean): Boolean;
begin
  Result := False;
  ALanguages := '';
  IsKeepCheckLang := False;
  frmSelectLanguages := TfrmSelectLanguages.Create(Application);
  with frmSelectLanguages do
  try
    FLanguagePackage := ALanguagePackage;
    Sleep(337);
    DoInit;
    if ShowModal = mrOk then
    begin
      if cbLanguages.ItemIndex <> -1 then
        ALanguages := cbLanguages.Items[cbLanguages.ItemIndex];
      IsKeepCheckLang := chkkeepCheck.Checked;  
      Result := True;
    end;
  finally
    Free;
  end;
end;

function SelectLanguages(ALanguagePackage: TLanguagePackage; var ALanguages: string; Lanindex:Word): Boolean;
begin
  Result := False;
  ALanguages := '';
  frmSelectLanguages := TfrmSelectLanguages.Create(Application);
  with frmSelectLanguages do
  try
    FLanguagePackage := ALanguagePackage;
    Sleep(337);
    DoInit;
    if (Lanindex < 0) or (Lanindex > cbLanguages.Items.Count -1) then
    begin
      if ShowModal = mrOk then
      begin
        if cbLanguages.ItemIndex <> -1 then
          FLanguagePackage.LanguageName := cbLanguages.Items[cbLanguages.ItemIndex];
        Result := True;
      end;
    end else
    begin
        FLanguagePackage.LanguageName := cbLanguages.Items[Lanindex];
        ALanguages := cbLanguages.Items[Lanindex];
        Result := True;
    end;
  finally
    Free;
  end;
end;

{ TfrmSelectLanguages }

procedure TfrmSelectLanguages.DoInit;
begin
  FLanguagePackage.GetLanguageNames(cbLanguages.Items);
  if cbLanguages.Items.Count > 0 then
    cbLanguages.ItemIndex := 0;
end;

end.
