program ConsoleTestPrj;

uses
  Forms,
  ConsoleTest in 'ConsoleTest.pas' {Form1},
  uConsoleClass in 'uConsoleClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
