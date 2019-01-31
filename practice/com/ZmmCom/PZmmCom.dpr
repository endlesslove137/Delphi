program PZmmCom;

uses
  ExceptionLog,
  Forms,
  UnitZmmCom in 'UnitZmmCom.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
