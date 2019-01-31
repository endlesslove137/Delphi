object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 425
  ClientWidth = 541
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
    Left = 157
    Top = 126
    Width = 200
    Height = 32
    Caption = 'Excel'#26367#25442'SQLlite'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 157
    Top = 230
    Width = 200
    Height = 33
    Caption = #25214#20986#26377#26410#32763#35793#30340#35760#24405
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 157
    Top = 175
    Width = 200
    Height = 33
    Caption = 'Excel'#22686#21152'SQLlite'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 157
    Top = 275
    Width = 200
    Height = 32
    Caption = #29289#21697#25968#25454#24211#30340#35821#35328#21253
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 31
    Top = 345
    Width = 98
    Height = 33
    Caption = 'Button5'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 196
    Top = 345
    Width = 98
    Height = 33
    Caption = 'Items'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 302
    Top = 345
    Width = 98
    Height = 33
    Caption = 'Monster'
    TabOrder = 6
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 408
    Top = 345
    Width = 98
    Height = 33
    Caption = 'Skill'
    TabOrder = 7
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 31
    Top = 386
    Width = 98
    Height = 32
    Caption = 'Button9'
    TabOrder = 8
    OnClick = Button9Click
  end
  object btn1: TButton
    Left = 333
    Top = 54
    Width = 200
    Height = 32
    Caption = 'Excel'#26367#25442'SQLlite'
    TabOrder = 9
  end
  object ExcelApplication: TExcelApplication
    AutoConnect = False
    ConnectKind = ckNewInstance
    AutoQuit = False
    Left = 80
    Top = 32
  end
  object ExcelWorksheet: TExcelWorksheet
    AutoConnect = False
    ConnectKind = ckNewInstance
    Left = 168
    Top = 32
  end
  object ExcelWorkbook: TExcelWorkbook
    AutoConnect = False
    ConnectKind = ckNewInstance
    Left = 264
    Top = 32
  end
end
