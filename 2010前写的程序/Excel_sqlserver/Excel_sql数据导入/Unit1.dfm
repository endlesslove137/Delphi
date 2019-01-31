object Form1: TForm1
  Left = 658
  Top = 328
  AlphaBlendValue = 213
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 686
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #26999#20307'_GB2312'
  Font.Style = [fsBold]
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RzPageControl1: TRzPageControl
    Left = 0
    Top = 0
    Width = 549
    Height = 686
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabIndex = 0
    TabOrder = 0
    FixedDimension = 19
    object TabSheet1: TRzTabSheet
      Caption = 'Excel '#34920#22836
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 545
        Height = 178
        Align = alClient
        Caption = #21046#23450
        TabOrder = 0
        object GroupBox1: TGroupBox
          Left = 2
          Top = 95
          Width = 541
          Height = 76
          Align = alCustom
          Caption = 'Excel'#34920#22836#22788#29702
          TabOrder = 0
          object Label1: TLabel
            Left = 58
            Top = 24
            Width = 14
            Height = 13
            Caption = #34892
            Color = clBlue
            ParentColor = False
          end
          object Label2: TLabel
            Left = 123
            Top = 22
            Width = 14
            Height = 13
            Caption = #21015
            Color = clBlue
            ParentColor = False
          end
          object Label5: TLabel
            Left = 58
            Top = 50
            Width = 14
            Height = 13
            Caption = #34892
            Color = clBlue
            ParentColor = False
          end
          object Label6: TLabel
            Left = 123
            Top = 50
            Width = 14
            Height = 13
            Caption = #21015
            Color = clBlue
            ParentColor = False
          end
          object lblSheet: TRzLabel
            Left = 323
            Top = 49
            Width = 63
            Height = 16
            Caption = #24403#21069'Sheet'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label8: TLabel
            Left = 323
            Top = 24
            Width = 56
            Height = 13
            Caption = #34920#26684#21517#31216
            Transparent = True
          end
          object reHColEnd: TRzEdit
            Left = 74
            Top = 45
            Width = 43
            Height = 21
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 0
          end
          object reHColStart: TRzEdit
            Left = 74
            Top = 15
            Width = 43
            Height = 21
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 1
          end
          object reHRowEnd: TRzEdit
            Left = 9
            Top = 46
            Width = 43
            Height = 21
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 2
          end
          object reHRowStart: TRzEdit
            Left = 9
            Top = 16
            Width = 43
            Height = 21
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 3
          end
          object RzButton3: TRzButton
            Left = 142
            Top = 11
            Width = 101
            Caption = #34920#22836#36215#22987
            TabOrder = 4
            OnClick = RzButton3Click
          end
          object RzButton5: TRzButton
            Left = 142
            Top = 42
            Width = 100
            Height = 27
            Caption = #34920#22836#32467#26463
            TabOrder = 5
            OnClick = RzButton5Click
          end
          object RzButton8: TRzButton
            Left = 252
            Top = 14
            Width = 65
            Height = 53
            Caption = #33719#21462#34920#22836#20449#24687
            TabOrder = 6
            OnClick = RzButton8Click
          end
          object RzButton17: TRzButton
            Left = 409
            Top = 11
            Width = 120
            Caption = #19978#19968#25968#25454#34920
            TabOrder = 7
            OnClick = RzButton17Click
          end
          object RzButton16: TRzButton
            Left = 409
            Top = 42
            Width = 120
            Caption = #19979#19968#25968#25454#34920
            TabOrder = 8
            OnClick = RzButton16Click
          end
        end
        object GroupBox11: TGroupBox
          Left = 2
          Top = 15
          Width = 541
          Height = 80
          Align = alTop
          Caption = 'GroupBox11'
          TabOrder = 1
          object RzLabel2: TRzLabel
            Left = 13
            Top = 22
            Width = 44
            Height = 13
            Caption = #26041'  '#26696
            Transparent = True
          end
          object RzLabel15: TRzLabel
            Left = 12
            Top = 46
            Width = 44
            Height = 21
            AutoSize = False
            Caption = #25972#29702#20154
            Transparent = True
          end
          object Label3: TLabel
            Left = 229
            Top = 23
            Width = 56
            Height = 13
            Caption = #25991#20214#26102#38388
            Transparent = True
          end
          object EdtScheme: TEdit
            Left = 62
            Top = 19
            Width = 158
            Height = 21
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 0
          end
          object RzEdit11: TRzEdit
            Left = 62
            Top = 46
            Width = 78
            Height = 21
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 1
          end
          object RzDateTimePicker1: TRzDateTimePicker
            Left = 296
            Top = 19
            Width = 143
            Height = 21
            Date = 40218.706480416670000000
            Time = 40218.706480416670000000
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 2
            FrameVisible = True
          end
          object RzButton18: TRzButton
            Left = 455
            Top = 17
            Caption = #20851#38381#25991#20214
            TabOrder = 3
            OnClick = RzButton18Click
          end
          object RzButton1: TRzButton
            Left = 440
            Top = 43
            Width = 91
            Height = 30
            Caption = #25171#24320#25991#20214'...'
            TabOrder = 4
            OnClick = RzButton1Click
          end
          object chkFront: TRzCheckBox
            Left = 153
            Top = 49
            Width = 75
            Height = 15
            Caption = #31383#20307#33267#21069
            Checked = True
            State = cbChecked
            TabOrder = 5
            Transparent = True
            OnClick = chkFrontClick
          end
          object CheckBox2: TCheckBox
            Left = 262
            Top = 49
            Width = 131
            Height = 17
            Caption = #22788#29702#38544#34255#30340#34892#21015
            Checked = True
            State = cbChecked
            TabOrder = 6
            OnClick = CheckBox2Click
          end
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 178
        Width = 545
        Height = 485
        Align = alBottom
        Caption = #34920#22836#23383#27573#22788#29702
        TabOrder = 1
        object cxGrid1: TcxGrid
          Left = 2
          Top = 15
          Width = 541
          Height = 384
          Align = alClient
          TabOrder = 0
          object cxGrid1DBTableView1: TcxGridDBTableView
            NavigatorButtons.ConfirmDelete = False
            DataController.DataSource = dsgrid
            DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoImmediatePost]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            object XlsColName: TcxGridDBColumn
              Caption = ' Excel'#22788#29702#21015#21517'          '
              DataBinding.FieldName = 'XLSColName'
              HeaderAlignmentHorz = taCenter
              Width = 170
            end
            object XlsColIndex: TcxGridDBColumn
              Caption = ' Excle'#21015#32034#24341' '
              DataBinding.FieldName = 'XLSColIdx'
              HeaderAlignmentHorz = taCenter
              MinWidth = 75
              Width = 107
            end
            object FieldDesc: TcxGridDBColumn
              Caption = #34920#23383#27573#25551#36848
              DataBinding.FieldName = 'DBFieldDesc'
              PropertiesClassName = 'TcxComboBoxProperties'
              Properties.ImmediatePost = True
              Properties.OnChange = FieldDescPropertiesChange
              HeaderAlignmentHorz = taCenter
              Width = 177
            end
            object FieldName: TcxGridDBColumn
              Caption = #34920#23383#27573#21517#31216
              DataBinding.FieldName = 'DBFieldName'
              HeaderAlignmentHorz = taCenter
              Width = 131
            end
            object DataType: TcxGridDBColumn
              Caption = #25968#25454#31867#22411
              DataBinding.FieldName = 'datatype'
            end
          end
          object cxGrid1Level1: TcxGridLevel
            GridView = cxGrid1DBTableView1
          end
        end
        object Panel1: TPanel
          Left = 2
          Top = 399
          Width = 541
          Height = 84
          Align = alBottom
          TabOrder = 1
          Visible = False
          object SpeedButton1: TSpeedButton
            Left = 375
            Top = 17
            Width = 90
            Height = 49
            Caption = #28155#21152#25551#36848
            OnClick = SpeedButton1Click
          end
          object Label4: TLabel
            Left = 49
            Top = 11
            Width = 70
            Height = 13
            Caption = #34920#23383#27573#25551#36848
            Transparent = True
          end
          object Label7: TLabel
            Left = 49
            Top = 37
            Width = 70
            Height = 13
            Caption = #34920#23383#27573#21517#31216
            Transparent = True
          end
          object Label10: TLabel
            Left = 49
            Top = 64
            Width = 56
            Height = 13
            Caption = #25968#25454#31867#22411
            Transparent = True
          end
          object ComboBox1: TComboBox
            Left = 125
            Top = 60
            Width = 149
            Height = 21
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 0
            Items.Strings = (
              #25968#23383
              #25991#23383
              #26085#26399)
          end
          object Edit1: TEdit
            Left = 125
            Top = 10
            Width = 149
            Height = 21
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 1
          end
          object Edit2: TEdit
            Left = 125
            Top = 33
            Width = 149
            Height = 21
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 2
          end
        end
      end
    end
    object TabSheet2: TRzTabSheet
      Caption = 'Excel '#25968#25454
      object GroupBox6: TGroupBox
        Left = 0
        Top = 74
        Width = 545
        Height = 318
        Align = alClient
        Caption = #26080#25928#22788#29702
        TabOrder = 0
        object lblDelInfo: TRzLabel
          Left = 101
          Top = 231
          Width = 87
          Height = 26
          AutoSize = False
          Caption = #20934#22791#28165#38500'...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object RzLabel8: TRzLabel
          Left = 333
          Top = 27
          Width = 42
          Height = 13
          Caption = #21028#23450#21015
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object RzLabel9: TRzLabel
          Left = 25
          Top = 28
          Width = 48
          Height = 133
          AutoSize = False
          Caption = #26080#25928#25968#25454#21028#26029#20851#38190#23383#12290#35832#22914#32479#35745#12289#21512#35745#31561#12290#20043#38388#29992#39'#'#39#20998#38548#12290
          Font.Charset = ANSI_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Button3: TButton
          Left = 345
          Top = 263
          Width = 157
          Height = 42
          Caption = #28165#38500#26080#25928
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = Button3Click
        end
        object reWellName: TRzEdit
          Left = 101
          Top = 30
          Width = 50
          Height = 21
          Text = '1'
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          ParentFont = False
          TabOrder = 1
        end
        object RzButton10: TRzButton
          Left = 400
          Top = 23
          Width = 89
          Height = 54
          Caption = #33719#21462#26080#25928#25968#25454#21028#23450#21015
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          TabOrder = 2
          TextStyle = tsRaised
          OnClick = RzButton10Click
        end
        object RzButton71: TRzButton
          Left = 202
          Top = 24
          Width = 95
          Height = 51
          Caption = #33719#21462#19981#20026#31354#30340#21015#21517
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = RzButton71Click
        end
        object RzCheckBox2: TRzCheckBox
          Left = 101
          Top = 91
          Width = 220
          Height = 16
          AutoSize = False
          Caption = #33719#21462#26377#25928#25968#25454#33539#22260#65288#32467#26463#34892#65289
          Checked = True
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          State = cbChecked
          TabOrder = 4
        end
        object RzCheckBox3: TRzCheckBox
          Left = 101
          Top = 57
          Width = 76
          Height = 20
          AutoSize = False
          Caption = #21024#38500#31354#34892
          Checked = True
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          State = cbChecked
          TabOrder = 5
        end
        object RzEdit8: TRzEdit
          Left = 333
          Top = 55
          Width = 31
          Height = 21
          Text = '3'
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          FrameVisible = True
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          ParentFont = False
          TabOrder = 6
        end
        object rzFilterString: TRzRichEdit
          Left = 101
          Top = 130
          Width = 401
          Height = 120
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          Lines.Strings = (
            '#'#21512#35745'#'#26102'#'#20117#32452'#'#20117#22330'#'#26032'#'#21407'#'#21495'#'#31449'#'#26085'#'#27833'#'#37327'#'#28082'#'#23450#36793'#'#37319#27833#38431'#'#23567#35745'#'
            #21512'#'
            #35745'#'#32452'#'#24196'#'#21776#23665'#'#22330'#'#38472'#'#37319'#'#36127#36131#20154'#'#26102'#'#26085#26399'#'#26032'#'#27833#36710'#200#'#32769#20117'#'#26412'#:#'
            #39029'#'
            #22791#27880
            '#'#30333'#'#30333'#'#26691'#'#21776#23665'#'#32599'#'#23546'#'#37326'#'#26753'#'#26446#24196#31185'#'#23546#27807'#'#37326#29482'#'#25968'#'#21776'#'#30333#29436#23700'#'#30333'#'
            #37073#23870
            '#'#20142#39532'#'#26691#26032'#'#24352#35199'#'#32650#32660'#'#20249#22330'#'#23870#23704'#'#26102'#'#26102#38388'#'#38388'#'#36127#36131'#'#32508'#'#21512'#'#32418'#'#36127'#'#36131
            '#')
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 7
          WantReturns = False
          FrameVisible = True
        end
        object CheckBox1: TCheckBox
          Left = 333
          Top = 91
          Width = 164
          Height = 17
          Caption = #20197'"'#21028#23450#21015'"'#24490#29615#21028#23450
          Checked = True
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          State = cbChecked
          TabOrder = 8
        end
      end
      object GroupBox4: TGroupBox
        Left = 0
        Top = 392
        Width = 545
        Height = 271
        Align = alBottom
        Caption = #25968#25454#36716#25442#20449#24687
        TabOrder = 1
        object lblRow: TRzLabel
          Left = 14
          Top = 47
          Width = 86
          Height = 16
          Caption = #24403#21069#33719#21462#34892' 0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object RzButton9: TRzButton
          Left = 691
          Top = 22
          Width = 130
          Height = 49
          Caption = #21047#26032#23545#29031#20449#24687
          TabOrder = 0
        end
        object RzButton23: TRzButton
          Left = 260
          Top = 91
          Width = 104
          Height = 28
          Caption = #38468#21152#20449#24687#21015'3'
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object reInfo3: TRzEdit
          Left = 260
          Top = 64
          Width = 104
          Height = 21
          Text = '0'
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 2
        end
        object RzButton22: TRzButton
          Left = 132
          Top = 91
          Width = 111
          Height = 29
          Caption = #38468#21152#20449#24687#21015'2'
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object reInfo2: TRzEdit
          Left = 132
          Top = 64
          Width = 104
          Height = 21
          Text = '0'
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 4
        end
        object RzButton21: TRzButton
          Left = 5
          Top = 91
          Width = 101
          Height = 29
          Caption = #38468#21152#20449#24687#21015'1'
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object reInfo1: TRzEdit
          Left = 5
          Top = 64
          Width = 101
          Height = 21
          Text = '0'
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 6
        end
        object pgBar: TProgressBar
          Left = 3
          Top = 20
          Width = 539
          Height = 21
          TabOrder = 7
        end
        object RzButton15: TRzButton
          Left = 762
          Top = 100
          Width = 183
          Caption = #33258#21160#21305#37197#21015
          Color = clCream
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          Visible = False
        end
        object RzButton2: TRzButton
          Left = 402
          Top = 47
          Width = 130
          Height = 74
          Caption = #33719#21462#25968#25454
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
          OnClick = RzButton2Click
        end
        object GroupBox10: TGroupBox
          Left = 2
          Top = 133
          Width = 541
          Height = 136
          Align = alBottom
          Caption = #25968#25454#24211#20449#24687
          TabOrder = 10
          object Panel3: TPanel
            Left = 2
            Top = 15
            Width = 537
            Height = 119
            Align = alClient
            TabOrder = 0
            object Label9: TLabel
              Left = 20
              Top = 17
              Width = 98
              Height = 13
              Caption = #25968#25454#36801#31227#30446#26631#34920
              Transparent = True
            end
            object ComboBox2: TComboBox
              Left = 138
              Top = 15
              Width = 145
              Height = 21
              ImeName = #26497#28857#20116#31508#36755#20837#27861
              TabOrder = 0
              OnChange = ComboBox2Change
            end
            object Button6: TButton
              Left = 329
              Top = 16
              Width = 113
              Height = 25
              Caption = #21024#38500#24403#21069#34920
              TabOrder = 1
              OnClick = Button6Click
            end
          end
        end
        object Button4: TButton
          Left = 370
          Top = 47
          Width = 26
          Height = 73
          Caption = #20445#23384#26041#26696
          TabOrder = 11
          WordWrap = True
          OnClick = Button4Click
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 0
        Width = 545
        Height = 74
        Align = alTop
        Caption = #25968#25454#36215#22987#20449#24687
        TabOrder = 2
        object RzButton7: TRzButton
          Left = 355
          Top = 44
          Width = 140
          Caption = #25968#25454#32467#26463#34892
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = RzButton7Click
        end
        object reDRowEnd: TRzEdit
          Left = 267
          Top = 44
          Width = 71
          Height = 21
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          ParentFont = False
          TabOrder = 1
        end
        object RzButton6: TRzButton
          Left = 355
          Top = 13
          Width = 139
          Caption = #25968#25454#36215#22987#34892
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = RzButton6Click
        end
        object reDRowStart: TRzEdit
          Left = 267
          Top = 14
          Width = 71
          Height = 21
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          ParentFont = False
          TabOrder = 3
        end
      end
    end
    object TabSheet3: TRzTabSheet
      Caption = 'SqlServer-'#25968#25454#24211#21629#20196
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox7: TGroupBox
        Left = 0
        Top = 0
        Width = 545
        Height = 121
        Align = alTop
        Caption = 'sql'#21629#20196
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Memo1: TMemo
          Left = 2
          Top = 15
          Width = 541
          Height = 104
          Align = alClient
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 0
        end
      end
      object GroupBox8: TGroupBox
        Left = 0
        Top = 558
        Width = 545
        Height = 105
        Align = alBottom
        Caption = #25805#20316
        TabOrder = 1
        object SpeedButton2: TSpeedButton
          Left = 16
          Top = 16
          Width = 89
          Height = 49
          Caption = #37197#32622#25968#25454#24211
          OnClick = SpeedButton2Click
        end
        object SpeedButton3: TSpeedButton
          Left = 111
          Top = 16
          Width = 121
          Height = 49
          Caption = #37325#26032#36830#25509#25968#25454#24211
          OnClick = SpeedButton3Click
        end
        object Button1: TButton
          Left = 292
          Top = 16
          Width = 101
          Height = 49
          Caption = #25191#34892#34920#21629#20196
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 409
          Top = 16
          Width = 120
          Height = 49
          Caption = #25191#34892#25968#25454#24211#21629#20196
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = Button2Click
        end
      end
      object GroupBox9: TGroupBox
        Left = 0
        Top = 121
        Width = 545
        Height = 437
        Align = alClient
        Caption = #34920#35270#22270
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object DBGrid1: TDBGrid
          Left = 2
          Top = 15
          Width = 541
          Height = 420
          Align = alClient
          DataSource = DataSource1
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = GB2312_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = #23435#20307
          TitleFont.Style = []
        end
      end
    end
    object TabSheet4: TRzTabSheet
      Caption = 'Excel '#25209#22788#29702
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TabSheet5: TRzTabSheet
      Caption = 'test'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label11: TLabel
        Left = 146
        Top = 80
        Width = 14
        Height = 13
        Caption = #34892
        Color = clBlue
        ParentColor = False
      end
      object Label12: TLabel
        Left = 211
        Top = 78
        Width = 14
        Height = 13
        Caption = #21015
        Color = clBlue
        ParentColor = False
      end
      object RzEdit1: TRzEdit
        Left = 97
        Top = 72
        Width = 43
        Height = 21
        ImeName = #26497#28857#20116#31508#36755#20837#27861
        TabOrder = 0
      end
      object RzEdit2: TRzEdit
        Left = 162
        Top = 72
        Width = 43
        Height = 21
        ImeName = #26497#28857#20116#31508#36755#20837#27861
        TabOrder = 1
      end
      object RzEdit3: TRzEdit
        Left = 97
        Top = 170
        Width = 108
        Height = 21
        ImeName = #26497#28857#20116#31508#36755#20837#27861
        TabOrder = 2
      end
      object BitBtn1: TBitBtn
        Left = 242
        Top = 125
        Width = 75
        Height = 25
        Caption = #36171#20540
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 3
        OnClick = BitBtn1Click
      end
      object BitBtn2: TBitBtn
        Left = 242
        Top = 168
        Width = 75
        Height = 25
        Caption = #35835#21462
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 4
        OnClick = BitBtn2Click
      end
    end
  end
  object AdoTemp: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 232
    Top = 395
  end
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Provider = 'D:\zmm\achieve\Excel_access\11sql.udl'
    Left = 48
    Top = 395
  end
  object ADOCommand1: TADOCommand
    Connection = ADOConnection1
    Parameters = <>
    Left = 128
    Top = 395
  end
  object DataSource1: TDataSource
    DataSet = AdoTemp
    Left = 176
    Top = 395
  end
  object Comparefields: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from comparefields')
    Left = 40
    Top = 304
  end
  object MapCol: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from mapcol')
    Left = 96
    Top = 304
    object MapColXLSColName: TWideStringField
      FieldName = 'XLSColName'
      Size = 200
    end
    object MapColXLSColIdx: TIntegerField
      FieldName = 'XLSColIdx'
    end
    object MapColDBFieldDesc: TWideStringField
      FieldName = 'DBFieldDesc'
      Size = 50
    end
    object MapColDBFieldName: TWideStringField
      FieldName = 'DBFieldName'
      Size = 50
    end
    object MapColdatatype: TStringField
      FieldName = 'datatype'
    end
  end
  object dsgrid: TDataSource
    DataSet = MapCol
    Left = 280
    Top = 392
  end
  object odFile: TOpenDialog
    Left = 56
    Top = 240
  end
  object datainsert: TADOTable
    Connection = ADOConnection1
    Left = 184
    Top = 304
  end
  object Well: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from DingbianYouJing')
    Left = 272
    Top = 312
    object WellJingHao: TStringField
      FieldName = 'JingHao'
      Size = 150
    end
    object WellCaiYouDui: TStringField
      FieldName = 'CaiYouDui'
      Size = 150
    end
    object WellJingQuYu: TStringField
      FieldName = 'JingQuYu'
      Size = 150
    end
    object WellWELLNAME: TStringField
      FieldName = 'WELLNAME'
      Size = 150
    end
    object WellJingLeiXing: TStringField
      FieldName = 'JingLeiXing'
      Size = 150
    end
    object WellBiaoGeMingCheng: TStringField
      FieldName = 'BiaoGeMingCheng'
      Size = 30
    end
    object WellInputDate: TDateTimeField
      FieldName = 'InputDate'
    end
    object WellSchemaName: TStringField
      FieldName = 'SchemaName'
      Size = 30
    end
    object WellInputUser: TStringField
      FieldName = 'InputUser'
      Size = 30
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 248
    Top = 91
    object xp1: TMenuItem
      Caption = 'xp'#39118#26684'-'#31881#34013
      OnClick = xp1Click
    end
    object N1: TMenuItem
      Tag = 1
      Caption = #27224#40644
      OnClick = xp1Click
    end
    object N2: TMenuItem
      Tag = 2
      Caption = #24518#31461#24180'-'#30742#32418
      OnClick = xp1Click
    end
    object N3: TMenuItem
      Tag = 3
      Caption = #34013#33394#22825#38469#65293#27700#26230
      OnClick = xp1Click
    end
    object N4: TMenuItem
      Tag = 4
      Caption = #33529#26524#39118#26684
      OnClick = xp1Click
    end
    object N5: TMenuItem
      Tag = 5
      Caption = #31881#33394#21487#20154
      OnClick = xp1Click
    end
    object N6: TMenuItem
      Tag = 6
      Caption = #28165#32511
      OnClick = xp1Click
    end
    object N7: TMenuItem
      Tag = 7
      Caption = #26263#28784#24615#24773'-'#30333#36793
      OnClick = xp1Click
    end
  end
end
