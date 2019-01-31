object Fxitongshezhi: TFxitongshezhi
  Left = 288
  Top = 167
  BorderStyle = bsDialog
  Caption = 'Fxitongshezhi'
  ClientHeight = 385
  ClientWidth = 677
  Color = 10930672
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #26999#20307'_GB2312'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 677
    Height = 280
    Align = alClient
    DataSource = Data2.dsemployee
    ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
    TabOrder = 0
    TitleFont.Charset = GB2312_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = #26999#20307'_GB2312'
    TitleFont.Style = []
  end
  object RadioGroup1: TRadioGroup
    Left = 558
    Top = 80
    Width = 99
    Height = 207
    Caption = 'RadioGroup1'
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = #26999#20307'_GB2312'
    Font.Style = []
    Items.Strings = (
      #21592#24037
      #23458#25143#20449#24687
      #20379#36135#21830#20449#24687
      #20135#21697#20449#24687
      #23494#30721#35774#32622
      #36135#29289#31867#21035)
    ParentFont = False
    TabOrder = 1
    Visible = False
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 280
    Width = 677
    Height = 105
    Align = alBottom
    Caption = #25805#20316
    TabOrder = 2
    object DBNavigator1: TDBNavigator
      Left = 18
      Top = 32
      Width = 377
      Height = 39
      DataSource = Data2.dsemployee
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbEdit, nbPost, nbCancel, nbRefresh]
      Align = alCustom
      Flat = True
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
    end
    object BitBtn1: TBitBtn
      Left = 538
      Top = 34
      Width = 113
      Height = 39
      TabOrder = 1
      Kind = bkClose
    end
    object BitBtn2: TBitBtn
      Left = 410
      Top = 34
      Width = 113
      Height = 39
      Caption = 'Delete'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #26999#20307'_GB2312'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = BitBtn2Click
      Kind = bkAbort
    end
  end
end
