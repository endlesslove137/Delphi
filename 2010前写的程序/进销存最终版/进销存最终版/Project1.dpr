program Project1;

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  jpeg,
  ExtCtrls,
  StdCtrls,
  Buttons,
  DB,
  ADODB,
  shellapi,
  adoconed,
  Unit1 in 'Unit1.pas' {fmain},
  Udata2 in 'Udata2.pas' {Data2: TDataModule},
  Unit2 in 'Unit2.pas' {Fxitongshezhi},
  Unit3 in 'Unit3.pas' {Fmingxi},
  Unit4 in 'Unit4.pas' {Fyishoumingxi},
  Unit5 in 'Unit5.pas' {Fmenu3},
  Unit6 in 'Unit6.pas' {Frpys},
  Unit7 in 'Unit7.pas' {Fqryf},
  Unit8 in 'Unit8.pas' {Form8},
  Unit9 in 'Unit9.pas' {Fjhtjreport},
  Ulogin in 'Ulogin.pas' {flogin},
  jinhodengji in 'jinhodengji.pas' {Fzhangbodengji},
  Unit11 in 'Unit11.pas' {Fstore},
  Unit12 in 'Unit12.pas' {Fselectdate},
  Unit13 in 'Unit13.pas' {Fsingledbgrid},
  Unit14 in 'Unit14.pas' {Fproduct},
  Unit15 in 'Unit15.pas' {Fprofit},
  Unit16 in 'Unit16.pas' {Fprofit2},
  Unit17 in 'Unit17.pas' {Form17},
  Unit18 in 'Unit18.pas' {Form18},
  Unit19 in 'Unit19.pas' {Form19},
  Unit20 in 'Unit20.pas' {fqrsell},
  Unit21 in 'Unit21.pas' {Fqrinproduct},
  Ubackup in 'Ubackup.pas' {Form22},
  Upath in 'Upath.pas' {Fpath},
  Unit23 in 'Unit23.pas' {Form23};

{$R *.res}

begin
  try
   Application.Initialize;
   Application.CreateForm(TData2, Data2);
  Application.CreateForm(Tflogin, flogin);
  Application.CreateForm(TForm22, Form22);
  Application.CreateForm(TFpath, Fpath);
  Application.CreateForm(TForm23, Form23);
  flogin.adoconnection1.Connected:=false;
   flogin.adoconnection1.ConnectionString:='';
   flogin.adoconnection1.ConnectionString:='FILE NAME='+extractfilepath(paramstr(0))+'\tadoconnection.udl';
   flogin.adoconnection1.Provider:=extractfilepath(paramstr(0))+'\tadoconnection.udl';
   flogin.adoconnection1.LoginPrompt:=false;
   flogin.adoconnection1.Connected:=true;
  Application.CreateForm(Tfmain, fmain);
  Application.CreateForm(TFstore, Fstore);
  Application.CreateForm(TFselectdate, Fselectdate);
  Application.CreateForm(TFsingledbgrid, Fsingledbgrid);
  Application.CreateForm(TFproduct, Fproduct);
  Application.CreateForm(TFprofit, Fprofit);
  Application.CreateForm(TFprofit2, Fprofit2);
  Application.CreateForm(TFxitongshezhi, Fxitongshezhi);
  Application.CreateForm(TFmingxi, Fmingxi);
  Application.CreateForm(TFyishoumingxi, Fyishoumingxi);
  Application.CreateForm(TFmenu3, Fmenu3);
  Application.CreateForm(TFrpys, Frpys);
  Application.CreateForm(TFqryf, Fqryf);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TFjhtjreport, Fjhtjreport);
  Application.CreateForm(TFzhangbodengji, Fzhangbodengji);
  Application.CreateForm(TForm17, Form17);
  Application.CreateForm(TForm18, Form18);
  Application.CreateForm(TForm19, Form19);
  Application.CreateForm(Tfqrsell, fqrsell);
  Application.CreateForm(TFqrinproduct, Fqrinproduct);
  Application.HelpFile := 's';
  Application.Title := '进销存管理';
  Application.CreateForm(TFxitongshezhi, Fxitongshezhi);
  Application.CreateForm(TFmingxi, Fmingxi);
  Application.CreateForm(TFyishoumingxi, Fyishoumingxi);
  Application.CreateForm(TFmenu3, Fmenu3);
  Application.CreateForm(TFrpys, Frpys);
  Application.CreateForm(TFqryf, Fqryf);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TFjhtjreport, Fjhtjreport);
  Application.CreateForm(TFzhangbodengji, Fzhangbodengji);
  Application.Run;
  except
   on exception do
   begin
    if application.MessageBox('请重新配置?','连接错误',MB_iconquestion+MB_YESNO)=idyes then
    begin
    shellexecute(0,'open',pchar(extractfilepath(paramstr(0))+'\tadoconnection.udl'),nil,nil,0);
    application.Terminate;
    end else
    application.terminate;
   end; 
  end;

end.
