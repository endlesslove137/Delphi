object fdata: Tfdata
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 198
  Top = 114
  Height = 199
  Width = 945
  object command1: TADOCommand
    Connection = conn1
    Parameters = <>
    Left = 14
    Top = 108
  end
  object conn1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=logistics;Data Source=.'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 118
    Top = 108
  end
  object dispatch: TADOTable
    Connection = conn1
    CursorType = ctStatic
    AfterPost = employeesAfterPost
    TableName = 'dispatch'
    Left = 145
    Top = 14
    object dispatchoid: TBCDField
      FieldName = 'oid'
      Precision = 18
      Size = 0
    end
    object dispatchcarid: TStringField
      FieldName = 'carid'
      Size = 37
    end
    object dispatchshipdate: TDateTimeField
      FieldName = 'shipdate'
    end
    object dispatchremarks: TMemoField
      FieldName = 'remarks'
      BlobType = ftMemo
    end
    object dispatchCarInform: TBooleanField
      FieldName = 'CarInform'
      Visible = False
    end
  end
  object dsdispatch: TDataSource
    DataSet = dispatch
    Left = 145
    Top = 56
  end
  object dsemployees: TDataSource
    DataSet = employees
    Left = 215
    Top = 56
  end
  object dscars: TDataSource
    DataSet = cars
    Left = 6
    Top = 56
  end
  object dscustomers: TDataSource
    DataSet = customers
    Left = 75
    Top = 56
  end
  object dsorderdetail: TDataSource
    DataSet = orderdetail
    Left = 285
    Top = 56
  end
  object dsreceipt: TDataSource
    DataSet = receipt
    Left = 424
    Top = 56
  end
  object dsorders: TDataSource
    DataSet = orders
    Left = 355
    Top = 56
  end
  object dsreparation: TDataSource
    DataSet = reparation
    Left = 494
    Top = 56
  end
  object dsstorage: TDataSource
    DataSet = storage
    Left = 564
    Top = 56
  end
  object dsstoragedetail: TDataSource
    DataSet = storagedetail
    Left = 634
    Top = 56
  end
  object procedure1: TADOStoredProc
    Active = True
    Connection = conn1
    CursorType = ctStatic
    ProcedureName = #26681#25454#21333#21495#26597#29289#21697';1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = 0
      end
      item
        Name = '@oid'
        Attributes = [paNullable]
        DataType = ftBCD
        Precision = 18
        Value = 20000c
      end>
    Left = 64
    Top = 108
  end
  object temp: TADOQuery
    Connection = conn1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.oid '#25176#36816#32534#21495',b.name '#23458#25143',c.name '#20184#36131#20154',convert(varchar(10),a.ord' +
        'erdate,105) '#23457#35831#26085#26399',a.insure '#26159#21542#25237#20445',a.smoney '#25910#21462#36153#29992',a.destination '#30446#30340#22320
      'from orders a,customers b,employees c'
      'where a.cid=b.cid and c.eid=a.eid and a.oid=2')
    Left = 702
    Top = 14
  end
  object dstemp: TDataSource
    DataSet = temp
    Left = 702
    Top = 56
  end
  object receipt: TADOQuery
    Connection = conn1
    CursorType = ctStatic
    AfterPost = employeesAfterPost
    Parameters = <>
    SQL.Strings = (
      'select * from receipt')
    Left = 423
    Top = 14
  end
  object orders: TADOQuery
    Connection = conn1
    CursorType = ctStatic
    AfterPost = employeesAfterPost
    Parameters = <>
    SQL.Strings = (
      'select * from orders')
    Left = 354
    Top = 14
    object ordersoid: TBCDField
      DisplayWidth = 5
      FieldName = 'oid'
      ReadOnly = True
      Precision = 18
      Size = 0
    end
    object orderseid: TBCDField
      DisplayWidth = 4
      FieldName = 'eid'
      Precision = 18
      Size = 0
    end
    object orderscid: TBCDField
      DisplayWidth = 5
      FieldName = 'cid'
      Precision = 18
      Size = 0
    end
    object ordersorderdate: TDateTimeField
      FieldName = 'orderdate'
      Visible = False
    end
    object ordersrequiredate: TDateTimeField
      DisplayWidth = 11
      FieldName = 'requiredate'
    end
    object orderssvolume: TFloatField
      DisplayWidth = 7
      FieldName = 'svolume'
    end
    object orderssweight: TFloatField
      DisplayWidth = 8
      FieldName = 'sweight'
    end
    object ordersinsure: TBooleanField
      DisplayWidth = 5
      FieldName = 'insure'
    end
    object orderssmoney: TBCDField
      DisplayWidth = 20
      FieldName = 'smoney'
      Precision = 19
    end
    object ordersstate: TStringField
      FieldName = 'state'
      Visible = False
      Size = 17
    end
    object ordersdestination: TStringField
      DisplayWidth = 73
      FieldName = 'destination'
      Size = 73
    end
    object ordersremarks: TMemoField
      DisplayWidth = 10
      FieldName = 'remarks'
      BlobType = ftMemo
    end
    object ordersNeedday: TIntegerField
      DisplayWidth = 10
      FieldName = 'Needday'
    end
  end
  object storage: TADOQuery
    Connection = conn1
    CursorType = ctStatic
    AfterPost = employeesAfterPost
    Parameters = <>
    SQL.Strings = (
      'select * from storage')
    Left = 562
    Top = 14
  end
  object reparation: TADOQuery
    Connection = conn1
    CursorType = ctStatic
    AfterPost = employeesAfterPost
    Parameters = <>
    SQL.Strings = (
      'select *from reparation')
    Left = 493
    Top = 14
  end
  object customers: TADOQuery
    Connection = conn1
    CursorType = ctStatic
    AfterPost = employeesAfterPost
    Parameters = <>
    SQL.Strings = (
      'select * from customers')
    Left = 75
    Top = 14
  end
  object cars: TADOQuery
    Connection = conn1
    CursorType = ctStatic
    AfterPost = employeesAfterPost
    Parameters = <>
    SQL.Strings = (
      'select * from cars')
    Left = 6
    Top = 14
  end
  object orderdetail: TADOQuery
    Connection = conn1
    CursorType = ctStatic
    AfterPost = employeesAfterPost
    Parameters = <>
    SQL.Strings = (
      'select * from orderdetail')
    Left = 284
    Top = 14
    object orderdetailoid: TBCDField
      FieldName = 'oid'
      Precision = 18
      Size = 0
    end
    object orderdetailname: TStringField
      FieldName = 'name'
      Size = 13
    end
    object orderdetailprice: TBCDField
      FieldName = 'price'
      Precision = 19
    end
    object orderdetailnumber: TIntegerField
      FieldName = 'number'
    end
    object orderdetailstate: TStringField
      FieldName = 'state'
      Visible = False
      Size = 17
    end
    object orderdetailremarks: TMemoField
      FieldName = 'remarks'
      BlobType = ftMemo
    end
  end
  object employees: TADOQuery
    Connection = conn1
    CursorType = ctStatic
    AfterPost = employeesAfterPost
    Parameters = <>
    SQL.Strings = (
      'select * from employees')
    Left = 214
    Top = 14
    object employeeseid: TBCDField
      FieldName = 'eid'
      ReadOnly = True
      Visible = False
      Precision = 18
      Size = 0
    end
    object employeesname: TStringField
      FieldName = 'name'
      Size = 13
    end
    object employeesphone: TBCDField
      FieldName = 'phone'
      Precision = 11
      Size = 0
    end
    object employeessex: TStringField
      FieldName = 'sex'
      FixedChar = True
      Size = 2
    end
    object employeessalary: TBCDField
      FieldName = 'salary'
      Precision = 19
    end
    object employeeshiredate: TDateTimeField
      FieldName = 'hiredate'
    end
    object employeesbirthday: TDateTimeField
      FieldName = 'birthday'
    end
    object employeespassword: TStringField
      FieldName = 'password'
      Visible = False
      Size = 11
    end
    object employeesdepartment: TStringField
      FieldName = 'department'
      Size = 73
    end
    object employeesremarks: TMemoField
      FieldName = 'remarks'
      BlobType = ftMemo
    end
  end
  object storagedetail: TADOQuery
    Connection = conn1
    CursorType = ctStatic
    AfterPost = employeesAfterPost
    Parameters = <>
    SQL.Strings = (
      'select * from storagedetail')
    Left = 632
    Top = 14
  end
  object reparationinform: TADOQuery
    Connection = conn1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select a.name,a.phone,c.customerinform'
      
        'from customers a inner join  orders b on a.cid=b.cid inner join ' +
        'reparation c on b.oid=c.rpid'
      'where c.customerinform=0')
    Left = 760
    Top = 14
  end
  object dsreparationinform: TDataSource
    DataSet = reparationinform
    Left = 761
    Top = 56
  end
end
