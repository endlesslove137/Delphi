unit Ulogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons,upublic,unit1,StdCtrls, jpeg, ExtCtrls;

type
  TFlogin = class(TForm)
    Image1: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Flogin: TFlogin;
  times:integer;
implementation

uses Udata;

{$R *.dfm}

procedure TFlogin.SpeedButton2Click(Sender: TObject);
begin
 application.Terminate;
end;

procedure TFlogin.SpeedButton1Click(Sender: TObject);
var
 loginpw:string;
 a:variant;    //定义变量

begin
 fdata.employees.Open;
 if not fdata.employees.locate('name',edit1.Text,[]) then
 begin
 showmessage('此用户不存在');
 exit;
 end else
 a:=fdata.employees.lookup('name',edit1.Text,'password');//将数据库中与用户对应的密码值赋给a
 loginpw:=a;//将a值赋给loginpw
 if edit2.text<>trim(loginpw) then
 begin
  inc(times);
   if times>3 then
   begin
    application.messagebox(pchar('对不起，密码错误次数超限'),pchar('警告'),mb_ok);
    application.Terminate;
   end;//如果密码输入出错次数超过3次则提示‘对不起，密码错误次数超限’
  application.MessageBox(pchar('密码错误,请重新输入'),pchar('提示'),mb_ok);
  exit;//如果输入密码错误则提示‘密码错误，请重新输入’
 end;
 user:=edit1.Text;//将edit1.text的值赋给user
 department:=fdata.employees.lookup('name',edit1.Text,'department');
 fdata.employees.close;//关闭fdata.employees
 close;
 fmain.Show;


end;

procedure TFlogin.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
 speedbutton1.Click;
end;

procedure TFlogin.FormShow(Sender: TObject);
begin
   animatewindow(Handle,700,aw_center+aw_activate);
 //  if fmain.Skin.Active then
 begin
     speedbutton1.Caption:='登陆';
     speedbutton2.Caption:='退出';
   end 
end;

procedure TFlogin.FormActivate(Sender: TObject);
begin
 self.Repaint;
end;

end.
