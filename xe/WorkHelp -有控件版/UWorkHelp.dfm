object Form1: TForm1
  Left = 309
  Top = 225
  Caption = #20010#20154#36741#21161#24037#20855
  ClientHeight = 425
  ClientWidth = 786
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object pgc1: TPageControl
    Left = 0
    Top = 0
    Width = 786
    Height = 404
    ActivePage = ts7
    Align = alClient
    TabOrder = 0
    object ts1: TTabSheet
      Caption = #26381#26381
      DesignSize = (
        778
        373)
      object btn1: TSpeedButton
        Left = 687
        Top = 346
        Width = 89
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #25191#34892
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000001000000010000000000000000000000FFFFFFFFFFFF
          FFFFFFFEF5EFB48157B07E55A08859998A5BA47350A06F4E9D6C4D99684B9665
          4A936348FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEF6F0B78459FEF6F0CFE9C97C
          D58BD2E7C7FEEFE5FDEDE1FDEDE0F8EFE8BD9F8E926248FFFFFFB48157B07E55
          AC7A53AB7A57B98659F7F3EABCE4BB71D4846AD17FA0DBA3F0EAD7FDECDFFEF8
          F3E9DFD9956449926248B78459FEF6F0FEF4ECD9EACF82B87070D28366CF7B83
          DC9480DB916ED38275D285C1E2B8F4F1E4FEF8F4E0CDC2946449BA875AFEF5EF
          B2E2B466CF7A94E3A38DE09C8CE09B92E2A189DE997AD88C6CD28093D99AE4E9
          D0FDEDE0FDEEE396664ABD8A5BBEE6BF8ADF9A6AD07E79C1749FDEA792DA9D8C
          E09B7CD98E75D386C6E6C1FEF1E7FEEFE4FEEDE1FDEDE099684BA89E6581D68F
          B2E3B5ECF1E1C5925FFEF6F1D0EACC78D78B9DDDA5EFF1E4FEF4EDFEF3EAFEF1
          E7FEEFE4FEEFE49C6B4CA4A467D9EDD4FEF6F0FEF6F0C89460FEF6F1DFEED8CE
          EACBFEF6F0FEF6F0FEF5EFFEF4EDFEF3EAFEF1E7FEF1E79E6D4DBE9661FBF5EF
          FEF6F0FEF6F0CA9762FEF6F1FEF6F0FEF6F0FEF6F0FEF6F0FEF6F0FEF5EFFEF4
          EDFEF3EAFEF2E9A1704FC89460FEF6F1FEF6F0FEF6F0CD9963FEF6F1FEF6F0FE
          F6F0FEF6F0FEF6F0FEF6F0FEF6F0FEF5EFFEF4EDFEF4ECA47350CA9762FEF6F1
          FEF6F0FEF6F0CF9B64FEF6F1F3DEB3F1D7AAEECD9DEAC08FE7B683E6B17CE6B1
          7CE6B17CFEF5EFA77651CD9963FEF6F1FEF6F0FEF6F0D19D64FEF6F1F3DEB2F1
          D6A9EECC9BEABF8DE7B581E6B07AE6B07AE6B07AFEF6F0AA7953CF9B64FEF6F1
          F3DEB3F1D8ACD29E65FEF8F3FEF7F2FEF7F2FEF7F2FEF7F2FEF7F2FEF7F2FEF7
          F2FEF7F2FEF8F3AD7B54D19D64FEF6F1F3DEB2F1D6AAD4A066D29E65D09C64CD
          9963CA9761C79460C3905EC08D5DBC895BB88659B48258B07E56D29E65FEF8F3
          FEF7F2FEF7F2FEF7F2FEF7F2FEF7F2FEF7F2FEF7F2FEF7F2FEF8F3AD7B54FFFF
          FFFFFFFFFFFFFFFFFFFFD4A066D29E65D09C64CD9963CA9761C79460C3905EC0
          8D5DBC895BB88659B48258B07E56FFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = btn1Click
        ExplicitLeft = 506
        ExplicitTop = 302
      end
      object cbbCbTarget: TComboBoxEx
        Left = 684
        Top = 27
        Width = 90
        Height = 25
        ItemsEx = <
          item
            Caption = #22269#26381
          end
          item
            Caption = #38889#22269
          end
          item
            Caption = #36234#21335
          end>
        Anchors = [akTop, akRight, akBottom]
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        TabOrder = 0
        Text = 'cbbCbTarget'
      end
      object chkUpdate: TCheckBox
        Left = 10
        Top = 5
        Width = 161
        Height = 17
        Caption = #25552#21462#25991#20214#21069#33258#21160#26356#26032
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object chkcommit: TCheckBox
        Left = 180
        Top = 5
        Width = 157
        Height = 17
        Caption = #31227#21160#25991#20214#21518#33258#21160#25552#20132
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object mmo1: TMemo
        Left = 3
        Top = 58
        Width = 771
        Height = 256
        Anchors = [akLeft, akTop, akRight, akBottom]
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        PopupMenu = pm
        ScrollBars = ssBoth
        TabOrder = 3
        WordWrap = False
        OnKeyDown = mmo3KeyDown
      end
      object lbledt1: TLabeledEdit
        Left = 64
        Top = 313
        Width = 711
        Height = 24
        Anchors = [akLeft, akRight]
        EditLabel.Width = 60
        EditLabel.Height = 16
        EditLabel.Caption = #25552#20132#35828#26126
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        LabelPosition = lpLeft
        TabOrder = 4
        Text = #38472#26480' '#22996#25176' '#24352#26126#26126#22797#21046#25552#20132
      end
      object chk3: TCheckBox
        Left = 339
        Top = 4
        Width = 118
        Height = 16
        Caption = #36716#25442#26412#22320#36335#24452
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object lbledt2: TLabeledEdit
        Left = 52
        Top = 28
        Width = 613
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 45
        EditLabel.Height = 16
        EditLabel.Caption = #28304#36335#24452
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        LabelPosition = lpLeft
        TabOrder = 6
        Text = 'D:\mine\'#30334#24230#32593#30424'\'#25105#30340#25991#26723'\work\program\521g\idgp\ZhanJiangII\!SC\'
      end
    end
    object ts2: TTabSheet
      Caption = 'Svn'
      ImageIndex = 1
      DesignSize = (
        778
        373)
      object btn2: TSpeedButton
        Left = 683
        Top = 347
        Width = 93
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #25552#20132
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000001000000010000000000000000000000FFFFFFFEFEFE
          FEFEFEFEFEFEFEFEFEF9F9F9F5F5F6F5F5F5F8F8F8FEFEFED07A2CEEAA27D182
          47FFFFFFFFFFFFFEFEFEFEFEFEFEFEFEF5F5F5C3C3C2A9A8A8B1B0B0A7A4A3A6
          A2A1B2B1B0ABAAAACE7523EEA924D18147FEFEFEFFFFFFFEFEFEFEFEFEC9C9C9
          73706F75706EC4C3C2DAD8D8CACBCACAC9C8D7D6D5C6C6C6CF7823EEA924D182
          47FEFEFEFEFEFEFFFFFFACACAC848382A8A7A6A1A19F89868791908F8D89888C
          8B889392908C8B89D07722EEA924D18247A4A4A4FFFFFFFFFFFF6D6C6AB7B6B5
          6C6A686E6A69CACAC9E1E1E0CAC9C8CF7722CF7722CF7723CF7722EEA924D182
          47D18247D18147CC72229896959A9897A4A3A2A6A4A38E8D8C90918E8C89878B
          8887CF7722FFC32CFFC42CEEA924DD8F31DD9031CC7222FFFFFFA9A7A6B1B0AF
          726F6E666461B5B3B0C4C3C2B2B1B2B2B1B0C0BFBECF7722FFC42CEEA923DD90
          31CC7121FFFFFFFFFFFFA8A7A4908D8B888685A1A09FB1B0AFAEACAAB9B9B7BC
          BDB9B2B1B0B2B1B0CF7722EEA923CC7121B1B0AFFFFFFFFFFFFF9C9B9AA19F9E
          9F9E9CB2B1B1BBB9B7BFBEBCC2C0BDC3C2BEC3C2BFC2C0BEBDBCB9CF77229C9B
          9BAAA8A7FFFFFFFFFFFFA4A3A2959391A6A4A2A7A6A3AAA8A7ACABAAAFAEACB0
          AFACB0AFACAEACACABABA9AFAEAB9B9898ACACAAFFFFFFFFFFFF959392ABAAA8
          A7A6A4AAA9A7AEACABB0AFAEB2B1AFB2B2B0B2B1AFB0B0AEAFAEABACABA9B2B1
          AEA1A09FFFFFFFFFFFFF9E9C9BC2C0BDB6B5B3B8B7B6BBB9B8BDBCB9BEBDBBBE
          BDBCBEBDBBBDBCBBBCBBB8BBB9B7C4C3BFB0AFAEFFFFFFFFFFFFAFAEACC8C8C6
          CBCAC9C9C6C5CAC9C8CBCAC9CBCBCACCCBCACBCBCACBCAC9CAC9C8CBCACBCFCE
          CCB1B0AFFFFFFFFFFFFFDCDBDBC2C2C0DEDDDCE3E3E2E0E0DEDEDEDDE0DDDEE0
          E0DEE0DEDEE1E0E0E4E3E3E3E2E2C4C4C3D3D0D0FFFFFFFFFFFFFFFFFFDBDADA
          D2D2D1E7E7E6F7F7F7FCFCFCFDFDFDFDFDFDFCFCFCF8F8F8E9E8E8D3D2D1D6D5
          D2FFFFFFD3D0D0FFFFFFFFFFFFFEFEFEFEFEFEDBDADADCDCDCE1E1E1DBDBDBDA
          DADAE1E1E1DCDBDBD8D8D7FFFFFFFEFEFEFEFEFEFEFEFEFFFFFF}
        OnClick = btn2Click
        ExplicitLeft = 502
        ExplicitTop = 303
      end
      object btn3: TSpeedButton
        Left = 588
        Top = 347
        Width = 89
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #26356#26032
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000001000000010000000000000000000000000000000000
          00000000000000000000000000000000000000000000000005140E083424022B
          1E0005030000000000000000000000000000000202021313134C4C4C6B6B6B83
          838385858525654B07925D149A6B089D6E00936A00231A000000000000000000
          090909646464CFCFCFE0E0E0D0D0D0DBDBDB97C2B203A2681CA878DBEFE8BAE3
          D808B58B00A8840006040000000000004F4F4FB5B5B5D3D3D3DFDFDFCECECED9
          D9D947BB9400B67BABE2D2A6E0D098DECE70DBC500D1AA033A30000000000000
          919191B9B9B9C4C4C4CFCFCFCFCFCFD8D8D84CCCA618D39E11D2A082E1CA5ADD
          C21FDFBC1FE4C40E4B41000000000000A2A2A2B4B4B4D3D3D3E1E1E1D0D0D0DB
          DBDB91DDC95AECC75AEECCA5EDDD84EBD85AF2D95AEED8071C18000000000000
          A5A5A5B5B5B5D2D2D2DBDBDBCECECEDBDBDBDBE3E196F1DC98FAE6ACF4E6A2F5
          E797FBEC3C766D010504000000000000A7A7A7BABABAC4C4C4D2D2D2CFCFCFD9
          D9D9E6E6E6E4E9E8C6ECE5B7EEE4B5E7DF5A7A75040A09000000000000000000
          A1A1A1B3B3B3D3D3D3E1E1E1D0D0D0DBDBDBE9E9E9F2F2F2EDEDEDE0E0E0D4D4
          D4949494000000000000000000000000A5A5A5B5B5B5D1D1D1D8D8D8CFCFCFDB
          DBDBE8E8E8F1F1F1EDEDEDE0E0E0CDCDCD737373000000000000000000000000
          A7A7A7BABABABDBDBDC7C7C7D0D0D0D9D9D9E1E1E1E8E8E8ECECECE9E9E9D2D2
          D2979797000000000000000000000000A0A0A0B4B4B4B7B7B7BEBEBEC5C5C5CE
          CECED7D7D7DFDFDFE7E7E7ECECECECECECA1A1A1000000000000000000000000
          949494BCBCBCB3B3B3B6B6B6BCBCBCC4C4C4CDCDCDD5D5D5DEDEDEE5E5E5E0E0
          E0989898000000000000000000000000000000A4A4A4D6D6D6CBCBCBC5C5C5C3
          C3C3C6C6C6C8C8C8C9C9C9C8C8C8989898000000000000000000000000000000
          0000000000000000000000000000007979797373730000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        OnClick = btn3Click
        ExplicitLeft = 407
        ExplicitTop = 303
      end
      object mmo2: TMemo
        Left = 3
        Top = 0
        Width = 772
        Height = 344
        Anchors = [akLeft, akTop, akRight, akBottom]
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        PopupMenu = pmsvn
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
        OnKeyDown = mmo3KeyDown
      end
    end
    object ts3: TTabSheet
      Caption = 'OA'
      ImageIndex = 2
      object btn4: TSpeedButton
        Left = 205
        Top = 17
        Width = 27
        Height = 26
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000001000000010000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000399DD62B91CF00000000000005659C0376B90377BA03
          77BA0377BA0377B9046FAC044267000000268ECC3DA0D95DB2E0389CD6000000
          02304B1587C9339FDD4FB7F256BEFA56BEFC55BDFA55BBF644ABE51F8CCC0262
          9C0000003CA0D85DB2E00000000C37503FA2DBAFD5E3F9F5E9E1AF77B8711DB7
          7423B8711DDEAC75F1F9FDA7DBF84AACE2147AB50000005CB2E00B22304EADE3
          E4E2D0FFF2DAD2A774A87531988C61919576978D64A57632CA9B64FFFFFFFFFF
          F782C5E82789C100000055B2E5EDE0C9FFE9CBFCF0DEA66B21938E661A1D2417
          191E171B1F86825FA1691DFFF9F3FFFCF3FFFCEDEAEDE853A3CF0378BC5C9EBC
          FFEDCBFFF2DEA670298C967A18191F1B1C1E5B5B5EA2A799BB9562F0DFCBFFFA
          EEFFFEE95FA4C70277BA0B7BBD0072B95A9EBFFFF7DAB270219A8E631C1D2014
          131699999AD0CBB8DBBA92FFFFF2FFF5E55CA2C60073B81482C50E7DBD1B86CA
          0074B91683C28B8568BE7B29AB8C519F8F5FEDD7BAFFE3C6E5DDCE94BFD1137D
          BA0278BD1D87CB1784C50E7DBD1D86C9238ED11583CA047CC60077C20077C200
          76BF0072BB006FB70073BA057AC01986CB258ED11F88CA1784C40E7DBD1C86C8
          248DCF2991D42A92D62A92D72B92D72B92D72A91D62A91D62991D52991D5298F
          D3268ED01F88CA1784C4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = btn4Click
      end
      object lbl1: TLabel
        Left = 18
        Top = 22
        Width = 30
        Height = 16
        Caption = #21333#21495
      end
      object btn5: TSpeedButton
        Left = 230
        Top = 17
        Width = 27
        Height = 26
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000001000000010000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF8A4E078F5B1C93642993652A8F5C1C8A4F07FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7E3B067D4B25936956AA8378AF
          897FAF897FAA8479956D5A7E4D287E3B06FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          7531096C3E287C564A896256987265A47F72A57F729D786B8F695D7D564C6A3F
          2A743209FFFFFFFFFFFFFFFFFF732A076435215F372A86695FC5B5AE8964588B
          64578E685B8761547A54476A4538633E32603421742B07FFFFFFFFFFFF602712
          59322456302379594EFDFEFDBFAFA86F473A70493B704A3D684235623C2F5D37
          2A5732255D2713FFFFFF681B095225144F291C532D20654134AB9891B8A8A1CA
          BEB877554A593123603A2D5C3629573124502A1E4D2415691B095D160A461E0E
          4621144C261950291CC0B2ACF9F9F6F8F8F6E7E3DF866A6050281A542E214E28
          1B472215411C0E5A160A5210073B1405431D114E281B552E20D2C8C4FDFEFCF8
          F8F6E6E1DD9F877E7E60545932245731244E281B411D0F511109500F0A4E2919
          593326613B2E5F372ACCBFBBF0EDEBC8BAB49B8178CFC4BEDFD9D4694337623B
          2E5E392C56332452120E550C0E613C2C653F336A44376A4335A58E85AD978EA9
          938BE6E1DDA68F86FAFBF9A28A81653C2F684235603D2E540C0E57020B724A3C
          805B4E815B4E80584BA1857AEFEEEAA99188EFECE9C5B4ACAB958DE8E2DF8661
          55815B4E714A3E57020BFFFFFF6A312EA07D6E9B75689C75689D7669E2DAD5DD
          D1CCB7A29AF0ECE9B19991FCFEFDC3ADA59C786868312FFFFFFFFFFFFF57040B
          91675EBE9A8BB58F82B1897CC8ACA2F7F7F5B79F97F5F2F0DCCCC6AE9991FBF9
          F5916960560309FFFFFFFFFFFFFFFFFF5B0D12A1796FD4B2A3D2AC9ECCA497EF
          E6E1EEE6E2C2ADA5FFFFFEAE968DB19690590C10FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF58040B86524EC39F93DDBAABECD4C8FFFDF9C2AAA1D1BDB68754515500
          06FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5A070F702A2E7F
          414280434570292E58020AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = btn5Click
      end
      object se1: TSpinEdit
        Left = 54
        Top = 17
        Width = 145
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
      end
    end
    object ts4: TTabSheet
      Caption = #36816#33829#27963#21160
      ImageIndex = 3
    end
    object ts5: TTabSheet
      Caption = #23383#26465#22788#29702
      ImageIndex = 4
      object btn6: TSpeedButton
        Left = 375
        Top = 53
        Width = 114
        Height = 24
        Caption = #25130#21462#23383#31526#38388#25991#23383
        OnClick = btn6Click
      end
      object btn7: TSpeedButton
        Left = 623
        Top = 26
        Width = 81
        Height = 24
        Caption = #22788#29702
        OnClick = btn7Click
      end
      object btn12: TSpeedButton
        Left = 375
        Top = 83
        Width = 114
        Height = 24
        Caption = 'X'#20998#35010
        OnClick = btn12Click
      end
      object btn13: TSpeedButton
        Left = 375
        Top = 113
        Width = 114
        Height = 24
        Caption = #26684#24335#23383#31526
        OnClick = btn13Click
      end
      object mmo3: TMemo
        Left = 0
        Top = 0
        Width = 281
        Height = 373
        Align = alLeft
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        PopupMenu = pmstr
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
        OnKeyDown = mmo3KeyDown
      end
      object chk1: TCheckBox
        Left = 296
        Top = 3
        Width = 97
        Height = 17
        Caption = #21435#38500#31354#34892
        TabOrder = 1
      end
      object chk2: TCheckBox
        Left = 392
        Top = 3
        Width = 97
        Height = 17
        Caption = #21435#38500#31354#23383#31526
        TabOrder = 2
      end
      object edtCh: TEdit
        Left = 296
        Top = 53
        Width = 33
        Height = 24
        Hint = '\s  '#20195#34920' '#34892#24320#22836' ; '#13#10'\e  '#20195#34920' '#34892#32467#23614
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
      object edtCh1: TEdit
        Left = 335
        Top = 53
        Width = 34
        Height = 24
        Hint = '\s  '#20195#34920' '#34892#24320#22836' ; '#13#10'\e  '#20195#34920' '#34892#32467#23614
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
      end
      object chk4: TCheckBox
        Left = 495
        Top = 3
        Width = 122
        Height = 17
        Caption = #28155#21152#24207#21495'(delphi)'
        TabOrder = 5
      end
      object chk5: TCheckBox
        Left = 623
        Top = 3
        Width = 90
        Height = 17
        Caption = #28155#21152#24207#21495
        TabOrder = 6
      end
      object se2: TSpinEdit
        Left = 296
        Top = 83
        Width = 33
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 7
        Value = 5
      end
      object edt1: TEdit
        Left = 296
        Top = 113
        Width = 73
        Height = 24
        Hint = '\s  '#20195#34920' '#34892#24320#22836' ; '#13#10'\e  '#20195#34920' '#34892#32467#23614
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        Text = #39'%s'#39
      end
      object edt2: TEdit
        Left = 335
        Top = 83
        Width = 34
        Height = 24
        Hint = '\s  '#20195#34920' '#34892#24320#22836' ; '#13#10'\e  '#20195#34920' '#34892#32467#23614
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        Text = ','
      end
    end
    object ts6: TTabSheet
      Caption = #23631#24149#21462#33394
      ImageIndex = 5
      object pnl1: TPanel
        Left = 0
        Top = 0
        Width = 778
        Height = 292
        Align = alClient
        BevelKind = bkSoft
        Caption = #22312#27492#21306#22495#25353#19979#40736#26631#24038#38190#23558#40736#26631#31227#21160#21040#20219#24847#20301#32622#21462#33394
        ParentBackground = False
        TabOrder = 0
        OnMouseDown = pnl1MouseDown
        OnMouseMove = pnl1MouseMove
        OnMouseUp = pnl1MouseUp
      end
      object pnl2: TPanel
        Left = 0
        Top = 292
        Width = 778
        Height = 81
        Align = alBottom
        TabOrder = 1
        object lbledtRGB: TLabeledEdit
          Left = 61
          Top = 27
          Width = 121
          Height = 24
          EditLabel.Width = 53
          EditLabel.Height = 16
          EditLabel.Caption = 'RGB'#33394#65306
          ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
          LabelPosition = lpLeft
          TabOrder = 0
        end
        object lbledtDecimal: TLabeledEdit
          Left = 248
          Top = 27
          Width = 121
          Height = 24
          EditLabel.Width = 60
          EditLabel.Height = 16
          EditLabel.Caption = #21313#36827#21046#65306
          ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
          LabelPosition = lpLeft
          TabOrder = 1
        end
        object lbledtHexColor: TLabeledEdit
          Left = 453
          Top = 27
          Width = 138
          Height = 24
          EditLabel.Width = 75
          EditLabel.Height = 16
          EditLabel.Caption = #21313#20845#36827#21046#65306
          ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
          LabelPosition = lpLeft
          TabOrder = 2
        end
      end
    end
    object ts7: TTabSheet
      Caption = #25112#21315#38596#25968#25454#32479#35745
      ImageIndex = 6
      object pnl3: TPanel
        Left = 0
        Top = 0
        Width = 778
        Height = 41
        Align = alTop
        BevelOuter = bvSpace
        TabOrder = 0
        object btnGetServer: TSpeedButton
          Left = 551
          Top = 11
          Width = 92
          Height = 24
          Caption = #33719#21462
          OnClick = btnGetServerClick
        end
        object lbledt3: TLabeledEdit
          Left = 86
          Top = 8
          Width = 459
          Height = 24
          EditLabel.Width = 79
          EditLabel.Height = 16
          EditLabel.Caption = 'ServerListURL'
          ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
          LabelPosition = lpLeft
          TabOrder = 0
          Text = 'http://xh.521g.com/miros/zqx/gt/ServerList.xml'
        end
        object btn8: TButton
          Left = 664
          Top = 10
          Width = 105
          Height = 25
          Caption = #22797#21046#21040#21098#36148#26495
          TabOrder = 1
          OnClick = btn8Click
        end
      end
      object RZLVServerlist: TRzListView
        Left = 0
        Top = 41
        Width = 778
        Height = 332
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = #26381#21153#22120
            Width = 171
          end
          item
            Caption = 'IP('#20250#35805')'
            Width = 131
          end
          item
            Caption = 'IP('#26085#24535')'
            Width = 131
          end
          item
            Caption = #29366#24577
          end
          item
            Caption = '2012A'
          end
          item
            Caption = '2012Q1'
            Width = 60
          end
          item
            Caption = '2012Q2'
            Width = 60
          end
          item
            Caption = '2012Q3'
            Width = 60
          end
          item
            Caption = '2012Q4'
            Width = 60
          end
          item
            Caption = '2013Q1'
            Width = 60
          end
          item
            Caption = '2013Q2'
            Width = 60
          end
          item
            Caption = '2013Q3'
            Width = 60
          end>
        GridLines = True
        ShowWorkAreas = True
        TabOrder = 1
        ViewStyle = vsReport
      end
    end
    object ts8: TTabSheet
      Caption = #27979#35797
      ImageIndex = 7
      object pb1: TPaintBox
        Left = 0
        Top = 0
        Width = 778
        Height = 105
        Align = alTop
        Color = clActiveCaption
        ParentColor = False
        OnMouseUp = pb1MouseUp
        ExplicitLeft = 72
        ExplicitTop = 24
        ExplicitWidth = 105
      end
      object btn9: TButton
        Left = 0
        Top = 111
        Width = 145
        Height = 25
        Caption = #33719#21462#32447#31243#36864#20986#30721
        TabOrder = 0
        OnClick = btn9Click
      end
      object btn10: TButton
        Left = 151
        Top = 111
        Width = 106
        Height = 25
        Caption = #21464#20307#35760#24405
        TabOrder = 1
        OnClick = btn10Click
      end
      object btn11: TButton
        Left = 263
        Top = 111
        Width = 90
        Height = 25
        Caption = 'absolute '
        TabOrder = 2
        OnClick = btn11Click
      end
      object btn14: TButton
        Left = 359
        Top = 111
        Width = 122
        Height = 25
        Caption = 'mysql'#27979#35797
        TabOrder = 3
      end
      object btn15: TButton
        Left = 487
        Top = 111
        Width = 122
        Height = 25
        Caption = 'strPointer'
        TabOrder = 4
        OnClick = btn15Click
      end
    end
    object ts9: TTabSheet
      Caption = #26376#32479#35745#25968#25454
      ImageIndex = 8
      object pnl4: TPanel
        Left = 0
        Top = 0
        Width = 778
        Height = 41
        Align = alTop
        BevelOuter = bvSpace
        TabOrder = 0
        object btn16: TSpeedButton
          Left = 551
          Top = 11
          Width = 92
          Height = 24
          Caption = #33719#21462
          OnClick = btn16Click
        end
        object lbledt4: TLabeledEdit
          Left = 86
          Top = 8
          Width = 459
          Height = 24
          EditLabel.Width = 79
          EditLabel.Height = 16
          EditLabel.Caption = 'ServerListURL'
          ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
          LabelPosition = lpLeft
          TabOrder = 0
          Text = 'D:\mine\'#30334#24230#32593#30424'\'#25105#30340#25991#26723'\work\bakeup\'#25968#25454#26597#35810'\'#21508#24179#21488'Ip.xlsx'
        end
        object btn17: TButton
          Left = 664
          Top = 10
          Width = 105
          Height = 25
          Caption = #22797#21046#21040#21098#36148#26495
          TabOrder = 1
          OnClick = btn17Click
        end
      end
      object RZLV1: TRzListView
        Left = 0
        Top = 41
        Width = 778
        Height = 332
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = #24179#21488
            Width = 171
          end
          item
            Caption = 'IP('#20250#35805')'
            Width = 131
          end
          item
            Caption = 'IP('#26085#24535')'
            Width = 131
          end
          item
            Caption = #26085#24535'DB'
            Width = 77
          end
          item
            Caption = #20250#35805'DB'
            Width = 77
          end
          item
            Caption = #32447#19979#65311
            Width = 60
          end
          item
            Caption = #20250#35805#65311
            Width = 60
          end
          item
            Caption = #26085#24535#65311
            Width = 46
          end>
        GridLines = True
        ShowWorkAreas = True
        TabOrder = 1
        ViewStyle = vsReport
      end
    end
    object ts10: TTabSheet
      Caption = 'png'
      ImageIndex = 9
      object img1: TImage
        Left = 0
        Top = 0
        Width = 778
        Height = 373
        Align = alClient
        OnMouseMove = img1MouseMove
        ExplicitHeight = 345
      end
      object btn18: TButton
        Left = 700
        Top = 3
        Width = 75
        Height = 25
        Caption = 'btn18'
        TabOrder = 0
        OnClick = btn18Click
      end
      object edt3: TEdit
        Left = 573
        Top = 4
        Width = 121
        Height = 24
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        TabOrder = 1
        Text = 'edt3'
        OnMouseMove = edt3MouseMove
      end
    end
  end
  object pb2: TProgressBar
    Left = 0
    Top = 404
    Width = 786
    Height = 21
    Align = alBottom
    TabOrder = 1
  end
  object pm: TPopupMenu
    Left = 144
    Top = 336
    object N1: TMenuItem
      Caption = #35821#35328#21253#25991#20214
      OnClick = N1Click
    end
    object N4: TMenuItem
      Caption = #21462#30701#36335#24452
      OnClick = N4Click
    end
  end
  object pmsvn: TPopupMenu
    Left = 176
    Top = 336
    object MenuItem1: TMenuItem
      Caption = #35821#35328#21253#25991#20214
      OnClick = MenuItem1Click
    end
    object N2: TMenuItem
      Caption = #26263#40657#32511#29492
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #26263#40657#20219#21153
      OnClick = N3Click
    end
    object N5: TMenuItem
      Caption = #21462#30701#36335#24452
      OnClick = N4Click
    end
  end
  object pmstr: TPopupMenu
    MenuAnimation = [maBottomToTop]
    Left = 208
    Top = 336
    object N6: TMenuItem
      Caption = #21435#38500#31354#34892
    end
    object N7: TMenuItem
      Caption = #21435#38500#31354#23383#31526
    end
  end
  object sqlqry1: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = con1
    Left = 64
    Top = 336
  end
  object con1: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    Params.Strings = (
      'DriverName=MySQL'
      'HostName=ServerName'
      'Database=DBNAME'
      'User_Name=user'
      'Password=password'
      'ServerCharSet='
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'ConnectTimeout=60')
    VendorLib = 'LIBMYSQL.dll'
    Left = 24
    Top = 336
  end
  object con2: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    Params.Strings = (
      'DriverName=MySQL'
      'HostName=ServerName'
      'Database=DBNAME'
      'User_Name=user'
      'Password=password'
      'ServerCharSet='
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'ConnectTimeout=60')
    VendorLib = 'LIBMYSQL.dll'
    Left = 304
    Top = 168
  end
end
