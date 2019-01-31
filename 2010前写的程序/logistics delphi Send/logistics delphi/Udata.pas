unit Udata;

interface

uses
  SysUtils, Classes, DB, DBTables, ADODB;

type
  Tfdata = class(TDataModule)
    command1: TADOCommand;
    conn1: TADOConnection;
    dispatch: TADOTable;
    dsdispatch: TDataSource;
    dsemployees: TDataSource;
    dscars: TDataSource;
    dscustomers: TDataSource;
    dsorderdetail: TDataSource;
    dsreceipt: TDataSource;
    dsorders: TDataSource;
    dsreparation: TDataSource;
    dsstorage: TDataSource;
    dsstoragedetail: TDataSource;
    procedure1: TADOStoredProc;
    temp: TADOQuery;
    dstemp: TDataSource;
    dispatchoid: TBCDField;
    dispatchcarid: TStringField;
    dispatchshipdate: TDateTimeField;
    dispatchremarks: TMemoField;
    dispatchCarInform: TBooleanField;
    receipt: TADOQuery;
    orders: TADOQuery;
    storage: TADOQuery;
    reparation: TADOQuery;
    customers: TADOQuery;
    cars: TADOQuery;
    orderdetail: TADOQuery;
    employees: TADOQuery;
    storagedetail: TADOQuery;
    employeeseid: TBCDField;
    employeesname: TStringField;
    employeesphone: TBCDField;
    employeessex: TStringField;
    employeessalary: TBCDField;
    employeeshiredate: TDateTimeField;
    employeesbirthday: TDateTimeField;
    employeespassword: TStringField;
    employeesdepartment: TStringField;
    employeesremarks: TMemoField;
    reparationinform: TADOQuery;
    dsreparationinform: TDataSource;
    ordersoid: TBCDField;
    orderseid: TBCDField;
    orderscid: TBCDField;
    ordersorderdate: TDateTimeField;
    ordersrequiredate: TDateTimeField;
    orderssvolume: TFloatField;
    orderssweight: TFloatField;
    ordersinsure: TBooleanField;
    orderssmoney: TBCDField;
    ordersstate: TStringField;
    ordersdestination: TStringField;
    ordersremarks: TMemoField;
    ordersNeedday: TIntegerField;
    orderdetailoid: TBCDField;
    orderdetailname: TStringField;
    orderdetailprice: TBCDField;
    orderdetailnumber: TIntegerField;
    orderdetailstate: TStringField;
    orderdetailremarks: TMemoField;
    procedure DataModuleCreate(Sender: TObject);
    procedure employeesAfterPost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fdata: Tfdata;

implementation

{$R *.dfm}

procedure Tfdata.DataModuleCreate(Sender: TObject);
begin
 conn1.Open;
 cars.Open;
 customers.Open;

end;

procedure Tfdata.employeesAfterPost(DataSet: TDataSet);
begin
 ///dataset.Refresh;
end;

end.
