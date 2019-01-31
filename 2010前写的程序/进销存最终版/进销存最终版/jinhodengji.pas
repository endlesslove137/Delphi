unit jinhodengji;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ComCtrls, ExtCtrls, DBCtrls,ADODB ;

type

  TFzhangbodengji = class(TForm)
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    GroupBox2: TGroupBox;
    ComboBox3: TComboBox;
    Label7: TLabel;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    BitBtn5: TBitBtn;
    GroupBox3: TGroupBox;
    ComboBox2: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    DateTimePicker1: TDateTimePicker;
    BitBtn1: TBitBtn;
    GroupBox4: TGroupBox;
    DBNavigator1: TDBNavigator;
    BitBtn2: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
  private
    { Private declarations }
  public
  procedure comboboxadditem(table: TADOTable;combobox: tcombobox;s:string);
  end;


var
  Fzhangbodengji: TFzhangbodengji;
implementation
 uses udata2,ulogin;
{$R *.dfm}

procedure TFzhangbodengji.FormActivate(Sender: TObject);
begin

bitbtn1.Enabled:=combobox2.ItemIndex<>-1;
self.Refresh;//刷新self
end;



procedure TFzhangbodengji.BitBtn1Click(Sender: TObject);
begin
  case combobox1.ItemIndex of
  1:
   begin
     data2.dstemp.DataSet:=data2.qtemp;//将data2.qtemp赋给data2.dstemp.DataSet
     dbgrid1.DataSource:=data2.dstemp;//将data2.dstemp赋给dbgrid1.DataSource
     data2.qtemp.Close;//关闭data2.qtemp
     data2.qtemp.SQL.Clear;//将data2.qtemp.SQL清空
     data2.qtemp.SQL.Add('select * from inproduct where employeeid=(select id from employee where name='+''''+combobox2.text+''''+')'+' and date>=:date' );//添加SQL语句到data2.qtemp.SQL
     data2.qtemp.Parameters.ParamValues['date']:=datetimepicker1.datetime;//将datetimepicker1.datetime赋给'date'
     data2.qtemp.Open;//打开data2.qtemp
   end;
  2:
   begin
     data2.dstemp.DataSet:=data2.qtemp;//将data2.qtemp赋给data2.dstemp.DataSet
     dbgrid1.DataSource:=data2.dstemp;//将data2.dstemp赋给dbgrid1.DataSource
     data2.qtemp.Close;//关闭data2.qtemp
     data2.qtemp.SQL.Clear;//将data2.qtemp.SQL清空
     data2.qtemp.SQL.Add('select * from sell where employeeid=(select id from employee where name='+''''+combobox2.text+''''+')'+' and date>=:date');//添加SQL语句到data2.qtemp.SQL
     data2.qtemp.Parameters.ParamValues['date']:=datetimepicker1.datetime;//将datetimepicker1.datetime赋给'date'
     data2.qtemp.Open;//打开data2.qtemp
   end;
  3:
   begin
     data2.dstemp.DataSet:=data2.qtemp;
     dbgrid1.DataSource:=data2.dstemp;
     data2.qtemp.Close;
     data2.qtemp.SQL.Clear;
     data2.qtemp.SQL.Add('select * from outproduct where employeeid=(select id from employee where name='+''''+combobox2.text+''''+')'+' and date>=:date');
     data2.qtemp.Parameters.ParamValues['date']:=datetimepicker1.datetime;
     data2.qtemp.Open;
   end;
  4:
   begin
     data2.dstemp.DataSet:=data2.qtemp;
     dbgrid1.DataSource:=data2.dstemp;
     data2.qtemp.Close;
     data2.qtemp.SQL.Clear;
     data2.qtemp.SQL.Add('select * from outcustomers where employeeid=(select id from employee where name='+''''+combobox2.text+''''+')'+' and date>=:date');
     data2.qtemp.Parameters.ParamValues['date']:=datetimepicker1.datetime;
     data2.qtemp.Open;
   end;

 end;

end;

procedure TFzhangbodengji.comboboxadditem(table: TADOTable;combobox: tcombobox;s:string);
begin
  combobox.Items.Clear;//将combobox.Items的值清空
  table.Open;
  table.First;
  while not table.Eof do
  begin
   combobox.Items.Add(table.fieldbyname(s).AsString);//将table.fieldbyname(s)添加到combobox.Items
   table.Next;
  end;
  table.Close;
  combobox.ItemIndex:=1;
end;
procedure TFzhangbodengji.FormCreate(Sender: TObject);
begin
 comboboxadditem(data2.employee,combobox2,'name');
 comboboxadditem(data2.product,combobox3,'name');
 comboboxadditem(data2.customers,combobox4,'name');
 comboboxadditem(data2.jinhuochangshang,combobox5,'name');
 combobox1.Items.Add('all');


