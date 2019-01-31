object Fselectdate: TFselectdate
  Left = 275
  Top = 207
  AutoScroll = False
  Caption = #36873#25321#26085#26399
  ClientHeight = 118
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 34
    Top = 18
    Width = 64
    Height = 16
    Caption = #24320#22987#26102#38388
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 34
    Top = 58
    Width = 64
    Height = 16
    Caption = #25130#27490#26102#38388
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object DateTimePicker1: TDateTimePicker
    Left = 156
    Top = 16
    Width = 148
    Height = 21
    Date = 37143.878800960700000000
    Time = 37143.878800960700000000
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
    ParentFont = False
    TabOrder = 0
  end
  object DateTimePicker2: TDateTimePicker
    Left = 156
    Top = 56
    Width = 148
    Height = 21
    Date = 39959.000011574070000000
    Time = 39959.000011574070000000
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
    ParentFont = False
    TabOrder = 1
  end
  object RadioGroup1: TRadioGroup
    Left = 322
    Top = 8
    Width = 201
    Height = 103
    Caption = 'RadioGroup1'
    Items.Strings = (
      #36827#36135#32479#35745
      #38144#21806#32479#35745
      #36864#36135#32479#35745)
    TabOrder = 2
    Visible = False
  end
  object Button1: TButton
    Left = 122
    Top = 88
    Width = 99
    Height = 25
    Caption = #24320#22987#26597#35810
    TabOrder = 3
    OnClick = Button1Click
  end
end
