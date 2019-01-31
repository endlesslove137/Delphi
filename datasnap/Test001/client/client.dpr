program client;

uses
  Vcl.Forms,
  ClientMain in 'ClientMain.pas' {Form2},
  ServerProxy in 'ServerProxy.pas',
  ClientModuleUnit1 in 'ClientModuleUnit1.pas' {ClientModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TClientModule1, ClientModule1);
  Application.Run;
end.
