inherited IWfrmIntegralTotal: TIWfrmIntegralTotal
  DesignLeft = 8
  DesignTop = 8
  inherited IWRegionClient: TIWRegion
    inherited IWRegion1: TIWRegion
      inherited TIWAdvWebGrid1: TTIWAdvWebGrid
        Top = 41
        Height = 554
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
            Tag = -1
            Title = #24080#21495
            Width = 150
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
            Tag = -1
            Title = #35282#33394#21517#31216
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
            Title = #24615#21035
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
            Title = #32844#19994
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
            Title = #36716#36523#31561#32423
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
            Title = #31561#32423
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
            Font.Color = clWebRED
            Font.Size = 10
            Font.Style = [fsBold]
            FooterFormat = '%g'
            SpinEditMaxValue = 100
            SpinEditMinValue = 0
            Title = #31215#20998
            SortFormat = sfAlphabetic
          end>
        ExplicitLeft = 2
        ExplicitTop = 73
        ExplicitHeight = 522
      end
      object IWRegion2: TIWRegion
        Left = 0
        Top = 0
        Width = 859
        Height = 41
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
        object IWButton3: TIWButton
          Left = 6
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
          Caption = #23548#20986'CSV'
          DoSubmitValidation = True
          Color = clBtnFace
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'IWButton1'
          ScriptEvents = <>
          TabOrder = 12
          OnClick = IWButton3Click
        end
      end
    end
  end
  inherited IWAppTitleRegion: TIWRegion
    inherited IWcBoxZJHTServers: TIWComboBox
      TabOrder = 0
    end
  end
end
