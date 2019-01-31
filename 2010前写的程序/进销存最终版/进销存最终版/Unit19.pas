unit Unit19;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TForm19 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form19: TForm19;

implementation
uses ulogin,udata2;
{$R *.dfm}

procedure TForm19.BitBtn1Click(Sender: TObject);
begin
 if edit1.text<>edit2.Text then showmessage('对不起,你两次输入的密码不一致不能修改')//如果edit1.text的值不等于edit2.Text则提示信息'对不起,你两次输入的密码不一致不能修改'
 else
 begin
   data2.login.Open;//打开data2.login
  if not data2.login.Locate('name',user,[])
   then showmessage('没有找到你的用户名')//如果data2.login.Locate中'name'为空则提示信息'没有找到你的用户名'
  else
   begin
    data2.login.Edit;
    data2.login.FieldByName('password').AsString:=edit2.Text;//将edit2.Text的值赋给data2.login.FieldByName中的'password'
    data2.login.Post;
   end;

 end;

end;

end.

