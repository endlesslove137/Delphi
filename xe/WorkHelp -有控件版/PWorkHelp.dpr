program PWorkHelp;

uses
  Forms,
  windows,
  UWorkHelp in 'UWorkHelp.pas' {Form1},
  UOrderMysql in '..\..\MyCommen\UOrderMysql.pas',
  UOrderNetFile in '..\..\MyCommen\UOrderNetFile.pas',
  UOrderTimer in '..\..\MyCommen\UOrderTimer.pas';

{$R *.res}
{$SetPEFlags $20}

var
 MyMutex:thandle;

const
 StrMyMutex = 'WorkHelp_count1';


begin
  if openmutex(Mutex_all_access, false, StrMyMutex) <>0 then
  begin
    MessageBox(0, '该程序已启动', '提示', MB_OK);
    Application.Terminate;
  end;
  MyMutex := CreateMutex(nil, False, StrMyMutex);
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
  CloseHandle(MyMutex);
  {主线程出口}

end.
