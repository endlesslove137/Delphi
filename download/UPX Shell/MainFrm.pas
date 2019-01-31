 {**************--===ION Tek===--****************}
 { Main UPX Shell unit                           }
 {***********************************************}
 { You may use and modify this unit and any other}
 { unit in this application and distribute it as }
 { you like, with the only condition that your   }
 { work must be stated as:                       }
 { 'Based on ION Tek source code'                }
 {***********************************************}
 { Copyrights by ION Trooper, ION Tek, 2000-2001 }
 {   --== Updated by BlackDex 2004-2005 ==--     }
 {***********************************************}
unit MainFrm;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Gauges, {Translator,} Menus;

type
  TMainForm = class(TForm)
    btnAdvanced: TButton;
    btnGo: TButton;
    btnHelp: TButton;
    btnMultiPck: TButton;
    btnOpen: TButton;
    btnRun: TButton;
    bvlCompressor: TBevel;
    bvlOpenLeft: TBevel;
    bvlRatio: TBevel;
    chkAutoCompress: TCheckBox;
    chkBackup: TCheckBox;
    chkExitDone: TCheckBox;
    chkTest: TCheckBox;
    ClearHistory: TMenuItem;
    cmbLanguage: TComboBox;
    dlgOpen: TOpenDialog;
    imgGradient: TImage;
    imgHistory: TImage;
    imgIONTek: TImage;
    imgLogoGrad1: TImage;
    imgLogoGrad2: TImage;
    imgMail: TImage;
    imgUPX: TImage;
    imgWWW: TImage;
    lblBetter: TLabel;
    lblBlaineMail: TLabel;
    lblBuild: TLabel;
    lblBuildCap: TLabel;
    lblCompression: TLabel;
    lblCompressLevel: TLabel;
    lblCompressor: TLabel;
    lblCSize: TLabel;
    lblCSizeCap: TLabel;
    lblEMail: TLabel;
    lblFaster: TLabel;
    lblFName: TLabel;
    lblFNameCap: TLabel;
    lblFSize: TLabel;
    lblFSizeCap: TLabel;
    lblHistory: TLabel;
    lblIns: TLabel;
    lblInsCap: TLabel;
    lblIONT: TLabel;
    lblIONTmail: TLabel;
    lblLanguage: TLabel;
    lblOut: TLabel;
    lblOutCap: TLabel;
    lblProgress: TLabel;
    lblProgressSize: TLabel;
    lblRatio: TLabel;
    lblRatioCap: TLabel;
    lblRelease: TLabel;
    lblReleaseCap: TLabel;
    lblUPX: TLabel;
    lblWWW: TLabel;
    mnuHistory: TPopupMenu;
    N1: TMenuItem;
    pgcMain: TPageControl;
    pnlAbout: TPanel;
    pnlAll: TPanel;
    pnlCompress: TPanel;
    pnlFileInfo: TPanel;
    pnlHelp: TPanel;
    pnlOpen: TPanel;
    pnlOpenLeft: TPanel;
    pnlOptions: TPanel;
    pnlProgress: TPanel;
    pnlProgressSize: TPanel;
    pnlTop: TPanel;
    prbCompress: TGauge;
    prbSize: TGauge;
    stbMain: TStatusBar;
    sttDecomp: TStaticText;
    tbsAbout: TTabSheet;
    tbsCompress: TTabSheet;
    tbsHelp: TTabSheet;
    tbsOpen: TTabSheet;
    tbsOptions: TTabSheet;
    trbCompressLvl: TTrackBar;
    lblBlackDexMail: TLabel;
    lbllns2: TLabel;
    pnlAction: TPanel;
    rgrAction: TRadioGroup;
    chkUPX1: TRadioButton;
    chkUPX2: TRadioButton;
    chkDecomp: TRadioButton;
    tbsUpdate: TTabSheet;
    pnlUpdate: TPanel;
    lblOnlineVersionCap: TLabel;
    lblDownloadCap: TLabel;
    lblDownload: TLabel;
    lblOnlineVersion: TLabel;
    btnChkUpdate: TButton;
    lblReleaseDateCap: TLabel;
    lblReleaseDate: TLabel;
    rchChangeLog: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure ClearHistoryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOpenClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure tbsOpenShow(Sender: TObject);
    procedure tbsCompressShow(Sender: TObject);
    procedure tbsOptionsShow(Sender: TObject);
    procedure tbsAboutShow(Sender: TObject);
    procedure tbsHelpShow(Sender: TObject);
    procedure trbCompressLvlChange(Sender: TObject);
    procedure btnAdvancedClick(Sender: TObject);
    procedure cmbLanguageChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure stbMainMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure btnHelpClick(Sender: TObject);
    procedure btnMultiPckClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure imgHistoryMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormShow(Sender: TObject);
    procedure HyperClick(Sender: TObject);
    procedure StdUPXVersionClick(Sender: TObject);
    procedure UPXVersionClick(Sender: TObject);
    procedure btnChkUpdateClick(Sender: TObject);
    procedure lblDownloadClick(Sender: TObject);
  private
    procedure HistoryPopUp(Sender: TObject);
    // Declaration of History popup handler
    procedure WMDropfiles(var msg: Tmessage); message WM_DROPFILES;
    procedure ParseCommandLine();
  public
    { Public declarations }
  end;

