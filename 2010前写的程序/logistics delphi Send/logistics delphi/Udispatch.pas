unit Udispatch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, Mask, DBCtrls, ExtCtrls, ComCtrls,
  Grids, DBGrids,udata, Buttons,upublic;

type
  TFdispatch = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    ComboBox2: TComboBox;
    DBNavigator: TDBNavigator;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label5: TLabel;
    Label21: TLabel;
    ComboBox1: TComboBox;
    GroupBox5: TGroupBox;
    DBGrid1: TDBGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure setok;
    procedure setno;
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  Fdispatch: TFdispatch;

implementation

{$R *.dfm}

procedure TFdispatch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=cafree;
end;

procedure TFdispatch.FormCreate(Sender: TObject);
begin
  showdbgrid(dbgrid1,fdata.dsdispatch,fdata.dispatch,DBNavigator);
  normalspace(DBGrid1);
  setno;
end;

procedure TFdispatch.ComboBox2Change(Sender: TObject);
var
 s:string;
 x:string;
begin
//根据单号查询到达日期和估计要用的日期
 if combobox2.Text<>'' then
 begin
  s:='select * from orders where oid='+combobox2.Text;
  settemp(s);
  x:='q';
  setlabel(label18,'sweight',x);
  setlabel(label17,'svolume',x);
  datetimepicker2.DateTime:=fdata.temp.FieldValues['requiredate'];
  setlabel(label8,'needday',x);
 end;
end;

//设置为不可用
procedure tfdispatch.setno;
begin
   setenable(groupbox1,0);
   setenable(groupbox2,0);
   setenable(groupbox3,0);
   setenable(groupbox4,0);
end;
//设置可用
procedure tfdispatch.setok;
begin
   setenable(groupbox1,1);
   setenable(groupbox2,1);
   setenable(groupbox3,1);
   setenable(groupbox4,1);
end;
procedure TFdispatch.SpeedButton2Click(Sender: TObject);
begin
   setok;
   fdata.dispatch.Append;
   comboboxadditem('未分配的托运单;1',combobox2,'oid');
   comboboxadditem('在库的司机;1',combobox1,'carid');
    combobox2.OnChange(nil);
end;

procedure TFdispatch.ComboBox1Change(Sender: TObject);
begin
 if combobox1.Text<>'' then
 begin
   setprocedure('根据司机查询车的情况;1','@carid',combobox1);
   setlabel(label16,'可用空间','n');
   setlabel(label15,'还可载重','n');
   setlabel(label21,'phone','n');
 end;
end;

procedure TFdispatch.SpeedButton5Click(Sender: TObject);
begin
 if(isnull(combobox2) or isnull(combobox1))then
 begin
  showmessage('请检查分配信息是否完整');
  exit;
 end
 else if datetimepicker1.Date+strtoint(label8.Caption)>datetimepicker2.DateTime then
 begin
  showmessage('请修改托运时间');
  exit;
 end
 else if (strtofloat(label18.Caption)>strtofloat(label15.Caption))  or (strtofloat(label17.Caption)>strtofloat(label16.Caption)) then
 begin
  showmessage('这个车装不下');
  exit;
 end else
 begin
  setfield(fdata.dispatch,'oid',combobox2);
  setfield(fdata.dispatch,'carid',combobox1);
  setfield(fdata.dispatch,'shipdate',datetimepicker1);
  setfield(fdata.dispatch,'remarks',combobox2);
  fdata.dispatch.Post;
 end;
end;

procedure TFdispatch.SpeedButton3Click(Sender: TObject);
begin
 setok;
 comboboxadditem('在库的司机;1',combobox1,'carid');
 settextbytable(fdata.dispatch,'oid',combobox2);
 combobox2.OnChange(nil);
 combobox2.Text:=fdata.dispatch.FieldValues['oid'];

end;

procedure TFdispatch.SpeedButton4Click(Sender: TObject);
begin
 deleteontable(fdata.dispatch)
end;

procedure TFdispatch.SpeedButton1Click(Sender: TObject);
begin
 self.Close;
end;

end.
