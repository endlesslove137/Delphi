program Project2;

uses
  ExceptionLog,
  Forms,
  Unit2 in 'Unit2.pas' {Form2},
  SQLite3 in 'SQLite3.pas',
  sqlite3udf in 'sqlite3udf.pas',
  SQLiteTable3 in 'SQLiteTable3.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
