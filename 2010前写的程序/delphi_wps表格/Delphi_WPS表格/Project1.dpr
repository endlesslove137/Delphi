program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmMain},
  UnitHS in 'UnitHS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
