inherited IWfrmStallTrack: TIWfrmStallTrack
  DesignLeft = 8
  DesignTop = 8
  inherited IWRegionClient: TIWRegion
    inherited IWRegion1: TIWRegion
      object IWRegion2: TIWRegion
        Left = 0
        Top = 0
        Width = 859
        Height = 73
        Cursor = crAuto
        RenderInvisibleControls = False
        TabOrder = 2
        Align = alTop
        BorderOptions.NumericWidth = 1
        BorderOptions.BorderWidth = cbwNumeric
        BorderOptions.Style = cbsSolid
        BorderOptions.Color = clNone
        Color = clNone
        ParentShowHint = False
        ShowHint = True
        ZIndex = 1000
        Splitter = False
        object IWBtnBuild: TIWButton
          Left = 377
          Top = 9
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
          Caption = #26597#35810
          DoSubmitValidation = True
          Color = clBtnFace
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'IWBtnBuild'
          ScriptEvents = <>
          TabOrder = 5
          OnClick = IWBtnBuildClick
        end
        object IWLabel3: TIWLabel
          Left = 14
          Top = 44
          Width = 82
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
          Alignment = taLeftJustify
          BGColor = clNone
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          NoWrap = False
          ConvertSpaces = False
          HasTabOrder = False
          FriendlyName = 'IWLabel1'
          Caption = #32467#26463#26085#26399#65306
          RawText = False
        end
        object IWLabel1: TIWLabel
          Left = 15
          Top = 13
          Width = 82
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
          Alignment = taLeftJustify
          BGColor = clNone
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          NoWrap = False
          ConvertSpaces = False
          HasTabOrder = False
          FriendlyName = 'IWLabel1'
          Caption = #36215#22987#26085#26399#65306
          RawText = False
        end
        object pSDate: TTIWDateSelector
          Left = 83
          Top = 9
          Width = 203
          Height = 24
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
          Day = 1
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          Month = 1
          NameOfMonths.Strings = (
            '1'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            '10'
            '11'
            '12')
          ShowDay = True
          ShowYear = True
          Style = dpYearMonthDay
          TabOrder = 13
          Year = 2010
          YearFrom = 2010
          YearTo = 2015
        end
        object pSTime: TTIWAdvTimeEdit
          Left = 235
          Top = 10
          Width = 125
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
          FocusColor = clWhite
          DoSubmitValidation = True
          Editable = True
          NonEditableAsLabel = True
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'pSTime'
          MaxLength = 0
          ReadOnly = False
          Required = False
          ScriptEvents = <>
          SubmitOnAsyncEvent = True
          TabOrder = 14
          AdvanceOnReturn = False
          BorderColor = clBlack
          BorderWidth = 1
          ButtonDownImage.Stretch = False
          ButtonDownImage.Frame = 0
          ButtonUpImage.Stretch = False
          ButtonUpImage.Frame = 0
          Color = clWhite
          Flat = False
          SelectAll = False
          ShowSeconds = True
          SubmitOnReturn = False
          Hour = 0
          Minutes = 0
          Seconds = 0
          TimeSeparator = ':'
        end
        object pETime: TTIWAdvTimeEdit
          Left = 234
          Top = 41
          Width = 125
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
          FocusColor = clWhite
          DoSubmitValidation = True
          Editable = True
          NonEditableAsLabel = True
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'pSTime'
          MaxLength = 0
          ReadOnly = False
          Required = False
          ScriptEvents = <>
          SubmitOnAsyncEvent = True
          TabOrder = 15
          AdvanceOnReturn = False
          BorderColor = clBlack
          BorderWidth = 1
          ButtonDownImage.Stretch = False
          ButtonDownImage.Frame = 0
          ButtonUpImage.Stretch = False
          ButtonUpImage.Frame = 0
          Color = clWhite
          Flat = False
          SelectAll = False
          ShowSeconds = True
          SubmitOnReturn = False
          Hour = 0
          Minutes = 0
          Seconds = 0
          TimeSeparator = ':'
        end
        object pEDate: TTIWDateSelector
          Left = 82
          Top = 40
          Width = 203
          Height = 24
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
          Day = 1
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          Month = 1
          NameOfMonths.Strings = (
            '1'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            '10'
            '11'
            '12')
          ShowDay = True
          ShowYear = True
          Style = dpYearMonthDay
          TabOrder = 16
          Year = 2010
          YearFrom = 2010
          YearTo = 2015
        end
        object IWButton3: TIWButton
          Left = 377
          Top = 39
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
          Caption = #23548#20986'CSV'
          DoSubmitValidation = True
          Color = clBtnFace
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'IWButton1'
          ScriptEvents = <>
          TabOrder = 17
          OnClick = IWButton3Click
        end
        object IWLogMode: TIWCheckBox
          Left = 468
          Top = 12
          Width = 123
          Height = 19
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
          Caption = #26032#29256#26085#24535#27169#24335
          Editable = True
          Font.Color = clWebBLUE
          Font.Size = 10
          Font.Style = [fsBold]
          SubmitOnAsyncEvent = True
          ScriptEvents = <>
          DoSubmitValidation = True
          Style = stNormal
          TabOrder = 18
          Checked = True
          FriendlyName = 'IWLogMode'
        end
      end
      object IWRegion3: TIWRegion
        Left = 0
        Top = 73
        Width = 859
        Height = 522
        Cursor = crAuto
        HorzScrollBar.Visible = False
        VertScrollBar.Visible = False
        RenderInvisibleControls = False
        Align = alClient
        BorderOptions.NumericWidth = 1
        BorderOptions.BorderWidth = cbwNumeric
        BorderOptions.Style = cbsNone
        BorderOptions.Color = clNone
        Color = clNone
        ParentShowHint = False
        ShowHint = True
        ZIndex = 1000
        Splitter = False
        object TIWAdvWebGrid1: TTIWAdvWebGrid
          Left = 0
          Top = 0
          Width = 859
          Height = 522
          Cursor = crAuto
          Align = alClient
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
          ActiveRowColor = clNone
          ActiveRowFontColor = clNone
          AdvanceOnReturn = False
          AutoEdit = False
          AutoHTMLAdapt = False
          Background.GradientDirection = gdHorizontal
          Background.Gradient1 = 16707813
          Background.Gradient2 = 16707813
          Background.Picture.Stretch = False
          Background.Picture.Frame = 0
          Bands.Active = False
          Bands.PrimaryColor = clInfoBk
          Bands.SecondaryColor = clWebWHITE
          Borders.Inner = ibAll
          Borders.Outer = obAll
          Borders.Padding = 0
          Borders.Spacing = 0
          Borders.Width = 1
          Borders.Collapsed = True
          Borders.Color = clWebGRAY
          Borders.ColorDark = clNone
          Borders.ColorLight = clNone
          CellComment.BorderColor = 14263350
          CellComment.Color = 15784080
          CellComment.DisplayType = dtMouseOver
          CellComment.Font.Color = 9330453
          CellComment.Font.Size = 10
          CellComment.Font.Style = []
          CheckTruePicture.Stretch = False
          CheckTruePicture.Frame = 0
          CheckFalsePicture.Stretch = False
          CheckFalsePicture.Frame = 0
          Color = 16707813
          Columns = <
            item
              CheckTrue = 'true'
              CheckFalse = 'false'
              ColumnHeaderFont.Color = clNone
              ColumnHeaderFont.Size = 10
              ColumnHeaderFont.Style = []
              ColumnType = ctRowNumber
              DefaultDynEdit = '0'
              DefaultDynText = '0'
              DetailFont.Color = clNone
              DetailFont.Size = 10
              DetailFont.Style = []
              ImageIndex = 0
              Font.Color = clNone
              Font.Size = 10
              Font.Style = []
              FooterFormat = '%g'
              SpinEditMaxValue = 100
              SpinEditMinValue = 0
              Width = 32
              SortFormat = sfAlphabetic
            end
            item
              CheckTrue = 'true'
              CheckFalse = 'false'
              ColumnHeaderFont.Color = clNone
              ColumnHeaderFont.Size = 10
              ColumnHeaderFont.Style = []
              DefaultDynEdit = '0'
              DefaultDynText = '0'
              DetailFont.Color = clNone
              DetailFont.Size = 10
              DetailFont.Style = []
              Font.Color = clNone
              Font.Size = 10
              Font.Style = []
              FooterFormat = '%g'
              SpinEditMaxValue = 100
              SpinEditMinValue = 0
              Title = #29289#21697'ID'
              Width = 100
              SortFormat = sfAlphabetic
            end
            item
              CheckTrue = 'true'
              CheckFalse = 'false'
              ColumnHeaderFont.Color = clNone
              ColumnHeaderFont.Size = 10
              ColumnHeaderFont.Style = []
              DefaultDynEdit = '0'
              DefaultDynText = '0'
              DetailFont.Color = clNone
              DetailFont.Size = 10
              DetailFont.Style = []
              Font.Color = clNone
              Font.Size = 10
              Font.Style = []
              FooterFormat = '%g'
              SpinEditMaxValue = 100
              SpinEditMinValue = 0
              Title = #29289#21697#21517#31216
              Width = 140
              SortFormat = sfAlphabetic
            end
            item
              CheckTrue = 'true'
              CheckFalse = 'false'
              ColumnHeaderFont.Color = clNone
              ColumnHeaderFont.Size = 10
              ColumnHeaderFont.Style = []
              DefaultDynEdit = '0'
              DefaultDynText = '0'
              DetailFont.Color = clNone
              DetailFont.Size = 10
              DetailFont.Style = []
              Font.Color = clNone
              Font.Size = 10
              Font.Style = []
              FooterFormat = '%g'
              SpinEditMaxValue = 100
              SpinEditMinValue = 0
              Title = #20132#26131#25968#37327
              Width = 100
              SortFormat = sfAlphabetic
            end
            item
              CheckTrue = 'true'
              CheckFalse = 'false'
              ColumnHeaderFont.Color = clNone
              ColumnHeaderFont.Size = 10
              ColumnHeaderFont.Style = []
              DefaultDynEdit = '0'
              DefaultDynText = '0'
              DetailFont.Color = clNone
              DetailFont.Size = 10
              DetailFont.Style = []
              ImageIndex = 0
              Font.Color = clNone
              Font.Size = 10
              Font.Style = []
              FooterFormat = '%g'
              SpinEditMaxValue = 100
              SpinEditMinValue = 0
              Title = #36135#24065#31867#22411
              Width = 100
              SortFormat = sfAlphabetic
            end
            item
              CheckTrue = 'true'
              CheckFalse = 'false'
              ColumnHeaderFont.Color = clNone
              ColumnHeaderFont.Size = 10
              ColumnHeaderFont.Style = []
              DefaultDynEdit = '0'
              DefaultDynText = '0'
              DetailFont.Color = clNone
              DetailFont.Size = 10
              DetailFont.Style = []
              Font.Color = clNone
              Font.Size = 10
              Font.Style = []
              FooterFormat = '%g'
              SpinEditMaxValue = 100
              SpinEditMinValue = 0
              Title = #20132#26131#20215#26684
              Width = 140
              SortFormat = sfAlphabetic
            end
            item
              CheckTrue = 'true'
              CheckFalse = 'false'
              ColumnHeaderFont.Color = clNone
              ColumnHeaderFont.Size = 10
              ColumnHeaderFont.Style = []
              DefaultDynEdit = '0'
              DefaultDynText = '0'
              DetailFont.Color = clNone
              DetailFont.Size = 10
              DetailFont.Style = []
              Font.Color = clNone
              Font.Size = 10
              Font.Style = []
              FooterFormat = '%g'
              SpinEditMaxValue = 100
              SpinEditMinValue = 0
              Title = #25670#25674#32773#31561#32423
              Width = 100
              SortFormat = sfAlphabetic
            end
            item
              CheckTrue = 'true'
              CheckFalse = 'false'
              ColumnHeaderFont.Color = clNone
              ColumnHeaderFont.Size = 10
              ColumnHeaderFont.Style = []
              DefaultDynEdit = '0'
              DefaultDynText = '0'
              DetailFont.Color = clNone
              DetailFont.Size = 10
              DetailFont.Style = []
              Font.Color = clNone
              Font.Size = 10
              Font.Style = []
              FooterFormat = '%g'
              SpinEditMaxValue = 100
              SpinEditMinValue = 0
              Title = #36141#20080#32773#31561#32423
              Width = 100
              SortFormat = sfAlphabetic
            end>
          ColumnHeaderColor = 11529727
          ColumnHeaderFont.Color = clNone
          ColumnHeaderFont.Size = 10
          ColumnHeaderFont.Style = []
          ColumnHeaderBorders.Inner = ibAll
          ColumnHeaderBorders.Outer = obAll
          ColumnHeaderBorders.Padding = 0
          ColumnHeaderBorders.Spacing = 0
          ColumnHeaderBorders.Width = 1
          ColumnHeaderBorders.Collapsed = True
          ColumnHeaderBorders.Color = clNone
          ColumnHeaderBorders.ColorDark = clNone
          ColumnHeaderBorders.ColorLight = clNone
          ColumnSizing = False
          Controller.Alignment = taLeftJustify
          Controller.Borders.Inner = ibAll
          Controller.Borders.Outer = obAll
          Controller.Borders.Padding = 0
          Controller.Borders.Spacing = 0
          Controller.Borders.Width = 1
          Controller.Borders.Collapsed = True
          Controller.Borders.Color = clNone
          Controller.Borders.ColorDark = clNone
          Controller.Borders.ColorLight = clNone
          Controller.Color = 8694014
          Controller.Font.Color = clNone
          Controller.Font.Size = 10
          Controller.Font.Style = []
          Controller.Gradient1 = 8694014
          Controller.Gradient2 = 4749293
          Controller.GradientDirection = gdHorizontal
          Controller.Height = 24
          Controller.MaxPages = 100
          Controller.Position = cpTop
          Controller.Pager = cpPrevNextFirstLast
          Controller.PagerType = cptImageButton
          Controller.IndicatorFormat = #24403#21069' %d '#39029#65292#20849#26377' %d '#39029
          Controller.IndicatorType = itPageNr
          Controller.TextPrev = #19978#19968#39029
          Controller.TextNext = #19979#19968#39029
          Controller.TextFirst = #31532#19968#39029
          Controller.TextLast = #26368#21518#19968#39029
          Controller.ImgPrev.Stretch = False
          Controller.ImgPrev.Frame = 1
          Controller.ImgNext.Stretch = False
          Controller.ImgNext.Frame = 1
          Controller.ImgFirst.Stretch = False
          Controller.ImgFirst.Frame = 1
          Controller.ImgLast.Stretch = False
          Controller.ImgLast.Frame = 0
          Controller.RowCountSelect = False
          Controller.HintFind = 'Find'
          Controller.ShowPagersAlways = False
          DateSeparator = '/'
          DateFormat = gdEU
          DecimalPoint = '.'
          DefaultColumnHeaderHeight = 22
          DefaultRowHeight = 22
          DetailRowHeight = 0
          DetailRowShow = dsNormal
          EditColor = clNone
          EditSelectAll = False
          FooterBorders.Inner = ibAll
          FooterBorders.Outer = obAll
          FooterBorders.Padding = 0
          FooterBorders.Spacing = 0
          FooterBorders.Width = 1
          FooterBorders.Collapsed = True
          FooterBorders.Color = clNone
          FooterBorders.ColorDark = clNone
          FooterBorders.ColorLight = clNone
          FooterColor = 11529727
          FooterFont.Color = clNone
          FooterFont.Size = 10
          FooterFont.Style = []
          Font.Color = 8404992
          Font.Size = 10
          Font.Style = [fsBold]
          Glyphs.EditButton.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            0800000000000001000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000707E4E4E4E4
            E4E4E4E4E4E4E4E4E4070707EDF609090909090909090909E4070707EDF60707
            0707070707070709E4070707EDF6F6090909090909090909E4070707EDFFF609
            0909095A09090909E4070707F5FF07070707075200070709E4070707F5FFFFF6
            F609095A00000709E407070707FFFFFFF6F6095AFB360007E407070707FF0707
            070707A4FB360007ED07070709FFFFFFFFF6F6F65BFB3600ED07070709FFFFFF
            FFFFF6F6ACFB36000707070709FF070707070707F652FB360007070709FFFFFF
            FFFFFFFF079A7F360007070709FFFFFFFFFFFFFF08EC51000200070709FFFFFF
            FFFFFFFF07EC9A0202410707090909090909090907E407838307}
          Glyphs.EditHint = 'Edit'
          Glyphs.PostButton.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            0800000000000001000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0007070707071D
            1D1D1D1D1D0707070707070707271E1F2727271F1E1D1D07070707071E276FB7
            F6F6F6BF6F271E1D0707072727B7F6FFF6F6F6FFFFBF271E1D070727B7FFF6B7
            6FBF276FF6FFBF271D07276FF6FF6F27F6FF6F1F27F6FF6F1E1D27B7FFBF6FF6
            FFF6B7271F6FFFBF1F1D27B7FFB7BFFFAF6FF6672727F6F6271E67BFFFB76F6F
            2727B7B72727F6F6271E6F08FFB76F6F6F676FB72727F6F6271E67BFFFF66F6F
            6F6F676F6FB7FFB7271D076FF6FFBF6F6F6F6727B7F6F66F1E07076FF6F6FFF6
            B7B7B7BFFFFFB7271E070707AFF6FFFFFFFFFFFFF6B7271F07070707076FBFF6
            F6F6F6B76F272707070707070707076FAFAF6F67270707070707}
          Glyphs.PostHint = 'Post'
          Glyphs.CancelButton.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            0800000000000001000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0007070707071D
            1D1D1D1D1D0707070707070707271E1F2727271F1E1D1D07070707071E276FB7
            F6F6F6BF6F271E1D0707072727B7F6FFF6F6F6FFFFBF271E1D070727B7FFF627
            27271F1FB7F6BF271D07276FF6FFB7B767272727B7B7FF6F1E1D27B7FFBF67B7
            F66767F6B727F6BF1F1D27B7FF6F6F67B7F6F6B72727BFF6271E67BFFF6F6F6F
            6FF6F66F2727B7F6271E6F08FF6F6F6FF6B7B7F66F27F6F6271E67BFFFF66FF6
            B76F6FB7F66FF6B7271D076FF6FFB7AF6F6F6F6FB7F6F66F1E07076FF6F6FFF6
            6F6F6FB7FFFFB7271E070707AFF6FFFFFFFFFFFFF6B7271F07070707076FBFF6
            F6F6F6B76F272707070707070707076FAFAF6F67270707070707}
          Glyphs.CancelHint = 'Cancel'
          Glyphs.SpinEditButtonDownImage.Stretch = False
          Glyphs.SpinEditButtonDownImage.Frame = 0
          Glyphs.SpinEditButtonUpImage.Stretch = False
          Glyphs.SpinEditButtonUpImage.Frame = 0
          HoverColor = clNone
          HoverFontColor = clNone
          HeaderStyle = hsRaised
          ID = 0
          Indicators.Browse.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888888880888888888888888008888888888888800088888
            8888888800008888888888880000088888888888000000888888888800000008
            8888888800000088888888880000088888888888000088888888888800088888
            8888888800888888888888880888888888888888888888888888}
          Indicators.Insert.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888888888888888888888888888888888888888888088888
            8888888888088888888888800808008888888888800088888888888880008888
            8888888008080088888888888808888888888888880888888888888888888888
            8888888888888888888888888888888888888888888888888888}
          Indicators.Edit.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888888888888888888888880080088888888888880888888
            8888888880888888888888888088888888888888808888888888888880888888
            8888888880888888888888888088888888888888808888888888888880888888
            8888888008008888888888888888888888888888888888888888}
          MouseSelect = msNone
          Nodes.NodeOpen.Stretch = False
          Nodes.NodeOpen.Frame = 1
          Nodes.NodeOpen.Data = {
            424DBE0000000000000076000000280000000900000009000000010004000000
            000048000000120B0000120B0000100000001000000000000000000080000080
            00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
            000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000FFF
            FFFF000000000FFF0FFF000000000FFF0FFF000000000F00000F000000000FFF
            0FFF000000000FFF0FFF000000000FFFFFFF000000000000000000000000}
          Nodes.NodeClosed.Stretch = False
          Nodes.NodeClosed.Frame = 1
          Nodes.NodeClosed.Data = {
            424DBE0000000000000076000000280000000900000009000000010004000000
            000048000000120B0000120B0000100000001000000000000000000080000080
            00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
            000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000FFF
            FFFF000000000FFFFFFF000000000FFFFFFF000000000F00000F000000000FFF
            FFFF000000000FFFFFFF000000000FFFFFFF000000000000000000000000}
          NameOfDays.Strings = (
            'Sun'
            'Mon'
            'Tue'
            'Wed'
            'Thu'
            'Fri'
            'Sat')
          NameOfMonths.Strings = (
            'January'
            'February'
            'March'
            'April'
            'May'
            'June'
            'July'
            'August'
            'September'
            'October'
            'November'
            'December')
          OuterBorder.Show = False
          OuterBorder.Color = clWebBLACK
          Page = 0
          RowCount = 10
          RowHeader.Show = False
          RowHeader.Width = 22
          RowHeader.Borders.Inner = ibAll
          RowHeader.Borders.Outer = obAll
          RowHeader.Borders.Padding = 0
          RowHeader.Borders.Spacing = 0
          RowHeader.Borders.Width = 1
          RowHeader.Borders.Collapsed = False
          RowHeader.Borders.Color = clNone
          RowHeader.Borders.ColorDark = clNone
          RowHeader.Borders.ColorLight = clNone
          RowHeader.Color = clBtnFace
          RowHeader.Gradient1 = clNone
          RowHeader.Gradient2 = clNone
          RowHeader.GradientDirection = gdHorizontal
          Scroll.Style = scAuto
          Scroll.Scrollbar3DLightColor = clNone
          Scroll.ScrollbarArrowColor = clNone
          Scroll.ScrollbarBaseColor = clNone
          Scroll.ScrollbarTrackColor = clNone
          Scroll.ScrollbarDarkshadowColor = clNone
          Scroll.ScrollbarFaceColor = clNone
          Scroll.ScrollbarHighlightColor = clNone
          Scroll.ScrollbarShadowColor = clNone
          SelectColor = clWebRED
          SelectFontColor = clWebBLACK
          ShowColumnHeader = True
          ShowFooter = False
          ShowSelect = True
          SortSettings.Show = False
          SortSettings.Column = -1
          SortSettings.Direction = sdAscending
          SortSettings.Ascending.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            88888888888888888888888888888888888888888888888888888888FFFFFFFF
            888888880888888F888888880888888F88888888808888F888888888808888F8
            8888888888088F888888888888088F88888888888880F888888888888880F888
            8888888888888888888888888888888888888888888888888888}
          SortSettings.Descending.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            88888888888888888888888888888888888888888880F888888888888880F888
            8888888888088F888888888888088F8888888888808888F888888888808888F8
            888888880888888F888888880888888F88888888000000008888888888888888
            8888888888888888888888888888888888888888888888888888}
          SortSettings.InitSortDir = sdAscending
          StretchColumn = -1
          TabOrder = 7
          UseFullHeight = True
          UseFullWidth = True
          AsyncActiveRowMove = False
          AsyncEdit = False
          AsyncPaging = False
          AsyncSorting = False
          ActiveRow = 0
          AlwaysEdit = False
          TotalRows = 10
          ExplicitLeft = 1
          ExplicitTop = -3
        end
      end
    end
  end
  inherited IWAppTitleRegion: TIWRegion
    inherited IWbtnChangePass: TIWButton
      TabOrder = 12
    end
    inherited IWcBoxZJHTSpList: TIWComboBox
      TabOrder = 9
    end
  end
  inherited IWRegionChangePass: TIWRegion
    inherited IWedtCPNewPass: TIWEdit
      TabOrder = 6
    end
    inherited IWbtnCPOK: TIWButton
      TabOrder = 8
    end
    inherited IWbtnCPCancel: TIWButton
      TabOrder = 10
    end
    inherited IWedtCPVerifyPass: TIWEdit
      TabOrder = 11
    end
  end
end
