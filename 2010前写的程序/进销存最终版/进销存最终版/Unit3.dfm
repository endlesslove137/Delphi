object Fmingxi: TFmingxi
  Left = 182
  Top = 128
  Width = 767
  Height = 469
  Caption = #20449#24687#26126#32454
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 759
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = clSkyBlue
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 81
      Height = 16
      AutoSize = False
      Caption = #23458#25143#21517#31216':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 238
      Top = 16
      Width = 96
      Height = 16
      AutoSize = False
      Caption = #24212#25910#27454#21512#35745#65306
    end
    object SpeedButton1: TSpeedButton
      Left = 454
      Top = 14
      Width = 65
      Height = 22
      Caption = #25253#34920#36755#20986
      Flat = True
      OnClick = SpeedButton1Click
    end
    object ComboBox1: TComboBox
      Left = 86
      Top = 12
      Width = 145
      Height = 24
      Style = csDropDownList
      Ctl3D = False
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
      ItemHeight = 16
      ParentCtl3D = False
      TabOrder = 0
      OnChange = ComboBox1Change
    end
    object Edit1: TEdit
      Left = 330
      Top = 14
      Width = 97
      Height = 22
      Ctl3D = False
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
      ParentCtl3D = False
      TabOrder = 1
    end
  end
  object ComboBox2: TComboBox
    Left = 540
    Top = 10
    Width = 145
    Height = 24
    ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
    ItemHeight = 16
    TabOrder = 1
    Text = 'ComboBox2'
    Visible = False
    Items.Strings = (
      #35831#20320#36873#25321
      #24212#25910#27454#26126#32454
      #24050#25910#27454#26126#32454
      #24212#20184#27454#26126#32454
      #24211#23384#26126#32454
      #21333#39033#20135#21697#20998#26512)
  end
  object Button1: TButton
    Left = 306
    Top = 194
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    Visible = False
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 41
    Width = 759
    Height = 394
    Align = alClient
    Ctl3D = False
    DataSource = Data2.dstemp
    ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = GB2312_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object RvProject1: TRvProject
    Engine = RvSystem1
    Left = 98
    Top = 168
  end
  object RvSystem1: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'ReportPrinter Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    Left = 128
    Top = 168
  end
  object RvDataSetConnection1: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = Data2.ADOStoredProc1
    Left = 156
    Top = 168
  end
end
