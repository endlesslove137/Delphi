program Project2;

uses
  Forms,
  Unit2 in 'Unit2.pas' {Form2},
  luascript in 'luascript.pas',
  UnitLangPackage in 'UnitLangPackage.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
