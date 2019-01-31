object Fpath: TFpath
  Left = 255
  Top = 218
  Width = 393
  Height = 162
  Caption = #25968#25454#31649#29702
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clBlue
  Font.Height = -16
  Font.Name = #26999#20307'_GB2312'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 74
    Width = 43
    Height = 23
    AutoSize = False
    Caption = #36335#24452#65306
    Transparent = True
  end
  object SpeedButton1: TSpeedButton
    Left = 348
    Top = 70
    Width = 31
    Height = 25
    Caption = '.....'
    Font.Charset = GB2312_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = #26999#20307'_GB2312'
    Font.Style = []
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 70
    Top = 102
    Width = 93
    Height = 25
    Caption = #24320#22987#22791#20221
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 222
    Top = 104
    Width = 97
    Height = 22
    Caption = #24320#22987#24674#22797
    OnClick = SpeedButton3Click
  end
  object Label2: TLabel
    Left = 102
    Top = 16
    Width = 180
    Height = 35
    Caption = #35831#35880#24910#25805#20316
    Font.Charset = GB2312_CHARSET
    Font.Color = clRed
    Font.Height = -35
    Font.Name = #26999#20307'_GB2312'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Edit1: TEdit
    Left = 52
    Top = 72
    Width = 291
    Height = 24
    ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
    TabOrder = 0
  end
  object Animate1: TAnimate
    Left = 62
    Top = 6
    Width = 272
    Height = 60
    CommonAVI = aviCopyFiles
    StopFrame = 31
    Visible = False
  end
end