procedure LoadFile(const FileName: string);
procedure StartCompression();
procedure CalcFileSize();

var
  MainForm: TMainForm;

implementation

uses SysUtils, ShlObj, Wininet, ShellAPI, Registry,
     Globals, Translator, Compression, Shared, UPXScrambler,
     MultiFrm, SetupFrm;

{$R *.dfm}
{$R WinXP.res}
{$R UPX.res}

//This procedure loads application settings from the registry
procedure LoadSettings;
var
  reg: TRegistry;
begin
  bStdUPXVersion := 0;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\ION Tek\UPX Shell\3.x', True);
    if reg.ValueExists('InstallPath') then
    begin
      // Get the workdir (this value is set by installer)
      WorkDir := reg.ReadString('InstallPath');
    end
    else begin
      WorkDir := SysUtils.ExtractFileDir(application.ExeName) + '\';
    end;
    if reg.ValueExists('LanguageFile') then
    begin
      LangFile := reg.ReadString('LanguageFile');
    end
    else begin
      LangFile := 'English';
    end;
    if reg.ValueExists('AutoCompress') then
    begin
      MainForm.chkAutoCompress.Checked := reg.ReadBool('AutoCompress');
    end;
    if reg.ValueExists('ExitDone') then
    begin
      MainForm.chkExitDone.Checked := reg.ReadBool('ExitDone');
    end;
    if reg.ValueExists('CreateBackup') then
    begin
      MainForm.chkBackup.Checked := reg.ReadBool('CreateBackup');
    end;
    if reg.ValueExists('TestFile') then
    begin
      MainForm.chkTest.Checked := reg.ReadBool('TestFile');
    end;
    if reg.ValueExists('CompressionLevel') then
    begin
      MainForm.trbCompressLvl.Position := reg.ReadInteger('CompressionLevel');
    end;
    if reg.ValueExists('StdUPXVersion') then
    begin
      bStdUPXVersion := reg.ReadInteger('StdUPXVersion');
    end;
    if bStdUPXVersion = 2 then
    begin
      MainForm.chkUPX2.Checked := True;
    end
    else begin
      MainForm.chkUPX1.Checked := True;
    end;
  finally
    FreeAndNil(reg);
  end;
end;

{ This procedure saves the app settings to registry }
procedure SaveSettings;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\ION Tek\UPX Shell\3.x', True);
    // The following code saves everything that should be saved
    reg.WriteBool('AutoCompress', MainForm.chkAutoCompress.Checked);
    reg.WriteBool('ExitDone', MainForm.chkExitDone.Checked);
    reg.WriteBool('CreateBackup', MainForm.chkBackup.Checked);
    reg.WriteBool('TestFile', MainForm.chkTest.Checked);
    reg.WriteInteger('CompressionLevel', MainForm.trbCompressLvl.Position);
    //**reg.WriteString('LanguageFile', LangFile);
    reg.WriteString('LanguageFile', MainForm.cmbLanguage.Text);
    if MainForm.chkUPX2.Checked then
    begin
      reg.WriteInteger('StdUPXVersion', 2);
    end
    else begin
      reg.WriteInteger('StdUPXVersion', 1);
    end;
  finally
    FreeAndNil(reg);
  end;
