program WellInfo;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  UOrderString in '..\Mycommon\UOrderString.pas',
  UOrderSystem in '..\Mycommon\UOrderSystem.pas',
  Upublic in '..\Mycommon\Upublic.pas',
  UorderAccess in '..\Mycommon\UorderAccess.pas',
  UOrderExcel in '..\Mycommon\UOrderExcel.pas',
  UOrderFile in '..\Mycommon\UOrderFile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '»’±®';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
