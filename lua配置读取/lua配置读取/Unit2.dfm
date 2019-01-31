object Form2: TForm2
  Left = 193
  Top = 119
  Caption = 'Form2'
  ClientHeight = 236
  ClientWidth = 383
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 56
    Top = 80
    Width = 75
    Height = 25
    Caption = 'StdItems.txt'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 40
    Top = 24
    Width = 297
    Height = 21
    TabOrder = 1
    Text = 'F:\WorkSVN\idgp\AnHei\!SC\Server\data\'
  end
  object Button2: TButton
    Left = 160
    Top = 80
    Width = 75
    Height = 25
    Caption = 'test'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 40
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 3
    OnClick = Button3Click
  end
end
