unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ToolWin, ExtCtrls, IniFiles;

type
  TForm2 = class(TForm)
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    Memo2: TMemo;
    Panel2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Panel3: TPanel;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    AppPath: string;
    ConfigINI: TINIFile;
  public
    procedure SaveLogFile(sLogText: string);
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  I: Integer;
  scrdir,destdir,sFile,strPath: string;
begin
  Button1.Enabled := False;
  try
    Memo1.Text := '';
    scrdir := Trim(Edit2.Text);
    destdir := Trim(Edit1.Text);
    ProgressBar1.Max := Memo2.Lines.Count;
    if (scrdir = '') or (destdir = '') or (Memo2.Lines.Count=0) then
    begin
      Memo1.Lines.Add('请检查源路径目标路径和源文件列表是否正确');
      Exit;
    end;
    for I := 0 to Memo2.Lines.Count - 1 do
    begin
      sFile := Trim(Memo2.Lines.Strings[I]);
      sFile := StringReplace(sFile,'/','\',[rfReplaceAll]);
      if sFile = '' then Continue;
      strPath := ExtractFilePath(destdir+sFile);
      if not DirectoryExists(strPath) then
      begin
        ForceDirectories(strPath);
      end;
      if not FileExists(scrdir+sFile) then
      begin
        Memo1.Lines.Add('源文件不存在：'+sFile);
      end
      else begin
        if not CopyFile(PChar(scrdir+sFile),PChar(destdir+sFile),False) then
        begin
          Memo1.Lines.Add('复制文件错误：'+sFile);
        end;
      end;
      ProgressBar1.Position := I+1;
      Application.ProcessMessages;
    end;
    if Memo2.Lines.Count > 0 then
    begin
      SaveLogFile(Memo2.Lines.Text);
    end;
  finally
    Button1.Enabled := True;
    Memo1.Lines.Add('-------------处理完成-------------');
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  Section,Ident: string;
begin
  AppPath := ExtractFilePath(Application.ExeName);
  ConfigINI := TINIFile.Create(AppPath+'config.ini');
  Section := '系统设置';
  Ident := '原路径';
  if not ConfigINI.ValueExists(Section,Ident) then
  begin
    ConfigINI.WriteString(Section,Ident,'');
  end;
  Edit2.Text := ConfigINI.ReadString(Section,Ident,'');
  Ident := '目标路径';
  if not ConfigINI.ValueExists(Section,Ident) then
  begin
    ConfigINI.WriteString(Section,Ident,'');
  end;
  Edit1.Text := ConfigINI.ReadString(Section,Ident,'');
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  ConfigINI.Free;
end;

procedure TForm2.SaveLogFile(sLogText: string);
var
  sFile: string;
  strList: TStringList;
begin
  strList := TStringList.Create;
  try
    if not DirectoryExists(AppPath+'log\') then
    begin
      ForceDirectories(AppPath+'log\');
    end;
    sFile := AppPath+'log\'+FormatDateTime('YYYYMMDD',Now)+'.txt';
    if FileExists(sFile) then
    begin
      strList.LoadFromFile(sFile);
    end;
    strList.Add('-----------开始：'+DateTimeToStr(Now));
    strList.Add(sLogText);
    strList.Add('-----------结束-----------');
    strList.SaveToFile(sFile);
  finally
    strList.Free;
  end;
end;

end.
