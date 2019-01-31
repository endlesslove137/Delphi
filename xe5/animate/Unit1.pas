unit Unit1;

interface

uses
  Winapi.Windows, Vcl.Imaging.GIFImg, System.SysUtils, Vcl.Dialogs,
  CommCtrl, Vcl.Forms, System.Win.Registry, IniFiles, shellapi,
  Vcl.Menus, Vcl.Controls, Vcl.ExtCtrls, UorderDesktop, System.Classes;

const
  sConfFile = 'Config.ini';
  sConfMain = 'Setup';
  sConfName = 'Name';
  sConfAuto = 'AutoBoot';
  exeFM = '%s.exe';

type

  TForm1 = class(TForm)
    Image1: TImage;
    pm1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    tmr1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
  private
    MainExe, exeName: string;
    Bauto, Bok: boolean;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



// use System.Win.Registry, windows;
// µ÷ÓÃ SetAutorun(Application.Title,application.ExeName,false);
procedure SetAutorun(aProgTitle, aCmdLine: string; aRunOnce: boolean);
var
  hKey: string;
  hReg: TRegIniFile;
begin
  if aRunOnce then  hKey := 'Once' else hKey := '';
  hReg := TRegIniFile.Create('');
  try
    hReg.RootKey := HKEY_CURRENT_USER;
    if hReg.OpenKey('SOFTWARE\MICROSOFT\Windows\CurrentVersion\run' + hKey + #0, True) then
      if not hReg.ValueExists(aProgTitle) then
        hReg.WriteString('', aProgTitle,aCmdLine);
  finally
    hReg.destroy;
  end;
end;



// uses IniFiles
procedure ReadConfig();
var
  iniF: tinifile;
begin
    iniF := tinifile.Create(ExtractFilePath(ParamStr(0)) + sConfFile);
  try
    Form1.exeName := iniF.ReadString(sConfMain, sConfName, '');
    Form1.MainExe := ExtractFilePath(ParamStr(0)) + Form1.exeName;
    Form1.MainExe := Format(exeFM, [Form1.MainExe]);
    Form1.Bauto := iniF.ReadBool(sConfMain, sConfAuto, True);
    if Form1.Bauto then
      SetAutorun(Form1.exeName, application.exeName, False);
  finally
    iniF.Destroy;
  end;
end;






procedure TForm1.FormCreate(Sender: TObject);
begin
  ReadConfig;
end;

procedure SetAnimate();
var
  prRect, pARect: TRECT;
  iSpace: Integer;
begin
    try
      Form1.Bok := GetIconRect(Form1.exeName, prRect, pARect);
      Form1.Top := prRect.Top;
      iSpace := pARect.Width - prRect.Height;
      if Odd(iSpace) then   iSpace := iSpace + 1;
      iSpace := iSpace div 2;

      Form1.Left := pARect.Left + iSpace;
      Form1.Image1.Stretch := True;
      Form1.Image1.SetBounds(0, 0, prRect.Height, prRect.Height);
      Form1.Height := prRect.Height;
      Form1.Width := prRect.Height;
      form1.show;
      BringWindowToTop(Form1.Handle);
    except
      Application.Terminate;
    end;
end ;




procedure TForm1.FormShow(Sender: TObject);
begin
  SetAnimate;
  tmr1.Enabled := True;
  ShowWindow(Application.Handle, SW_HIDE);
  SetWindowLong(Application.Handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
  TGIFImage(Image1.Picture.Graphic).Animate := True;
  TGIFImage(Image1.Picture.Graphic).AnimateLoop := glContinously;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  if Trim(MainExe) <> '' then
    ShellExecute(Handle, 'open', PWideChar(MainExe), '', nil, SW_SHOWNORMAL);
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
 SetAnimate;
end;

initialization

end.
