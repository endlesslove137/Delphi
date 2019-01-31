unit Udata2;

interface

uses
     Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables,comobj, ADODB,jinhodengji,StdCtrls;
type
  TData2 = class(TDataModule)
    jinhuochangshang: TADOTable;
    category: TADOTable;
    product: TADOTable;
    inproduct: TADOTable;
    outproduct: TADOTable;
    employee: TADOTable;
    dsjinhuochangshang: TDataSource;
    dscategory: TDataSource;
    dsproduct: TDataSource;
    dsinproduct: TDataSource;
    dsoutproduct: TDataSource;
    dsemployee: TDataSource;
    dscustomers: TDataSource;
    dssell: TDataSource;
    dslogin: TDataSource;
    dsoutcustomers: TDataSource;
    customers: TADOTable;
    sell: TADOTable;
    login: TADOTable;
    outcustomers: TADOTable;
    ADOConnection1: TADOConnection;
    dstemp: TDataSource;
    qtemp: TADOQuery;
    sumout: TTable;
    dssumout: TDataSource;
    ADOStoredProc1: TADOStoredProc;
    employeeid: TAutoIncField;
    employeeName: TStringField;
    employeesex: TStringField;
    employeebirthday: TDateTimeField;
    employeephone: TStringField;
    employeeAddress: TStringField;
    employeesalary: TBCDField;
    employeeemployeedate: TDateTimeField;
    jinhuochangshangID: TAutoIncField;
    jinhuochangshangname: TStringField;
    jinhuochangshangAddress: TStringField;
    jinhuochangshangphone: TStringField;
    categoryid: TAutoIncField;
    categoryname: TStringField;
    categorymemo: TStringField;
    productid: TAutoIncField;
    productjinhuochangshangid: TIntegerField;
    productcategoryid: TIntegerField;
    productname: TStringField;
    productprice: TBCDField;
    productstocks: TIntegerField;
    inproductproductid: TIntegerField;
    inproductNumber: TIntegerField;
    inproductemployeeid: TIntegerField;
    inproductprice: TBCDField;
    inproductcush: TBCDField;
    inproductsumpricee: TBCDField;
    inproductID: TIntegerField;
    inproductjhcsid: TIntegerField;
    inproductdate: TDateTimeField;
    outproductNumber: TIntegerField;
    outproductcush: TBCDField;
    outproductdate: TDateTimeField;
    outproductID: TIntegerField;
    outproductemployeeid: TIntegerField;
    outproductproductID: TIntegerField;
    outproductsumpricee: TBCDField;
    outproductinproductid: TIntegerField;
    customersID: TAutoIncField;
    customersName: TStringField;
    customerslinkman: TStringField;
    customersphone: TStringField;
    customersAddress: TStringField;
    sellcustomerId: TIntegerField;
    sellemployeeid: TIntegerField;
    sellnumber: TIntegerField;
    sellproductID: TIntegerField;
    sellcush: TBCDField;
    sellSumpricee: TBCDField;
    selldate: TDateTimeField;
    sellid: TIntegerField;
    sellagio: TIntegerField;
    loginname: TStringField;
    loginpassword: TStringField;
    outcustomersid: TAutoIncField;
    outcustomersnumber: TIntegerField;
    outcustomerscush: TBCDField;
    outcustomersSumpricee: TBCDField;
    outcustomersemployeeid: TIntegerField;
    outcustomerssellId: TIntegerField;
    outcustomersdate: TDateTimeField;
    outcustomersproductid: TIntegerField;
    outcustomerscustomerid: TIntegerField;
    loginisadmin: TBooleanField;
    back: TADOCommand;
    procedure outcustomersBeforeInsert(DataSet: TDataSet);
    procedure outcustomersAfterInsert(DataSet: TDataSet);
    procedure inproductsumpriceeSetText(Sender: TField;
      const Text: String);
    procedure inproductAfterInsert(DataSet: TDataSet);
    procedure outproductAfterInsert(DataSet: TDataSet);
    procedure sellAfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
  procedure findid(table: TADOTable;combobox: tcombobox;var id:integer);
  end;

var
  Data2: TData2;
  customerid:integer;
  theemployeeid:integer;
  supplierid:integer;
  theproductid:integer;
implementation
{$R *.dfm}
procedure tdata2.findid(table: TADOTable;combobox: tcombobox;var id:integer);
begin
 table.Open;
 table.Locate('name',combobox.Text,[]);
 id:=table.FieldByName('id').AsInteger;
 table.Close;
end;

procedure TData2.outcustomersBeforeInsert(DataSet: TDataSet);
begin
 showmessage('提示：请先在在快捷编辑数据区选择相应的数据');
 dataset.Cancel; 

end;

procedure TData2.outcustomersAfterInsert(DataSet: TDataSet);
begin
  findid(employee,Fzhangbodengji.ComboBox2,theemployeeid);
  outcustomers['employeeid']:=theemployeeid;
  findid(customers,Fzhangbodengji.ComboBox4,customerid);
  outcustomers['customerid']:=customerid;
  findid(product,Fzhangbodengji.ComboBox3,theproductid);
  outcustomers['productid']:=theproductid;

end;

procedure TData2.inproductsumpriceeSetText(Sender: TField;
  const Text: String);
begin
 showmessage('此值自动计算');
end;

procedure TData2.inproductAfterInsert(DataSet: TDataSet);
begin
  findid(employee,Fzhangbodengji.ComboBox2,theemployeeid);
  inproduct['employeeid']:=theemployeeid;
  findid(jinhuochangshang,Fzhangbodengji.ComboBox4,supplierid);
  inproduct['jhcsid']:=supplierid;
  findid(product,Fzhangbodengji.ComboBox3,theproductid);
  inproduct['productid']:=theproductid;

end;

procedure TData2.outproductAfterInsert(DataSet: TDataSet);
begin
  findid(employee,Fzhangbodengji.ComboBox2,theemployeeid);
  outproduct['employeeid']:=theemployeeid;
  findid(product,Fzhangbodengji.ComboBox3,theproductid);
  outproduct['productid']:=theproductid;

end;

procedure TData2.sellAfterInsert(DataSet: TDataSet);
begin
  findid(employee,Fzhangbodengji.ComboBox2,theemployeeid);
  sell['employeeid']:=theemployeeid;
  findid(customers,Fzhangbodengji.ComboBox4,customerid);
  sell['customerid']:=customerid;
  findid(product,Fzhangbodengji.ComboBox3,theproductid);
  sell['productid']:=theproductid;

end;

end.

























