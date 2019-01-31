unit Uorder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls,udata,StdCtrls, Mask, ExtCtrls, Grids, DBGrids,upublic,Buttons,
  ComCtrls,udetail;

type
  TForder = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox15: TGroupBox;
    DBGrid4: TDBGrid;
    DBNavigator4: TDBNavigator;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label3: TLabel;
    Label13: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Label12: TLabel;
    Label10: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    Label2: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBMemo1: TDBMemo;
    DBCheckBox1: TDBCheckBox;
    GroupBox2: TGroupBox;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    GroupBox18: TGroupBox;
    Label37: TLabel;
    SpeedButton11: TSpeedButton;
    CheckBox4: TCheckBox;
    Edit7: TEdit;
    TabSheet2: TTabSheet;
    GroupBox3: TGroupBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    SpeedButton3: TSpeedButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    GroupBox5: TGroupBox;
    Label15: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label27: TLabel;
    DBLookupComboBox3: TDBLookupComboBox;
    DBEdit4: TDBEdit;
    DBEdit9: TDBEdit;
    DBMemo2: TDBMemo;
    GroupBox6: TGroupBox;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Label16: TLabel;
    DBEdit7: TDBEdit;
    Label17: TLabel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    CheckBox2: TCheckBox;
    SpeedButton6: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton11Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Forder: TForder;

implementation

{$R *.dfm}

procedure TForder.FormShow(Sender: TObject);
begin
 fdata.orders.Open;
 fdata.employees.Open;
 fdata.customers.Open;
 fdata.orderdetail.Open;
end;

procedure TForder.SpeedButton12Click(Sender: TObject);
begin
 deleteonquery(fdata.orders);
end;

procedure TForder.SpeedButton13Click(Sender: TObject);
begin
  close;
end;

procedure TForder.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 isexit(self,action);
end;

procedure TForder.SpeedButton11Click(Sender: TObject);
var
 s:string;
begin
 if isnull(edit7) then
 begin
 showmessage('请查询相应信息,以方便打印信息');
 exit;
 end else
 begin
 if checkbox2.Checked then
 begin
 s:='select * from orders where oid='+quotedstr(edit7.Text)+' and state='+quotedstr('正在审请');
 setenable(speedbutton5,1)
 end
 else
 begin
 s:='select * from orders where oid='+quotedstr(edit7.Text);
 ;setenable(speedbutton5,0)
 end;
 searchinquery(fdata.orders,s);
 speedbutton6.Enabled:=true;
 if fdata.orders.RecordCount<=0 then setenable(speedbutton5,0);
 end;


end;


procedure TForder.CheckBox4Click(Sender: TObject);
begin
 if checkbox4.Checked then selectallinquery(fdata.orders);
 edit7.Text:='';
end;

procedure TForder.SpeedButton1Click(Sender: TObject);
begin
 deleteonquery(fdata.orderdetail);
end;

procedure TForder.CheckBox1Click(Sender: TObject);
begin
 if checkbox1.Checked then selectallinquery(fdata.orderdetail);

end;

procedure TForder.SpeedButton3Click(Sender: TObject);
var
 s:string;
begin
 if isnull(edit1) then
 begin
 showmessage('请输入审请单号');
 exit;
 end else
 begin
 s:='select *from orderdetail where oid='+edit1.Text;
 searchinquery(fdata.orderdetail,s);
 end;
end;


procedure TForder.SpeedButton4Click(Sender: TObject);
begin
  fdata.orders.Refresh;
  isjlxx:=true;
  pagecontrol1.ActivePage:=TabSheet1;
end;

procedure TForder.SpeedButton5Click(Sender: TObject);
begin
 if isnull(edit7) then
 begin
 showmessage('请输入订单id');
  speedbutton6.Enabled:=false;
 exit;
 end else
 if application.messagebox('确定用户已经付款了吗？','Warging',mb_okcancel+mb_iconquestion)=idok then
 begin
  setprocedure('用户提交款额时修改状态为已审请;1','@oid',edit7,false);
  oid:=edit7.Text;
  speedbutton6.Enabled:=true;
 end
 else
 exit;

end;

procedure TForder.SpeedButton6Click(Sender: TObject);
var
 s:string;

begin
  s:='select a.oid 托运编号,b.name 客户,c.name 付责人,convert(varchar(10),a.orderdate,105) 审请日期,a.insure 是否投保,a.smoney 收取费用,a.destination 目的地 from orders a,customers b,employees c where a.cid=b.cid and c.eid=a.eid and a.oid='+quotedstr(edit7.Text);
 settemp(s);
 setprocedure('根据单号查物品;1','@oid',edit7);
 fdetail.QRLabel45.Caption:=edit7.Text+'号审请单的信息如下';
 fdetail.quickrep5.Preview;
end;

procedure TForder.Edit7Exit(Sender: TObject);
begin
// speedbutton6.Enabled:=edit7.Text<>'';
 if not isnull(edit1) then oid:=edit1.Text;
end;

end.
