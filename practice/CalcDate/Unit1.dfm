object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 95
  ClientWidth = 249
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
    Left = 24
    Top = 16
    Width = 13
    Height = 16
    Caption = 'A:'
  end
  object lbl2: TLabel
    Left = 24
    Top = 67
    Width = 12
    Height = 16
    Caption = 'B:'
  end
  object lbl3: TLabel
    Left = 24
    Top = 38
    Width = 13
    Height = 16
    Caption = 'N:'
  end
  object btn1: TSpeedButton
    Left = 176
    Top = 8
    Width = 65
    Height = 22
    Caption = 'A + N = B'
    OnClick = btn1Click
  end
  object btn2: TSpeedButton
    Left = 176
    Top = 36
    Width = 65
    Height = 22
    Caption = 'A -  B = N'
    OnClick = btn2Click
  end
  object btn3: TSpeedButton
    Left = 176
    Top = 65
    Width = 65
    Height = 22
    Caption = 'B -  N = A'
    OnClick = btn3Click
  end
  object dtp1: TDateTimePicker
    Left = 43
    Top = 8
    Width = 111
    Height = 24
    Date = 41271.455453553240000000
    Time = 41271.455453553240000000
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 0
    OnChange = dtp1Change
  end
  object dtp2: TDateTimePicker
    Left = 43
    Top = 64
    Width = 111
    Height = 24
    Date = 41271.455453553240000000
    Time = 41271.455453553240000000
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 1
    OnChange = dtp1Change
  end
  object edt1: TEdit
    Left = 118
    Top = 34
    Width = 36
    Height = 24
    Hint = #26085#24046
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 2
    Text = 'edt1'
    OnChange = dtp1Change
  end
  object edt2: TEdit
    Left = 80
    Top = 34
    Width = 36
    Height = 24
    Hint = #26376#24046
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 3
    Text = 'edt1'
    OnChange = dtp1Change
  end
end
