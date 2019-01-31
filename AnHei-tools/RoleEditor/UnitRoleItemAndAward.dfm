object frmRoleItemAndAward: TfrmRoleItemAndAward
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 455
  ClientWidth = 606
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    606
    455)
  PixelsPerInch = 120
  TextHeight = 15
  object Button1: TButton
    Left = 505
    Top = 420
    Width = 93
    Height = 31
    Anchors = [akLeft, akBottom]
    Caption = #30830#23450'(&O)'
    ModalResult = 1
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 18
    Top = 10
    Width = 580
    Height = 404
    ActivePage = tsFastCom
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object ts3: TTabSheet
      Caption = #20219#21153#30446#26631
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grp2: TGroupBox
        Left = 0
        Top = 113
        Width = 572
        Height = 261
        Align = alClient
        Caption = #30446#26631#22320#28857
        TabOrder = 0
        object grp3: TGroupBox
          Left = 2
          Top = 89
          Width = 568
          Height = 170
          Align = alClient
          Caption = #38656#35201#32463#36807#30340#21069#25552#22320#28857#21015#34920
          TabOrder = 0
          object lvpass: TListView
            Left = 2
            Top = 17
            Width = 564
            Height = 151
            Align = alClient
            Columns = <
              item
                Caption = #22320#22270
                Width = 96
              end
              item
                Alignment = taCenter
                Caption = #24618#29289
                Width = 84
              end
              item
                Alignment = taCenter
                Caption = #20301#32622
                Width = 91
              end
              item
                Caption = #34892#20026#25551#36848
                Width = 213
              end>
            ColumnClick = False
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            PopupMenu = pmpass
            TabOrder = 0
            ViewStyle = vsReport
            OnDblClick = MenuItem5Click
          end
        end
        object pnl2: TPanel
          Left = 2
          Top = 17
          Width = 568
          Height = 72
          Align = alTop
          BevelOuter = bvLowered
          TabOrder = 1
          object lbl24: TLabel
            Left = 19
            Top = 11
            Width = 38
            Height = 15
            Caption = #22320#22270':'
          end
          object lbl23: TLabel
            Left = 19
            Top = 41
            Width = 38
            Height = 15
            Caption = #20301#32622':'
          end
          object lbl25: TLabel
            Left = 275
            Top = 13
            Width = 53
            Height = 15
            Caption = #23545#35937#21517':'
          end
          object se15: TSpinEdit
            Left = 79
            Top = 38
            Width = 84
            Height = 24
            Hint = #29615#22659#37324#37197#32622#21306#22495#30340#20013#28857
            MaxValue = 65535
            MinValue = 0
            TabOrder = 0
            Value = 1
          end
          object se16: TSpinEdit
            Left = 176
            Top = 38
            Width = 84
            Height = 24
            Hint = #29615#22659#37324#37197#32622#21306#22495#30340#20013#28857
            MaxValue = 65535
            MinValue = 0
            TabOrder = 1
            Value = 1
          end
          object chk4: TCheckBox
            Left = 398
            Top = 41
            Width = 118
            Height = 17
            Caption = #38544#34255#24555#20256#25353#38062
            TabOrder = 2
          end
          object cb6: TComboBoxEx
            Left = 79
            Top = 9
            Width = 181
            Height = 24
            ItemsEx = <>
            ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
            ItemHeight = 16
            TabOrder = 3
            OnSelect = cb6Select
          end
          object cb7: TComboBoxEx
            Left = 334
            Top = 8
            Width = 181
            Height = 24
            ItemsEx = <>
            ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
            ItemHeight = 16
            TabOrder = 4
            OnSelect = cb7Select
          end
        end
      end
      object pnl1: TPanel
        Left = 0
        Top = 0
        Width = 572
        Height = 113
        Align = alTop
        TabOrder = 1
        DesignSize = (
          572
          113)
        object lbl19: TLabel
          Left = 11
          Top = 8
          Width = 38
          Height = 15
          Align = alCustom
          Caption = #27169#24335':'
        end
        object lbl20: TLabel
          Left = 11
          Top = 34
          Width = 23
          Height = 15
          Caption = #20540':'
        end
        object lbl21: TLabel
          Left = 11
          Top = 60
          Width = 38
          Height = 15
          Caption = #25968#37327':'
        end
        object lbl18: TLabel
          Left = 11
          Top = 86
          Width = 54
          Height = 15
          Caption = #22870#21169'id:'
        end
        object cb2: TComboBox
          Left = 71
          Top = 4
          Width = 369
          Height = 23
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 32
          ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          ItemHeight = 0
          TabOrder = 0
          OnChange = cb2Change
        end
        object se13: TSpinEdit
          Left = 71
          Top = 58
          Width = 182
          Height = 24
          MaxValue = 65535
          MinValue = 0
          TabOrder = 1
          Value = 1
        end
        object se11: TSpinEdit
          Left = 71
          Top = 30
          Width = 182
          Height = 24
          MaxValue = 65535
          MinValue = 0
          TabOrder = 2
          Value = 1
        end
        object chk3: TCheckBox
          Left = 470
          Top = 10
          Width = 98
          Height = 18
          Caption = #21015#34920#25490#21015
          TabOrder = 3
        end
        object se12: TSpinEdit
          Left = 71
          Top = 84
          Width = 182
          Height = 24
          Enabled = False
          MaxValue = 65535
          MinValue = 0
          TabOrder = 4
          Value = 1
        end
        object grp1: TGroupBox
          Left = 255
          Top = 30
          Width = 306
          Height = 79
          Caption = #33258#23450#20041#38656#27714
          TabOrder = 5
          object lbl16: TLabel
            Left = 5
            Top = 18
            Width = 40
            Height = 15
            Caption = 'Data:'
          end
          object lbl17: TLabel
            Left = 5
            Top = 44
            Width = 48
            Height = 15
            Caption = 'DataM:'
          end
          object edt4: TEdit
            Left = 59
            Top = 15
            Width = 239
            Height = 23
            ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
            TabOrder = 0
          end
          object edt5: TEdit
            Left = 59
            Top = 41
            Width = 239
            Height = 23
            ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
            TabOrder = 1
          end
        end
        object cb5: TComboBoxEx
          Left = 71
          Top = 31
          Width = 179
          Height = 24
          ItemsEx = <>
          ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          ItemHeight = 16
          TabOrder = 6
          OnChange = cb5Change
          DropDownCount = 32
        end
      end
    end
    object tsFastCom: TTabSheet
      Caption = #24555#36895#23436#25104
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        572
        374)
      object lbl1: TLabel
        Left = 20
        Top = 19
        Width = 68
        Height = 15
        Caption = #25187#38500#36947#20855':'
      end
      object lbl2: TLabel
        Left = 20
        Top = 45
        Width = 68
        Height = 15
        Caption = #25187#38500#29289#21697':'
      end
      object btn1: TSpeedButton
        Left = 299
        Top = 39
        Width = 29
        Height = 25
        Caption = '+'
        Visible = False
      end
      object lbl3: TLabel
        Left = 20
        Top = 73
        Width = 68
        Height = 15
        Caption = #25187#38500#25968#37327':'
      end
      object cbb1: TComboBox
        Left = 110
        Top = 15
        Width = 181
        Height = 23
        Style = csDropDownList
        DropDownCount = 32
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 0
        TabOrder = 0
        OnChange = cbb1Change
        OnSelect = cbb1Change
      end
      object cbb2: TComboBox
        Left = 110
        Top = 43
        Width = 181
        Height = 23
        AutoDropDown = True
        DropDownCount = 32
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 0
        TabOrder = 1
      end
      object se1: TSpinEdit
        Left = 110
        Top = 69
        Width = 181
        Height = 24
        MaxValue = 2100000000
        MinValue = 0
        TabOrder = 2
        Value = 1
      end
      object lv1: TListView
        Left = 20
        Top = 98
        Width = 528
        Height = 266
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            AutoSize = True
            Caption = #29289#21697#21517#31216
          end
          item
            Caption = #25968#37327
            Width = 63
          end>
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 3
        ViewStyle = vsReport
        Visible = False
      end
    end
    object tsAwards: TTabSheet
      Caption = #20219#21153#22870#21169
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label4: TLabel
        Left = 20
        Top = 26
        Width = 68
        Height = 15
        Caption = #22870#21169#27169#24335':'
      end
      object Label5: TLabel
        Left = 169
        Top = 54
        Width = 23
        Height = 15
        Caption = #20540':'
      end
      object Label6: TLabel
        Left = 169
        Top = 81
        Width = 68
        Height = 15
        Caption = #22870#21169#25968#37327':'
      end
      object Label7: TLabel
        Left = 169
        Top = 108
        Width = 68
        Height = 15
        Caption = #29289#21697#21697#36136':'
      end
      object Label8: TLabel
        Left = 169
        Top = 135
        Width = 68
        Height = 15
        Caption = #24378#21270#31561#32423':'
      end
      object lbl4: TLabel
        Left = 20
        Top = 54
        Width = 38
        Height = 15
        Hint = '-1'#34920#31034#19981#38480#21046#32844#19994
        Caption = #32844#19994':'
        ParentShowHint = False
        ShowHint = True
      end
      object lbl5: TLabel
        Left = 20
        Top = 81
        Width = 38
        Height = 15
        Hint = '-1'#20063#26159#19981#38480#21046#24615#21035
        Caption = #24615#21035':'
        ParentShowHint = False
        ShowHint = True
      end
      object lbl6: TLabel
        Left = 20
        Top = 219
        Width = 68
        Height = 15
        Hint = '-1'#20063#26159#19981#38480#21046#24615#21035
        Caption = #22870#21169#25551#36848':'
        ParentShowHint = False
        ShowHint = True
      end
      object lbl7: TLabel
        Left = 169
        Top = 163
        Width = 68
        Height = 15
        Hint = '-1'#20063#26159#19981#38480#21046#24615#21035
        Caption = #31561#32423#20493#29575':'
        ParentShowHint = False
        ShowHint = True
      end
      object lbl8: TLabel
        Left = 23
        Top = 189
        Width = 68
        Height = 15
        Hint = '-1'#20063#26159#19981#38480#21046#24615#21035
        Caption = #27425#25968#20493#29575':'
        ParentShowHint = False
        ShowHint = True
      end
      object lbl9: TLabel
        Left = 20
        Top = 108
        Width = 62
        Height = 15
        Caption = 'vip'#31561#32423':'
      end
      object lbl10: TLabel
        Left = 20
        Top = 135
        Width = 70
        Height = 15
        Hint = 'boss'#25104#38271#31561#32423#21644#29289#21697#31561#32423#30456#21516#21363#20026#26032#29289#21697
        Caption = 'boss'#31561#32423':'
        ParentShowHint = False
        ShowHint = True
      end
      object lbl11: TLabel
        Left = 20
        Top = 163
        Width = 68
        Height = 15
        Caption = #37325#35201#31243#24230':'
        ParentShowHint = False
        ShowHint = True
      end
      object lbl12: TLabel
        Left = 20
        Top = 246
        Width = 68
        Height = 15
        Hint = #31934#38203#23646#24615#19968#33268
        Caption = #26497#21697#23646#24615':'
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object ComboBox3: TComboBox
        Left = 93
        Top = 25
        Width = 235
        Height = 23
        Style = csDropDownList
        DropDownCount = 32
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 0
        TabOrder = 0
        OnChange = ComboBox3Change
      end
      object SpinEdit2: TSpinEdit
        Left = 239
        Top = 78
        Width = 89
        Height = 24
        MaxValue = 99999999
        MinValue = 1
        TabOrder = 1
        Value = 1
      end
      object SpinEdit3: TSpinEdit
        Left = 239
        Top = 133
        Width = 89
        Height = 24
        MaxValue = 63
        MinValue = 0
        TabOrder = 2
        Value = 0
      end
      object SpinEdit4: TSpinEdit
        Left = 239
        Top = 105
        Width = 89
        Height = 24
        MaxValue = 15
        MinValue = 0
        TabOrder = 3
        Value = 0
      end
      object se2: TSpinEdit
        Left = 239
        Top = 51
        Width = 89
        Height = 24
        MaxValue = 99999999
        MinValue = 0
        TabOrder = 4
        Value = 1
      end
      object chk1: TCheckBox
        Left = 240
        Top = 3
        Width = 65
        Height = 17
        Hint = '0'#34920#31034#19981#21487#36873#65288#24517#36865#65289#65292#21542#21017#34920#31034#21487#36873#22870#21169
        Caption = #21487#36873
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object chk2: TCheckBox
        Left = 169
        Top = 3
        Width = 65
        Height = 17
        Caption = #32465#23450
        TabOrder = 6
      end
      object edt1: TEdit
        Left = 93
        Top = 214
        Width = 235
        Height = 23
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        TabOrder = 7
      end
      object edt2: TEdit
        Left = 239
        Top = 159
        Width = 89
        Height = 23
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        TabOrder = 8
        Text = '0'
      end
      object edt3: TEdit
        Left = 93
        Top = 186
        Width = 235
        Height = 23
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        TabOrder = 9
        Text = '0'
      end
      object se5: TSpinEdit
        Left = 93
        Top = 105
        Width = 73
        Height = 24
        MaxValue = 63
        MinValue = 0
        TabOrder = 10
        Value = 0
      end
      object se6: TSpinEdit
        Left = 93
        Top = 133
        Width = 73
        Height = 24
        MaxValue = 63
        MinValue = 0
        TabOrder = 11
        Value = 0
      end
      object se7: TSpinEdit
        Left = 93
        Top = 159
        Width = 73
        Height = 24
        MaxValue = 63
        MinValue = 0
        TabOrder = 12
        Value = 0
      end
      object se8: TSpinEdit
        Left = 93
        Top = 243
        Width = 73
        Height = 24
        MaxValue = 63
        MinValue = 0
        TabOrder = 13
        Value = 0
        Visible = False
      end
      object cb4: TComboBoxEx
        Left = 195
        Top = 51
        Width = 133
        Height = 24
        ItemsEx = <>
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 16
        TabOrder = 14
        OnChange = cb4Change
        DropDownCount = 32
      end
      object cbjob: TComboBox
        Left = 93
        Top = 51
        Width = 73
        Height = 23
        Style = csDropDownList
        DropDownCount = 32
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 15
        TabOrder = 15
        OnChange = cb4Change
        Items.Strings = (
          '0 '#19981#38480
          '1 '#25112#22763
          '2 '#27861#24072
          '3 '#36947#22763)
      end
      object cbsex: TComboBox
        Left = 93
        Top = 79
        Width = 73
        Height = 23
        Style = csDropDownList
        DropDownCount = 32
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 15
        TabOrder = 16
        OnChange = cb4Change
        Items.Strings = (
          '0 '#30007
          '1 '#22899
          '-1 '#19981#38480)
      end
    end
    object ts2: TTabSheet
      Caption = #20219#21153#26465#20214
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbl13: TLabel
        Left = 14
        Top = 51
        Width = 38
        Height = 15
        Caption = #27169#24335':'
      end
      object lbl14: TLabel
        Left = 14
        Top = 83
        Width = 38
        Height = 15
        Caption = #30446#26631':'
      end
      object lbl15: TLabel
        Left = 14
        Top = 110
        Width = 38
        Height = 15
        Caption = #25968#37327':'
      end
      object cb1: TComboBox
        Left = 84
        Top = 51
        Width = 235
        Height = 23
        Style = csDropDownList
        DropDownCount = 32
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 0
        TabOrder = 0
        OnChange = cb1Change
      end
      object se9: TSpinEdit
        Left = 84
        Top = 80
        Width = 85
        Height = 24
        MaxValue = 2100000000
        MinValue = 0
        TabOrder = 1
        Value = 1
      end
      object se10: TSpinEdit
        Left = 84
        Top = 108
        Width = 235
        Height = 24
        MaxValue = 2100000000
        MinValue = 0
        TabOrder = 2
        Value = 1
      end
      object cb3: TComboBoxEx
        Left = 84
        Top = 80
        Width = 234
        Height = 24
        ItemsEx = <>
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        ItemHeight = 16
        TabOrder = 3
        OnChange = cb3Change
        DropDownCount = 32
      end
    end
    object ts4: TTabSheet
      Caption = #22320#28857#21015#34920
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        572
        374)
      object lbl22: TLabel
        Left = 19
        Top = 41
        Width = 38
        Height = 15
        Caption = #20301#32622':'
      end
      object lbl26: TLabel
        Left = 19
        Top = 11
        Width = 38
        Height = 15
        Caption = #22320#22270':'
      end
      object lbl27: TLabel
        Left = 275
        Top = 13
        Width = 53
        Height = 15
        Caption = #23545#35937#21517':'
      end
      object lbl28: TLabel
        Left = 3
        Top = 83
        Width = 68
        Height = 15
        Hint = '-1'#20063#26159#19981#38480#21046#24615#21035
        Caption = #34892#20026#25551#36848':'
        ParentShowHint = False
        ShowHint = True
      end
      object se18: TSpinEdit
        Left = 79
        Top = 38
        Width = 84
        Height = 24
        MaxValue = 65535
        MinValue = 0
        TabOrder = 0
        Value = 1
      end
      object se19: TSpinEdit
        Left = 176
        Top = 38
        Width = 84
        Height = 24
        MaxValue = 65535
        MinValue = 0
        TabOrder = 1
        Value = 1
      end
      object btn3: TButton
        Left = 478
        Top = 340
        Width = 92
        Height = 31
        Anchors = [akLeft, akBottom]
        Caption = #30830#23450'(&O)'
        TabOrder = 2
        OnClick = btn3Click
      end
      object edt6: TEdit
        Left = 78
        Top = 76
        Width = 441
        Height = 23
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        TabOrder = 3
      end
      object cb8: TComboBoxEx
        Left = 79
        Top = 9
        Width = 181
        Height = 24
        ItemsEx = <>
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        ItemHeight = 16
        TabOrder = 4
        OnSelect = cb6Select
      end
      object cb9: TComboBoxEx
        Left = 334
        Top = 8
        Width = 181
        Height = 24
        ItemsEx = <>
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        ItemHeight = 16
        TabOrder = 5
        OnSelect = cb9Select
      end
    end
    object tsSurprise: TTabSheet
      Caption = #24778#21916#22870#21169
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblLuckValue: TLabel
        Left = 23
        Top = 18
        Width = 53
        Height = 15
        Caption = #24184#36816#24230':'
      end
      object lblLuckRate: TLabel
        Left = 23
        Top = 44
        Width = 54
        Height = 15
        Caption = #20493'  '#29575':'
      end
      object seProb: TSpinEdit
        Left = 102
        Top = 14
        Width = 231
        Height = 24
        Hint = '0'#34920#31034#19981#38480#21046#37325#22797#27425#25968
        MaxValue = 1000
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Value = 1
      end
      object serate: TSpinEdit
        Left = 102
        Top = 44
        Width = 231
        Height = 24
        Hint = '0'#34920#31034#19981#38480#21046#37325#22797#27425#25968
        MaxValue = 1000
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Value = 1
      end
    end
    object tsMultiAward: TTabSheet
      Caption = #22810#20493#22870#21169
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 13
        Top = 39
        Width = 38
        Height = 15
        Caption = #20493#29575':'
      end
      object Label2: TLabel
        Left = 14
        Top = 15
        Width = 38
        Height = 15
        Caption = #31867#22411':'
      end
      object Label3: TLabel
        Left = 14
        Top = 65
        Width = 23
        Height = 15
        Hint = #22914#26524#26159#22266#23450#29615#20219#21153','#34920#31034#24403#21069#20219#21153#25152#22312#31532#20960#29615' '#40664#35748' 0'#13#10
        Caption = #20540':'
        ParentShowHint = False
        ShowHint = True
      end
      object seMARate: TSpinEdit
        Left = 74
        Top = 34
        Width = 231
        Height = 24
        MaxValue = 1000
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Value = 1
      end
      object cbMutiAwardType: TComboBox
        Left = 74
        Top = 7
        Width = 231
        Height = 23
        Style = csDropDownList
        DropDownCount = 32
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 0
        TabOrder = 1
      end
      object seMAValue: TSpinEdit
        Left = 74
        Top = 61
        Width = 231
        Height = 24
        Hint = '0'#34920#31034#19981#38480#21046#37325#22797#27425#25968
        MaxValue = 99999999
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Value = 1
      end
    end
  end
  object pmpass: TPopupMenu
    OnPopup = pmpassPopup
    Left = 192
    Top = 263
    object MenuItem5: TMenuItem
      Caption = #32534#36753'(&E)'
      Default = True
      OnClick = MenuItem5Click
    end
    object MenuItem6: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = MenuItem6Click
    end
    object MenuItem9: TMenuItem
      Caption = '-'
    end
    object MenuItem10: TMenuItem
      Caption = #26032#24314'(&N)'
      OnClick = MenuItem10Click
    end
  end
end
