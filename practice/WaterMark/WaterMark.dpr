program WaterMark;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  GdipExport in '..\..\MyCommen\GdiPlus\gdiplus20071007\pas\GdipExport.pas',
  Gdiplus in '..\..\MyCommen\GdiPlus\gdiplus20071007\pas\Gdiplus.pas',
  GdipTypes in '..\..\MyCommen\GdiPlus\gdiplus20071007\pas\GdipTypes.pas',
  GdipUtil in '..\..\MyCommen\GdiPlus\gdiplus20071007\pas\GdipUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
