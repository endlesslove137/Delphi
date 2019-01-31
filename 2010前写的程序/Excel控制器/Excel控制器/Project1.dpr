program Project1;

uses
  Forms,
  xpman,
  Unit1 in 'Unit1.pas' {Form1},
  UOrderExcel in '..\Mycommon\UOrderExcel.pas',
  Upublic in '..\Mycommon\Upublic.pas';

{$R *.res}

begin
  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
