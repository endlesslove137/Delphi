program GetConsoleOutput;

uses
  Forms,
  uGetConsoleOutput in 'uGetConsoleOutput.pas' {frmGetConsoleOutput};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGetConsoleOutput, frmGetConsoleOutput);
  Application.Run;
end.
