program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {FrmMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMainForm, FrmMainForm);
  Application.Run;
end.
