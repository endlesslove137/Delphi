program Timer_sql;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UnitStdXmlForm in 'UnitStdXmlForm.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Metropolis UI Dark');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
