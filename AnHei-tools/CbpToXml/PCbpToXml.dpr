program PCbpToXml;

uses
  Forms,
  UMain in 'UMain.pas' {Form1},
  ComCBPRead_TLB in '..\common\ComCBPRead_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
