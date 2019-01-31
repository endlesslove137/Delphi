object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 297
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lst1: TListBox
    Left = 0
    Top = 0
    Width = 385
    Height = 297
    Align = alLeft
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    ItemHeight = 13
    TabOrder = 0
  end
  object btn1: TButton
    Left = 417
    Top = 16
    Width = 121
    Height = 25
    Caption = 'EnumWindows'
    TabOrder = 1
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 417
    Top = 64
    Width = 121
    Height = 33
    Caption = 'EnumProcess'
    TabOrder = 2
    OnClick = btn2Click
  end
end
