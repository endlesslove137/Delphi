program PWorkHelp_XE5;

uses
  Forms,
  windows,
  UWorkHelp in 'UWorkHelp.pas' {Form1},
  UOrderMysql in '..\..\MyCommen\UOrderMysql.pas',
  UOrderNetFile in '..\..\MyCommen\UOrderNetFile.pas',
  UOrderTimer in '..\..\MyCommen\UOrderTimer.pas',
  Vcl.Themes,
  Vcl.Styles;
//  UnitNORepeat in 'UnitNORepeat.pas'

{$R *.res}
{$SetPEFlags $20}

var
 MyMutex:thandle;

const
 StrMyMutex = 'WorkHelp_count1';


begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := DebugHook<>0;
  Application.Title := '¸öÈË¸¨Öú-application-appearance-title';
  TStyleManager.TrySetStyle('Metropolis UI Blue');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
