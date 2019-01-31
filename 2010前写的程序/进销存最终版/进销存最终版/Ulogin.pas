unit Ulogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,unit1,jpeg, ExtCtrls, StdCtrls, Buttons, DB, ADODB,shellapi,adoconed;

type
  Tflogin = class(TForm)
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    ComboBox1: TComboBox;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  flogin: Tflogin;
  theconnectstring:string;
  user:string;
implementation

uses Udata2;
var
  times:integer=0;
{$R *.dfm}

procedure Tflogin.ComboBox1Change(Sender: TObject);
begin
speedbutton1.Enabled:=combobox1.itemindex<>0;//combobox1值不为空
end;

procedure Tflogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if messagebox(handle,'确定退出?','Warging',mb_okcancel+mb_iconquestion)=idcancel then
  action:=canone;
end;

procedure Tflogin.SpeedButton1Click(Sender: TObject);
var
 loginpw:string;
 a:variant;    //定义变量

begin
 adotable1.Open;//打开adotable1
 a:=adotable1.lookup('name',combobox1.Text,'password');//将数据库中与用户对应的密码值赋给a
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
 user:=combobox1.Text;//将combobox1.text的值赋给user
 flogin.hide;
 adotable1.close;//关闭adotable1
 fmain.Show;//打开fmain页面
end;


procedure Tflogin.SpeedButton2Click(Sender: TObject);
begin
  application.Terminate;
end;


procedure Tflogin.FormShow(Sender: TObject);
begin
 try
 combobox1.Items.Add('请选择用户名');//添加值‘请选择用户名’到combobox1.items
 adotable1.Open;//打开adtable1
 while not adotable1.Eof do
 begin
  combobox1.Items.Add(adotable1.fieldbyname('name').asstring);
  adotable1.Next;//将数据库中‘name’的值添加到combobox1.items中
 end;
 combobox1.ItemIndex:=0;
 except
   showmessage('连接出错');
 end;
  animatewindow(handle,700,aw_center)//将flogin窗体放置显示器中央并固定
end;

procedure Tflogin.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_return then
 speedbutton1.Click;
end;

procedure Tflogin.FormHide(Sender: TObject);
begin
 animatewindow(handle,700,aw_center+aw_hide);//将flogin窗体隐藏
end;

end.
