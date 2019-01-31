unit Ustorage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,ADODB,
  Dialogs,udata,StdCtrls, Buttons, ComCtrls, upublic,   ExtCtrls, DBCtrls, Mask, jpeg,udetail;

type
  TFstorage = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    ComboBox2: TComboBox;
    Memo1: TMemo;
    GroupBox3: TGroupBox;
    SpeedButton2: TSpeedButton;
    SpeedButton8: TSpeedButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fstorage: TFstorage;

implementation


{$R *.dfm}

procedure TFstorage.CheckBox1Click(Sender: TObject);
begin
 if checkbox1.checked then
 begin
  if not issure then checkbox1.Checked:=false
  else
  begin
   setenable(groupbox2,1);
  end;
 end else
   setenable(groupbox2,0);

end;

procedure TFstorage.ComboBox1Change(Sender: TObject);
begin
 if not isnull(combobox1) then
 begin
 setprocedure('根据单号查询占用空间;1','@oid',combobox1);
 setlabel(label7,'svolume','n');
  oid:=combobox1.text;
 checkbox1.Enabled:=true;
 speedbutton1.Enabled:=true;
 end else
 begin
  setenable(checkbox1,0);
  setenable(speedbutton1,0);
 end;


end;

procedure TFstorage.FormCreate(Sender: TObject);
begin
 //setprocedure('查询未入库的单号;1');
end;

procedure TFstorage.ComboBox2Change(Sender: TObject);
begin
  if not isnull(combobox2) then
  begin
  setprocedure('根据sid查询仓库的剩余空间;1','@sid',combobox2);
  setlabel(label4,'还可用空间','n');
  speedbutton2.Enabled:=true;
  end;
end;

procedure TFstorage.SpeedButton1Click(Sender: TObject);
begin
 setprocedure('根据单号查物品;1','@oid',combobox1);
 fdetail.qrlabel33.Caption:=oid+'号托运单产品如下';
 fdetail.QuickRep4.Preview;

end;

procedure TFstorage.SpeedButton2Click(Sender: TObject);
var
 adoquery:tadoquery;
begin
  if strtoint(label7.Caption)>strtoint(label4.Caption) then
  begin
   showmessage('这个仓库装不下了');
   exit;
  end
  else  if not checkbox1.Checked then
  begin
   showmessage('没有核对货物');
   exit;
  end else
  begin
  try
  adoquery:=fdata.temp;
  adoquery.SQL.Clear;
  adoquery.SQL.Add('insert into storagedetail(oid,sid,remarks) values(:oid,:sid,:remarks)');
  adoquery.Parameters.ParamByName('oid').Value:=combobox1.Text;
  adoquery.Parameters.ParamByName('sid').Value:=combobox2.Text;
  adoquery.Parameters.ParamByName('remarks').Value:=memo1.Text;
  adoquery.ExecSQL;
  showmessage('成功保存');
  except
   showmessage('保存出错');
  end;
  end;
end;

procedure TFstorage.FormActivate(Sender: TObject);
begin
 comboboxadditem('查询未入库的单号;1',combobox1,'oid');
 comboboxadditem(fdata.storage,combobox2,'sid');

end;

procedure TFstorage.SpeedButton8Click(Sender: TObject);
begin
 close;
end;

end.
