object ServerMethods1: TServerMethods1
  OldCreateOrder = False
  Height = 150
  Width = 215
  object con1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=D:\work\program\de' +
      'lphi\datasnap\datasnapdemo1SRV\data\test.accdb;Persist Security ' +
      'Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.ACE.OLEDB.12.0'
    Left = 16
    Top = 8
  end
  object tbl1: TADOTable
    Active = True
    Connection = con1
    CursorType = ctStatic
    TableName = 'test'
    Left = 64
    Top = 8
  end
  object dtstprvdr1: TDataSetProvider
    DataSet = tbl1
    Left = 112
    Top = 8
  end
end