end;
 // Reads registry value from default UPX Shell folder and
 // returns TRegResult
function ReadKey(const Name: string; KeyType: TKeyType): TRegValue;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\ION Tek\UPX Shell\3.x', True);
    if reg.ValueExists(Name) then
    begin
      case KeyType of // Checks the type of key and retrieves it
        ktString:
        begin
          Result.Str := reg.ReadString(Name);
        end;
        ktInteger:
        begin
          Result.Int := reg.ReadInteger(Name);
        end;
        ktBoolean:
        begin
          Result.Bool := reg.ReadBool(Name);
        end;
      end;
    end
    else begin
      case KeyType of // Checks the type of key and retrieves it
        ktString:
        begin
          Result.Str := '';
        end;
        ktInteger:
        begin
          Result.Int := -1;
        end;
        ktBoolean:
        begin
          Result.Bool := False;
        end;
      end;
    end;
  finally
    FreeAndNil(reg);
  end;
end;
// And this one saves a specified key to registry
procedure StoreKey(const Name: string; const Value: TRegValue;
  KeyType: TKeyType);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\ION Tek\UPX Shell\3.x', True);
    case KeyType of
      ktString:
      begin
        reg.WriteString(Name, Value.Str);
      end;
      ktInteger:
      begin
        reg.WriteInteger(Name, Value.Int);
      end;
      ktBoolean:
      begin
        reg.WriteBool(Name, Value.Bool);
      end;
    end;
  finally
    FreeAndNil(reg);
  end;
end;

