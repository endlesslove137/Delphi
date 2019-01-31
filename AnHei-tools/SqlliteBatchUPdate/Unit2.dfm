object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 475
  ClientWidth = 611
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 17
  object Button1: TButton
    Left = 92
    Top = 94
    Width = 141
    Height = 33
    Caption = 'contents'#25552#21462#20013#25991
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 31
    Top = 160
    Width = 159
    Height = 25
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button2: TButton
    Left = 220
    Top = 157
    Width = 98
    Height = 33
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 366
    Top = 157
    Width = 117
    Height = 33
    Caption = 'Lang'#21040'Mysql'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 241
    Top = 94
    Width = 137
    Height = 33
    Caption = 'lang'#25552#21462#20013#25991
    TabOrder = 4
    OnClick = Button4Click
  end
  object Edit2: TEdit
    Left = 31
    Top = 335
    Width = 389
    Height = 25
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 5
    Text = 'Edit2'
  end
  object Button5: TButton
    Left = 428
    Top = 332
    Width = 138
    Height = 33
    Caption = #29983#25104'UPDATE'#33050#26412
    TabOrder = 6
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 115
    Top = 387
    Width = 98
    Height = 33
    Caption = #35835#21462'lang.txt'
    TabOrder = 7
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 241
    Top = 387
    Width = 137
    Height = 33
    Caption = #25171#24320'Excel'#36716#25442
    TabOrder = 8
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 490
    Top = 157
    Width = 98
    Height = 33
    Caption = 'Mysql'#21040'Lang'
    TabOrder = 9
    OnClick = Button8Click
  end
  object Edit3: TEdit
    Left = 31
    Top = 428
    Width = 159
    Height = 25
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 10
    Text = 'Quy?t chi?n thi'#234'n h?, v?n quan kh?ng s?!'
  end
  object Button9: TButton
    Left = 418
    Top = 387
    Width = 99
    Height = 33
    Caption = #21518#21488'xml'
    TabOrder = 11
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 366
    Top = 208
    Width = 222
    Height = 33
    Caption = 'Lang Excel'#21040'Mysql'
    TabOrder = 12
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 358
    Top = 31
    Width = 190
    Height = 33
    Caption = #22788#29702#21516#21517#32763#35793#19981#21516
    TabOrder = 13
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 366
    Top = 259
    Width = 222
    Height = 33
    Caption = 'contents Excel'#21040'Mysql'
    TabOrder = 14
    OnClick = Button12Click
  end
  object Button13: TButton
    Left = 63
    Top = 282
    Width = 98
    Height = 33
    Caption = #35821#35328#21253#21512#24182
    TabOrder = 15
    OnClick = Button13Click
  end
  object SQLConnection: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    Params.Strings = (
      'DriverName=MySQL'
      'HostName=192.168.0.203'
      'Database=gstatic'
      'User_Name=root'
      'Password=xianhaiwangluo'
      'ServerCharSet=utf-8'
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'ConnectTimeout=60')
    VendorLib = 'LIBMYSQL.dll'
    Left = 48
    Top = 16
  end
  object quContents: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection
    Left = 144
    Top = 16
  end
  object quIdTable: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection
    Left = 240
    Top = 16
  end
  object ExcelApplication: TExcelApplication
    AutoConnect = False
    ConnectKind = ckNewInstance
    AutoQuit = False
    Left = 48
    Top = 168
  end
  object ExcelWorksheet: TExcelWorksheet
    AutoConnect = False
    ConnectKind = ckNewInstance
    Left = 136
    Top = 168
  end
  object ExcelWorkbook: TExcelWorkbook
    AutoConnect = False
    ConnectKind = ckNewInstance
    Left = 232
    Top = 168
  end
  object quUpdate: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection
    Left = 304
    Top = 72
  end
end
