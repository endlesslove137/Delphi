unit Uinformation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,upublic, udata,ComCtrls, StdCtrls, DBCtrls, Grids, DBGrids,
  ExtCtrls, Mask, Buttons;

type
  Tfinformation = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Editphone: TDBEdit;
    Editmaster: TDBEdit;
    Editcarid: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Editload: TDBEdit;
    Editvolume: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    GroupBox2: TGroupBox;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    DBMemo1: TDBMemo;
    Label6: TLabel;
    Label8: TLabel;
    GroupBox3: TGroupBox;
    SpeedButton6: TSpeedButton;
    TabSheet2: TTabSheet;
    GroupBox4: TGroupBox;
    Editeid: TDBEdit;
    Label10: TLabel;
    Label11: TLabel;
    Editname: TDBEdit;
    Label12: TLabel;
    DBEdit1: TDBEdit;
    Editsalary: TDBEdit;
    Label14: TLabel;
    Label19: TLabel;
    Editbirthday: TDBEdit;
    Edithiredate: TDBEdit;
    Label15: TLabel;
    Label16: TLabel;
    GroupBox5: TGroupBox;
    DBGrid2: TDBGrid;
    DBNavigator2: TDBNavigator;
    GroupBox6: TGroupBox;
    SpeedButton2: TSpeedButton;
    Label20: TLabel;
    DBRadioGroup1: TDBRadioGroup;
    DBComboBox1: TDBComboBox;
    Label13: TLabel;
    DBMemo2: TDBMemo;
    GroupBox7: TGroupBox;
    Edit2: TEdit;
    Label18: TLabel;
    SpeedButton3: TSpeedButton;
    CheckBox1: TCheckBox;
    GroupBox8: TGroupBox;
    CheckBox2: TCheckBox;
    Label9: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    GroupBox9: TGroupBox;
    Edit5: TEdit;
    Edit4: TEdit;
    GroupBox10: TGroupBox;
    Edit6: TEdit;
    Label21: TLabel;
    Label22: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label23: TLabel;
    ComboBox1: TComboBox;
    Label24: TLabel;
    SpeedButton7: TSpeedButton;
    Label17: TLabel;
    Label25: TLabel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    TabSheet4: TTabSheet;
    GroupBox11: TGroupBox;
    DBGrid3: TDBGrid;
    DBNavigator3: TDBNavigator;
    GroupBox12: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBMemo3: TDBMemo;
    DBMemo4: TDBMemo;
    GroupBox13: TGroupBox;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    GroupBox14: TGroupBox;
    Label31: TLabel;
    SpeedButton10: TSpeedButton;
    Edit3: TEdit;
    CheckBox3: TCheckBox;
    Label32: TLabel;
    TabSheet5: TTabSheet;
    GroupBox15: TGroupBox;
    DBGrid4: TDBGrid;
    DBNavigator4: TDBNavigator;
    GroupBox16: TGroupBox;
    Label30: TLabel;
    Label33: TLabel;
    Label35: TLabel;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit8: TDBEdit;
    DBMemo5: TDBMemo;
    GroupBox17: TGroupBox;
    GroupBox18: TGroupBox;
    Label37: TLabel;
    Label36: TLabel;
    DBRadioGroup2: TDBRadioGroup;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    CheckBox4: TCheckBox;
    Edit7: TEdit;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  finformation: Tfinformation;

implementation

{$R *.dfm}

procedure Tfinformation.SpeedButton1Click(Sender: TObject);
var
 s:string;
begin
 if isnull(edit1) then
 begin
 showmessage('请输入汽车牌照');
 exit;
 end else
 begin
 s:='select * from cars where carid='+quotedstr(edit1.Text);
 searchinquery(fdata.cars,s);
 end;
end;

procedure Tfinformation.SpeedButton2Click(Sender: TObject);
begin
 close;
end;

procedure Tfinformation.SpeedButton3Click(Sender: TObject);
var
 s:string;
begin
 if isnull(edit2) then
 begin
 showmessage('请输入名字');
 exit;
 end else
 begin
 s:='select * from employees where name='+quotedstr(edit2.Text);
 searchinquery(fdata.employees,s);
 end;
