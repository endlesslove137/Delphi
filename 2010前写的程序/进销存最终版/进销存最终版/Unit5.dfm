object Fmenu3: TFmenu3
  Left = 282
  Top = 128
  Width = 517
  Height = 366
  Caption = #26126#32454#34920
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 509
    Height = 45
    Align = alClient
    Color = 9240460
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 320
      Top = 5
      Width = 161
      Height = 27
      Caption = #25171#21360#25253#34920'('#24050#25910')'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object Label1: TLabel
      Left = 46
      Top = 18
      Width = 123
      Height = 21
      AutoSize = False
      Caption = 'Label1'
    end
    object SpeedButton2: TSpeedButton
      Left = 302
      Top = 5
      Width = 161
      Height = 27
      Caption = #25171#21360#25253#34920
      Flat = True
      OnClick = SpeedButton2Click
    end
    object Edit1: TEdit
      Left = 178
      Top = 16
      Width = 121
      Height = 22
      Ctl3D = False
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
      ParentCtl3D = False
      TabOrder = 0
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 45
    Width = 509
    Height = 287
    Align = alBottom
    ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
    TabOrder = 1
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
end