{ This one loads a list of previously opened files and adds'em to History menu }
procedure LoadHistory;
var
  strings: TStrings;
  i: integer;
  MenuItem: TMenuItem; // To add to the History menu
begin
  strings := TStringList.Create;
  try
    strings.CommaText := ReadKey('History', ktString).Str;
    // Load the file history
    for i := strings.Count - 1 downto 0 do
    begin
      MenuItem := TMenuItem.Create(MainForm);
      MenuItem.Caption := strings.Strings[i];
      MenuItem.OnClick := MainForm.HistoryPopUp;
      MainForm.mnuHistory.Items.Add(MenuItem);
    end;
  finally
    FreeAndNil(Strings);
  end;
end;

// Adds an item to the History menu and stores it to registry
procedure WriteHistory(const FileName: string);
var
  strings: TStrings;
  Value:   TRegValue;

  { This nested procedure adds a new menu item to the History menu }
  procedure AddNewMenuItem;
  var
    MenuItem: TMenuItem; // To add to the History menu
  begin
    MenuItem := TMenuItem.Create(MainForm);
    MenuItem.Caption := FileName;
    MenuItem.OnClick := MainForm.HistoryPopUp;
    MainForm.mnuHistory.Items.Add(MenuItem);
  end;

begin
  strings := TStringList.Create;
  try
    strings.CommaText := ReadKey('History', ktString).Str;
    // Load the file history
    if strings.IndexOf(FileName) = -1 then // If item isn't already in the list
    begin
      strings.Add(FileName);
      Value.Str := strings.CommaText;
      StoreKey('History', Value, ktString);
      AddNewMenuItem;
    end;
  finally
    FreeAndNil(strings);
  end;
end;

procedure TMainForm.ParseCommandLine;
var
  i: integer;
begin
  for i := 1 to ParamCount() do
  begin
    if ParamStr(i) = '--debug' then
    begin
      Globals.Config.DebugMode := True;
    end;
  end;
end;

// This procedure handles the History Menu
procedure TMainForm.HistoryPopUp(Sender: TObject);
begin
  LoadFile((Sender as TMenuItem).Caption);
end;

//Calculates file size
procedure CalcFileSize;
begin
  FileSize := GetFileSize(GlobFileName);
  MainForm.lblFSize.Caption := ProcessSize(FileSize);
end;

{ Opens the specified file for the further compression..
  Contains a lot of nested procedures:}
procedure LoadFile(const FileName: string);
//This function unsets the ReadOnly attribute of the file
  function SetFileAttrib: boolean;
  var
    Attrib: cardinal;
  begin
    Result := True;
    Attrib := GetFileAttributes(PChar(FileName));
    if (Attrib and FILE_ATTRIBUTE_READONLY) > 0 then
    begin
      if Application.MessageBox(TranslateMsg(
        'The file attribute is set to ReadOnly. To proceed it must be unset. Continue?'),
        TranslateMsg('Confirmation'), MB_YESNO + MB_ICONQUESTION) = idYes then
      begin
        SetFileAttributes(PChar(FileName), Attrib - FILE_ATTRIBUTE_READONLY);
        Result := True;
      end
      else begin
        Result := False;
      end;
    end;
  end;
  //This one resets all visual controls to default state
  procedure ResetVisuals;
  begin
    MainForm.lblCSizeCap.Visible := False;
    MainForm.lblCSize.Visible    := False;
    MainForm.bvlRatio.Visible    := False;
    MainForm.lblRatioCap.Visible := False;
    MainForm.lblRatio.Visible    := False;
    MainForm.btnRun.Visible      := False;
    MainForm.pgcMain.ActivePageIndex := 1;
    MainForm.prbCompress.Progress := 0;
    MainForm.prbSize.Progress    := 0;
    MainForm.sttDecomp.Width     := 0;
  end;

  //Extracts file name out of a path
  procedure ExtractName;
  var
    temp: string;
  begin
    temp := SysUtils.ExtractFileName(FileName);
    MainForm.lblFName.Caption := temp;
    MainForm.stbMain.Panels[0].Text := temp;
  end;
  //Start main procedure
begin
  if (FileName <> '') and (FileExists(FileName)) and (SetFileAttrib) then
    //Unsets read-only attribute of a file
  begin
    GlobFileName := FileName; //Assign a global filename variable
    ResetVisuals(); //Resets visual controls
    if AlreadyPacked then
    begin
      //This one checks if the file is compressed and sets RadioButton
      MainForm.chkDecomp.Checked := True;
      sUPXVersion := GetUPXVersion(GlobFileName);
      MainForm.chkUPX1.Enabled := False;
      MainForm.chkUPX2.Enabled := False;
    end
    else begin
      MainForm.chkDecomp.Checked := False;
      sUPXVersion := '';
      MainForm.chkUPX1.Enabled := True;
      MainForm.chkUPX2.Enabled := True;
      if bStdUPXVersion = 2 then
      begin
        MainForm.chkUPX2.Checked := True;
      end
      else begin
        MainForm.chkUPX1.Checked := True;
      end;
    end;
    ExtractName();  //Extracts a file name and puts it on a label & statusbar
    CalcFileSize(); //Extracts file size and puts it on another label
    WriteHistory(FileName); //Add item to History menu
    if MainForm.chkAutoCompress.Checked then
    begin
      StartCompression();
    end;
  end;
end;

 //This procedure is responsible for changing of the
 //track bar label from digits to 'best' and vice versa:-)
procedure TrackBest;
begin
  if MainForm.trbCompressLvl.Position < 10 then
  begin
    MainForm.lblCompression.Caption :=
      IntToStr(MainForm.trbCompressLvl.Position);
  end
  else begin
    MainForm.lblCompression.Caption := TranslateMsg('Best');
  end;
end;

{ Loads visual settings, gets upx version... }
procedure LoadVisualSettings;
//This is used for getting the version of upx.exe
  function GetUPXOut: string;
  var
    f:     TFileStream;
    chain: array[1..$4] of char; //This will contain something like '1.20'
  begin
    if FileExists(workdir + 'upx.exe') then
    begin
      try
        f := TFileStream.Create(workdir + 'upx.exe', fmOpenRead);
        f.Position := 1;
        f.Seek($3DB, soFromBeginning);
        f.ReadBuffer(chain, $4);
        Result := chain;
      finally
        FreeAndNil(f);
      end;
    end
    else begin
      Result := IntToStr( -1);
    end;
  end;

var
  UPXOutStr: string;
begin
  //Checks if there is newer upx installed and sets it
  with MainForm do
  begin
    UPXOutStr := GetUPXOut;
    if (UPXOutStr <> lblIns.Caption) and (UPXOutStr <> IntToStr( -1)) then
    begin
      DecimalSeparator := '.';
      if strtofloat(UPXOutStr) < strtofloat(lblIns.Caption) then
      begin
        lblIns.Font.Color := clRed;
      end
      else begin
        lblIns.Font.Color := clNavy;
      end;
      lblIns.Caption := UPXOutStr;
    end;
    //Checks UPX Shell release and buil numbers
    lblRelease.Caption := GetBuild(biNoBuild);
    lblBuild.Caption   := GetBuild(biBuild);
    lblOut.Caption     := GetBuild(biCute);
  end;
end;
// Scans workdir for .lng files and adds them to cmbLanguage
procedure EnumerateLanguages;
//Kill the final .lng extension to show in the cmbLanguage
  function KillExt(const FullPath: string): string;
  begin
    Result := ExtractFileName(FullPath);
    Result := copy(Result, 1, pos('.', Result) - 1);
  end;

var
  SRec:  TSearchRec;
  LangF: string;
begin
  SetCurrentDir(WorkDir);
  if FindFirst('*.lng', faAnyFile, SRec) = 0 then
  begin
    MainForm.cmbLanguage.Items.Add(KillExt(SRec.Name));
    while FindNext(SRec) = 0 do
    begin
      MainForm.cmbLanguage.Items.Add(KillExt(SRec.Name));
    end;
  end;
  FindClose(SRec);
  with MainForm.cmbLanguage do
  begin
    LangF := ReadKey('LanguageFile', ktString).Str;
    if LangF = '' then
    begin
      ItemIndex := Items.IndexOf('English');
      LangFile  := 'English';
    end
    else begin
      ItemIndex := Items.IndexOf(LangF);
      LangFile  := LangF;
    end;
  end;
end;

procedure StartScramble;
begin
  ScrambleUPX();
end;

procedure StartCompression; //initializes compression
var
  StartTime: int64;
  CompressParams: string;
  Compress:  TCompDecomp; //Holds whether to compress or decompress
  OldCursor: TCursor;
  // This one gets the compression time
  procedure StartTimer;
  begin
    QueryPerformanceCounter(StartTime);
  end;

  function StopTimer: string;
  var
    Frequency, StopTime: int64;
    Time: string[5];
  begin
    QueryPerformanceFrequency(Frequency);
    QueryPerformanceCounter(StopTime);
    Time   := floattostr((StopTime - StartTime) / Frequency);
    Result := Time;
  end;

  procedure SetCompressionVisuals(ControlEnabled: boolean);
  begin
    with MainForm do
    begin
      btnOpen.Enabled    := ControlEnabled;
      btnGo.Enabled      := ControlEnabled;
      imgHistory.Enabled := ControlEnabled;
      chkDecomp.Enabled := ControlEnabled;
      if ControlEnabled then
      begin
        if Compress <> cdCompress then
        begin
          chkUPX1.Enabled := ControlEnabled;
          chkUPX2.Enabled := ControlEnabled;
        end;
      end
      else begin
        chkUPX1.Enabled := ControlEnabled;
        chkUPX2.Enabled := ControlEnabled;
      end;
      btnRun.Enabled      := ControlEnabled;
      chkBackup.Enabled   := ControlEnabled;
      chkAutoCompress.Enabled := ControlEnabled;
      chkExitDone.Enabled := ControlEnabled;
      chkTest.Enabled     := ControlEnabled;
      btnAdvanced.Enabled := ControlEnabled;
      btnMultiPck.Enabled := ControlEnabled;
      trbCompressLvl.Enabled := ControlEnabled;
      if not ControlEnabled then
      begin
        sttDecomp.Width := 0;
      end;
    end;
  end;

  procedure TouchFile(const FileName: string);
  begin
    SHChangeNotify(SHCNE_UPDATEITEM, SHCNF_PATH, PChar(FileName), nil);
    SHChangeNotify(SHCNE_ATTRIBUTES, SHCNF_PATH, PChar(ExtractFileDir(FileName)), nil); //SHCNE_UPDATEDIR - SHCNE_ATTRIBUTES
  end;

  //Main code
begin
  Busy      := True;
  OldCursor := Screen.Cursor;
  try
    StartTimer;
    DragAcceptFiles(MainForm.Handle, False);
    //Disable Drag&Drop while compressing
    CompressParams := GetCompressParams;
    SetCompressionVisuals(False);
    if not MainForm.chkDecomp.Checked then
    begin
      Compress := cdCompress;
    end
    else begin
      Compress := cdDecompress;
    end;
    //Start the compression now
    CompressFile(CompressParams, Compress);
    SetCompressionVisuals(True);
    MainForm.stbMain.Panels[1].Text := MainForm.stbMain.Panels[1].Text +
      TranslateMsg(' (in ') + StopTimer + TranslateMsg(' seconds)');
    if (Compress = cdCompress) and (SetupForm.chkScramble.Checked) then
    begin
      try
        Screen.Cursor := crHourGlass;
        StartScramble;
      finally
        Screen.Cursor := OldCursor;
      end;
    end;
    TouchFile(GlobFileName);
    if (MainForm.chkExitDone.Checked) and (CompressionResult) then
    begin
      Application.Terminate;
    end;
  finally
    Busy := False;
    DragAcceptFiles(MainForm.Handle, True); // Re-enable Drag&Drop
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DrawGradient(imgGradient.Canvas, 255, imgGradient.Height,
    imgGradient.Width, clSilver, GetSysColor(COLOR_BTNFACE));
  DragAcceptFiles(MainForm.Handle, True); // Enable Drag&Drop
  with Globals.Config do
  begin
    DebugMode := False;
    LocalizerMode := False;
  end;
  LoadSettings;
  LoadHistory;
  ParseCommandLine;
  Application.HintHidePause := 10000;
  Application.HelpFile      := WorkDir + 'UPXShell.chm';
  EnumerateLanguages;
  // Scans for available language files and adds to cmbLanguage
  DrawGradient(imgLogoGrad1.Canvas, 50, imgLogoGrad1.Height,
    imgLogoGrad1.Width,
    clBtnFace, clSilver);
  DrawGradient(imgLogoGrad2.Canvas, 50, imgLogoGrad2.Height,
    imgLogoGrad2.Width,
    clSilver, clBtnFace);
end;
// Clears the History menu
procedure TMainForm.ClearHistoryClick(Sender: TObject);
var
  Value: TRegValue;
  i:     integer;
begin
  Value.Str := '';
  StoreKey('History', Value, ktString);
  for i := mnuHistory.Items.Count - 1 downto 2 do
  begin
    mnuHistory.Items.Delete(i);
  end;
end;

procedure TMainForm.imgHistoryMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  mnuHistory.Popup(MainForm.Left + 90, MainForm.Top + 200);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
end;

procedure TMainForm.btnOpenClick(Sender: TObject);
var
  val: TRegValue;
begin
  dlgOpen.FilterIndex := Extension;
  with ReadKey('LastFolder', ktString) do
  begin
    if Str <> '' then
    begin
      dlgOpen.InitialDir := Str;
    end;
  end;
  if dlgOpen.Execute then
  begin
    Extension := dlgOpen.FilterIndex;
    val.Str   := ExtractFileDir(dlgOpen.FileName);
    StoreKey('LastFolder', val, ktString);
    if dlgOpen.FileName <> '' then
    begin
      LoadFile(dlgOpen.filename);
    end;
  end;
end;

procedure TMainForm.btnGoClick(Sender: TObject);
var
  CompDecomp: string;
begin
  if GlobFileName = '' then
  begin
    if chkDecomp.Checked then
    begin
      CompDecomp := TranslateMsg('decompress');
    end
    else begin
      CompDecomp := TranslateMsg('compress');
    end;
    beep;
    Application.MessageBox(PChar(TranslateMsg('There is nothing to ') +
      CompDecomp),
      TranslateMsg('Error'), MB_OK + MB_ICONERROR);
  end
  else begin
    StartCompression;
  end;
end;
//Drag&Drop handler
procedure TMainForm.WMDropfiles(var msg: Tmessage);
var
  hdrop:     integer; //THandle
  buffer:    string;
  buflength: integer;
begin
  hdrop     := msg.WParam;
  buflength := DragQueryFile(hdrop, 0, nil, 300) + 1;
  setlength(buffer, buflength);
  DragQueryFile(hdrop, 0, PChar(buffer), buflength);
  DragFinish(hdrop);
  LoadFile(trim(buffer));
end;

procedure TMainForm.tbsOpenShow(Sender: TObject);
begin
  if btnOpen.Enabled then
  begin
    btnOpen.SetFocus;
  end;
end;

procedure TMainForm.tbsCompressShow(Sender: TObject);
begin
  if btnGo.Enabled then
  begin
    btnGo.SetFocus;
  end;
end;

procedure TMainForm.tbsOptionsShow(Sender: TObject);
begin
  if chkBackup.Enabled then
  begin
    chkBackup.SetFocus;
  end;
end;

procedure TMainForm.tbsAboutShow(Sender: TObject);
begin
  if pnlAbout.Enabled then
  begin
    pnlAbout.SetFocus;
  end;
end;

procedure TMainForm.tbsHelpShow(Sender: TObject);
begin
  if btnHelp.Enabled then
  begin
    btnHelp.SetFocus;
  end;
end;

procedure TMainForm.trbCompressLvlChange(Sender: TObject);
begin
  TrackBest;
end;

procedure TMainForm.btnAdvancedClick(Sender: TObject);
begin
  SetupForm.ShowModal;
end;

procedure TMainForm.cmbLanguageChange(Sender: TObject);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\ION Tek\UPX Shell\3.x', True);
    reg.WriteString('OldContext', Trim(TranslateMsg('Compress with UPX')));
    reg.CloseKey;
  finally
    FreeAndNil(reg);
  end;
  LangFile := cmbLanguage.Text;
  LoadLanguage(MainForm);
  TrackBest;
  IntergrateContext(True);  
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  LoadLanguage(MainForm);
  TrackBest; //Checks the position of CompressionLevel TrackBar
  LoadVisualSettings;
end;

procedure TMainForm.stbMainMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: integer);
begin
  if (stbMain.Panels[0].Text <> '') and (stbMain.Panels[1].Text = '') then
  begin
    stbMain.Hint := stbMain.Panels[0].Text;
  end
  else begin
    if (stbMain.Panels[0].Text <> '') and (stbMain.Panels[1].Text <> '') then
    begin
      stbMain.Hint := stbMain.Panels[0].Text + #13#10 + stbMain.Panels[1].Text;
    end;
  end;
