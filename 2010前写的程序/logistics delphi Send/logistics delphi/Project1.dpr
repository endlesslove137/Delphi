program project1;

uses
  Forms,
  SysUtils,
  Dialogs,
  Messages,
  shellapi,
  Windows,
  Unit1 in 'Unit1.pas' {Fmain},
  Upublic in 'Upublic.pas',
  Udispatch in 'Udispatch.pas' {Fdispatch},
  Udata in 'Udata.pas' {fdata: TDataModule},
  Uinformation in 'Uinformation.pas' {finformation},
  Uanalyse in 'Uanalyse.pas' {Fanalyse},
  Udatamanager in 'Udatamanager.pas' {Fdatamanager},
  Ubackup in 'Ubackup.pas' {Fbackup},
  Urstore in 'Urstore.pas' {Frestore},
  Uremind in 'Uremind.pas' {Fremind},
  Umoney in 'Umoney.pas' {Fmoney},
  Udatepicker in 'Udatepicker.pas' {Fdatepicker},
  Udetail in 'Udetail.pas' {fdetail},
  Ulogin in 'Ulogin.pas' {Flogin},
  Urightcontrol in 'Urightcontrol.pas' {Frightcontrol},
  Ustorage in 'Ustorage.pas' {Fstorage},
  Uorder in 'Uorder.pas' {Forder},
  Ucheck in '张明明\Ucheck.pas' {Fcheck};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '物流管理系统';

  try
   Application.CreateForm(Tfdata, fdata);
  fdata.conn1.Connected:=false;
   fdata.conn1.ConnectionString:='';
   fdata.conn1.ConnectionString:='FILE NAME='+extractfilepath(paramstr(0))+'\coon1.udl';
   fdata.conn1.Provider:=extractfilepath(paramstr(0))+'\coon1.udl';
   fdata.conn1.LoginPrompt:=false;
   fdata.conn1.Connected:=true;
   Application.CreateForm(TFmain, Fmain);
   Application.CreateForm(TFlogin, Flogin);
   FLOGIN.ShowModal;
   Application.CreateForm(Tfdetail, fdetail);
   FLOGIN.Free;
 except
   on exception do
   begin
    if application.MessageBox('请重新配置?','连接错误',MB_iconquestion+MB_YESNO)=idyes then
    begin
    shellexecute(0,'open',pchar(extractfilepath(paramstr(0))+'coon1.udl'),nil,nil,0);
    application.Terminate;
    end else
    application.terminate;
   end;
  end;
     Application.Run;


end.