end;

procedure TFzhangbodengji.FormShow(Sender: TObject);
var
 bo:boolean;
begin
 data2.login.Open;//打开data2.login
 data2.login.Locate('name',ulogin.user,[]);
 bo:=data2.login.FieldValues['isadmin'];
 if not bo then bitbtn2.Visible:=false;
 fzhangbodengji.Caption:=combobox1.Text;
 case   combobox1.ItemIndex of
   1..4:
 begin
       bitbtn2.Visible:=true;//将bitbtn2隐藏
       label4.Visible:=true ;//将label4隐藏
       combobox2.Visible:=true;//将combobox2隐藏
       label5.Visible:=true;//将label5隐藏
       datetimepicker1.Visible:=true;//将datetimepicker1隐藏
       bitbtn1.Visible:=true;//将bitbtn1隐藏
       groupbox3.Visible:=true;//将groupbox3隐藏
       dbnavigator1.Visible:=true;//将dbnavigator1隐藏
       groupbox2.Visible:=true;//将groupbox2隐藏
       groupbox4.Visible:=true;//将groupbox4隐藏

 end;
 else
       bitbtn2.Visible:=false;//否则不将bitbtn2隐藏
       label4.Visible:=false ;
       combobox2.Visible:=false;
       label5.Visible:=false;
       datetimepicker1.Visible:=false;
       bitbtn1.Visible:=false;
       groupbox3.Visible:=false;
       dbnavigator1.Visible:=false;
       groupbox2.Visible:=false;
       groupbox4.Visible:=false;

 end;
 combobox2.OnChange(nil);
end;

procedure TFzhangbodengji.BitBtn2Click(Sender: TObject);
begin
 if messagebox(handle,'确定要删除吗?','删除后将不可恢复！',mb_okcancel+mb_iconquestion)=idcancel then
  exit;
  case combobox1.ItemIndex of
   1:
    begin
     dbgrid1.datasource:=data2.dsinproduct;//将data2.dsinproduct赋给dbgrid1.datasource
     dbnavigator1.DataSource:=data2.dsinproduct;//将data2.dsinproduct赋给dbgrid1.dbnavigator1
     data2.inproduct.Delete;//将data2.inproduct删除
    end;
   2:
    begin
     dbgrid1.datasource:=data2.dssell;
     dbnavigator1.DataSource:=data2.dssell;
     data2.sell.Delete;
    end;
   3:
    begin
     dbgrid1.datasource:=data2.dsoutproduct;
     dbnavigator1.DataSource:=data2.dsoutproduct;
     data2.outproduct.Delete;
    end;
   4:
    begin
     dbgrid1.datasource:=data2.dsoutcustomers;
     dbnavigator1.DataSource:=data2.dsoutcustomers;
     data2.outcustomers.Delete;
    end;
 end;
end;

procedure TFzhangbodengji.ComboBox2Change(Sender: TObject);
var
 vyf,vsf:variant;
 yf,sf,qk:real;