end;

procedure TMainForm.btnHelpClick(Sender: TObject);
begin
  ShellExecute(self.Handle, 'open', PChar(Application.HelpFile), nil,
    nil, SW_SHOWNORMAL);
end;

procedure TMainForm.btnMultiPckClick(Sender: TObject);
begin
  MultiForm := TMultiForm.Create(self);
  try
    // 1: Fix by KIRILL on 12.03.2003
    MainForm.Hide;
    MultiForm.ShowModal;
    MainForm.Show;
  finally
    MultiForm.Release
  end;
end;

procedure TMainForm.StdUPXVersionClick(Sender: TObject);
begin
  case (Sender as TRadioButton).Tag of
    1:
    begin
      bStdUPXVersion := 1;
    end;
    2:
    begin
      bStdUPXVersion := 2;
    end;
  end;
end;

procedure TMainForm.btnRunClick(Sender: TObject);
begin
  ShellExecute(self.Handle, 'open', PChar(GlobFileName), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TMainForm.HyperClick(Sender: TObject);
var
  s: string;
begin
  // 1: Fix by KIRILL on 12.03.2003
  case (Sender as TLabel).Tag of
    1:
    begin
      S := 'http://upxshell.sf.net';
    end;
    2:
    begin
      S := 'http://upx.sf.net';
    end;
    3:
    begin
      S := 'mailto:ION_T<efsoft@ukrpost.net>?Subject=UPX_Shell_' +
        GetBuild(biFull);
    end;
    4:
    begin
      S := 'mailto:BlackDex<black.dex.prg@lycos.nl>?Subject=UPX_Shell_' +
        GetBuild(biFull);
    end;
    5:
    begin
      S := 'mailto:Blaine<bsoutham@myrealbox.com>?Subject=UPX_Shell_' +
        GetBuild(biFull);
    end;
  end;
  ShellExecute(0, 'open', PChar(s), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  // I have no other choice, but to put this code in the
  // onShow event, since I must make sure that the form is
  // drawn...
  if lowercase(ParamStr(1)) <> '' then
  begin
    //Checks if there's a file passed through command line
    LoadFile(ParamStr(1));
  end;
  OnShow := nil;
end;

procedure TMainForm.UPXVersionClick(Sender: TObject);
begin
  case (Sender as TRadioButton).Tag of
    1:
    begin
      bStdUPXVersion := 1;
    end;
    2:
    begin
      bStdUPXVersion := 2;
    end;
  end;
end;

procedure TMainForm.btnChkUpdateClick(Sender: TObject);

  //Inline function to get the update file
  function GetInetFile(const fileURL: string; strStream: TStringStream): boolean;
  const
    BufferSize = 1024;
  var
    hSession: HInternet;
    hURL: HInternet;
    Buffer: array[1..BufferSize] of Byte;
    BufferLen: DWORD;
    sAppName: string;
  begin
    sAppName := ExtractFileName(Application.ExeName);
    hSession := InternetOpen(PChar(sAppName), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    try
      hURL := InternetOpenURL(hSession, PChar(fileURL), nil,0,0,0);
      try
        repeat
        begin
          InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
          strStream.WriteBuffer(Buffer, BufferLen);
        end;
        until BufferLen = 0;
        Result := true;
      finally
        InternetCloseHandle(hURL)
      end;
    finally
      InternetCloseHandle(hSession)
    end;
  end;

//Main procedure
var
  sUpdateFile: string;
  sInetStream: TStringStream;
  sInetStrings: TStrings;
  OldCursor: TCursor;
begin
 sUpdateFile:= 'http://upxshell.sf.net/update/update.upd';

 sInetStream := TStringStream.Create('');
 sInetStrings := TStringList.Create;
 rchChangeLog.Lines.Clear;
 OldCursor := screen.Cursor;
 try
   Screen.Cursor := crHourGlass;
   if GetInetFile(sUpdateFile, sInetStream) then
   begin
     sInetStrings.Clear;
     sInetStrings.Delimiter := '=';
     sInetStrings.QuoteChar := '"';
     sInetStrings.DelimitedText := sInetStream.DataString;

     if (sInetStrings[sInetStrings.IndexOf('UPDATEFILE') + 1] = 'UPXSHELL') then
     begin
       lblOnlineVersion.Caption := sInetStrings[sInetStrings.IndexOf('release') + 1] + '.' + sInetStrings[sInetStrings.IndexOf('build') + 1];
       lblReleaseDate.Caption := sInetStrings[sInetStrings.IndexOf('date') + 1];

       if (sInetStrings[sInetStrings.IndexOf('build') + 1] > GetBuild(biBuild)) or
          (sInetStrings[sInetStrings.IndexOf('release') + 1] > GetBuild(biNoBuild)) then
          begin
            lblDownload.Caption := sInetStrings[sInetStrings.IndexOf('url') + 1];
            lblDownload.Font.Color := clBlue;
            lblDownload.Enabled := true;
            rchChangeLog.Lines.Add(sInetStrings[sInetStrings.IndexOf('changelog') + 1]);
          end
          else
          begin
            rchChangeLog.Lines.Add('There is no new update avalable.');
            lblDownload.Font.Color := clWindowText;
            lblDownload.Enabled := false;
          end;
     end
     else
       rchChangeLog.Lines.Add('Error retereving updates!' + #13#10 + 'Invalide or missing update file.');
     begin
     end;
   end
   else
   begin
     rchChangeLog.Lines.Add('Error retereving updates!');
   end;
 finally
  Screen.Cursor := OldCursor;
  FreeAndNil(sInetStream);
  FreeAndNil(sInetStrings);
  FreeAndNil(OldCursor);
 end;
end;

procedure TMainForm.lblDownloadClick(Sender: TObject);
begin
  if lblDownload.Enabled then
  begin
    ShellExecute(0, 'open', PChar(lblDownload.Caption), Nil, Nil, SW_SHOW);
  end;
end;

(*
procedure TMainForm.btnLocalizerModeClick(Sender: TObject);
begin
  // Toggle localization mode
  // In this mode every object capable of MouseUp event
  // detection get's a popup menu, which allows one to set
  // the object's caption and hint
  Globals.Config.LocalizerMode := not Globals.Config.LocalizerMode;
  pnlLocalization.Visible := Globals.Config.LocalizerMode;
  LocalizerMode(self, Globals.Config.LocalizerMode);
end;
*)

end.

