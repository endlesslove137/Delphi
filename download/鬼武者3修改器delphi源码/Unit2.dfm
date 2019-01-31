object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #39740#27494#32773'3'#20462#25913#22120
  ClientHeight = 93
  ClientWidth = 229
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 147
    Top = 0
    Width = 81
    Height = 41
    Caption = #21464#36523#39740#27494#32773
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 0
    Top = 0
    Width = 89
    Height = 41
    Caption = #20462#25913#21095#33647
    TabOrder = 1
    OnClick = BitBtn2Click
  end
  object StaticText1: TStaticText
    Left = 8
    Top = 70
    Width = 124
    Height = 17
    Caption = #26816#27979#28216#25103#26159#21542#36816#34892#20013'...'
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 138
    Top = 47
    Width = 97
    Height = 17
    Caption = #20445#25345#21464#36523
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = CheckBox1Click
  end
  object StaticText2: TStaticText
    Left = 8
    Top = 47
    Width = 28
    Height = 17
    Caption = #25968#37327
    TabOrder = 4
  end
  object Edit1: TEdit
    Left = 42
    Top = 43
    Width = 31
    Height = 21
    MaxLength = 2
    TabOrder = 5
    Text = '66'
    OnKeyPress = Edit1KeyPress
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 152
    Top = 56
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = BitBtn1Click
    Left = 208
    Top = 56
  end
end
