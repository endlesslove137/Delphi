inherited IWfrmOnlineCount: TIWfrmOnlineCount
  DesignLeft = 8
  DesignTop = 8
  inherited IWRegionClient: TIWRegion
    inherited IWRegion1: TIWRegion
      object IWLabel2: TIWLabel
        Left = 208
        Top = 48
        Width = 0
        Height = 0
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
        RawText = False
      end
      object IWRegion2: TIWRegion
        Left = 0
        Top = 0
        Width = 859
        Height = 76
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
          TabOrder = 0
          Year = 2010
          YearFrom = 2010
          YearTo = 2015
        end
        object pSTime: TTIWAdvTimeEdit
          Left = 259
          Top = 13
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
          TabOrder = 4
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
          Top = 45
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
          Left = 83
          Top = 41
          Width = 208
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
          Left = 259
          Top = 45
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
        object IWLabel4: TIWLabel
          Left = 398
          Top = 32
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
          FriendlyName = 'IWLabel4'
          Caption = #26354#32447#21608#26399#65306
          RawText = False
        end
        object IWComboBox1: TIWComboBox
          Left = 485
          Top = 31
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
          NoSelectionText = '-- No Selection --'
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
          TabOrder = 12
          ItemIndex = -1
          Items.Strings = (
            '1'#23567#26102
            '2'#23567#26102
            '4'#23567#26102
            '1'#22825
            '30'#20998#38047
            '20'#20998#38047
            '10'#20998#38047)
          Sorted = False
          FriendlyName = 'IWComboBox1'
        end
        object IWBtnBuild: TIWButton
          Left = 628
          Top = 28
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
          TabOrder = 15
          OnClick = IWBtnBuildClick
        end
      end
      object IWRegion3: TIWRegion
        Left = 0
        Top = 76
        Width = 859
        Height = 519
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
          Left = 32
          Top = 10
          Width = 600
          Height = 371
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
          Chart.Range.StartDate = 41236.607919189820000000
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
              CrossHairYValue.BorderWidth = 0
              CrossHairYValue.Font.Charset = DEFAULT_CHARSET
              CrossHairYValue.Font.Color = clWindowText
              CrossHairYValue.Font.Height = -11
              CrossHairYValue.Font.Name = 'Tahoma'
              CrossHairYValue.Font.Style = []
              CrossHairYValue.GradientSteps = 0
              CrossHairYValue.Visible = False
              LegendText = 'Serie 0'
              ShowInLegend = False
              Marker.MarkerType = mCircle
              Marker.MarkerColor = clRed
              Marker.MarkerSize = 6
              Marker.MarkerColorTo = clWhite
              Name = 'Serie 0'
              ShowValue = True
              ValueFont.Charset = ANSI_CHARSET
              ValueFont.Color = clWindowText
              ValueFont.Height = -13
              ValueFont.Name = #23435#20307
              ValueFont.Style = []
              ValueFormat = '%g'
              ValueWidth = 10
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
              XAxis.TickMarkSize = 4
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
              YAxis.TickMarkSize = 4
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
          Chart.Title.Text = #24635#22312#32447
          Chart.XAxis.Font.Charset = DEFAULT_CHARSET
          Chart.XAxis.Font.Color = clWindowText
          Chart.XAxis.Font.Height = -11
          Chart.XAxis.Font.Name = 'Tahoma'
          Chart.XAxis.Font.Style = []
          Chart.XGrid.MajorDistance = 1
          Chart.XGrid.MinorLineColor = clGray
          Chart.XGrid.MajorLineColor = clSilver
          Chart.XGrid.MinorLineStyle = psDot
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
          Chart.XGrid.Visible = True
          Chart.YAxis.Font.Charset = DEFAULT_CHARSET
          Chart.YAxis.Font.Color = clWindowText
          Chart.YAxis.Font.Height = -11
          Chart.YAxis.Font.Name = 'Tahoma'
          Chart.YAxis.Font.Style = []
          Chart.YAxis.Size = 60
          Chart.YGrid.MinorDistance = 1.000000000000000000
          Chart.YGrid.MajorDistance = 2.000000000000000000
          Chart.YGrid.MajorLineStyle = psDot
          Chart.YGrid.Visible = True
        end
      end
    end
  end
  inherited IWAppTitleRegion: TIWRegion
    inherited IWcBoxZJHTServers: TIWComboBox
      TabOrder = 3
    end
    inherited IWbtnCloseApp: TIWButton
      TabOrder = 6
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
