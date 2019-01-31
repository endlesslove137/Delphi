program TestSqlite;

uses
  Forms,
  uTestSqlite in 'uTestSqlite.pas' {Form1},
  SQLiteTable3 in 'SQLiteTable3.pas',
  SQLite3 in 'SQLite3.pas',
  TestThreadUnit in 'TestThreadUnit.pas';

{$R *.res}

begin
  {$IF RTLVersion >= 18}
   ReportMemoryLeaksOnShutdown := true;
  {$IFEND}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
