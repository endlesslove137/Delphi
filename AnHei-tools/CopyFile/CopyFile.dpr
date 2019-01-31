program CopyFile;

uses
  Forms,
  fMain in 'fMain.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '批量文件复制';
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
