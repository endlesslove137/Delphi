object Fzhangbodengji: TFzhangbodengji
  Left = 285
  Top = 71
  BorderStyle = bsToolWindow
  Caption = #36134#31807#30331#35760
  ClientHeight = 450
  ClientWidth = 574
  Color = 10930672
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 45
    Width = 574
    Height = 362
    Align = alClient
    Caption = #21015#34920
    Color = clSkyBlue
    ParentColor = False
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 2
      Top = 15
      Width = 570
      Height = 212
      Align = alClient
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 287
      Width = 570
      Height = 73
      Align = alBottom
      Caption = #24555#25463#32534#36753#25968#25454#21306
      TabOrder = 2
      object Label7: TLabel
        Left = 40
        Top = 22
        Width = 57
        Height = 13
        AutoSize = False
        Caption = #20135#21697#36873#25321
      end
      object Label8: TLabel
        Left = 200
        Top = 22
        Width = 69
        Height = 15
        AutoSize = False
        Caption = #23458#25143#36873#25321
      end
      object Label9: TLabel
        Left = 358
        Top = 20
        Width = 97
        Height = 19
        AutoSize = False
        Caption = #20379#24212#21830#36873#25321
      end
      object ComboBox3: TComboBox
        Left = 40
        Top = 40
        Width = 137
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
        ItemHeight = 13
        TabOrder = 0
      end
      object ComboBox4: TComboBox
        Left = 200
        Top = 40
        Width = 137
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
        ItemHeight = 13
        TabOrder = 1
      end
      object ComboBox5: TComboBox
        Left = 360
        Top = 40
        Width = 137
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
        ItemHeight = 13
        TabOrder = 2
      end
    end
    object GroupBox4: TGroupBox
      Left = 2
      Top = 227
      Width = 570
      Height = 60
      Align = alBottom
      Caption = #35760#24405#25805#20316
      TabOrder = 3
      object DBNavigator1: TDBNavigator
        Left = 7
        Top = 14
        Width = 396
        Height = 39
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbEdit, nbPost, nbCancel, nbRefresh]
        Flat = True
        TabOrder = 0
      end
      object BitBtn2: TBitBtn
        Left = 434
        Top = 16
        Width = 113
        Height = 39
        Caption = 'Delete'
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #26999#20307'_GB2312'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = BitBtn2Click
        Kind = bkAbort
      end
    end
    object ComboBox1: TComboBox
      Left = 327
      Top = 155
      Width = 145
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
      ItemHeight = 13
      TabOrder = 0
      Text = 'ComboBox1'
      Visible = False
      Items.Strings = (
        #35831#20320#36873#25321
        #36827#36135#30331#35760
        #38144#21806#30331#35760
        #20844#21496#36864#36135#30331#35760
        #23458#25143#36864#36135#30331#35760
        #32467#36134#32479#35745
        #20184#27454#32479#35745
        #25903#20986#32479#35745)
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 407
    Width = 574
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    Color = clMoneyGreen
    TabOrder = 1
    object Label12: TLabel
      Left = 16
      Top = 12
      Width = 57
      Height = 13
      AutoSize = False
      Caption = #24635#35745#37329#39069
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 204
      Top = 12
      Width = 57
      Height = 13
      AutoSize = False
      Caption = #23454#20184#37329#39069
      Color = clActiveBorder
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 382
      Top = 12
      Width = 40
      Height = 13
      AutoSize = False
      Caption = #27424#27454
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 82
      Top = 12
      Width = 3
      Height = 13
    end
    object Label3: TLabel
      Left = 270
      Top = 12
      Width = 3
      Height = 13
    end
    object Label6: TLabel
      Left = 420
      Top = 12
      Width = 3
      Height = 13
    end
    object BitBtn5: TBitBtn
      Left = 498
      Top = 6
      Width = 65
      Height = 25
      Caption = #20851#38381
      TabOrder = 0
      Kind = bkClose
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 0
    Width = 574
    Height = 45
    Align = alTop
    Caption = #23450#20301#21306#22495
    Color = 10539763
    ParentColor = False
    TabOrder = 2
    object Label4: TLabel
      Left = 32
      Top = 18
      Width = 24
      Height = 13
      Caption = #21592#24037
    end
    object Label5: TLabel
      Left = 218
      Top = 12
      Width = 45
      Height = 25
      AutoSize = False
      Caption = #24320#22987#26597#35810#26102#38388
      Color = clActiveBorder
      ParentColor = False
      Transparent = True
      WordWrap = True
    end
    object ComboBox2: TComboBox
      Left = 68
      Top = 16
      Width = 113
      Height = 19
      Style = csOwnerDrawFixed
      Ctl3D = False
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 0
      OnChange = ComboBox2Change
    end
    object DateTimePicker1: TDateTimePicker
      Left = 270
      Top = 16
      Width = 137
      Height = 20
      Date = 39796.000000000000000000
      Time = 39796.000000000000000000
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
      TabOrder = 1
    end
    object BitBtn1: TBitBtn
      Left = 476
      Top = 14
      Width = 75
      Height = 25
      Caption = '&Search'
      TabOrder = 2
      OnClick = BitBtn1Click
      Kind = bkYes
    end
  end
end
