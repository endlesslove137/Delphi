object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 386
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object lbl1: TLabel
    Left = 10
    Top = 204
    Width = 48
    Height = 16
    Caption = 'Bin si&ze:'
    FocusControl = edtBinSize
  end
  object grpItems: TGroupBox
    Left = 10
    Top = 10
    Width = 267
    Height = 178
    Caption = 'Raw materials'
    TabOrder = 0
    object lbl2: TLabel
      Left = 20
      Top = 30
      Width = 52
      Height = 16
      Caption = '&Quantity:'
      FocusControl = edtQuantity
    end
    object lbl3: TLabel
      Left = 20
      Top = 59
      Width = 68
      Height = 16
      Caption = '&Description:'
      FocusControl = edtDescription
    end
    object lbl4: TLabel
      Left = 20
      Top = 89
      Width = 37
      Height = 16
      Caption = '&Value:'
      FocusControl = edtValue
    end
    object edtQuantity: TEdit
      Left = 98
      Top = 25
      Width = 41
      Height = 24
      ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
      TabOrder = 0
      Text = '1'
    end
    object edtDescription: TEdit
      Left = 98
      Top = 54
      Width = 149
      Height = 24
      ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
      TabOrder = 1
      Text = 'Description'
    end
    object edtValue: TEdit
      Left = 98
      Top = 84
      Width = 41
      Height = 24
      ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
      TabOrder = 2
      Text = '100'
    end
    object btnAdd: TButton
      Left = 87
      Top = 138
      Width = 93
      Height = 31
      Caption = '&Add Item'
      TabOrder = 3
    end
  end
  object btnOptimize: TButton
    Left = 187
    Top = 197
    Width = 92
    Height = 31
    Caption = '&Optimize!'
    TabOrder = 1
  end
  object tvBins: TTreeView
    Left = 8
    Top = 229
    Width = 267
    Height = 149
    Indent = 19
    TabOrder = 2
  end
  object edtBinSize: TEdit
    Left = 69
    Top = 199
    Width = 50
    Height = 24
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 3
    Text = '1000'
  end
end
