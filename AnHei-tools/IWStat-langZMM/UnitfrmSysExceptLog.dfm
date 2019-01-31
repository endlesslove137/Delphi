inherited IWfrmSysExceptLog: TIWfrmSysExceptLog
  DesignLeft = 8
  DesignTop = 8
  inherited IWRegionClient: TIWRegion
    inherited IWRegion1: TIWRegion
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      object IWMemo1: TIWMemo
        Left = 0
        Top = 47
        Width = 859
        Height = 548
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
        BGColor = clNone
        Editable = True
        Font.Color = clNone
        Font.Size = 10
        Font.Style = []
        ScriptEvents = <>
        InvisibleBorder = False
        HorizScrollBar = True
        VertScrollBar = True
        Required = False
        TabOrder = 8
        SubmitOnAsyncEvent = True
        FriendlyName = 'IWMemo1'
        ExplicitLeft = 208
        ExplicitTop = 232
        ExplicitWidth = 121
        ExplicitHeight = 121
      end
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
          Caption = #36873#25321#26085#26399#65306
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
          TabOrder = 5
          Year = 2010
          YearFrom = 2010
          YearTo = 2015
        end
        object IWBtnBuild: TIWButton
          Left = 294
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
          Caption = #26597#30475#26085#24535
          DoSubmitValidation = True
          Color = clBtnFace
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'IWBtnBuild'
          ScriptEvents = <>
          TabOrder = 7
          OnClick = IWBtnBuildClick
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
    inherited IWedtCPNewPass: TIWEdit
      TabOrder = 6
    end
    inherited IWbtnCPOK: TIWButton
      TabOrder = 9
    end
    inherited IWbtnCPCancel: TIWButton
      TabOrder = 10
    end
    inherited IWedtCPVerifyPass: TIWEdit
      TabOrder = 11
    end
  end
end