end;

procedure Tfinformation.CheckBox1Click(Sender: TObject);
begin
 if checkbox1.Checked then selectallinquery(fdata.employees);
end;

procedure Tfinformation.CheckBox2Click(Sender: TObject);
begin
 if checkbox1.Checked then selectallinquery(fdata.cars);

end;

procedure Tfinformation.SpeedButton5Click(Sender: TObject);
begin
 deleteonquery(fdata.cars);
end;

procedure Tfinformation.SpeedButton4Click(Sender: TObject);
begin
 deleteonquery(fdata.employees);
end;

procedure Tfinformation.SpeedButton6Click(Sender: TObject);
begin
 close;
end;

procedure Tfinformation.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 isexit(self,action);
end;

procedure Tfinformation.BitBtn1Click(Sender: TObject);
begin
 if isnull(edit6) then
 showmessage('请输入新的密码')
 else
 try
 setprocedure('updatepassword;1','@eid','@newpassword',label24,edit6);
 showmessage('修改成功');
 except showmessage('出错了');
 end;

end;

procedure Tfinformation.ComboBox1Change(Sender: TObject);
var
 s:string;
 n:integer;
begin
 if isnull(combobox1) then
  exit
 else
 begin
  s:='select * from employees where name='+quotedstr(combobox1.Text);
  settemp(s);
  n:=fdata.temp.RecordCount;
  if n>1 then  speedbutton7.Enabled:=true
  else speedbutton7.Enabled:=false;
   settextbyquery(fdata.temp,'eid',label24);
 end;
end;

procedure Tfinformation.SpeedButton7Click(Sender: TObject);
begin
 if   fdata.temp.Eof then
 fdata.temp.First else
 fdata.temp.Next;
 settextbyquery(fdata.temp,'eid',label24);
end;

procedure Tfinformation.BitBtn3Click(Sender: TObject);
begin
  if isnull(edit5) then
  showmessage('请输入新的密码')
  else if edit5.Text<>edit4.Text then
  showmessage('两次密码不一至')
  else
  begin
  end;
end;

procedure Tfinformation.FormShow(Sender: TObject);
begin
  fdata.cars.Open;
  fdata.employees.Open;
  fdata.storage.Open;
  fdata.customers.Open;
  if not(department='管理员') then
  begin
   GroupBox10.Visible:=false;
   dbcombobox1.Style:=csDropDownList;
  end  else
  begin
   groupbox9.Visible:=true;
   dbcombobox1.Style:=csDropDown;
  end;
  candelete(speedbutton5);
  candelete(speedbutton4);
  candelete(speedbutton9);
  candelete(speedbutton12);

end;

procedure Tfinformation.SpeedButton10Click(Sender: TObject);
var
 s:string;
begin
 if isnull(edit3) then
 begin
 showmessage('请输入仓库ID');
 exit;
 end else
 begin
 s:='select * from storage where sid='+edit3.Text;
 searchinquery(fdata.storage,s);
 end;
end;



procedure Tfinformation.CheckBox3Click(Sender: TObject);
begin
 if checkbox3.Checked then selectallinquery(fdata.storage);

end;

procedure Tfinformation.CheckBox4Click(Sender: TObject);
begin
 if checkbox4.Checked then selectallinquery(fdata.customers);

end;

procedure Tfinformation.SpeedButton11Click(Sender: TObject);
var
 s:string;
begin
 if isnull(edit7) then
 begin
 showmessage('请输入客户姓名');
 exit;
 end else
 begin
 s:='select * from customers where name='+quotedstr(edit7.Text);
 searchinquery(fdata.customers,s);
 end;
end;


procedure Tfinformation.SpeedButton12Click(Sender: TObject);
begin
 deleteonquery(fdata.customers);
end;

procedure Tfinformation.SpeedButton9Click(Sender: TObject);
begin
 deleteonquery(fdata.storage);
end;

procedure Tfinformation.TabSheet3Show(Sender: TObject);
begin
 comboboxadditem(fdata.employees,combobox1,'name');
end;

end.
