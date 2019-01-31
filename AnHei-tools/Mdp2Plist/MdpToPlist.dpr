program MdpToPlist;

uses
  ExceptionLog,
  Forms,
  UnitMdpToPlist in 'UnitMdpToPlist.pas' {frmMdpToPlist},
  UnitStdXmlForm in '..\common\UnitStdXmlForm.pas',
  UnitThreadTexture in 'UnitThreadTexture.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMdpToPlist, FrmMdpToPlist);
  Application.Run;
end.
