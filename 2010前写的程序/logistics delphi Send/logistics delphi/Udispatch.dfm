object Fdispatch: TFdispatch
  Left = 306
  Top = 155
  Width = 629
  Height = 551
  Caption = #35843#24230#20998#37197
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #26999#20307'_GB2312'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 621
    Height = 517
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #32534#36753
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 613
        Height = 339
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object SpeedButton1: TSpeedButton
          Left = 486
          Top = 288
          Width = 119
          Height = 39
          Caption = #36864#20986
          OnClick = SpeedButton1Click
        end
        object SpeedButton2: TSpeedButton
          Left = 516
          Top = 14
          Width = 69
          Height = 61
          Caption = #28155#21152
          OnClick = SpeedButton2Click
        end
        object SpeedButton3: TSpeedButton
          Left = 516
          Top = 80
          Width = 71
          Height = 61
          Caption = #20462#25913
          OnClick = SpeedButton3Click
        end
        object SpeedButton4: TSpeedButton
          Left = 518
          Top = 146
          Width = 69
          Height = 59
          Caption = #21024#38500
          OnClick = SpeedButton4Click
        end
        object SpeedButton5: TSpeedButton
          Left = 518
          Top = 212
          Width = 69
          Height = 59
          Caption = #20445#23384
          OnClick = SpeedButton5Click
        end
        object GroupBox1: TGroupBox
          Left = 177
          Top = 6
          Width = 146
          Height = 169
          Caption = #26085#26399#20998#37197
          TabOrder = 0
          object Label3: TLabel
            Left = 13
            Top = 18
            Width = 64
            Height = 16
            Caption = #25176#36816#26085#26399
          end
          object Label6: TLabel
            Left = 11
            Top = 68
            Width = 128
            Height = 16
            Caption = #23458#25143#35201#27714#21040#36798#26085#26399
          end
          object Label7: TLabel
            Left = 9
            Top = 122
            Width = 128
            Height = 16
            Caption = #26412#21333#20272#35745#35201#29992#26085#26399
          end
          object Label8: TLabel
            Left = 28
            Top = 146
            Width = 51
            Height = 16
            AutoSize = False
            Font.Charset = GB2312_CHARSET
            Font.Color = clRed
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
          end
          object Label9: TLabel
            Left = 82
            Top = 148
            Width = 48
            Height = 16
            Caption = #65288#22825#65289
          end
          object DateTimePicker1: TDateTimePicker
            Left = 23
            Top = 36
            Width = 106
            Height = 24
            Date = 39973.387174652780000000
            Time = 39973.387174652780000000
            ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
            TabOrder = 0
          end
          object DateTimePicker2: TDateTimePicker
            Left = 23
            Top = 90
            Width = 108
            Height = 24
            Date = 39973.387174652780000000
            Time = 39973.387174652780000000
            Enabled = False
            ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
            TabOrder = 1
          end
        end
        object GroupBox3: TGroupBox
          Left = 328
          Top = 6
          Width = 179
          Height = 167
          Caption = #22791#27880
          TabOrder = 1
          object Memo1: TMemo
            Left = 10
            Top = 24
            Width = 159
            Height = 127
            ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
            Lines.Strings = (
              '')
            TabOrder = 0
          end
        end
        object GroupBox4: TGroupBox
          Left = 2
          Top = 4
          Width = 167
          Height = 169
          Caption = #25176#36816#21333#21495
          TabOrder = 2
          object Label1: TLabel
            Left = 10
            Top = 24
            Width = 80
            Height = 16
            Caption = #25176#36816#21333#21495#65306
          end
          object Label4: TLabel
            Left = 120
            Top = 88
            Width = 16
            Height = 16
            Caption = 'kg'
          end
          object Label10: TLabel
            Left = 122
            Top = 126
            Width = 16
            Height = 16
            Caption = 'm3'
          end
          object Label11: TLabel
            Left = 14
            Top = 88
            Width = 32
            Height = 16
            Caption = #37325#37327
          end
          object Label12: TLabel
            Left = 14
            Top = 122
            Width = 32
            Height = 16
            Caption = #20307#31215
          end
          object Label17: TLabel
            Left = 47
            Top = 120
            Width = 70
            Height = 16
            AutoSize = False
            Font.Charset = GB2312_CHARSET
            Font.Color = clRed
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
          end
          object Label18: TLabel
            Left = 47
            Top = 90
            Width = 70
            Height = 16
            AutoSize = False
            Font.Charset = GB2312_CHARSET
            Font.Color = clRed
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
          end
          object ComboBox2: TComboBox
            Left = 10
            Top = 44
            Width = 145
            Height = 24
            ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
            ItemHeight = 16
            TabOrder = 0
            OnChange = ComboBox2Change
          end
        end
        object DBNavigator: TDBNavigator
          Left = 4
          Top = 282
          Width = 336
          Height = 43
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbCancel, nbRefresh]
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 3
        end
        object GroupBox2: TGroupBox
          Left = 4
          Top = 176
          Width = 501
          Height = 95
          Caption = #25176#36816#36710#36742
          TabOrder = 4
          object Label2: TLabel
            Left = 63
            Top = 18
            Width = 64
            Height = 16
            Caption = #21487#29992#36710#36742
          end
          object Label13: TLabel
            Left = 222
            Top = 16
            Width = 64
            Height = 16
            Caption = #36824#21487#36733#37325
          end
          object Label14: TLabel
            Left = 222
            Top = 44
            Width = 64
            Height = 16
            Caption = #21487#29992#31354#38388
          end
          object Label15: TLabel
            Left = 294
            Top = 16
            Width = 111
            Height = 16
            AutoSize = False
            Font.Charset = GB2312_CHARSET
            Font.Color = clRed
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
          end
          object Label16: TLabel
            Left = 294
            Top = 46
            Width = 111
            Height = 16
            AutoSize = False
            Font.Charset = GB2312_CHARSET
            Font.Color = clRed
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
          end
          object Label19: TLabel
            Left = 410
            Top = 17
            Width = 16
            Height = 16
            Caption = 'kg'
          end
          object Label20: TLabel
            Left = 412
            Top = 47
            Width = 16
            Height = 16
            Caption = 'm3'
          end
          object Label5: TLabel
            Left = 222
            Top = 72
            Width = 64
            Height = 16
            Caption = #32852#31995#30005#35805
          end
          object Label21: TLabel
            Left = 294
            Top = 72
            Width = 102
            Height = 16
            AutoSize = False
            Font.Charset = GB2312_CHARSET
            Font.Color = clRed
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
          end
          object ComboBox1: TComboBox
            Left = 62
            Top = 40
            Width = 109
            Height = 24
            ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
            ItemHeight = 16
            TabOrder = 0
            OnChange = ComboBox1Change
          end
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 339
        Width = 613
        Height = 147
        Align = alClient
        Caption = #20998#37197#34920#24403#21069#20869#23481
        TabOrder = 1
        object DBGrid1: TDBGrid
          Left = 9
          Top = 15
          Width = 596
          Height = 120
          DataSource = fdata.dsdispatch
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
          TabOrder = 0
          TitleFont.Charset = GB2312_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -16
          TitleFont.Name = #26999#20307'_GB2312'
          TitleFont.Style = []
        end
      end
    end
  end
end
