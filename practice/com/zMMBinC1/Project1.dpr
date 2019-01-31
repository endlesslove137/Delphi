program Project1;

uses
  ExceptionLog,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  BinIntf in '..\zMMBin1Serv\BinIntf.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
