inherited IWfrmRoleLevel: TIWfrmRoleLevel
  Height = 1000
  ExplicitHeight = 1000
  DesignLeft = 8
  DesignTop = 8
  object TIWDateSelector1: TTIWDateSelector [0]
    Left = 70
    Top = 35
    Width = 140
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
    TabOrder = 17
    Year = 2010
    YearFrom = 2010
    YearTo = 2015
  end
  object TIWAdvTimeEdit1: TTIWAdvTimeEdit [1]
    Left = 215
    Top = 37
    Width = 130
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
    TabOrder = 18
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
  inherited IWRegionClient: TIWRegion
    Height = 925
    ExplicitHeight = 925
    inherited IWRegion1: TIWRegion
      Height = 895
      ExplicitHeight = 895
      object IWRegion2: TIWRegion
        Left = 0
        Top = 0
        Width = 859
        Height = 65
        Cursor = crAuto
        RenderInvisibleControls = False
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
          Left = 69
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
          TabOrder = 3
          Year = 2010
          YearFrom = 2010
          YearTo = 2015
        end
        object pSTime: TTIWAdvTimeEdit
          Left = 231
          Top = 13
          Width = 130
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
          TabOrder = 6
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
        object IWLabel3: TIWLabel
          Left = 15
          Top = 39
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
        object pEDate: TTIWDateSelector
          Left = 69
          Top = 35
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
          TabOrder = 8
          Year = 2010
          YearFrom = 2010
          YearTo = 2015
        end
        object pETime: TTIWAdvTimeEdit
          Left = 231
          Top = 39
          Width = 130
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
          TabOrder = 10
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
        object IWBtnBuild: TIWButton
          Left = 759
          Top = 10
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
          Caption = #29983#25104#22270#34920
          DoSubmitValidation = True
          Color = clBtnFace
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'IWBtnBuild'
          ScriptEvents = <>
          TabOrder = 12
          OnClick = IWBtnBuildClick
        end
        object IWLabel2: TIWLabel
          Left = 369
          Top = 38
          Width = 83
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
          FriendlyName = 'IWLabel2'
          Caption = #31561'  '#32423'  '#27573#65306
          RawText = False
        end
        object IWedtLevel: TIWEdit
          Left = 434
          Top = 35
          Width = 57
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
          FriendlyName = 'IWedtLevel'
          MaxLength = 0
          ReadOnly = False
          Required = False
          ScriptEvents = <>
          SubmitOnAsyncEvent = True
          TabOrder = 15
          PasswordPrompt = False
          Text = '5'
        end
        object IWLabel4: TIWLabel
          Left = 369
          Top = 12
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
          Caption = #21019#24314#26085#26399#65306
          RawText = False
        end
        object pCDate: TTIWDateSelector
          Left = 431
          Top = 7
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
          TabOrder = 19
          Year = 2010
          YearFrom = 2010
          YearTo = 2015
        end
        object pCTime: TTIWAdvTimeEdit
          Left = 593
          Top = 11
          Width = 130
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
          TabOrder = 20
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
      end
      object IWRegion3: TIWRegion
        Left = 0
        Top = 65
        Width = 859
        Height = 830
        Cursor = crAuto
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
        object TIWAdvChart1: TTIWAdvChart
          Left = 5
          Top = 6
          Width = 600
          Height = 500
          Cursor = crAuto
          Visible = False
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
          Chart.AxisMode = amAxisChartWidthHeight
          Chart.Background.Font.Charset = DEFAULT_CHARSET
          Chart.Background.Font.Color = clWindowText
          Chart.Background.Font.Height = -11
          Chart.Background.Font.Name = 'Tahoma'
          Chart.Background.Font.Style = []
          Chart.Bands.Distance = 2.000000000000000000
          Chart.CrossHair.CrossHairYValues.Position = [chYAxis]
          Chart.CrossHair.Distance = 0
          Chart.Legend.Font.Charset = DEFAULT_CHARSET
          Chart.Legend.Font.Color = clWindowText
          Chart.Legend.Font.Height = -11
          Chart.Legend.Font.Name = 'Tahoma'
          Chart.Legend.Font.Style = []
          Chart.Range.StartDate = 41236.607920277780000000
          Chart.Series = <
            item
              AutoRange = arCommon
              Pie.ValueFont.Charset = DEFAULT_CHARSET
              Pie.ValueFont.Color = clWindowText
              Pie.ValueFont.Height = -11
              Pie.ValueFont.Name = 'Tahoma'
              Pie.ValueFont.Style = []
              Pie.LegendFont.Charset = DEFAULT_CHARSET
              Pie.LegendFont.Color = clWindowText
              Pie.LegendFont.Height = -11
              Pie.LegendFont.Name = 'Tahoma'
              Pie.LegendFont.Style = []
              Annotations = <>
              ChartType = ctBar
              CrossHairYValue.BorderWidth = 0
              CrossHairYValue.Font.Charset = DEFAULT_CHARSET
              CrossHairYValue.Font.Color = clWindowText
              CrossHairYValue.Font.Height = -11
              CrossHairYValue.Font.Name = 'Tahoma'
              CrossHairYValue.Font.Style = []
              CrossHairYValue.GradientSteps = 0
              LegendText = 'Serie 0'
              ShowInLegend = False
              Marker.MarkerPicture.Data = {}
              Name = 'Serie 0'
              ChartPattern.Data = {}
              ShowValue = True
              ValueFont.Charset = DEFAULT_CHARSET
              ValueFont.Color = clWindowText
              ValueFont.Height = -11
              ValueFont.Name = 'Tahoma'
              ValueFont.Style = []
              ValueFormat = '%g'
              XAxis.DateTimeFont.Charset = DEFAULT_CHARSET
              XAxis.DateTimeFont.Color = clWindowText
              XAxis.DateTimeFont.Height = -11
              XAxis.DateTimeFont.Name = 'Tahoma'
              XAxis.DateTimeFont.Style = []
              XAxis.MajorFont.Charset = DEFAULT_CHARSET
              XAxis.MajorFont.Color = clWindowText
              XAxis.MajorFont.Height = -11
              XAxis.MajorFont.Name = 'Tahoma'
              XAxis.MajorFont.Style = []
              XAxis.MajorUnit = 1.000000000000000000
              XAxis.MajorUnitSpacing = 0
              XAxis.MinorFont.Charset = DEFAULT_CHARSET
              XAxis.MinorFont.Color = clWindowText
              XAxis.MinorFont.Height = -11
              XAxis.MinorFont.Name = 'Tahoma'
              XAxis.MinorFont.Style = []
              XAxis.MinorUnit = 1.000000000000000000
              XAxis.MinorUnitSpacing = 0
              XAxis.TextTop.Font.Charset = DEFAULT_CHARSET
              XAxis.TextTop.Font.Color = clWindowText
              XAxis.TextTop.Font.Height = -11
              XAxis.TextTop.Font.Name = 'Tahoma'
              XAxis.TextTop.Font.Style = []
              XAxis.TextBottom.Font.Charset = DEFAULT_CHARSET
              XAxis.TextBottom.Font.Color = clWindowText
              XAxis.TextBottom.Font.Height = -11
              XAxis.TextBottom.Font.Name = 'Tahoma'
              XAxis.TextBottom.Font.Style = []
              YAxis.MajorFont.Charset = DEFAULT_CHARSET
              YAxis.MajorFont.Color = clWindowText
              YAxis.MajorFont.Height = -11
              YAxis.MajorFont.Name = 'Tahoma'
              YAxis.MajorFont.Style = []
              YAxis.MajorUnitSpacing = 0
              YAxis.MinorFont.Charset = DEFAULT_CHARSET
              YAxis.MinorFont.Color = clWindowText
              YAxis.MinorFont.Height = -11
              YAxis.MinorFont.Name = 'Tahoma'
              YAxis.MinorFont.Style = []
              YAxis.MinorUnitSpacing = 0
              YAxis.TextLeft.Font.Charset = DEFAULT_CHARSET
              YAxis.TextLeft.Font.Color = clWindowText
              YAxis.TextLeft.Font.Height = -11
              YAxis.TextLeft.Font.Name = 'Tahoma'
              YAxis.TextLeft.Font.Style = []
              YAxis.TextRight.Font.Charset = DEFAULT_CHARSET
              YAxis.TextRight.Font.Color = clWindowText
              YAxis.TextRight.Font.Height = -11
              YAxis.TextRight.Font.Name = 'Tahoma'
              YAxis.TextRight.Font.Style = []
              SelectedMarkSize = 0
              BarValueTextFont.Charset = DEFAULT_CHARSET
              BarValueTextFont.Color = clWindowText
              BarValueTextFont.Height = -11
              BarValueTextFont.Name = 'Tahoma'
              BarValueTextFont.Style = []
              XAxisGroups = <>
              SerieType = stNormal
            end>
          Chart.Title.Alignment = taCenter
          Chart.Title.Font.Charset = GB2312_CHARSET
          Chart.Title.Font.Color = clBlue
          Chart.Title.Font.Height = -19
          Chart.Title.Font.Name = #21326#25991#20013#23435
          Chart.Title.Font.Style = [fsBold]
          Chart.Title.Position = tTop
          Chart.Title.Size = 40
          Chart.Title.Text = #31561#32423#20154#25968#20998#24067#22270
          Chart.XAxis.Font.Charset = DEFAULT_CHARSET
          Chart.XAxis.Font.Color = clWindowText
          Chart.XAxis.Font.Height = -11
          Chart.XAxis.Font.Name = 'Tahoma'
          Chart.XAxis.Font.Style = []
          Chart.XGrid.MajorFont.Charset = DEFAULT_CHARSET
          Chart.XGrid.MajorFont.Color = clWindowText
          Chart.XGrid.MajorFont.Height = -11
          Chart.XGrid.MajorFont.Name = 'Tahoma'
          Chart.XGrid.MajorFont.Style = []
          Chart.XGrid.MinorFont.Charset = DEFAULT_CHARSET
          Chart.XGrid.MinorFont.Color = clWindowText
          Chart.XGrid.MinorFont.Height = -11
          Chart.XGrid.MinorFont.Name = 'Tahoma'
          Chart.XGrid.MinorFont.Style = []
          Chart.YAxis.Font.Charset = DEFAULT_CHARSET
          Chart.YAxis.Font.Color = clWindowText
          Chart.YAxis.Font.Height = -11
          Chart.YAxis.Font.Name = 'Tahoma'
          Chart.YAxis.Font.Style = []
          Chart.YAxis.Size = 80
          Chart.YGrid.MinorDistance = 1.000000000000000000
          Chart.YGrid.MajorDistance = 2.000000000000000000
        end
      end
    end
  end
  inherited IWNavBarRegion: TIWRegion
    Height = 925
    ExplicitHeight = 925
    inherited TIWBasicSideNavBar1: TTIWExchangeBar
      Height = 925
      ExplicitHeight = 1000
    end
    inherited TIWGradientBarRight: TTIWGradientLabel
      Height = 925
      ExplicitHeight = 925
    end
  end
  inherited IWAppTitleRegion: TIWRegion
    inherited IWbtnCloseApp: TIWButton
      TabOrder = 4
    end
    inherited IWbtnChangePass: TIWButton
      TabOrder = 14
    end
    inherited IWcBoxZJHTSpList: TIWComboBox
      TabOrder = 16
    end
  end
  inherited IWRegionChangePass: TIWRegion
    inherited IWedtCPOldPass: TIWEdit
      TabOrder = 5
    end
    inherited IWedtCPNewPass: TIWEdit
      TabOrder = 7
    end
    inherited IWbtnCPOK: TIWButton
      TabOrder = 9
    end
    inherited IWbtnCPCancel: TIWButton
      TabOrder = 11
    end
    inherited IWedtCPVerifyPass: TIWEdit
      TabOrder = 13
    end
  end
end
