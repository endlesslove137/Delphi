inherited IWfrmGlobalPay: TIWfrmGlobalPay
  DesignLeft = 8
  DesignTop = 8
  inherited IWRegionClient: TIWRegion
    inherited IWRegion1: TIWRegion
      object IWRegion2: TIWRegion
        Left = 0
        Top = 0
        Width = 859
        Height = 47
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
          Left = 517
          Top = 8
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
          TabOrder = 6
          OnClick = IWBtnBuildClick
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
          TabOrder = 7
          Year = 2010
          YearFrom = 2010
          YearTo = 2015
        end
        object IWLabel3: TIWLabel
          Left = 248
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
          Caption = #32467#26463#26085#26399#65306
          RawText = False
        end
        object pEDate: TTIWDateSelector
          Left = 309
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
          TabOrder = 9
          Year = 2010
          YearFrom = 2010
          YearTo = 2015
        end
        object IWAmdbMode: TIWCheckBox
          Left = 600
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
          Caption = #21382#21490#25968#25454#27169#24335
          Editable = True
          Font.Color = clWebBLUE
          Font.Size = 10
          Font.Style = [fsBold]
          SubmitOnAsyncEvent = True
          ScriptEvents = <>
          DoSubmitValidation = True
          Style = stNormal
          TabOrder = 15
          Checked = False
          FriendlyName = 'IWAmdbMode'
        end
      end
      object IWRegion3: TIWRegion
        Left = 0
        Top = 47
        Width = 859
        Height = 548
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
          Left = 15
          Top = 20
          Width = 900
          Height = 600
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
          Chart.AxisMode = amXAxisFullWidth
          Chart.Background.Font.Charset = DEFAULT_CHARSET
          Chart.Background.Font.Color = clWindowText
          Chart.Background.Font.Height = -11
          Chart.Background.Font.Name = 'Tahoma'
          Chart.Background.Font.Style = []
          Chart.Bands.Distance = 2.000000000000000000
          Chart.CrossHair.CrossHairYValues.Position = [chYAxis]
          Chart.CrossHair.Distance = 0
          Chart.Margin.RightMargin = 30
          Chart.Legend.Font.Charset = DEFAULT_CHARSET
          Chart.Legend.Font.Color = clWindowText
          Chart.Legend.Font.Height = -11
          Chart.Legend.Font.Name = 'Tahoma'
          Chart.Legend.Font.Style = []
          Chart.Range.StartDate = 41236.607946134260000000
          Chart.Series.ChartMode = dmHorizontal
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
              ValueFormat = '%.1m'
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
          Chart.Title.Text = #21508#21306#20805#20540
          Chart.XAxis.Font.Charset = DEFAULT_CHARSET
          Chart.XAxis.Font.Color = clWindowText
          Chart.XAxis.Font.Height = -11
          Chart.XAxis.Font.Name = 'Tahoma'
          Chart.XAxis.Font.Style = []
          Chart.XAxis.Size = 120
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
          Chart.YGrid.MinorDistance = 1.000000000000000000
          Chart.YGrid.MajorDistance = 2.000000000000000000
        end
      end
    end
  end
  inherited IWAppTitleRegion: TIWRegion
    inherited IWbtnChangePass: TIWButton
      TabOrder = 12
    end
    inherited IWcBoxZJHTSpList: TIWComboBox
      TabOrder = 13
    end
  end
  inherited IWRegionChangePass: TIWRegion
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
