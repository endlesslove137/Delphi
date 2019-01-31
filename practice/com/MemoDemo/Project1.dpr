program Project1;

uses
  ExceptionLog,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Project1_TLB in 'Project1_TLB.pas',
  Unit2 in 'Unit2.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
