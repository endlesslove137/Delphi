program LangEdit;

uses
  Forms,
  FMain in 'FMain.pas' {Form1},
  IWLang in 'IWLang.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