begin
 bitbtn1.Enabled:=combobox2.ItemIndex<>-1;//当combobox2.ItemIndex的值不等于-1时bitbtn1可用
 yf:=0;
 sf:=0;
 case combobox1.ItemIndex of
   1:
    begin
     dbgrid1.datasource:=data2.dsinproduct;
     dbnavigator1.DataSource:=data2.dsinproduct;
     data2.inproduct.First;
     while  not data2.inproduct.Eof do
     begin
      vyf:=data2.inproduct.FieldValues['Sumpricee'];//将'Sumpricee'赋给vyf
      vsf:=data2.inproduct.FieldValues['cush'];//将'cush'赋给vsf
      yf:=yf+vyf;//将yf+vyf赋给yf
      sf:=sf+vsf;//将sf+vyf赋给sf
      data2.inproduct.Next;
     end;
      qk:=yf-sf;//将yf-sf赋给qk
      label2.caption:=floattostr(yf);//将Yf转换为string赋给label2.caption
      label3.caption:=floattostr(sf);//将sf转换为string赋给label3.caption
      label6.caption:=floattostr(qk);//将qk转换为string赋给label6.caption
    end;
   2:
    begin
     dbgrid1.datasource:=data2.dssell;
     dbnavigator1.DataSource:=data2.dssell;
     data2.sell.First;
     while  not data2.sell.Eof do
     begin
      vyf:=data2.sell.FieldValues['Sumpricee'];
      vsf:=data2.sell.FieldValues['cush'];
      yf:=yf+vyf;
      sf:=sf+vsf;
      data2.sell.Next;
     end;
      qk:=yf-sf;
      label2.caption:=floattostr(yf);
      label3.caption:=floattostr(sf);
      label6.caption:=floattostr(qk);
    end;
   3:
    begin
     dbgrid1.datasource:=data2.dsoutproduct;
     dbnavigator1.DataSource:=data2.dsoutproduct;
     data2.outproduct.First;
     while  not data2.outproduct.Eof do
     begin
      vyf:=data2.outproduct.FieldValues['Sumpricee'];
      vsf:=data2.outproduct.FieldValues['cush'];
      yf:=yf+vyf;
      sf:=sf+vsf;
      data2.outproduct.Next;
     end;
      qk:=yf-sf;
      label2.caption:=floattostr(yf);
      label3.caption:=floattostr(sf);
      label6.caption:=floattostr(qk);
    end;
   4:
    begin
     dbgrid1.datasource:=data2.dsoutcustomers;
     dbnavigator1.DataSource:=data2.dsoutcustomers;
     data2.outcustomers.First;
     while  not data2.outcustomers.Eof do
     begin
      vyf:=data2.outcustomers.FieldValues['Sumpricee'];
      vsf:=data2.outcustomers.FieldValues['cush'];
      yf:=yf+vyf;
      sf:=sf+vsf;
      data2.outcustomers.Next;
     end;
      qk:=yf-sf;
      label2.caption:=floattostr(yf);
      label3.caption:=floattostr(sf);
      label6.caption:=floattostr(qk);
    end;
  5..6:
  begin
     data2.qtemp.Close;//关闭data2.qtemp
     data2.qtemp.SQL.Clear;//将data2.qtemp.SQL清空
     data2.qtemp.SQL.Add('select distinct customers.name 客户名称,cush 实付款,Sumpricee 应付款,欠款=sumpricee-cush from sell inner join customers on sell.customerid=customers.id');//'+' and date='+datetimetostring(picker1.date)//添加SQL语句到data2.qtemp.SQL
     data2.qtemp.Open;//打开data2.qtemp
     data2.dstemp.DataSet:=data2.qtemp;//将data2.qtemp赋给data2.dstemp.DataSet
     dbgrid1.DataSource:=data2.dstemp;//将data2.dstemp赋给dbgrid1.DataSource
     dbnavigator1.DataSource:=data2.dstemp;//将data2.dstemp赋给dbnavigator1.DataSource
     data2.outcustomers.First;
     while  not data2.outcustomers.Eof do
     begin
      vyf:=data2.outcustomers.FieldValues['Sumpricee'];
      vsf:=data2.outcustomers.FieldValues['cush'];
      yf:=yf+vyf;
      sf:=sf+vsf;
      data2.outcustomers.Next;
     end;
      qk:=yf-sf;
      label2.caption:=floattostr(yf);
      label3.caption:=floattostr(sf);
      label6.caption:=floattostr(qk);
    end;
  7:
  begin
     data2.dstemp.DataSet:=data2.qtemp;
     dbgrid1.DataSource:=data2.dstemp;
     dbnavigator1.DataSource:=data2.dstemp;
     data2.qtemp.Close;
     data2.qtemp.SQL.Clear;
     data2.qtemp.SQL.Add(' if exists(select * from sysobjects where name=''sumout'') drop table sumout ');
     data2.qtemp.SQL.Add(' create table sumout (date datetime,reason varchar(17),cush  money,Sumpricee money,employee varchar(17)) select date 时间,reason 原因,cush 实付款,sumpricee 应付款,employee 雇员ID from sumout');
     data2.qtemp.Open;
     data2.inproduct.First;
     while not data2.inproduct.Eof do
     begin
       data2.qtemp.AppendRecord([data2.inproduct.FieldValues['date'],'公司进货',data2.inproduct.FieldValues['cush'],data2.inproduct.FieldValues['sumpricee'],data2.inproduct.FieldValues['employeeid']]);
       data2.inproduct.next;
     end;
     data2.outcustomers.First;
     while not data2.outcustomers.Eof do
     begin
       data2.qtemp.AppendRecord([data2.outcustomers.FieldValues['date'],'客户退货',data2.outcustomers.FieldValues['cush'],data2.outcustomers.FieldValues['sumpricee'],data2.outcustomers.FieldValues['employeeid']]);
       data2.outcustomers.Next;
     end;
     data2.qtemp.First;
     while  not data2.QTEMP.Eof do
     begin
      vsf:=data2.qtemp.FieldValues['实付款'];
      vyf:=data2.qtemp.FieldValues['应付款'];
      yf:=yf+vyf;
      sf:=sf+vsf;
      data2.qtemp.next;
     end;
      qk:=yf-sf;
      label2.caption:=floattostr(yf);
      label3.caption:=floattostr(sf);
      label6.caption:=floattostr(qk);
  end;
 end;
end;



end.
