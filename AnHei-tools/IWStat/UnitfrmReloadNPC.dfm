inherited IWfrmReloadNPC: TIWfrmReloadNPC
  DesignLeft = 8
  DesignTop = 8
  inherited IWRegionClient: TIWRegion
    inherited IWRegion1: TIWRegion
      object IWRegion2: TIWRegion
        Left = 0
        Top = 0
        Width = 859
        Height = 412
        Cursor = crAuto
        HorzScrollBar.Visible = False
        VertScrollBar.Visible = False
        RenderInvisibleControls = False
        Align = alClient
        BorderOptions.NumericWidth = 1
        BorderOptions.BorderWidth = cbwNumeric
        BorderOptions.Style = cbsSolid
        BorderOptions.Color = clNone
        Color = clNone
        ParentShowHint = False
        ShowHint = True
        ZIndex = 1000
        Splitter = False
        object IWRegion3: TIWRegion
          Left = 197
          Top = 1
          Width = 661
          Height = 410
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
          object IWbtnReloadNPC: TIWButton
            Left = 282
            Top = 16
            Width = 111
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
            Caption = #25209#37327#21047#26032'NPC'
            DoSubmitValidation = True
            Color = clBtnFace
            Font.Color = clNone
            Font.Size = 10
            Font.Style = []
            FriendlyName = 'IWbtnReloadNPC'
            ScriptEvents = <>
            TabOrder = 12
            OnClick = IWbtnReloadNPCClick
          end
          object IWRegion7: TIWRegion
            Left = 0
            Top = 0
            Width = 265
            Height = 410
            Cursor = crAuto
            HorzScrollBar.Visible = False
            VertScrollBar.Visible = False
            RenderInvisibleControls = False
            Align = alLeft
            BorderOptions.NumericWidth = 1
            BorderOptions.BorderWidth = cbwNumeric
            BorderOptions.Style = cbsNone
            BorderOptions.Color = clNone
            Color = clNone
            ParentShowHint = False
            ShowHint = True
            ZIndex = 1000
            Splitter = False
            object IWLabel4: TIWLabel
              Left = 0
              Top = 0
              Width = 265
              Height = 16
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
              Font.Color = clWebRED
              Font.Size = 10
              Font.Style = []
              NoWrap = False
              ConvertSpaces = False
              HasTabOrder = False
              FriendlyName = 'IWLabel1'
              Caption = #26684#24335#65306#22320#22270#21517#31216' NPC'#21517#31216
              RawText = False
              ExplicitLeft = 6
              ExplicitTop = 5
            end
            object IWMemoNPC: TIWMemo
              Left = 0
              Top = 16
              Width = 265
              Height = 394
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
              HorizScrollBar = False
              VertScrollBar = True
              Required = False
              TabOrder = 15
              SubmitOnAsyncEvent = True
              FriendlyName = 'IWMemoNPC'
              ExplicitLeft = 144
              ExplicitTop = 176
              ExplicitWidth = 121
              ExplicitHeight = 121
            end
          end
        end
        object IWRegion6: TIWRegion
          Left = 1
          Top = 1
          Width = 196
          Height = 410
          Cursor = crAuto
          HorzScrollBar.Visible = False
          VertScrollBar.Visible = False
          RenderInvisibleControls = False
          Align = alLeft
          BorderOptions.NumericWidth = 1
          BorderOptions.BorderWidth = cbwNumeric
          BorderOptions.Style = cbsNone
          BorderOptions.Color = clNone
          Color = clNone
          ParentShowHint = False
          ShowHint = True
          ZIndex = 1000
          Splitter = False
          object TIWclbServers: TTIWCheckListBox
            Left = 0
            Top = 21
            Width = 196
            Height = 373
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
            Alignment = taLeftJustify
            BGColor = clWebWHITE
            FocusColor = clNone
            DoSubmitValidation = True
            Editable = True
            NonEditableAsLabel = True
            Font.Color = clNone
            Font.FontName = 'Arial'
            Font.Size = 10
            Font.Style = []
            FriendlyName = 'TIWclbServers'
            MaxLength = 0
            ReadOnly = False
            Required = False
            ScriptEvents = <>
            SubmitOnAsyncEvent = True
            TabOrder = 8
            BorderColor = clBlack
            BorderWidth = 1
            BGColorTo = clNone
            BGColorGradientDirection = gdHorizontal
            CheckAllBox = False
            CheckAllHelp = htLabel
            CheckAllText = #20840#36873
            UnCheckAllText = #20840#19981#36873
            ExplicitLeft = 5
            ExplicitTop = 131
            ExplicitHeight = 271
          end
          object IWLabel3: TIWLabel
            Left = 0
            Top = 394
            Width = 196
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
            ExplicitTop = 283
          end
          object IWCheckBox1: TIWCheckBox
            Left = 0
            Top = 0
            Width = 196
            Height = 21
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
            Caption = #20840#36873
            Editable = True
            Font.Color = clNone
            Font.Size = 10
            Font.Style = []
            SubmitOnAsyncEvent = True
            ScriptEvents = <>
            DoSubmitValidation = True
            Style = stNormal
            TabOrder = 16
            OnClick = IWCheckBox1Click
            Checked = False
            FriendlyName = 'IWCheckBox1'
            ExplicitTop = -6
          end
        end
      end
      object IWRegion5: TIWRegion
        Left = 0
        Top = 412
        Width = 859
        Height = 183
        Cursor = crAuto
        HorzScrollBar.Visible = False
        VertScrollBar.Visible = False
        RenderInvisibleControls = False
        Align = alBottom
        BorderOptions.NumericWidth = 1
        BorderOptions.BorderWidth = cbwNumeric
        BorderOptions.Style = cbsSolid
        BorderOptions.Color = clNone
        Color = clNone
        ParentShowHint = False
        ShowHint = True
        ZIndex = 1000
        Splitter = False
        object TIWGradientLabel5: TTIWGradientLabel
          Left = 1
          Top = 1
          Width = 857
          Height = 20
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
          Text = #26085#24535#31383#21475
          Font.Color = clWindow
          Font.FontName = 'Verdana'
          Font.Size = 10
          Font.Style = [fsBold]
          Alignment = taCenter
          Color = clWebLIGHTSALMON
          ColorTo = 4749293
          Direction = gdHorizontal
          ExplicitLeft = 5
          ExplicitTop = 6
          ExplicitWidth = 855
        end
        object IWMemoSuccessLog: TIWMemo
          Left = 1
          Top = 21
          Width = 424
          Height = 161
          Cursor = crAuto
          Align = alLeft
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
          TabOrder = 5
          SubmitOnAsyncEvent = True
          FriendlyName = 'IWMemoSuccessLog'
        end
        object IWMemoFailLog: TIWMemo
          Left = 425
          Top = 21
          Width = 433
          Height = 161
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
          TabOrder = 7
          SubmitOnAsyncEvent = True
          FriendlyName = 'IWMemoFailLog'
          ExplicitLeft = 470
          ExplicitTop = 96
          ExplicitWidth = 121
          ExplicitHeight = 121
        end
      end
    end
  end
  inherited IWAppTitleRegion: TIWRegion
    inherited IWbtnChangePass: TIWButton
      TabOrder = 13
    end
    inherited IWcBoxZJHTSpList: TIWComboBox
      TabOrder = 14
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
  object IWTimerResult: TIWTimer
    Enabled = False
    Interval = 1000
    OnTimer = IWTimerResultTimer
    Left = 280
    Top = 344
  end
end