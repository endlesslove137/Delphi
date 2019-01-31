object ServerMethods1: TServerMethods1
  OldCreateOrder = False
  OnCreate = DSServerModuleCreate
  OnDestroy = DSServerModuleDestroy
  Height = 288
  Width = 290
  object con1: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.ACE.OLEDB.12.0;User ID=Admin;Data Source=D:\w' +
      'ork\program\delphi\datasnap\datasnapdemo1SRV\data\test.accdb;Mod' +
      'e=Share Deny None;Persist Security Info=False;Jet OLEDB:System d' +
      'atabase="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Passwor' +
      'd="";Jet OLEDB:Engine Type=6;Jet OLEDB:Database Locking Mode=1;J' +
      'et OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transac' +
      'tions=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create Syst' +
      'em Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don' +
      #39't Copy Locale on Compact=False;Jet OLEDB:Compact Without Replic' +
      'a Repair=False;Jet OLEDB:SFP=False;Jet OLEDB:Support Complex Dat' +
      'a=False'
    LoginPrompt = False
    Provider = 'Microsoft.ACE.OLEDB.12.0'
    Left = 34
    Top = 36
  end
  object tbl1: TADOTable
    Connection = con1
    TableName = 'students'
    Left = 36
    Top = 104
  end
  object ProvStudent: TDataSetProvider
    DataSet = tbl1
    Left = 46
    Top = 172
  end
end
