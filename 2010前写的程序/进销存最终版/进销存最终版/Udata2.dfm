object Data2: TData2
  OldCreateOrder = False
  Left = 253
  Top = 149
  Height = 224
  Width = 864
  object jinhuochangshang: TADOTable
    Connection = ADOConnection1
    CursorType = ctDynamic
    TableName = 'jinhuochangshang'
    Left = 16
    Top = 80
    object jinhuochangshangID: TAutoIncField
      FieldName = 'ID'
      ReadOnly = True
    end
    object jinhuochangshangname: TStringField
      DisplayLabel = 'Name'
      FieldName = 'name'
      Size = 17
    end
    object jinhuochangshangAddress: TStringField
      FieldName = 'Address'
      Size = 37
    end
    object jinhuochangshangphone: TStringField
      DisplayLabel = 'Phone'
      FieldName = 'phone'
      Size = 11
    end
  end
  object category: TADOTable
    Connection = ADOConnection1
    CursorType = ctDynamic
    TableName = 'category'
    Left = 85
    Top = 80
    object categoryid: TAutoIncField
      DisplayLabel = 'ID'
      FieldName = 'id'
      ReadOnly = True
    end
    object categoryname: TStringField
      DisplayLabel = 'Name'
      FieldName = 'name'
      Size = 37
    end
    object categorymemo: TStringField
      DisplayLabel = 'Memo'
      FieldName = 'memo'
      Size = 37
    end
  end
  object product: TADOTable
    Connection = ADOConnection1
    CursorType = ctDynamic
    TableName = 'product'
    Left = 153
    Top = 80
    object productid: TAutoIncField
      DisplayLabel = 'ID'
      FieldName = 'id'
      ReadOnly = True
    end
    object productjinhuochangshangid: TIntegerField
      DisplayLabel = 'SupplierID'
      FieldName = 'jinhuochangshangid'
    end
    object productcategoryid: TIntegerField
      DisplayLabel = 'CategoryID'
      FieldName = 'categoryid'
    end
    object productname: TStringField
      DisplayLabel = 'Name'
      FieldName = 'name'
      Size = 37
    end
    object productprice: TBCDField
      DisplayLabel = 'Price'
      FieldName = 'price'
      Precision = 19
    end
    object productstocks: TIntegerField
      DisplayLabel = 'Stocks'
      FieldName = 'stocks'
    end
  end
  object inproduct: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    BeforeInsert = outcustomersBeforeInsert
    AfterInsert = inproductAfterInsert
    TableName = 'Inproduct'
    Left = 220
    Top = 80
    object inproductID: TIntegerField
      FieldName = 'ID'
    end
    object inproductemployeeid: TIntegerField
      DisplayLabel = 'EmployeeID'
      FieldName = 'employeeid'
    end
    object inproductproductid: TIntegerField
      DisplayLabel = 'ProductID'
      FieldName = 'productid'
    end
    object inproductjhcsid: TIntegerField
      DisplayLabel = 'SupplierID'
      FieldName = 'jhcsid'
    end
    object inproductNumber: TIntegerField
      FieldName = 'Number'
    end
    object inproductprice: TBCDField
      DisplayLabel = 'Price'
      FieldName = 'price'
      Precision = 19
    end
    object inproductcush: TBCDField
      DisplayLabel = 'Cush'
      FieldName = 'cush'
      Precision = 19
    end
    object inproductsumpricee: TBCDField
      DisplayLabel = 'SumPricee'
      FieldName = 'sumpricee'
      ReadOnly = True
      OnSetText = inproductsumpriceeSetText
      Precision = 19
    end
    object inproductdate: TDateTimeField
      DisplayLabel = 'Date'
      FieldName = 'date'
    end
  end
  object outproduct: TADOTable
    Connection = ADOConnection1
    CursorType = ctDynamic
    BeforeInsert = outcustomersBeforeInsert
    AfterInsert = outproductAfterInsert
    TableName = 'Outproduct'
    Left = 288
    Top = 80
    object outproductID: TIntegerField
      FieldName = 'ID'
    end
    object outproductemployeeid: TIntegerField
      DisplayLabel = 'EmployeeID'
      FieldName = 'employeeid'
    end
    object outproductinproductid: TIntegerField
      DisplayLabel = 'InProductID'
      FieldName = 'inproductid'
    end
    object outproductproductID: TIntegerField
      DisplayLabel = 'ProductID'
      FieldName = 'productID'
    end
    object outproductNumber: TIntegerField
      FieldName = 'Number'
    end
    object outproductcush: TBCDField
      DisplayLabel = 'Cush'
      FieldName = 'cush'
      Precision = 19
    end
    object outproductsumpricee: TBCDField
      DisplayLabel = 'SumPricee'
      FieldName = 'sumpricee'
      OnSetText = inproductsumpriceeSetText
      Precision = 19
    end
    object outproductdate: TDateTimeField
      DisplayLabel = 'Date'
      FieldName = 'date'
    end
  end
  object employee: TADOTable
    Connection = ADOConnection1
    CursorType = ctDynamic
    TableName = 'Employee'
    Left = 355
    Top = 80
    object employeeid: TAutoIncField
      DisplayLabel = 'ID'
      FieldName = 'id'
      ReadOnly = True
    end
    object employeeName: TStringField
      FieldName = 'Name'
      Size = 17
    end
    object employeesex: TStringField
      DisplayLabel = 'Sex'
      FieldName = 'sex'
      Size = 2
    end
    object employeebirthday: TDateTimeField
      DisplayLabel = 'Birthday'
      FieldName = 'birthday'
    end
    object employeephone: TStringField
      DisplayLabel = 'Phone'
      FieldName = 'phone'
      Size = 11
    end
    object employeeAddress: TStringField
      FieldName = 'Address'
      Size = 50
    end
    object employeesalary: TBCDField
      DisplayLabel = 'Salary'
      FieldName = 'salary'
      Precision = 19
    end
    object employeeemployeedate: TDateTimeField
      DisplayLabel = 'HireDate'
      FieldName = 'employeedate'
    end
  end
  object dsjinhuochangshang: TDataSource
    DataSet = jinhuochangshang
    Left = 20
    Top = 4
  end
  object dscategory: TDataSource
    DataSet = category
    Left = 87
    Top = 4
  end
  object dsproduct: TDataSource
    DataSet = product
    Left = 154
    Top = 4
  end
  object dsinproduct: TDataSource
    DataSet = inproduct
    Left = 222
    Top = 4
  end
  object dsoutproduct: TDataSource
    DataSet = outproduct
    Left = 289
    Top = 4
  end
  object dsemployee: TDataSource
    DataSet = employee
    Left = 356
    Top = 4
  end
  object dscustomers: TDataSource
    DataSet = customers
    Left = 424
    Top = 4
  end
  object dssell: TDataSource
    DataSet = sell
    Left = 485
    Top = 4
  end
  object dslogin: TDataSource
    DataSet = login
    Left = 558
    Top = 4
  end
  object dsoutcustomers: TDataSource
    DataSet = outcustomers
    Left = 626
    Top = 4
  end
  object customers: TADOTable
    Connection = ADOConnection1
    CursorType = ctDynamic
    TableName = 'customers'
    Left = 423
    Top = 80
    object customersID: TAutoIncField
      FieldName = 'ID'
      ReadOnly = True
    end
    object customersName: TStringField
      FieldName = 'Name'
      Size = 10
    end
    object customerslinkman: TStringField
      DisplayLabel = 'LinkerName'
      FieldName = 'linkman'
      Size = 17
    end
    object customersphone: TStringField
      DisplayLabel = 'Phone'
      FieldName = 'phone'
      Size = 11
    end
    object customersAddress: TStringField
      FieldName = 'Address'
      Size = 57
    end
  end
  object sell: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    BeforeInsert = outcustomersBeforeInsert
    AfterInsert = sellAfterInsert
    TableName = 'sell'
    Left = 490
    Top = 80
    object sellid: TIntegerField
      DisplayLabel = 'ID'
      FieldName = 'id'
    end
    object sellcustomerId: TIntegerField
      DisplayLabel = 'CustomerID'
      FieldName = 'customerId'
    end
    object sellemployeeid: TIntegerField
      DisplayLabel = 'EmployeeID'
      FieldName = 'employeeid'
    end
    object sellproductID: TIntegerField
      DisplayLabel = 'ProductID'
      FieldName = 'productID'
    end
    object sellnumber: TIntegerField
      DisplayLabel = 'Number'
      FieldName = 'number'
    end
    object sellagio: TIntegerField
      DisplayLabel = 'Discount'
      FieldName = 'agio'
    end
    object sellcush: TBCDField
      DisplayLabel = 'Cush'
      FieldName = 'cush'
      Precision = 19
    end
    object sellSumpricee: TBCDField
      DisplayLabel = 'SumPricee'
      FieldName = 'Sumpricee'
      OnSetText = inproductsumpriceeSetText
      Precision = 19
    end
    object selldate: TDateTimeField
      DisplayLabel = 'Date'
      FieldName = 'date'
    end
  end
  object login: TADOTable
    Connection = ADOConnection1
    CursorType = ctDynamic
    TableName = 'login'
    Left = 560
    Top = 80
    object loginname: TStringField
      DisplayLabel = 'Name'
      FieldName = 'name'
      Size = 37
    end
    object loginpassword: TStringField
      DisplayLabel = 'PassWord'
      FieldName = 'password'
      Size = 37
    end
    object loginisadmin: TBooleanField
      FieldName = 'isadmin'
    end
  end
  object outcustomers: TADOTable
    Connection = ADOConnection1
    CursorType = ctDynamic
    BeforeInsert = outcustomersBeforeInsert
    AfterInsert = outcustomersAfterInsert
    TableName = 'Outcustomers'
    Left = 626
    Top = 80
    object outcustomersid: TAutoIncField
      DisplayLabel = 'ID'
      FieldName = 'id'
      ReadOnly = True
    end
    object outcustomerssellId: TIntegerField
      DisplayLabel = 'SellID'
      FieldName = 'sellId'
    end
    object outcustomerscustomerid: TIntegerField
      DisplayLabel = 'CustomerID'
      FieldName = 'customerid'
    end
    object outcustomersemployeeid: TIntegerField
      DisplayLabel = 'EmployeeID'
      FieldName = 'employeeid'
    end
    object outcustomersproductid: TIntegerField
      DisplayLabel = 'ProductID'
      FieldName = 'productid'
    end
    object outcustomersnumber: TIntegerField
      DisplayLabel = 'Number'
      FieldName = 'number'
    end
    object outcustomerscush: TBCDField
      DisplayLabel = 'Cush'
      FieldName = 'cush'
      Precision = 19
    end
    object outcustomersSumpricee: TBCDField
      DisplayLabel = 'SumPricee'
      FieldName = 'Sumpricee'
      OnSetText = inproductsumpriceeSetText
      Precision = 19
    end
    object outcustomersdate: TDateTimeField
      DisplayLabel = 'Date'
      FieldName = 'date'
    end
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=jxc;Data Source=.'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 704
    Top = 44
  end
  object dstemp: TDataSource
    DataSet = qtemp
    Left = 72
    Top = 132
  end
  object qtemp: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 124
    Top = 136
  end
  object sumout: TTable
    Left = 178
    Top = 134
  end
  object dssumout: TDataSource
    Left = 234
    Top = 134
  end
  object ADOStoredProc1: TADOStoredProc
    Connection = ADOConnection1
    ProcedureName = #21378#23478#26159#21542#36827#36135';1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = 0
      end
      item
        Name = '@customer'
        Attributes = [paNullable]
        DataType = ftString
        Size = 37
        Value = #24352#27663#20844#21496
      end>
    Left = 300
    Top = 136
  end
  object back: TADOCommand
    Connection = ADOConnection1
    Parameters = <>
    Left = 402
    Top = 134
  end
end
