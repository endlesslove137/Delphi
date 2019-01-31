object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'datasnap client'
  ClientHeight = 372
  ClientWidth = 646
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object dbnvgr1: TDBNavigator
    Left = 0
    Top = 0
    Width = 646
    Height = 25
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 200
    ExplicitTop = 8
    ExplicitWidth = 240
  end
  object dbgrd1: TDBGrid
    Left = 0
    Top = 25
    Width = 646
    Height = 347
    Align = alClient
    DataSource = ds1
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object con1: TSQLConnection
    DriverName = 'DataSnap'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXDataSnap'
      'HostName=127.0.0.1'
      'Port=8080'
      'CommunicationProtocol=tcp/ip'
      'DatasnapContext=datasnap/'
      
        'DriverAssemblyLoader=Borland.Data.TDBXClientDriverLoader,Borland' +
        '.Data.DbxClientDriver,Version=19.0.0.0,Culture=neutral,PublicKey' +
        'Token=91d62ebb5b0d1b1b'
      'Filters={}'
      'DSProxyPort=8888')
    Connected = True
    Left = 48
    Top = 136
  end
  object con2: TDSProviderConnection
    ServerClassName = 'tServerMethods1'
    Connected = True
    SQLConnection = con1
    Left = 48
    Top = 80
  end
  object Cds1: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    ProviderName = 'dtstprvdr1'
    RemoteServer = con2
    Left = 128
    Top = 152
  end
  object ds1: TDataSource
    DataSet = Cds1
    Left = 216
    Top = 40
  end
end
