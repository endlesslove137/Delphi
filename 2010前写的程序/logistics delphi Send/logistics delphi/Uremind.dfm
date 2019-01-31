object Fremind: TFremind
  Left = 381
  Top = 160
  Width = 446
  Height = 480
  Caption = #28201#39336#25552#37266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 438
    Height = 446
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #26410#20837#24211#25552#37266
      object DBGrid1: TDBGrid
        Left = 0
        Top = 41
        Width = 430
        Height = 377
        Align = alClient
        ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 430
        Height = 41
        Align = alTop
        Alignment = taLeftJustify
        Caption = '        '#12288#12288#12288#12288#12288#12288#26410#20837#24211#21333#21495#22914#19979
        TabOrder = 1
        object Label1: TLabel
          Left = 224
          Top = 16
          Width = 24
          Height = 13
          AutoSize = False
          Caption = #20849#26377
        end
        object Label2: TLabel
          Left = 306
          Top = 16
          Width = 47
          Height = 13
          AutoSize = False
          Caption = #26465#35760#24405
        end
        object Label3: TLabel
          Left = 259
          Top = 14
          Width = 45
          Height = 16
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton1: TSpeedButton
          Left = 14
          Top = 10
          Width = 61
          Height = 22
          Caption = #26597#30475
          OnClick = SpeedButton1Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #26410#20998#37197#25552#37266
      ImageIndex = 1
      object DBGrid2: TDBGrid
        Left = 0
        Top = 41
        Width = 430
        Height = 377
        Align = alClient
        ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 430
        Height = 41
        Align = alTop
        Alignment = taLeftJustify
        Caption = '       '#12288#12288#12288#12288#12288#12288#12288#12288' '#26410#20998#37197#21333#21495#22914#19979
        TabOrder = 1
        object Label4: TLabel
          Left = 248
          Top = 14
          Width = 24
          Height = 13
          AutoSize = False
          Caption = #20849#26377
        end
        object Label5: TLabel
          Left = 330
          Top = 14
          Width = 47
          Height = 13
          AutoSize = False
          Caption = #26465#35760#24405
        end
        object Label6: TLabel
          Left = 280
          Top = 12
          Width = 41
          Height = 16
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton2: TSpeedButton
          Left = 24
          Top = 10
          Width = 79
          Height = 22
          Caption = #26597#30475
          OnClick = SpeedButton2Click
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #20219#21153#25552#37266
      ImageIndex = 2
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 430
        Height = 41
        Align = alTop
        Alignment = taLeftJustify
        Caption = '        '#12288#12288#12288#12288#12288'    '#20170#26085#21496#26426#20219#21153
        TabOrder = 0
        object Label7: TLabel
          Left = 224
          Top = 16
          Width = 24
          Height = 13
          AutoSize = False
          Caption = #20849#26377
        end
        object Label8: TLabel
          Left = 306
          Top = 16
          Width = 47
          Height = 13
          AutoSize = False
          Caption = #26465#35760#24405
        end
        object Label9: TLabel
          Left = 256
          Top = 14
          Width = 41
          Height = 16
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton3: TSpeedButton
          Left = 14
          Top = 10
          Width = 75
          Height = 22
          Caption = #26597#30475
          OnClick = SpeedButton3Click
        end
      end
      object GroupBox1: TGroupBox
        Left = 52
        Top = 86
        Width = 299
        Height = 187
        Caption = #20219#21153#21517#21333
        TabOrder = 1
        Visible = False
        object Label10: TLabel
          Left = 22
          Top = 24
          Width = 117
          Height = 13
          AutoSize = False
          Caption = #20170#22825#26377#20219#21153#30340#21496#26426
        end
        object Label11: TLabel
          Left = 164
          Top = 44
          Width = 60
          Height = 13
          Caption = #30005#35805#21495#30721#65306
        end
        object Label13: TLabel
          Left = 172
          Top = 68
          Width = 115
          Height = 17
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton4: TSpeedButton
          Left = 92
          Top = 154
          Width = 103
          Height = 22
          Caption = #29616#22312#36890#30693
          Enabled = False
          OnClick = SpeedButton4Click
        end
        object ListBox1: TListBox
          Left = 20
          Top = 48
          Width = 121
          Height = 97
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
          ItemHeight = 13
          TabOrder = 0
          OnClick = ListBox1Click
        end
        object CheckBox2: TCheckBox
          Left = 168
          Top = 106
          Width = 97
          Height = 17
          Caption = #24050#36890#30693#21496#26426
          Enabled = False
          TabOrder = 1
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #36180#20607#36890#30693
      ImageIndex = 3
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 430
        Height = 41
        Align = alTop
        Alignment = taLeftJustify
        Caption = '        '#12288#12288#12288#12288#12288#12288#12288#24212#36890#30693#30340#23458#25143#22914#19979
        TabOrder = 0
        object Label12: TLabel
          Left = 224
          Top = 16
          Width = 24
          Height = 13
          AutoSize = False
          Caption = #20849#26377
        end
        object Label14: TLabel
          Left = 306
          Top = 16
          Width = 47
          Height = 13
          AutoSize = False
          Caption = #26465#35760#24405
        end
        object Label15: TLabel
          Left = 256
          Top = 14
          Width = 41
          Height = 16
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton5: TSpeedButton
          Left = 14
          Top = 10
          Width = 75
          Height = 22
          Caption = #26597#30475
          OnClick = SpeedButton5Click
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 290
        Width = 430
        Height = 128
        Align = alBottom
        Caption = 'GroupBox2'
        TabOrder = 1
        object DBText1: TDBText
          Left = 124
          Top = 56
          Width = 63
          Height = 15
          DataField = 'phone'
          DataSource = fdata.dsreparationinform
        end
        object DBText2: TDBText
          Left = 124
          Top = 24
          Width = 63
          Height = 15
          DataField = 'name'
          DataSource = fdata.dsreparationinform
        end
        object Label16: TLabel
          Left = 52
          Top = 22
          Width = 56
          Height = 13
          AutoSize = False
          Caption = #23458#25143#21517#31216
        end
        object Label17: TLabel
          Left = 54
          Top = 58
          Width = 56
          Height = 13
          AutoSize = False
          Caption = #32852#31995#26041#24335
        end
        object DBCheckBox1: TDBCheckBox
          Left = 66
          Top = 88
          Width = 97
          Height = 17
          Caption = #24050#36890#30693
          DataField = 'customerinform'
          DataSource = fdata.dsreparationinform
          TabOrder = 0
          ValueChecked = 'True'
          ValueUnchecked = 'False'
          OnClick = DBCheckBox1Click
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 41
        Width = 430
        Height = 249
        Align = alClient
        Caption = 'GroupBox3'
        TabOrder = 2
        object DBGrid3: TDBGrid
          Left = 2
          Top = 15
          Width = 426
          Height = 207
          Align = alClient
          DataSource = fdata.dsreparationinform
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
        object DBNavigator1: TDBNavigator
          Left = 2
          Top = 222
          Width = 426
          Height = 25
          DataSource = fdata.dsreparationinform
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbEdit, nbPost, nbCancel, nbRefresh]
          Align = alBottom
          TabOrder = 1
        end
      end
    end
  end
end
