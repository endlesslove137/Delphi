program TaskEditor;





{%TogetherDiagram 'ModelSupport_TaskEditor\default.txaPackage'}

uses
  ExceptionLog,
  Forms,
  UnitMain in 'UnitMain.pas' {frmMain},
  MXML in '..\Additions\MXML.pas',
  UnitRoleEdit in 'UnitRoleEdit.pas' {frmRoleEdit},
  UnitViewRole in 'UnitViewRole.pas' {frmViewRoleInfo},
  UnitRoleRelation in 'UnitRoleRelation.pas' {frmRoleRelation},
  UnitGenRoleAdt in 'UnitGenRoleAdt.pas',
  AdtTypes in '..\common\AdtTypes.pas',
  UnitMonItemReader in 'UnitMonItemReader.pas',
  UnitSelLocation in 'UnitSelLocation.pas' {frmSelLocation},
  XML2Cbp in '..\common\XML2Cbp.pas',
  UnitLangPackage in '..\common\UnitLangPackage.pas',
  UnitLPConnect in '..\common\UnitLPConnect.pas' {frmLPConnect},
  uDocStateCheck in '..\common\uDocStateCheck.pas',
  UnitSettings in 'UnitSettings.pas' {FrmSettings},
  UnitSelectLanguages in '..\common\UnitSelectLanguages.pas' {frmSelectLanguages},
  UBatchUpdatePrice in '..\Additions\UBatchUpdatePrice.pas',
  UnitRoleItemAndAward in 'UnitRoleItemAndAward.pas' {frmRoleItemAndAward};

{$R *.res}

begin
  Application.Initialize;
//  TStyleManager.TrySetStyle('Metropolis UI Blue');
//  TStyleManager.TrySetStyle('Amakrits');
  Application.Title := 'TaskEditor';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmViewRoleInfo, frmViewRoleInfo);
  Application.CreateForm(TfrmSelLocation, frmSelLocation);
  Application.CreateForm(TFrmBatchUpdatePrice, FrmBatchUpdatePrice);
  Application.Run;
end.
