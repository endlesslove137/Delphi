program PFtpClient;

uses
  Forms,
  FtpClient in 'FtpClient.pas' {FtpClientForm},
  UnitStdXmlForm in 'UnitStdXmlForm.pas',
  UFtpClient in '..\MyCommen\UFtpClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ÏÉº£ Ftp¿Í»§¶Ë';
  Application.CreateForm(TFtpClientForm, FtpClientForm);
  Application.Run;
end.
