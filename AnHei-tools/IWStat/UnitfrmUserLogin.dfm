object IWfrmUserLogin: TIWfrmUserLogin
  Left = 0
  Top = 0
  Width = 555
  Height = 400
  RenderInvisibleControls = False
  AllowPageAccess = True
  ConnectionMode = cmAny
  SupportedBrowsers = []
  OnCreate = IWAppFormCreate
  OnDestroy = IWAppFormDestroy
  BGColor = 4146101
  Background.Fixed = False
  HandleTabs = False
  LeftToRight = True
  LockUntilLoaded = True
  LockOnSubmit = True
  ShowHint = True
  XPTheme = True
  DesignLeft = 8
  DesignTop = 8
  object IWRegion1: TIWRegion
    Left = 48
    Top = 80
    Width = 457
    Height = 280
    Cursor = crAuto
    HorzScrollBar.Visible = False
    VertScrollBar.Visible = False
    RenderInvisibleControls = False
    BorderOptions.NumericWidth = 2
    BorderOptions.BorderWidth = cbwMedium
    BorderOptions.Style = cbsSolid
    BorderOptions.Color = clWebBLACK
    Color = clWebWHITE
    ParentShowHint = False
    ShowHint = True
    ZIndex = 1000
    Splitter = False
    object IWLabelTitle: TIWLabel
      Left = 3
      Top = 66
      Width = 451
      Height = 31
      Cursor = crAuto
      Align = alTop
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      Alignment = taCenter
      BGColor = clNone
      Font.Color = clNone
      Font.FontName = #21326#25991#20013#23435
      Font.Size = 20
      Font.Style = []
      NoWrap = False
      ConvertSpaces = False
      HasTabOrder = False
      AutoSize = False
      FriendlyName = 'IWLabelTitle'
      Caption = #26263#40657#38477#39764#24405#25968#25454#32479#35745
      RawText = False
      ExplicitTop = 65
      ExplicitWidth = 453
    end
    object IWLabel2: TIWLabel
      AlignWithMargins = True
      Left = 176
      Top = 114
      Width = 74
      Height = 21
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      Alignment = taLeftJustify
      BGColor = clNone
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      NoWrap = False
      ConvertSpaces = False
      HasTabOrder = False
      FriendlyName = 'IWLabel2'
      Caption = #29992#25143#21517#65306
      RawText = False
    end
    object IWLabel3: TIWLabel
      AlignWithMargins = True
      Left = 184
      Top = 157
      Width = 67
      Height = 21
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      Alignment = taLeftJustify
      BGColor = clNone
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      NoWrap = False
      ConvertSpaces = True
      HasTabOrder = False
      FriendlyName = 'IWLabel3'
      Caption = #23494'  '#30721#65306
      RawText = False
    end
    object IWEditUser: TIWEdit
      AlignWithMargins = True
      Left = 256
      Top = 113
      Width = 121
      Height = 21
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      Alignment = taLeftJustify
      BGColor = clNone
      FocusColor = clNone
      DoSubmitValidation = True
      Editable = True
      NonEditableAsLabel = True
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'IWEditUser'
      MaxLength = 0
      ReadOnly = False
      Required = False
      ScriptEvents = <>
      SubmitOnAsyncEvent = True
      TabOrder = 0
      PasswordPrompt = False
    end
    object IWEditPassword: TIWEdit
      AlignWithMargins = True
      Left = 256
      Top = 157
      Width = 121
      Height = 21
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      Alignment = taLeftJustify
      BGColor = clNone
      FocusColor = clNone
      DoSubmitValidation = True
      Editable = True
      NonEditableAsLabel = True
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'IWEditPassword'
      MaxLength = 0
      ReadOnly = False
      Required = False
      ScriptEvents = <>
      SubmitOnAsyncEvent = True
      TabOrder = 1
      OnSubmit = IWButtonLoginClick
      PasswordPrompt = True
    end
    object IWButtonLogin: TIWButton
      AlignWithMargins = True
      Left = 201
      Top = 226
      Width = 75
      Height = 25
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      Caption = #36827#20837
      DoSubmitValidation = True
      Color = clBtnFace
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'IWButtonLogin'
      ScriptEvents = <>
      TabOrder = 2
      OnClick = IWButtonLoginClick
    end
    object IWlabVersion: TIWLabel
      Left = 54
      Top = 180
      Width = 86
      Height = 16
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      Alignment = taCenter
      BGColor = clNone
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      NoWrap = False
      ConvertSpaces = False
      HasTabOrder = False
      AutoSize = False
      FriendlyName = 'IWlabVersion'
      Caption = #26263#40657#38477#39764#24405
      RawText = False
    end
    object TIWFadeImage1: TTIWFadeImage
      Left = 8
      Top = 95
      Width = 159
      Height = 81
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      DoSubmitValidation = True
      FadeType = ftFadeInOut
      Opacity = 100
      Speed = 0
      Picture.Stretch = False
      Picture.Frame = 1
      Picture.Data = {
        474946383961A3005B0077003121FE1A536F6674776172653A204D6963726F73
        6F6674204F66666963650021F90401000000002C0B0003009300530087000000
        0000000000330000660000990000CC0000FF0033000033330033660033990033
        CC0033FF0066000066330066660066990066CC0066FF00990000993300996600
        99990099CC0099FF00CC0000CC3300CC6600CC9900CCCC00CCFF00FF0000FF33
        00FF6600FF9900FFCC00FFFF3300003300333300663300993300CC3300FF3333
        003333333333663333993333CC3333FF3366003366333366663366993366CC33
        66FF3399003399333399663399993399CC3399FF33CC0033CC3333CC6633CC99
        33CCCC33CCFF33FF0033FF3333FF6633FF9933FFCC33FFFF6600006600336600
        666600996600CC6600FF6633006633336633666633996633CC6633FF66660066
        66336666666666996666CC6666FF6699006699336699666699996699CC6699FF
        66CC0066CC3366CC6666CC9966CCCC66CCFF66FF0066FF3366FF6666FF9966FF
        CC66FFFF9900009900339900669900999900CC9900FF99330099333399336699
        33999933CC9933FF9966009966339966669966999966CC9966FF999900999933
        9999669999999999CC9999FF99CC0099CC3399CC6699CC9999CCCC99CCFF99FF
        0099FF3399FF6699FF9999FFCC99FFFFCC0000CC0033CC0066CC0099CC00CCCC
        00FFCC3300CC3333CC3366CC3399CC33CCCC33FFCC6600CC6633CC6666CC6699
        CC66CCCC66FFCC9900CC9933CC9966CC9999CC99CCCC99FFCCCC00CCCC33CCCC
        66CCCC99CCCCCCCCCCFFCCFF00CCFF33CCFF66CCFF99CCFFCCCCFFFFFF0000FF
        0033FF0066FF0099FF00CCFF00FFFF3300FF3333FF3366FF3399FF33CCFF33FF
        FF6600FF6633FF6666FF6699FF66CCFF66FFFF9900FF9933FF9966FF9999FF99
        CCFF99FFFFCC00FFCC33FFCC66FFCC99FFCCCCFFCCFFFFFF00FFFF33FFFF66FF
        FF99FFFFCCFFFFFF010203010203010203010203010203010203010203010203
        0102030102030102030102030102030102030102030102030102030102030102
        0301020301020301020301020301020301020301020301020301020301020301
        020301020301020301020301020301020301020301020301020301020308FF00
        01081C48B0A0C18308132A5CC8B0A1C38710234A9C48B1A2C58B18335AC4D446
        23AF480231691C49B2A4C024494C964809A084C997301D96281180A64D97144B
        AC08C0D366CD9840830A6C439367CF9E333B4634CA942900A542A38EDC79D4A7
        CF871D6B6A2DDAB40454A9607376452970E6CC000FB7AE2CCBB567D8B712E918
        9D7930C955865B116AE509B72FC33697B80EFD3AF4E69CA1971097E50BD860A4
        C446FD4A464827C9518598ECE6E518F22CCD900739E79D4C9AA051960A2DCFDD
        DB3400E1833E5F97863B7A21A6D6B8D18A5CE819F5ECBE4569CA3E98BB69E286
        9187FF162AB7A76F856D59F35CF13C615100BB97C315CCD06EF4B3736DF2FF8E
        AC5DF275865C59687DA2952AF984EDCBF7051C5C2151A666F3833F7DBC60E2F3
        F2C195155F09CDD1D40A253CB1D282EEF1F4C46B98B8A455807EDDF793410BE2
        B7A05D1CEE772186918144E15B740457DD4E569550194A0AA254A25575ED35E2
        5B491C97DC406D18885F0049CCD146123FA2D486825CD1050059003475584B38
        CD181375021DF5A04044AA35131D80E5D863122F6EF593828B39A894914EC254
        53093A9E39D07EF93DE1E363975C92E31CDEB1899685049E5566466811575356
        36B1E4534D08AEE40960917C24678433B1D71400ECDD25DE9E66F215C94D38B5
        B51287735C3247A76FCE3193664D79176270FDADD9674EE505F0C441EEB9FF67
        A4A35A017909976D0873C91397F0C22597C119152978900AFBDA6715AD10D387
        69AD3A10A9AD99A5E14A6D60E2C92EBB203387AE977872EB51D14AE79641044A
        54EE4BE73A942E93AB1D252B8F68DA8A4C30C874424727F32213095155728562
        BB5F12042044E32EDBA772034176E18F51022C6E526DB41149B6F5FA784927F4
        EEB22F4AE26AC8541B772ADCE4428D25D967752451851DCA033D91D2842BA3E5
        53AC45ED842096BCF41ACC33F4567BC9BCD504F3516625DAEC25A1EB7DC61177
        0C4568729FCABE84D35C2D910CA3C9C181B752A9393E568B30F346D2A9C4F406
        F39896AA81CB93A97BFD37A188D6B5C494774FF2881F147D42F15C002C04FFEB
        92AC0C9E99F6A8355EB2CBCF9D08536DAEF44EEC294AFB5946538BACF53D2876
        382198E44001E0DD5AD42F7514DD5E4A317CA4A64522859277AB676D6B9C97EC
        DBED9B981C7E2BDB67065AA7877B09CAD785C5396BD1C86B3E9D9B4058D20905
        9BFB216897CBA2AE9E84A3092608D81C1C892A179D7AC4397D82C2EAE7B2822E
        FBEB999745BDBCE35D19D985E1E863CD7176BFF09A087990404A6F96F44F3CB8
        2B9AB722D2EE72B7A0206D4A330794D699765415FD8C2A23C92B41DF0482B741
        B18626D4E1C8A2BCB313169DC56528F191FF7EB4B5469965799F82C21C145441
        9D18A550F1FA518BAA37935B89AA4AF4C3E099B0B4A8C59508232E89DDBEFF8E
        94922AE5665471CA5112F3C322D6AD4E4E49385B9D205793F2B5AE7AB9438A57
        22D63AC8410C7FA3B253A300D3AB8D4531126223D3445C12090DB6B15A6D9C1E
        FACEB43C4CCC014549E00891BCB2250E6DC98659228AA974E8A2B3A8075367F2
        119D40D823B3D049918DCC61E7E0F8115EB4C17393E4C80F878746219E2D76A0
        1CD2FEBCE3264FA1EA56A3A413EB5642A71F492C1269DB5DA7A6383841727141
        B8DC1417B95827A474EA708713556B801431D351040A88E28826B754191F6506
        4198302596ECE8B91258923D87DC127B6038431E26014512DC546566B2BC6DD6
        E87B549C49F692B03C1735F25F78AC641CE1C713643A93781191DFC6F675FFC4
        4FA91376768C53736A4414F0AD04840ED40F1705A7BF99802A7F095D89A7E6B0
        8B4F35742F48BC4466BE333A200D119F105166529A831B152ECF1373A0C31C50
        EA09D594A057DEC1DB83F446A7A2E5673D720CE3F80240874BF43433C332A1CB
        84D1939C59B2685EA2CED0BED9949E12153F8BA32048D1632BC0F0843E4774D3
        4A69D5953899E5097032DCE150DA2994E6210F9182DC13F2208C6008A37FBB72
        95F7F2232A877AAA272BEC142AF747D15D44334E76FC54348591A69A24519529
        590B44F4D6C3F4F9EA5F455AE925DE0ABF6856B00D1F391C503BF7043DE0EB18
        CE98831E3A9B07528C62B4DDF3D653397B2814AA48B2BA2A115356805976FFD6
        248F946CE36477AB2B5ABD54998B5BE644F66555FEA474765CE9A92730218C3C
        CCF609D1AC6B090EA755616D6B72C838062900A1872A54A1419E10862726E7A8
        2774E209DEF2847A57C8BBE9C4C9A28BEC91463DF5043AF44FBD4DF19606B3F4
        D1A92664BF4DC955B726CB946D75CB137883C27A75355E9A4041A33599C3F278
        B4820A076005A4D09633F280492B040010C820054FAA808CE9A856BD2EEC0A14
        9EA01E287442B5BBE505F6B03759AEB280AB0FD61570950980E541C456B0EC6A
        34516C14F5AAD7737AD04309964707C29A45570E7215521C14623D38E3CAAA20
        852A3CEC0C5554C10AA470068A9041666198590F0EF2441E76A207325325FF41
        3A9E6F34E7CC5C5AAD80AB2B50B273E424A78845044DD51A1D8C57CB02B67602
        CD3C518F9A77E2894E54F0BA89B609A20390E1103F03107D0384333C0C882A00
        0210ABA04A85573C5A64383700CE08F185299D07AE902271BC8DB5303AF10C4F
        AF00100DCA0D705F1511327EC7CCBB102F53EA2562A6908214C1112FF98431E9
        CF91F9D962E609202E6C855CAFC00A56F8EE74A6BD025528683AEEB1822A5481
        0CB0252EBCE7468627C87CE56207EFAAB16B09CBFEDBC6D1B5755E9E300A0BD6
        7D6A9EE88114EAA927BD1C5D8259A33956D70E33329C015A64789829D500F874
        38AD8A559416D455B87035D6CCB7FD54BBD0CE0833BEC88CAF4A5FFAE1EFFFE6
        91267BFC6744C16F05794046C67B526E6450A5CD98BCB01ED67D5FF17AE2DBFE
        4EF5B3D9FD70511BC50AAB987600C47DE52BABE7095BBE30553C7C67A3689ADC
        C85085D0438EEBE25CBBC2FDCBE35C2502E8DB042FE07C4B1CBD4A706C943385
        05F88A7BCE8D92E154DBDDE19D8BFA74F8D6144D3FC319CF78E1D2ADDEE54F7B
        3A0FABD82E296AFD0C2D5BF8EDD7AEC2B81BFF8CF0F66A713E9688C40293F2E9
        941B6CA4A8C2E8EE9CE73257B92D9A6E3AB46DD6F8ED8E7B156E67FA95957E61
        67D07E057DE389D6EDBE026764FC09D60E801E523F7B9B3C18B044A9C834DFED
        AF983F61EE35D979BD423CFD10037DDB0AB7FBA697BE7064FCBD1A51570FFF0B
        AC00E22B17BD1ADA16F5C3AD3C8A90B360E66FAF42978B1E723D20A8C8D8BBA4
        7FBBE3234DADD04DC2906BB8517A6606369E506960531C56D67457B6134F3074
        21B70292077FA8B67084172937C76942870CDC365BA94766A43075ED6662F3C5
        6B15E1322445134E3559BB90824D814D2FB6640FE80970972F216814505005AB
        F0659EF6041E266E3B610564563622867633F16F32D71379607B93F3610A0208
        591672BE1700DA560255F00C20E80CED4715A9A6740F38609B54119BD2168533
        585CD513E8750951F64268660505880CA81562B8963AFEE680F36266A6863417
        F67936477761262B6B556DAA0062C88037DB357C43C76EDE76618B180031FFB7
        5E266811E5743ED3B42D77D43BBA220C2D885188A6199E255ED3970768377CCF
        A00A0197679D436693156273506E72E162BA82661894078D666A6C460A78335A
        259007AA50134B4872226605ED57056887372CD066B393791771404CA155A864
        1CD8822D83835253C65968C25525B06E6486724F2062E825592C556335915E73
        212ADBC27101905284E2808EA20705986F3C2184B956026DB65E71022617C142
        E7F32972812687C437BD1290E6448E3C018F5AA152CBA3426D6570EDD18AE835
        3DEC6416D1F48A2BD51B78635F8DD2398D326B47466587A6152E266256C13769
        085CCA98132C121E34215F404751B0C37949C02D9CF75224C51371A289BCFF10
        6C716562C8B05B4CC216D8C11E79244C2AC7154F405918D53F91E22AC2C6134D
        365EC59120F9A7486A14119338926E324DDE81096DA45B93935249D060013067
        10F95301495836139689D3634B52102EA18E6E627605A751EC246084A549E773
        130CB664BC906F2A681690755BD3542D2C31410FD145E7D3239FF22981A157DE
        131856214C0064382FE9981C62386D0599908232F1C2238F733DA5E43D28E129
        13052D0E8209BCC00B2A4552E8C51E9D3292B7554C72B23155691DFA28393CF2
        2B72923C70A43DF7112862B95FCDB43874124D394958919810F6D43900353D3D
        E69C13B4648016415FA92B4CA6152C50912BC11115843E5B249CDF7392B0FF81
        98D2A34A93791848B43F732239B3F49694094AD8E22940D910819104C1349F46
        929F8A444674069B3466198B694A0B242DA3524C880539CAE912D2393E5B9279
        9921554FF19599C128E9180928A4514A91797823117AA47F0EA137C803472295
        2273362A9A14682399222E4353C0D21DD2039182E23E045123A3B298D20518FA
        E39615619FA2F4676B62317B755BCAF42D64342473E519796916F8336F06C1A2
        617810C8A4823982A23C9523D2591281268965A719C8B44C8C825B11D2A55AD2
        4CBFE24E3595200F91294C5A3575754E40A2A450A41282721151A42580913D90
        E9508F819E551531ADD447309A58FB07A583EA123F523F04C467833A11E2B059
        11C8349883B951425A2D3D861395B19BBF42A699979C23F152BBC3445C54263E
        F22390A4A8499144D5913FC5E44551614FA3B49284B927B8754FB4953D2AD295
        4E8321100A166FB92F80163D5952353372AA7E266F71125625132090DA23B14A
        2938B1A195BA639885309351A05545278B5A26046531C614204B46504F4A2908
        C1588BC3A9DA4117712AACE29A1A68545723824211B9AE1FCA252C3723D82AAF
        7FB6A6F8BAAFFCDAAFFEFAAFB31110003B}
      UseBorder = False
      UseSize = False
    end
    object IWLabel1: TIWLabel
      Left = 3
      Top = 36
      Width = 451
      Height = 30
      Cursor = crAuto
      Align = alTop
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      Alignment = taLeftJustify
      BGColor = clNone
      Font.Color = clNone
      Font.Size = 12
      Font.Style = []
      NoWrap = False
      ConvertSpaces = True
      HasTabOrder = False
      AutoSize = False
      FriendlyName = 'IWLabel1'
      Caption = '  '#27426#36814#20351#29992#12298#26263#40657#38477#39764#24405#12299#21518#21488#31649#29702
      RawText = False
      ExplicitLeft = 2
      ExplicitTop = 35
      ExplicitWidth = 453
    end
    object IWlabErrorTip: TIWLabel
      Left = 3
      Top = 261
      Width = 451
      Height = 16
      Cursor = crAuto
      Align = alBottom
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      Alignment = taRightJustify
      BGColor = clNone
      Font.Color = clWebRED
      Font.Size = 10
      Font.Style = []
      NoWrap = False
      ConvertSpaces = False
      HasTabOrder = False
      AutoSize = False
      FriendlyName = 'IWlabErrorTip'
      RawText = False
      ExplicitLeft = 1
      ExplicitTop = 234
      ExplicitWidth = 453
    end
    object IWLabel4: TIWLabel
      Left = 160
      Top = 194
      Width = 93
      Height = 21
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      Alignment = taLeftJustify
      BGColor = clNone
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      NoWrap = False
      ConvertSpaces = False
      HasTabOrder = False
      FriendlyName = 'IWLabel1'
      Caption = #35821#35328#36873#25321#65306
      RawText = False
    end
    object IWComboBox1: TIWComboBox
      Left = 256
      Top = 193
      Width = 121
      Height = 21
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      StyleRenderOptions.RenderSize = True
      StyleRenderOptions.RenderPosition = True
      StyleRenderOptions.RenderFont = True
      StyleRenderOptions.RenderZIndex = True
      StyleRenderOptions.RenderVisibility = True
      StyleRenderOptions.RenderStatus = True
      StyleRenderOptions.RenderAbsolute = True
      BGColor = clNone
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FocusColor = clNone
      AutoHideOnMenuActivation = False
      ItemsHaveValues = False
      NoSelectionText = '--'#26410#36873#25321'--'
      Required = False
      RequireSelection = True
      ScriptEvents = <>
      UseSize = True
      Style = stNormal
      ButtonColor = clBtnFace
      DoSubmitValidation = True
      Editable = True
      NonEditableAsLabel = True
      SubmitOnAsyncEvent = True
      TabOrder = 4
      ItemIndex = -1
      Items.Strings = (
        #33719#24471
        #28040#32791)
      Sorted = False
      FriendlyName = 'IWComboBox1'
    end
    object IWRegion2: TIWRegion
      Left = 3
      Top = 3
      Width = 451
      Height = 33
      Cursor = crAuto
      RenderInvisibleControls = False
      Align = alTop
      BorderOptions.NumericWidth = 1
      BorderOptions.BorderWidth = cbwNumeric
      BorderOptions.Style = cbsNone
      BorderOptions.Color = clNone
      Color = clWebWHITE
      ParentShowHint = False
      ShowHint = True
      ZIndex = 1000
      Splitter = False
    end
  end
  object IWTimer1: TIWTimer
    Enabled = False
    Interval = 100
    OnAsyncTimer = IWTimer1AsyncTimer
    Left = 432
    Top = 104
  end
end
