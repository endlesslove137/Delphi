object Fstorage: TFstorage
  Left = 243
  Top = 161
  Width = 460
  Height = 453
  Caption = #20837#24211#20449#24687
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #26999#20307'_GB2312'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 452
    Height = 419
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #26680#23545#20837#24211
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 444
        Height = 153
        Align = alTop
        Caption = #36135#29289#26680#23545
        TabOrder = 0
        object Label1: TLabel
          Left = 24
          Top = 16
          Width = 87
          Height = 19
          AutoSize = False
          Caption = #26410#20837#24211#21333#21495
        end
        object SpeedButton1: TSpeedButton
          Left = 34
          Top = 62
          Width = 143
          Height = 25
          Caption = #20837#24211#29289#21697#26126#32454
          Enabled = False
          Flat = True
          OnClick = SpeedButton1Click
        end
        object Label6: TLabel
          Left = 26
          Top = 120
          Width = 68
          Height = 16
          Caption = #21344#29992#31354#38388
        end
        object Label7: TLabel
          Left = 102
          Top = 120
          Width = 9
          Height = 16
        end
        object Label8: TLabel
          Left = 180
          Top = 120
          Width = 26
          Height = 16
          Caption = 'M'#65299
          Font.Charset = GB2312_CHARSET
          Font.Color = clRed
          Font.Height = -16
          Font.Name = #26999#20307'_GB2312'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ComboBox1: TComboBox
          Left = 34
          Top = 36
          Width = 145
          Height = 24
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
          ItemHeight = 16
          TabOrder = 0
          OnChange = ComboBox1Change
        end
        object CheckBox1: TCheckBox
          Left = 34
          Top = 90
          Width = 145
          Height = 25
          Caption = #26159#21542#19968#33268
          Enabled = False
          TabOrder = 1
          OnClick = CheckBox1Click
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 153
        Width = 444
        Height = 130
        Align = alClient
        Caption = #20998#37197#20179#24211
        Enabled = False
        TabOrder = 1
        object Label2: TLabel
          Left = 32
          Top = 20
          Width = 85
          Height = 16
          Caption = #35831#36873#25321#20179#24211
        end
        object Label3: TLabel
          Left = 32
          Top = 74
          Width = 102
          Height = 16
          Caption = #20179#24211#31354#38386#31354#38388
        end
        object Label4: TLabel
          Left = 38
          Top = 100
          Width = 9
          Height = 16
        end
        object Label5: TLabel
          Left = 146
          Top = 98
          Width = 26
          Height = 16
          Caption = 'M'#65299
          Font.Charset = GB2312_CHARSET
          Font.Color = clRed
          Font.Height = -16
          Font.Name = #26999#20307'_GB2312'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label9: TLabel
          Left = 248
          Top = 16
          Width = 34
          Height = 16
          Caption = #22791#27880
        end
        object ComboBox2: TComboBox
          Left = 30
          Top = 40
          Width = 145
          Height = 24
          Style = csDropDownList
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
          ItemHeight = 16
          TabOrder = 0
          OnChange = ComboBox2Change
        end
        object Memo1: TMemo
          Left = 248
          Top = 38
          Width = 163
          Height = 81
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20116#31508
          Lines.Strings = (
            '')
          TabOrder = 1
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 283
        Width = 444
        Height = 105
        Align = alBottom
        Caption = #25805#20316#21306#22495
        TabOrder = 2
        object SpeedButton2: TSpeedButton
          Left = 38
          Top = 34
          Width = 115
          Height = 37
          Caption = #20445#23384#20998#37197
          Enabled = False
          OnClick = SpeedButton2Click
        end
        object SpeedButton8: TSpeedButton
          Left = 224
          Top = 32
          Width = 117
          Height = 36
          Caption = #36864#20986
          Flat = True
          Glyph.Data = {
            12090000424D120900000000000036000000280000001C0000001B0000000100
            180000000000DC080000C30E0000C30E00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4FFFFE7F5EFFAFBF8FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFF1FFFFE1F3ECF9FAF7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFEFFFFF2FCFBEDF9F7E7FCFBF0F8F6A7FEFD8AD4
            BEE9ECE1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFCFCF9FBFA
            EDFDFB92D6C162B69447D6C376CCB592EFE7D2E9DEEDE0D0FCFAF8FCFFFFFEFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFEAE9E8B9A9A39CC6BAAAF4E699B8956EA47BB0B898
            CDDBCCC1ECE37ACBB2B9C0A1C0F5F0BCFFFFF7FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5DBCC64
            6054270D0044987B65E6DF5C6B602DBCA832A0A0A1B7B2CCE1D04DE9DF97D7C6
            41F6F37CFFFFF5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFCFBF9F5F4EEFBF9F1E1D7C9686248204A4939463997A98E8C928953
            272868C4B52E4E41AEA2A2BFC6A77EA379CBDFD1E4FDFDF9FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFE7D4E5D9BDCEBD
            9E615D473C6C6769B8BC4B4A3E628B6880B287A8392A848E887A6A5FC6C8C9B3
            F8EB91EFE4ECFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFEBEBEAACA697A1977FB0A590726B57345F5B85D7D66AB0AE4247
            3D6B8C7596C0AB881613513C348A9D92C4B6B4C9C1C3D0C4C5C3C0C0BFBFBFBB
            BBBBEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD0D0CE4C4A47
            6363654C4D502746407FD0CF84CFC86DA6A93552452FA96247E994725329693A
            3C9185887C70705F6060626262626262626262595959D7D7D7FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDFAFAFCFBF9FBA9A7A825494A8DDDD8
            619995374C530F2C45217B5A2DED1E2CCD0E5D0600BF727CF9F8F8F6F7F7F6F6
            F6F6F6F6F6F6F6F5F5F5FDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFB8B6B62647458BDCD751807D0B0B0E0124463D7FA6
            63CD6D2FCB2A353A13AE9198FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2
            AEB026484684D1CD75BBB66483931D623F00D21532F4858DAA9D7D7C4AC3C8BA
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2AFB026484682CECA7FCAC472
            ADC13D604061C2009BFF4587C7B3938F6DE5D0B2FEFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFB2AFB026484683CFCB7CC4BE589CAF4C5D3DDDC100FFFF0769
            F49575AD88B9995AEAE7DBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2AFB02648
            4683CFCB7CC4BE5B9DB04A5D3DCBC100FFFF00B4FD4742B3B97F849DF0E1D8FF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2AFB026484683CFCB7CC4BE5C9DB0495D
            3DC9C100FFFF00D3FF3C138EAB7D8FD9FFF7F8FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFB2AFB026484683CFCB7CC4BE5C9DB0495E3EC9C100FFFF00EEFF2E84BA
            8CB7C8DCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2AFB026484683CFCB
            7CC5BF5C99AB494A2FC9B800FFFF00FFFF059698239B9EA3F9FAFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFB2AFB027464580CCCF75B9BC56A9C441A68AC5E41A
            FFFF00FFFF00838100868485F7F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB1
            AFB227595598ECD49FD4BF7CF7E195FF84FFFF0BFFFF08FFFF0B9595008E8E8A
            F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFABA6AE00251C56954183721367
            742D62661D837F007D7B008E8A01353300808180FCFCFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFDAD9D97875747F7F7B827F7C817C7B807B7D7E7D7F7D7D807F
            7E80727278C5C4C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDF5F3
            F3F3F1F4F1F2F6F2F2F5F3F3F5F2F2F6F2F2F6F1F1F6F3F3F5FBFBFBFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          OnClick = SpeedButton8Click
        end
      end
    end
  end
end
