object ClientModule1: TClientModule1
  OldCreateOrder = False
  Height = 271
  Width = 415
  object SQLConnection1: TSQLConnection
    DriverName = 'DataSnap'
    LoginPrompt = False
    Params.Strings = (
      'Port=211'
      'CommunicationProtocol=tcp/ip'
      'DatasnapContext=datasnap/')
    Left = 64
    Top = 10
    UniqueId = '{1F59D2AE-FE69-461F-B7A5-49368C3DD9D8}'
  end
  object con1: TDSProviderConnection
    ServerClassName = 'TServerMethods1'
    SQLConnection = SQLConnection1
    Left = 74
    Top = 84
  end
  object CdsStudents: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'ProvStudent'
    RemoteServer = con1
    AfterInsert = CdsStudentsAfterInsert
    Left = 76
    Top = 146
  end
end
