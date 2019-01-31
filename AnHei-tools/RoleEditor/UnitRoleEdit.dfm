object frmRoleEdit: TfrmRoleEdit
  Left = 309
  Top = 113
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #32534#36753#20219#21153
  ClientHeight = 670
  ClientWidth = 829
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    829
    670)
  PixelsPerInch = 120
  TextHeight = 15
  object Button1: TButton
    Left = 624
    Top = 628
    Width = 94
    Height = 31
    Anchors = [akRight, akBottom]
    Caption = #30830#23450'(&O)'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 725
    Top = 628
    Width = 94
    Height = 31
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #21462#28040'(&C)'
    Default = True
    ModalResult = 2
    TabOrder = 0
  end
  object PageControl2: TPageControl
    Left = 10
    Top = 10
    Width = 809
    Height = 605
    ActivePage = TabSheet3
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object TabSheet3: TTabSheet
      Caption = #20219#21153#25968#25454
      DesignSize = (
        801
        575)
      object PageControl1: TPageControl
        Left = 4
        Top = 299
        Width = 791
        Height = 219
        ActivePage = TabSheet1
        Anchors = [akLeft, akTop, akRight, akBottom]
        Style = tsFlatButtons
        TabOrder = 0
        object ts2: TTabSheet
          Caption = #26465#20214
          ImageIndex = 3
          object lvConds: TListView
            Left = 0
            Top = 0
            Width = 783
            Height = 186
            Align = alClient
            Columns = <
              item
                Caption = #31867#22411
                Width = 321
              end
              item
                Caption = #30446#26631
                Width = 193
              end
              item
                Caption = #25968#37327
                Width = 238
              end
              item
                Caption = #30446#26631'ID'
                Width = 0
              end>
            ColumnClick = False
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            PopupMenu = pmCond
            TabOrder = 0
            ViewStyle = vsReport
            OnDblClick = MenuItem7Click
          end
        end
        object TabSheet1: TTabSheet
          Caption = #30446#26631
          object lvTargets: TListView
            Left = 0
            Top = 0
            Width = 783
            Height = 186
            Align = alClient
            Columns = <
              item
                Caption = #31867#22411
                Width = 194
              end
              item
                Caption = #20540
                Width = 88
              end
              item
                Caption = #25968#37327
                Width = 48
              end
              item
                Caption = 'Data'
                Width = 58
              end
              item
                Caption = 'DataM'
                Width = 65
              end
              item
                Alignment = taCenter
                Caption = #20351#29992#21015#34920
                Width = 200
              end
              item
                Caption = #20851#32852#22870#21169'id'
                Width = 88
              end
              item
                Caption = 'DataID'
                Width = 0
              end
              item
                Caption = 'DataMID'
                Width = 0
              end>
            ColumnClick = False
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            PopupMenu = pmTarget
            TabOrder = 0
            ViewStyle = vsReport
            OnDblClick = E1Click
          end
        end
        object TabSheet2: TTabSheet
          Caption = #22870#21169
          ImageIndex = 1
          object lvAwardTags: TListView
            Left = 0
            Top = 0
            Width = 105
            Height = 186
            Align = alLeft
            Columns = <
              item
                Caption = #30446#26631'ID'
                Width = 78
              end>
            ColumnClick = False
            FlatScrollBars = True
            ReadOnly = True
            RowSelect = True
            PopupMenu = pmAwardTag
            TabOrder = 0
            ViewStyle = vsReport
            OnDblClick = MenuItem1Click
            OnSelectItem = lvAwardTagsSelectItem
          end
          object pnl1: TPanel
            Left = 105
            Top = 0
            Width = 678
            Height = 186
            Align = alClient
            BevelOuter = bvLowered
            TabOrder = 1
            object ListViewAwards: TListView
              Left = 1
              Top = 1
              Width = 676
              Height = 184
              Align = alClient
              Columns = <
                item
                  Caption = #31867#22411
                  Width = 105
                end
                item
                  Caption = #20540
                  Width = 53
                end
                item
                  Caption = #25968#37327
                  Width = 68
                end
                item
                  Caption = #21697#36136
                  Width = 56
                end
                item
                  Caption = #24378#21270#31561#32423
                  Width = 83
                end
                item
                  Caption = #26159#21542#21487#36873
                  Width = 84
                end
                item
                  Caption = #32465#23450
                  Width = 71
                end
                item
                  Caption = #32844#19994
                  Width = 58
                end
                item
                  Caption = #24615#21035
                  Width = 61
                end
                item
                  Caption = #31561#32423#20493#29575
                  Width = 0
                end
                item
                  Caption = #27425#25968#20493#29575
                  Width = 0
                end
                item
                  Caption = 'vip'#32423#21035
                  Width = 0
                end
                item
                  Caption = 'Boss'#32423#21035
                  Width = 0
                end
                item
                  Caption = #37325#35201#31243#24207
                  Width = 0
                end
                item
                  Caption = #26497#21697#23646#24615
                  Width = 0
                end
                item
                  Caption = #22870#21169#25551#36848
                  Width = 0
                end
                item
                  Caption = #20540'ID'
                  Width = 0
                end>
              ColumnClick = False
              FlatScrollBars = True
              MultiSelect = True
              ReadOnly = True
              RowSelect = True
              PopupMenu = pmAward
              TabOrder = 0
              ViewStyle = vsReport
              OnDblClick = MenuItem1Click
            end
          end
        end
        object ts1: TTabSheet
          Caption = #24555#36895#23436#25104
          ImageIndex = 2
          TabVisible = False
          object lv1: TListView
            Left = 0
            Top = 0
            Width = 783
            Height = 186
            Align = alClient
            Columns = <
              item
                Caption = #25187#38500#36947#20855
                Width = 183
              end
              item
                Caption = #21517#31216
                Width = 190
              end
              item
                Caption = #25968#37327
                Width = 143
              end>
            ColumnClick = False
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            PopupMenu = pm1
            TabOrder = 0
            ViewStyle = vsReport
            OnDblClick = MenuItem5Click
          end
        end
        object ts3: TTabSheet
          Caption = #24778#21916#22870#21169
          ImageIndex = 4
          object lvsurprise: TListView
            Left = 0
            Top = 0
            Width = 783
            Height = 186
            Align = alClient
            Columns = <
              item
                Caption = #24778#21916#24230
                Width = 321
              end
              item
                Caption = #20493#29575
                Width = 193
              end>
            ColumnClick = False
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            PopupMenu = pmSurprise
            TabOrder = 0
            ViewStyle = vsReport
            OnDblClick = EditSurpriseClick
          end
        end
        object tsMutiAward: TTabSheet
          Caption = #22810#20493#22870#21169
          ImageIndex = 5
          object lvMutiAward: TListView
            Left = 0
            Top = 0
            Width = 783
            Height = 186
            Align = alClient
            Columns = <
              item
                Caption = #31867#22411
                Width = 164
              end
              item
                Caption = #20493#29575
                Width = 73
              end
              item
                Caption = #20540
                Width = 475
              end>
            ColumnClick = False
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            PopupMenu = pmMutiAward
            TabOrder = 0
            ViewStyle = vsReport
            OnDblClick = EditMAClick
          end
        end
      end
      object PageControl3: TPageControl
        Left = 9
        Top = 4
        Width = 791
        Height = 293
        ActivePage = TabSheet5
        Style = tsFlatButtons
        TabOrder = 1
        object TabSheet5: TTabSheet
          Caption = #22522#26412
          DesignSize = (
            783
            260)
          object GroupBox1: TGroupBox
            Left = 0
            Top = 3
            Width = 385
            Height = 254
            Anchors = [akLeft, akTop, akRight]
            Caption = #20219#21153#26631#35782
            TabOrder = 0
            DesignSize = (
              385
              254)
            object Label1: TLabel
              Left = 13
              Top = 16
              Width = 54
              Height = 15
              Caption = #20219#21153'ID:'
              Font.Charset = ANSI_CHARSET
              Font.Color = clRed
              Font.Height = -15
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object Label2: TLabel
              Left = 13
              Top = 38
              Width = 68
              Height = 15
              Caption = #20219#21153#21517#31216':'
            end
            object Label3: TLabel
              Left = 13
              Top = 68
              Width = 68
              Height = 15
              Caption = #32487#25215#20219#21153':'
            end
            object Label10: TLabel
              Left = 13
              Top = 196
              Width = 68
              Height = 15
              Caption = #37325#22797#27425#25968':'
            end
            object Label14: TLabel
              Left = 13
              Top = 118
              Width = 68
              Height = 15
              Caption = #35302#21457#31561#32423':'
            end
            object Label15: TLabel
              Left = 13
              Top = 93
              Width = 68
              Height = 15
              AutoSize = False
              Caption = #20219#21153#31867#22411':'
            end
            object lbl5: TLabel
              Left = 13
              Top = 144
              Width = 68
              Height = 15
              Hint = #22914#26524#26159#22266#23450#29615#20219#21153','#34920#31034#24403#21069#20219#21153#25152#22312#31532#20960#29615' '#40664#35748' 0'#13#10
              Caption = #25152#22312#29615#25968':'
              ParentShowHint = False
              ShowHint = True
            end
            object lbl7: TLabel
              Left = 13
              Top = 168
              Width = 68
              Height = 15
              AutoSize = False
              Caption = #24341#23548'ID:'
            end
            object lbl8: TLabel
              Left = 200
              Top = 198
              Width = 113
              Height = 15
              Caption = #24555#36895#23436#25104#20803#23453#25968':'
            end
            object lbl9: TLabel
              Left = 200
              Top = 144
              Width = 68
              Height = 15
              Caption = #26368#22823#29615#25968':'
            end
            object lbl10: TLabel
              Left = 13
              Top = 220
              Width = 69
              Height = 15
              Caption = #21608#26399'('#31186'):'
            end
            object Edit1: TEdit
              Left = 111
              Top = 16
              Width = 64
              Height = 25
              BorderStyle = bsNone
              Color = clBtnFace
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 0
              Text = 'Edit1'
            end
            object ComboBox1: TComboBoxEx
              Left = 110
              Top = 64
              Width = 266
              Height = 24
              ItemsEx = <>
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 16
              TabOrder = 2
              OnChange = ComboBox1Change
              DropDownCount = 32
            end
            object SpinEdit6: TSpinEdit
              Left = 110
              Top = 193
              Width = 79
              Height = 24
              Hint = '0'#34920#31034#19981#38480#21046#37325#22797#27425#25968
              MaxValue = 255
              MinValue = 0
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              Value = 1
            end
            object SpinEdit8: TSpinEdit
              Left = 110
              Top = 114
              Width = 81
              Height = 24
              MaxValue = 65535
              MinValue = 0
              TabOrder = 4
              Value = 0
            end
            object CheckBox2: TCheckBox
              Left = 205
              Top = 15
              Width = 96
              Height = 21
              Hint = #24403#20154#29289#24403#21069#20219#21153#21015#34920#20013#21253#21547#26377#27492#20219#21153#30340#23376#23385#20219#21153#26102#65292#27492#20219#21153#19981#33021#34987#25509#21463#12290
              Caption = #25490#26021#23376#20219#21153
              ParentShowHint = False
              ShowHint = True
              TabOrder = 5
            end
            object ComboBox9: TComboBox
              Left = 110
              Top = 89
              Width = 265
              Height = 23
              Style = csDropDownList
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 15
              TabOrder = 6
            end
            object CheckBox3: TCheckBox
              Left = 304
              Top = 15
              Width = 72
              Height = 21
              Caption = #21487#25918#24323
              TabOrder = 7
            end
            object Edit2: TEdit
              Left = 110
              Top = 38
              Width = 258
              Height = 25
              Anchors = [akLeft, akTop, akRight]
              BorderStyle = bsNone
              Color = clBtnFace
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 1
              Text = 'Edit2'
            end
            object se1: TSpinEdit
              Left = 110
              Top = 141
              Width = 79
              Height = 24
              Hint = '0'#34920#31034#19981#38480#21046#37325#22797#27425#25968
              MaxValue = 255
              MinValue = 0
              ParentShowHint = False
              ShowHint = True
              TabOrder = 8
              Value = 1
            end
            object cb5: TComboBox
              Left = 110
              Top = 168
              Width = 265
              Height = 23
              Style = csDropDownList
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 15
              TabOrder = 9
              Items.Strings = (
                '0 '#19981#37197#32622
                '1 '#22914#20309#25552#21319'('#23453#30707#24378#21270#30028#38754')'
                '2 '#24555#36895#23436#25104'('#20219#21153#22996#25176#30028#38754')'
                '3 '#22914#20309#21319#32423'('#27743#28246#23453#20856#25105#35201#21319#32423#30028#38754')')
            end
            object se3: TSpinEdit
              Left = 321
              Top = 194
              Width = 54
              Height = 24
              Hint = '0'#34920#31034#19981#38480#21046#37325#22797#27425#25968
              MaxValue = 255
              MinValue = 0
              ParentShowHint = False
              ShowHint = True
              TabOrder = 10
              Value = 1
            end
            object se4: TSpinEdit
              Left = 274
              Top = 141
              Width = 102
              Height = 24
              MaxValue = 65535
              MinValue = 0
              TabOrder = 11
              Value = 0
            end
            object seinterval: TSpinEdit
              Left = 110
              Top = 218
              Width = 79
              Height = 24
              Hint = '0'#34920#31034#19981#38480#21046#37325#22797#27425#25968
              MaxValue = 99999999
              MinValue = 0
              ParentShowHint = False
              ShowHint = True
              TabOrder = 12
              Value = 1
            end
          end
          object GroupBox6: TGroupBox
            Left = 416
            Top = 4
            Width = 364
            Height = 81
            Caption = #21457#24067
            TabOrder = 1
            DesignSize = (
              364
              81)
            object Label12: TLabel
              Left = 6
              Top = 58
              Width = 32
              Height = 15
              Caption = 'NPC:'
              Font.Charset = ANSI_CHARSET
              Font.Color = clRed
              Font.Height = -15
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object Label18: TLabel
              Left = 4
              Top = 37
              Width = 38
              Height = 15
              Caption = #22320#22270':'
              Font.Charset = ANSI_CHARSET
              Font.Color = clRed
              Font.Height = -15
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object lbl3: TLabel
              Left = 4
              Top = 12
              Width = 38
              Height = 15
              Caption = #31867#22411':'
            end
            object cbPropNpc: TComboBox
              Left = 82
              Top = 55
              Width = 138
              Height = 23
              DropDownCount = 32
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 15
              TabOrder = 1
              OnChange = cbPropNpcChange
            end
            object ComboBox6: TComboBoxEx
              Left = 82
              Top = 33
              Width = 279
              Height = 24
              ItemsEx = <>
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 16
              TabOrder = 0
              OnSelect = ComboBox6Select
              DropDownCount = 32
            end
            object cb3: TComboBox
              Left = 82
              Top = 11
              Width = 279
              Height = 23
              DropDownCount = 32
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 15
              TabOrder = 2
              OnChange = cbPropNpcChange
              Items.Strings = (
                '0 '#20174'NPC'#19978#25509#20219#21153
                '1 '#28385#36275#25509#21463#26465#20214#26102#33258#21160#25509#21463
                '2 '#30001#33050#26412#31995#32479#21160#24577#21457#24067)
            end
            object chk1: TCheckBox
              Left = 226
              Top = 57
              Width = 93
              Height = 21
              Anchors = [akRight, akBottom]
              Caption = #21487#20197#36895#20256
              TabOrder = 3
            end
          end
          object grp1: TGroupBox
            Left = 416
            Top = 84
            Width = 364
            Height = 77
            Caption = #21463#29702
            TabOrder = 2
            DesignSize = (
              364
              77)
            object lbl1: TLabel
              Left = 6
              Top = 57
              Width = 32
              Height = 15
              Caption = 'NPC:'
              Font.Charset = ANSI_CHARSET
              Font.Color = clRed
              Font.Height = -15
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object lbl2: TLabel
              Left = 4
              Top = 35
              Width = 38
              Height = 15
              Caption = #22320#22270':'
              Font.Charset = ANSI_CHARSET
              Font.Color = clRed
              Font.Height = -15
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object lbl4: TLabel
              Left = 4
              Top = 14
              Width = 38
              Height = 15
              Caption = #31867#22411':'
            end
            object cbCompNpc: TComboBox
              Left = 82
              Top = 52
              Width = 138
              Height = 23
              DropDownCount = 32
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 15
              TabOrder = 0
            end
            object cb2: TComboBoxEx
              Left = 82
              Top = 30
              Width = 279
              Height = 24
              ItemsEx = <>
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 16
              TabOrder = 1
              OnSelect = cb2Select
              DropDownCount = 32
            end
            object cb4: TComboBox
              Left = 82
              Top = 8
              Width = 279
              Height = 23
              DropDownCount = 32
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 15
              TabOrder = 2
              OnChange = cbPropNpcChange
              Items.Strings = (
                '0 '#20174'NPC'#19978#20132#21153
                '1 '#28385#36275#38656#27714#26465#20214#26102#33258#21160#23436#25104#24182#33719#24471#22870#21169
                '2 '#34920#31034#30001#33050#26412#31995#32479#21160#24577#22788#29702)
            end
            object chk2: TCheckBox
              Left = 226
              Top = 53
              Width = 93
              Height = 23
              Anchors = [akRight, akBottom]
              Caption = #21487#20197#36895#20256
              TabOrder = 3
            end
          end
          object grp2: TGroupBox
            Left = 416
            Top = 161
            Width = 364
            Height = 48
            Caption = #22810#20493#22870#21169
            TabOrder = 3
            Visible = False
            object lbl6: TLabel
              Left = 118
              Top = 17
              Width = 38
              Height = 15
              Hint = #22914#26524#26159#22266#23450#29615#20219#21153','#34920#31034#24403#21069#20219#21153#25152#22312#31532#20960#29615' '#40664#35748' 0'#13#10
              Caption = #20493#25968':'
              ParentShowHint = False
              ShowHint = True
            end
            object lbl12: TLabel
              Left = 204
              Top = 17
              Width = 23
              Height = 15
              Hint = #22914#26524#26159#22266#23450#29615#20219#21153','#34920#31034#24403#21069#20219#21153#25152#22312#31532#20960#29615' '#40664#35748' 0'#13#10
              Caption = #20540':'
              ParentShowHint = False
              ShowHint = True
            end
            object lbl13: TLabel
              Left = 5
              Top = 17
              Width = 38
              Height = 15
              Caption = #31867#22411':'
            end
            object seAward: TSpinEdit
              Left = 158
              Top = 12
              Width = 38
              Height = 24
              Hint = '('#23383#27573#65306'multiAward '#24847#20041#65306#33719#24471#22810#20493#33719#24471#30340#20493#25968')'
              MaxValue = 255
              MinValue = 0
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              Value = 1
            end
            object seEntrust: TSpinEdit
              Left = 229
              Top = 12
              Width = 132
              Height = 24
              Hint = '('#23383#27573#65306'Entrust '#24847#20041#65306#33719#24471#22810#20493#33719#24471#30340' '#20803#23453#25110#32773#28857#21367' '#20010#25968')'
              MaxValue = 999999
              MinValue = 0
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              Value = 1
            end
            object cbDoubleMoney: TComboBox
              Left = 42
              Top = 13
              Width = 71
              Height = 23
              Hint = '('#23383#27573#65306'DoubleMoneyType '#24847#20041#65306#33719#24471#22810#20493#33719#24471#30340#31867#22411')'
              Style = csDropDownList
              DropDownCount = 32
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 15
              TabOrder = 2
              OnChange = cbPropNpcChange
            end
          end
          object grp3: TGroupBox
            Left = 416
            Top = 211
            Width = 364
            Height = 46
            Caption = #36141#20080
            TabOrder = 4
            object lbl17: TLabel
              Left = 5
              Top = 15
              Width = 38
              Height = 15
              Caption = #31867#22411':'
            end
            object lbl11: TLabel
              Left = 118
              Top = 16
              Width = 38
              Height = 15
              Hint = #36141#20080#20219#21153#27425#25968#20803#23453#22522#25968
              Caption = #22522#25968':'
              ParentShowHint = False
              ShowHint = True
            end
            object cbAgainMoney: TComboBox
              Left = 42
              Top = 11
              Width = 71
              Height = 23
              Style = csDropDownList
              DropDownCount = 32
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 15
              TabOrder = 0
              OnChange = cbPropNpcChange
            end
            object seStar: TSpinEdit
              Left = 158
              Top = 10
              Width = 203
              Height = 24
              Hint = #36141#20080#20219#21153#27425#25968#20803#23453#22522#25968
              MaxValue = 999999
              MinValue = 0
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              Value = 1
            end
          end
        end
        object TabSheet6: TTabSheet
          Caption = #39640#32423
          ImageIndex = 1
          TabVisible = False
          object GroupBox9: TGroupBox
            Left = 4
            Top = 0
            Width = 324
            Height = 144
            Caption = 'GroupBox9'
            TabOrder = 0
            object Label20: TLabel
              Left = 225
              Top = 39
              Width = 15
              Height = 15
              Caption = #65306
            end
            object Label21: TLabel
              Left = 159
              Top = 66
              Width = 15
              Height = 15
              Caption = #33267
            end
            object Label22: TLabel
              Left = 224
              Top = 95
              Width = 15
              Height = 15
              Caption = #65306
            end
            object SpinEdit9: TSpinEdit
              Left = 160
              Top = 35
              Width = 58
              Height = 24
              MaxValue = 23
              MinValue = 0
              TabOrder = 2
              Value = 0
            end
            object SpinEdit10: TSpinEdit
              Left = 245
              Top = 35
              Width = 58
              Height = 24
              MaxValue = 59
              MinValue = 0
              TabOrder = 3
              Value = 0
            end
            object CheckBox1: TCheckBox
              Left = 10
              Top = -3
              Width = 103
              Height = 22
              Caption = #20219#21153#20165#38480#20110
              TabOrder = 0
            end
            object CheckListBox1: TCheckListBox
              Left = 10
              Top = 26
              Width = 141
              Height = 110
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 15
              Items.Strings = (
                #21608#26085
                #21608#19968
                #21608#20108
                #21608#19977
                #21608#22235
                #21608#20116
                #21608#20845)
              TabOrder = 1
            end
            object SpinEdit11: TSpinEdit
              Left = 159
              Top = 91
              Width = 57
              Height = 24
              MaxValue = 23
              MinValue = 0
              TabOrder = 4
              Value = 0
            end
            object SpinEdit12: TSpinEdit
              Left = 244
              Top = 91
              Width = 57
              Height = 24
              MaxValue = 59
              MinValue = 0
              TabOrder = 5
              Value = 0
            end
          end
          object GroupBox5: TGroupBox
            Left = 4
            Top = 151
            Width = 367
            Height = 99
            Caption = #20219#21153#26102#38388#38480#21046
            TabOrder = 1
            object Label4: TLabel
              Left = 19
              Top = 24
              Width = 68
              Height = 15
              Caption = #38480#21046#26041#24335':'
            end
            object Label7: TLabel
              Left = 76
              Top = 65
              Width = 15
              Height = 15
              Caption = #26085
            end
            object Label8: TLabel
              Left = 156
              Top = 65
              Width = 15
              Height = 15
              Caption = #26102
            end
            object Label9: TLabel
              Left = 236
              Top = 65
              Width = 15
              Height = 15
              Caption = #20998
            end
            object SpinEdit3: TSpinEdit
              Left = 19
              Top = 61
              Width = 55
              Height = 24
              MaxValue = 30
              MinValue = 0
              TabOrder = 0
              Value = 0
            end
            object SpinEdit4: TSpinEdit
              Left = 99
              Top = 61
              Width = 55
              Height = 24
              MaxValue = 23
              MinValue = 0
              TabOrder = 1
              Value = 0
            end
            object SpinEdit5: TSpinEdit
              Left = 179
              Top = 61
              Width = 55
              Height = 24
              MaxValue = 59
              MinValue = 0
              TabOrder = 2
              Value = 0
            end
            object cBoxAutoWaiver: TCheckBox
              Left = 264
              Top = 64
              Width = 92
              Height = 21
              Caption = #33258#21160#25918#24323
              TabOrder = 3
              Visible = False
            end
          end
          object GroupBox3: TGroupBox
            Left = 360
            Top = 4
            Width = 388
            Height = 99
            Caption = #20219#21153#37325#22797#38388#38548
            TabOrder = 2
            object Label27: TLabel
              Left = 85
              Top = 65
              Width = 15
              Height = 15
              Caption = #26085
            end
            object Label28: TLabel
              Left = 176
              Top = 65
              Width = 15
              Height = 15
              Caption = #26102
            end
            object Label29: TLabel
              Left = 265
              Top = 65
              Width = 15
              Height = 15
              Caption = #20998
            end
            object Label5: TLabel
              Left = 19
              Top = 24
              Width = 68
              Height = 15
              Caption = #37325#22797#26041#24335':'
            end
            object SpinEdit16: TSpinEdit
              Left = 23
              Top = 61
              Width = 55
              Height = 24
              MaxValue = 30
              MinValue = 0
              TabOrder = 0
              Value = 0
            end
            object SpinEdit17: TSpinEdit
              Left = 109
              Top = 61
              Width = 60
              Height = 24
              MaxValue = 23
              MinValue = 0
              TabOrder = 1
              Value = 0
            end
            object SpinEdit18: TSpinEdit
              Left = 203
              Top = 61
              Width = 55
              Height = 24
              MaxValue = 59
              MinValue = 0
              TabOrder = 2
              Value = 0
            end
            object ComboBox8: TComboBox
              Left = 94
              Top = 20
              Width = 187
              Height = 23
              Style = csDropDownList
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ItemHeight = 15
              TabOrder = 3
              OnSelect = ComboBox8Select
              Items.Strings = (
                #26080#38480#21046
                #21608#26399#24615#37325#22797
                #27599#26085#37325#22797
                #27599#21608#37325#22797)
            end
          end
        end
        object TabSheet7: TTabSheet
          Caption = #25551#36848
          ImageIndex = 2
          object GroupBox2: TGroupBox
            Left = 0
            Top = 0
            Width = 783
            Height = 260
            Align = alClient
            Caption = #20219#21153#25551#36848'('#21487#29992#28216#25103#33050#26412#30528#33394#35821#27861')'
            TabOrder = 0
            object Memo1: TMemo
              Left = 2
              Top = 17
              Width = 779
              Height = 241
              Align = alClient
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              Lines.Strings = (
                'Memo1')
              ScrollBars = ssVertical
              TabOrder = 0
              OnDblClick = Memo1DblClick
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = #23545#35805
          ImageIndex = 3
          object GroupBox4: TGroupBox
            Left = 4
            Top = 4
            Width = 774
            Height = 144
            Caption = #25509#20219#21153#23545#35805
            TabOrder = 0
            object MemoPromTalk: TMemo
              Left = 2
              Top = 17
              Width = 770
              Height = 125
              Align = alClient
              ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 0
            end
          end
          object GroupBox7: TGroupBox
            Left = 4
            Top = 149
            Width = 774
            Height = 144
            Caption = #20132#20219#21153#23545#35805
            TabOrder = 1
            object MemoCompTalk: TMemo
              Left = 2
              Top = 17
              Width = 770
              Height = 125
              Align = alClient
              ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 0
            end
          end
        end
        object TabSheet8: TTabSheet
          Caption = #21095#24773
          ImageIndex = 4
          object GroupBox8: TGroupBox
            Left = 4
            Top = 4
            Width = 774
            Height = 144
            Caption = #25509#20219#21153#21095#24773'('#25903#25345'HTML)'
            TabOrder = 0
            object MemoAcceptStory: TMemo
              Left = 2
              Top = 17
              Width = 770
              Height = 125
              Align = alClient
              ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 0
            end
          end
          object GroupBox10: TGroupBox
            Left = 4
            Top = 149
            Width = 774
            Height = 144
            Caption = #20132#20219#21153#21095#24773'('#25903#25345'HTML)'
            TabOrder = 1
            object MemoFinishStory: TMemo
              Left = 2
              Top = 17
              Width = 770
              Height = 125
              Align = alClient
              ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 0
            end
          end
        end
      end
      object cBoxTransmit: TCheckBox
        Left = 374
        Top = 550
        Width = 144
        Height = 21
        Anchors = [akLeft, akBottom]
        Caption = #25509#20219#21153#21518#25552#31034#20256#36865
        TabOrder = 2
      end
      object chkFindByDriver: TCheckBox
        Left = 3
        Top = 550
        Width = 87
        Height = 21
        Anchors = [akLeft, akBottom]
        Caption = #33258#21160#23547#36335
        TabOrder = 3
      end
      object chk3: TCheckBox
        Left = 94
        Top = 550
        Width = 101
        Height = 21
        Anchors = [akLeft, akBottom]
        Caption = #33258#21160#19978#22352#39569
        TabOrder = 4
      end
      object chk4: TCheckBox
        Left = 199
        Top = 549
        Width = 82
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = #38543#26426#30446#26631
        TabOrder = 5
      end
      object CheckBoxGiveAward: TCheckBox
        Left = 285
        Top = 549
        Width = 85
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = #19981#32473#22870#21169
        TabOrder = 6
      end
      object CBComTrans: TCheckBox
        Left = 522
        Top = 550
        Width = 159
        Height = 21
        Anchors = [akLeft, akBottom]
        Caption = #23436#25104#20219#21153#21518#25552#31034#20256#36865
        TabOrder = 7
      end
    end
  end
  object btnUpRole: TButton
    Left = 10
    Top = 629
    Width = 94
    Height = 31
    Anchors = [akLeft, akBottom]
    Caption = #19978#19968#20010'(&P)'
    TabOrder = 3
    OnClick = btnUpRoleClick
  end
  object btnDownRole: TButton
    Left = 125
    Top = 629
    Width = 94
    Height = 31
    Anchors = [akLeft, akBottom]
    Caption = #19979#19968#20010'(&N)'
    TabOrder = 4
    OnClick = btnDownRoleClick
  end
  object pmAward: TPopupMenu
    OnPopup = pmAwardPopup
    Left = 160
    Top = 355
    object MenuItem1: TMenuItem
      Caption = #32534#36753'(&E)'
      Default = True
      OnClick = MenuItem1Click
    end
    object MenuItem2: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = MenuItem2Click
    end
    object C2: TMenuItem
      Caption = #22797#21046'(&C)'
      OnClick = C2Click
    end
    object P2: TMenuItem
      Caption = #31896#36148'(&P)'
      OnClick = P2Click
    end
    object MenuItem3: TMenuItem
      Caption = '-'
    end
    object MenuItem4: TMenuItem
      Caption = #26032#24314'(&N)'
      OnClick = MenuItem4Click
    end
  end
  object pmTarget: TPopupMenu
    OnPopup = pmTargetPopup
    Left = 96
    Top = 355
    object E1: TMenuItem
      Caption = #32534#36753'(&E)'
      Default = True
      OnClick = E1Click
    end
    object D1: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = D1Click
    end
    object C1: TMenuItem
      Caption = #22797#21046'(&C)'
      OnClick = C1Click
    end
    object P1: TMenuItem
      Caption = #31896#36148'(&P)'
      OnClick = P1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object N2: TMenuItem
      Caption = #26032#24314'(&N)'
      OnClick = N2Click
    end
  end
  object pm1: TPopupMenu
    OnPopup = pmAwardPopup
    Left = 752
    Top = 639
    object MenuItem5: TMenuItem
      Caption = #32534#36753'(&E)'
      Default = True
      OnClick = MenuItem5Click
    end
    object N5: TMenuItem
      Caption = #22797#21046'(&C)'
    end
    object N6: TMenuItem
      Caption = #31896#36148'(&V)'
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
  object pmCond: TPopupMenu
    OnPopup = pmCondPopup
    Left = 40
    Top = 355
    object MenuItem7: TMenuItem
      Caption = #32534#36753'(&E)'
      Default = True
      OnClick = MenuItem7Click
    end
    object MenuItem8: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = MenuItem8Click
    end
    object MenuItem11: TMenuItem
      Caption = #22797#21046'(&C)'
      OnClick = MenuItem11Click
    end
    object MenuItem12: TMenuItem
      Caption = #31896#36148'(&P)'
      OnClick = MenuItem12Click
    end
    object MenuItem13: TMenuItem
      Caption = '-'
    end
    object MenuItem14: TMenuItem
      Caption = #26032#24314'(&N)'
      OnClick = MenuItem14Click
    end
  end
  object pmAwardTag: TPopupMenu
    OnPopup = pmAwardTagPopup
    Left = 56
    Top = 439
    object MenuItem15: TMenuItem
      Caption = #32534#36753'(&E)'
      Default = True
      OnClick = MenuItem15Click
    end
    object MenuItem16: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = MenuItem16Click
    end
    object MenuItem19: TMenuItem
      Caption = '-'
    end
    object MenuItem20: TMenuItem
      Caption = #26032#24314'(&N)'
      OnClick = MenuItem20Click
    end
  end
  object pmSurprise: TPopupMenu
    OnPopup = pmSurprisePopup
    Left = 192
    Top = 355
    object EditSurprise: TMenuItem
      Caption = #32534#36753'(&E)'
      Default = True
      OnClick = EditSurpriseClick
    end
    object delSurprise: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = delSurpriseClick
    end
    object CopySurprise: TMenuItem
      Caption = #22797#21046'(&C)'
      OnClick = CopySurpriseClick
    end
    object pasteSurprise: TMenuItem
      Caption = #31896#36148'(&P)'
      OnClick = pasteSurpriseClick
    end
    object MenuItem23: TMenuItem
      Caption = '-'
    end
    object AddSurprise: TMenuItem
      Caption = #26032#24314'(&N)'
      OnClick = AddSurpriseClick
    end
  end
  object pmMutiAward: TPopupMenu
    OnPopup = pmMutiAwardPopup
    Left = 224
    Top = 355
    object editMA: TMenuItem
      Caption = #32534#36753'(&E)'
      Default = True
      OnClick = EditMAClick
    end
    object DelMA: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = delMAClick
    end
    object CopyMA: TMenuItem
      Caption = #22797#21046'(&C)'
      OnClick = CopyMAClick
    end
    object PasteMA: TMenuItem
      Caption = #31896#36148'(&P)'
      OnClick = pasteMAClick
    end
    object MenuItem24: TMenuItem
      Caption = '-'
    end
    object AddMA: TMenuItem
      Caption = #26032#24314'(&N)'
      OnClick = AddMAClick
    end
  end
end
