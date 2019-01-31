program Project1;

uses
  Forms,
  Unit1 in '..\..\..\..\..\..\..\..\Desktop\test\Unit1.pas' {Form1},
  GdiPlus in 'GdiPlus.pas',
  GdiPlusHelpers in 'GdiPlusHelpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
