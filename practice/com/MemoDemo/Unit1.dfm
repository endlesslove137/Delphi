object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 252
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object mmo1: TMemo
    Left = 24
    Top = 16
    Width = 449
    Height = 185
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    Lines.Strings = (
      'mmo1')
    TabOrder = 0
  end
  object btn1: TButton
    Left = 24
    Top = 207
    Width = 75
    Height = 25
    Caption = 'font'
    TabOrder = 1
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 398
    Top = 207
    Width = 75
    Height = 25
    Caption = 'color'
    TabOrder = 2
    OnClick = btn2Click
  end
  object dlgFont1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 128
    Top = 32
  end
  object dlgColor1: TColorDialog
    Left = 184
    Top = 24
  end
end
