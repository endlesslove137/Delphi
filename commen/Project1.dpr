program Project1;

uses
  ExceptionLog,
  Forms,
  Unit1 in '..\test\Unit1.pas' {Form1},
  sevenzip in 'sevenzip.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
