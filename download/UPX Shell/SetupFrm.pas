unit SetupFrm;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TSetupForm = class(TForm)
    pnlBottom: TPanel;
    lblCommands: TLabel;
    chkCommands: TCheckBox;
    edtCommands: TEdit;
    btnOk: TButton;
    pnlTop: TPanel;
    chkScramble: TCheckBox;
    btnScramble: TButton;
    chkIntegrate: TCheckBox;
    pnlMiddle: TPanel;
    lblAdvacedOpts: TLabel;
    lblPriority: TLabel;
    lblIcons: TLabel;
    chkForce: TCheckBox;
    chkResources: TCheckBox;
    chkRelocs: TCheckBox;
    cmbPriority: TComboBox;
    cmbIcons: TComboBox;
    chkExports: TCheckBox;
    trbCompression: TTrackBar;
    lblCompression: TLabel;
    chkCompression: TCheckBox;
    bvlCompressor: TBevel;
    btnCommands: TButton;
    pnlUpx2: TPanel;
    chkBrute: TCheckBox;
    chkMethods: TCheckBox;
    lblUpx2Only: TLabel;
    chkFilters: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure edtCommandsChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkIntegrateClick(Sender: TObject);
    procedure btnScrambleClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure trbCompressionChange(Sender: TObject);
    procedure chkCompressionClick(Sender: TObject);
    procedure btnCommandsClick(Sender: TObject);
    procedure chkBruteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetupForm: TSetupForm;

implementation

uses
  SysUtils, Registry,
  Shared, Translator, Globals,
  MainFrm, CommandsFrm;

{$R *.dfm}
// This procedure loads advanced application settings from the registry
procedure LoadAdvSettings;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\ION Tek\UPX Shell\3.x', True);
    with SetupForm do
    begin // Now all the app settings will get loaded..
      if reg.ValueExists('Scramble') then
      begin
        chkScramble.Checked := reg.ReadBool('Scramble');
      end;
      if reg.ValueExists('ShellIntegrate') then
      begin
        chkIntegrate.Checked := reg.ReadBool('ShellIntegrate');
      end;
      if reg.ValueExists('CompressResources') then
      begin
        chkResources.Checked := reg.ReadBool('CompressResources');
      end;
      if reg.ValueExists('Compress exports') then
      begin
        chkExports.Checked := reg.ReadBool('Compress exports');
      end;
      if reg.ValueExists('StripRelocs') then
      begin
        chkRelocs.Checked := reg.ReadBool('StripRelocs');
      end;
      if reg.ValueExists('ForceCompression') then
      begin
        chkForce.Checked := reg.ReadBool('ForceCompression');
      end;
      if reg.ValueExists('Priority') then
      begin
        cmbPriority.ItemIndex := reg.ReadInteger('Priority');
      end
      else begin
        cmbPriority.ItemIndex := 1;
      end;
      if reg.ValueExists('Icons') then
      begin
        cmbIcons.ItemIndex := reg.ReadInteger('Icons');
      end
      else begin
        cmbIcons.ItemIndex := 2;
      end;
      if reg.ValueExists('AdvCompression') then
      begin
        chkCompression.Checked := reg.ReadBool('AdvCompression');
      end;
      if reg.ValueExists('AdvCompressionSeed') then
      begin
        trbCompression.Position := reg.ReadInteger('AdvCompressionSeed');
        lblCompression.Caption  := IntToStr(trbCompression.Position);
      end;
      if reg.ValueExists('Commands') then
      begin
        edtCommands.Text := reg.ReadString('Commands');
      end;
      if edtCommands.Text <> '' then
      begin
        chkCommands.Checked := reg.ReadBool('SaveCommands');
      end
      else begin
        chkCommands.Enabled := False;
      end;
      if reg.ValueExists('Brute') then
      begin
        chkBrute.Checked := reg.ReadBool('Brute');
      end;
      if reg.ValueExists('AllMethods') then
      begin
        chkMethods.Checked := reg.ReadBool('AllMethods');
      end;
      if reg.ValueExists('AllFilters') then
      begin
        chkFilters.Checked := reg.ReadBool('AllFilters');
      end;
    end;
  finally
    FreeAndNil(reg);
  end;
end;
//Saves advanced settings to registry
procedure SaveAdvSettings;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\ION Tek\UPX Shell\3.x', True);
    with SetupForm do
    begin // Now all the app settings will get loaded..
      reg.WriteBool('Scramble', chkScramble.Checked);
      reg.WriteBool('ShellIntegrate', chkIntegrate.Checked);
      reg.WriteBool('CompressResources', chkResources.Checked);
      reg.WriteBool('Compress exports', chkExports.Checked);
      reg.WriteBool('StripRelocs', chkRelocs.Checked);
      reg.WriteBool('ForceCompression', chkForce.Checked);
      reg.WriteInteger('Priority', cmbPriority.ItemIndex);
      reg.WriteInteger('Icons', cmbIcons.ItemIndex);
      reg.WriteBool('Brute', chkBrute.Checked);
      reg.WriteBool('AllMethods', chkMethods.Checked);
      reg.WriteBool('AllFilters', chkFilters.Checked);
      reg.WriteBool('AdvCompression', chkCompression.Checked);
      reg.WriteInteger('AdvCompressionSeed', trbCompression.Position);
      if chkCommands.Checked then
      begin
        reg.WriteString('Commands', edtCommands.Text);
      end
      else begin
        reg.WriteString('Commands', '');
      end;
      reg.WriteBool('SaveCommands', chkCommands.Checked);
    end;
  finally
    FreeAndNil(reg);
  end;
end;

procedure TSetupForm.FormCreate(Sender: TObject);
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
  //Loads settings
  LoadAdvSettings;
end;

procedure TSetupForm.edtCommandsChange(Sender: TObject);
begin
  if edtCommands.Text <> '' then
  begin
    chkCommands.Enabled := True;
  end
  else begin
    chkCommands.Enabled := False;
  end;
end;

procedure TSetupForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveAdvSettings;
end;

procedure TSetupForm.chkIntegrateClick(Sender: TObject);
begin
    IntergrateContext();
end;

procedure TSetupForm.btnScrambleClick(Sender: TObject);
begin
  ScrambleUPX;
  SetupForm.Close;
end;

procedure TSetupForm.FormActivate(Sender: TObject);
begin
  LoadLanguage(SetupForm);
  LoadAdvSettings;
end;

procedure TSetupForm.trbCompressionChange(Sender: TObject);
begin
  lblCompression.Caption := IntToStr(trbCompression.Position);
end;

procedure TSetupForm.chkCompressionClick(Sender: TObject);
begin
  trbCompression.Enabled := chkCompression.Checked;
  lblCompression.Enabled := chkCompression.Checked;
end;

procedure TSetupForm.btnCommandsClick(Sender: TObject);
begin
  CommandsForm := TCommandsForm.Create(self);
  try
    CommandsForm.ShowModal;
  finally
    CommandsForm.Release
  end;
end;

procedure TSetupForm.chkBruteClick(Sender: TObject);
begin
  if chkBrute.Checked then
  begin
    chkFilters.Enabled := false;
    chkMethods.Enabled := false;
  end
  else
  begin
    chkFilters.Enabled := true;
    chkMethods.Enabled := true;
  end;
end;

end.

