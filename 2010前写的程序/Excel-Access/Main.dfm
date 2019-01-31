object frmMain: TfrmMain
  Left = 435
  Top = 0
  Caption = #26085#25253#22788#29702
  ClientHeight = 646
  ClientWidth = 530
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label3: TLabel
    Left = 75
    Top = 24
    Width = 15
    Height = 16
    Caption = #34892
  end
  object Label4: TLabel
    Left = 149
    Top = 22
    Width = 15
    Height = 16
    Caption = #21015
  end
  object RzPageControl1: TRzPageControl
    Left = 0
    Top = 0
    Width = 530
    Height = 646
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    FixedDimension = 22
    object TabSheet1: TRzTabSheet
      Caption = #21046#23450
      object RzGroupBox1: TRzGroupBox
        Left = 0
        Top = 0
        Width = 526
        Height = 69
        Align = alTop
        BorderInner = fsGroove
        BorderOuter = fsFlat
        Caption = #26041#26696
        TabOrder = 0
        object RzLabel15: TRzLabel
          Left = 8
          Top = 40
          Width = 60
          Height = 21
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          AutoSize = False
          Caption = #25972#29702#20154#65306
        end
        object RzLabel2: TRzLabel
          Left = 8
          Top = 13
          Width = 60
          Height = 16
          Caption = #37319#27833#21378#65306
        end
        object RzButton24: TRzButton
          Left = 211
          Top = 86
          Width = 146
          Caption = #36873#25321#24211#25991#20214'....'
          TabOrder = 0
          Visible = False
          OnClick = RzButton24Click
        end
        object Button4: TButton
          Left = 139
          Top = 38
          Width = 71
          Height = 25
          Caption = #20445#23384#26041#26696
          TabOrder = 1
          OnClick = Button4Click
        end
        object chkFront: TRzCheckBox
          Left = 313
          Top = 46
          Width = 79
          Height = 18
          Caption = #31383#20307#33267#21069
          State = cbUnchecked
          TabOrder = 2
          OnClick = chkFrontClick
        end
        object cmbSchema: TComboBox
          Left = 69
          Top = 14
          Width = 141
          Height = 24
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 3
          Text = 'cmbSchema'
          OnChange = cmbSchemaChange
        end
        object RzButton1: TRzButton
          Left = 211
          Top = 13
          Width = 96
          Height = 51
          Caption = #25171#24320#25991#20214'...'
          TabOrder = 4
          OnClick = RzButton1Click
        end
        object RzCheckBox1: TRzCheckBox
          Left = 454
          Top = 18
          Width = 50
          Height = 18
          Caption = 'GoOn'
          State = cbUnchecked
          TabOrder = 5
          OnClick = RzCheckBox1Click
        end
        object RzCheckBox2: TRzCheckBox
          Left = 424
          Top = 46
          Width = 91
          Height = 18
          Caption = 'Single Sheet'
          State = cbUnchecked
          TabOrder = 6
          OnClick = RzCheckBox2Click
        end
        object RzDateTimePicker1: TRzDateTimePicker
          Left = 309
          Top = 11
          Width = 140
          Height = 26
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Date = 40218.706480416670000000
          Time = 40218.706480416670000000
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 7
          FrameVisible = True
        end
        object RzEdit11: TRzEdit
          Left = 69
          Top = 37
          Width = 67
          Height = 24
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 8
        end
      end
      object RzGroupBox2: TRzGroupBox
        Left = 0
        Top = 69
        Width = 526
        Height = 278
        Align = alTop
        TabOrder = 1
        object GroupBox1: TGroupBox
          Left = 1
          Top = 17
          Width = 524
          Height = 77
          Align = alTop
          Caption = #34892#21015#22320#22336#20449#24687
          TabOrder = 0
          object Label1: TLabel
            Left = 61
            Top = 26
            Width = 15
            Height = 16
            Caption = #34892
            Color = clBlue
            ParentColor = False
          end
          object Label2: TLabel
            Left = 135
            Top = 24
            Width = 15
            Height = 16
            Caption = #21015
            Color = clBlue
            ParentColor = False
          end
          object Label5: TLabel
            Left = 61
            Top = 52
            Width = 15
            Height = 16
            Caption = #34892
            Color = clBlue
            ParentColor = False
          end
          object Label6: TLabel
            Left = 135
            Top = 55
            Width = 15
            Height = 16
            Caption = #21015
            Color = clBlue
            ParentColor = False
          end
          object RzButton5: TRzButton
            Left = 159
            Top = 44
            Width = 82
            Height = 27
            Caption = #34920#22836#32467#26463
            TabOrder = 0
            OnClick = RzButton5Click
          end
          object reHColEnd: TRzEdit
            Left = 86
            Top = 47
            Width = 43
            Height = 24
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 1
          end
          object reHRowEnd: TRzEdit
            Left = 12
            Top = 48
            Width = 43
            Height = 24
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 2
            OnChange = reHRowEndChange
          end
          object RzButton3: TRzButton
            Left = 158
            Top = 16
            Width = 83
            Caption = #34920#22836#36215#22987
            TabOrder = 3
            OnClick = RzButton3Click
          end
          object reHColStart: TRzEdit
            Left = 86
            Top = 17
            Width = 43
            Height = 24
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 4
          end
          object reHRowStart: TRzEdit
            Left = 12
            Top = 18
            Width = 43
            Height = 24
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 5
            OnChange = reHRowStartChange
          end
          object reDRowStart: TRzEdit
            Left = 248
            Top = 16
            Width = 43
            Height = 24
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 6
          end
          object RzButton6: TRzButton
            Left = 310
            Top = 15
            Width = 88
            Caption = #25968#25454#36215#22987#34892
            TabOrder = 7
            OnClick = RzButton6Click
          end
          object reDRowEnd: TRzEdit
            Left = 248
            Top = 46
            Width = 43
            Height = 24
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 8
          end
          object RzButton7: TRzButton
            Left = 310
            Top = 46
            Width = 88
            Caption = #25968#25454#32467#26463#34892
            TabOrder = 9
            OnClick = RzButton7Click
          end
          object RzButton17: TRzButton
            Left = 400
            Top = 15
            Width = 119
            Caption = #19978#19968#25968#25454#34920
            TabOrder = 10
            OnClick = RzButton17Click
          end
          object RzButton16: TRzButton
            Left = 400
            Top = 45
            Width = 119
            Caption = #19979#19968#25968#25454#34920
            TabOrder = 11
            OnClick = RzButton16Click
          end
        end
        object GroupBox6: TGroupBox
          Left = 2
          Top = 179
          Width = 581
          Height = 94
          Align = alCustom
          Caption = #26080#25928#20449#24687
          TabOrder = 2
          object lblDelInfo: TRzLabel
            Left = 426
            Top = 63
            Width = 87
            Height = 14
            AutoSize = False
            Caption = #20934#22791#28165#38500'...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object Button3: TButton
            Left = 425
            Top = 14
            Width = 88
            Height = 43
            Caption = #28165#38500#26080#25928
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = Button3Click
          end
          object rzFilterString: TMemo
            Left = 8
            Top = 14
            Width = 407
            Height = 75
            Hint = #26080#25928#25968#25454#21028#26029#20851#38190#23383#12290#35832#22914#32479#35745#12289#21512#35745#31561#12290#20043#38388#29992#39'#'#39#20998#38548#12290'('#22312#40664#35748#24773#20917#19979#20250#33258#21160#26816#26597#21069#19977#21015#30340#25968#25454#21512#27861#24615')'
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            Lines.Strings = (
              '#'#26085'#'#27833'#'#28082'#'#27700'#'#31449'#'#20117#32452'#'#21512#35745'#')
            ScrollBars = ssVertical
            TabOrder = 1
          end
        end
        object GroupBox2: TGroupBox
          Left = 2
          Top = 100
          Width = 581
          Height = 73
          Align = alCustom
          Caption = #25968#25454#36716#25442#20449#24687
          TabOrder = 1
          object lblRow: TRzLabel
            Left = 263
            Top = 23
            Width = 75
            Height = 16
            Caption = #24403#21069#33719#21462#34892
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblSheet: TRzLabel
            Left = 201
            Top = 23
            Width = 34
            Height = 16
            Caption = 'lsheet'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lbl1: TLabel
            Left = 116
            Top = 24
            Width = 45
            Height = 16
            Caption = #20117#21517#21015
          end
          object RzButton9: TRzButton
            Left = 578
            Top = 12
            Width = 130
            Height = 49
            Caption = #21047#26032#23545#29031#20449#24687
            TabOrder = 0
            OnClick = RzButton9Click
          end
          object RzButton20: TRzButton
            Left = 467
            Top = 35
            Width = 52
            Height = 34
            Caption = #32487#32493#33719#21462
            TabOrder = 1
            OnClick = RzButton20Click
          end
          object RzButton19: TRzButton
            Left = 412
            Top = 37
            Width = 54
            Height = 32
            Caption = #20572#27490#33719#21462
            TabOrder = 2
            OnClick = RzButton19Click
          end
          object pgBar: TProgressBar
            Left = 3
            Top = 48
            Width = 403
            Height = 21
            TabOrder = 3
          end
          object RzButton15: TRzButton
            Left = 578
            Top = 74
            Width = 183
            Caption = #33258#21160#21305#37197#21015
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            OnClick = RzButton15Click
          end
          object RzButton2: TRzButton
            Left = 412
            Top = 11
            Width = 107
            Height = 24
            Caption = #33719#21462#25968#25454
            TabOrder = 5
            OnClick = RzButton2Click
          end
          object RzButton8: TRzButton
            Left = 3
            Top = 17
            Width = 108
            Caption = #33719#21462#34920#22836#20449#24687
            TabOrder = 6
            OnClick = RzButton8Click
          end
          object reWellName: TEdit
            Left = 167
            Top = 18
            Width = 24
            Height = 24
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 7
            Text = '1'
          end
        end
      end
      object RzGroupBox3: TRzGroupBox
        Left = 0
        Top = 347
        Width = 526
        Height = 273
        Align = alClient
        Caption = #23383#27573#23545#29031
        TabOrder = 2
        object cxGrid1: TcxGrid
          Left = 523
          Top = 17
          Width = 2
          Height = 218
          Align = alClient
          TabOrder = 0
          object grdCol: TcxGridDBTableView
            NavigatorButtons.ConfirmDelete = False
            DataController.DataSource = dssheet
            DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoImmediatePost]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsView.GroupByBox = False
            object grdColSchemaNo: TcxGridDBColumn
              DataBinding.FieldName = 'SchemaNo'
              HeaderAlignmentHorz = taCenter
              Width = 111
            end
            object grdColSheetName: TcxGridDBColumn
              DataBinding.FieldName = 'SheetName'
              HeaderAlignmentHorz = taCenter
              Width = 111
            end
            object grdColHeadStartColumn: TcxGridDBColumn
              DataBinding.FieldName = 'HeadStartColumn'
              HeaderAlignmentHorz = taCenter
              Width = 111
            end
            object grdColHeadEndColumn: TcxGridDBColumn
              DataBinding.FieldName = 'HeadEndColumn'
              HeaderAlignmentHorz = taCenter
              Width = 111
            end
            object grdColHeadStartRow: TcxGridDBColumn
              DataBinding.FieldName = 'HeadStartRow'
              HeaderAlignmentHorz = taCenter
              Width = 111
            end
            object grdColHeadEndRow: TcxGridDBColumn
              DataBinding.FieldName = 'HeadEndRow'
              HeaderAlignmentHorz = taCenter
              Width = 111
            end
            object grdColDataStartColumn: TcxGridDBColumn
              DataBinding.FieldName = 'DataStartColumn'
              HeaderAlignmentHorz = taCenter
              Width = 111
            end
            object grdColDataEndColumn: TcxGridDBColumn
              DataBinding.FieldName = 'DataEndColumn'
              HeaderAlignmentHorz = taCenter
              Width = 111
            end
          end
          object cxGrid1Level1: TcxGridLevel
            GridView = grdCol
          end
        end
        object cxSplitter1: TcxSplitter
          Left = 515
          Top = 17
          Width = 8
          Height = 218
          HotZoneClassName = 'TcxMediaPlayer9Style'
          Control = cxGrid3
        end
        object cxGrid3: TcxGrid
          Left = 1
          Top = 17
          Width = 514
          Height = 218
          Align = alLeft
          TabOrder = 2
          object cxgrdbtblvw1: TcxGridDBTableView
            NavigatorButtons.ConfirmDelete = False
            DataController.DataSource = dsCol
            DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoImmediatePost]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsView.GroupByBox = False
            object grdColXLSColName: TcxGridDBColumn
              Caption = #21015#21517
              DataBinding.FieldName = 'XLSColName'
              HeaderAlignmentHorz = taCenter
              Width = 117
            end
            object grdColXLSColIdx: TcxGridDBColumn
              Caption = #21015#21495
              DataBinding.FieldName = 'XLSColIdx'
              HeaderAlignmentHorz = taCenter
              Width = 20
            end
            object grdColDBFieldDesc: TcxGridDBColumn
              Caption = #25968#25454#24211#25551#36848
              DataBinding.FieldName = 'DBFieldDesc'
              PropertiesClassName = 'TcxComboBoxProperties'
              Properties.ImmediatePost = True
              Properties.OnChange = grdColDBFieldDescPropertiesChange
              HeaderAlignmentHorz = taCenter
              Width = 137
            end
            object grdColDBFieldName: TcxGridDBColumn
              Caption = #25968#25454#24211#21015#21517
              DataBinding.FieldName = 'DBFieldName'
              HeaderAlignmentHorz = taCenter
              Width = 101
            end
            object cxgrdbtblvw1Column1: TcxGridDBColumn
              Caption = #25968#25454#31867#22411
              DataBinding.FieldName = 'DataType'
              Width = 77
            end
          end
          object cxGridLevel1: TcxGridLevel
            GridView = cxgrdbtblvw1
          end
        end
        object pnl1: TPanel
          Left = 1
          Top = 235
          Width = 524
          Height = 37
          Align = alBottom
          TabOrder = 3
          Visible = False
          object btn1: TSpeedButton
            Left = 426
            Top = 6
            Width = 88
            Height = 25
            Caption = #28155#21152#25551#36848
            Flat = True
            OnClick = btn1Click
          end
          object lbl2: TLabel
            Left = 1
            Top = 11
            Width = 30
            Height = 16
            Caption = #25551#36848
            Transparent = True
          end
          object lbl3: TLabel
            Left = 156
            Top = 11
            Width = 30
            Height = 16
            Caption = #21517#31216
            Transparent = True
          end
          object lbl4: TLabel
            Left = 297
            Top = 12
            Width = 30
            Height = 16
            Caption = #31867#22411
            Transparent = True
          end
          object cbb1: TComboBox
            Left = 344
            Top = 6
            Width = 78
            Height = 24
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 0
            Items.Strings = (
              #25968#23383
              #25991#23383
              #26085#26399)
          end
          object edt1: TEdit
            Left = 35
            Top = 6
            Width = 115
            Height = 24
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 1
          end
          object edt2: TEdit
            Left = 192
            Top = 6
            Width = 92
            Height = 24
            Hint = #25968#25454#24211#23383#27573#25551#36848','#24212#35813#29992#33521#25991#21629#21517' '
            ImeName = #26497#28857#20116#31508#36755#20837#27861
            TabOrder = 2
          end
        end
      end
    end
    object TabSheet2: TRzTabSheet
      Caption = #25968#25454
      object Label9: TLabel
        Left = 8
        Top = 18
        Width = 105
        Height = 16
        Caption = #25968#25454#36801#31227#30446#26631#34920
        Transparent = True
      end
      object ComboBox2: TComboBox
        Left = 119
        Top = 10
        Width = 145
        Height = 24
        ImeName = #26497#28857#20116#31508#36755#20837#27861
        TabOrder = 0
        OnChange = ComboBox2Change
      end
      object btn2: TButton
        Left = 170
        Top = 164
        Width = 75
        Height = 25
        Caption = 'btn2'
        TabOrder = 1
        OnClick = btn2Click
      end
    end
    object TabSheet3: TRzTabSheet
      Caption = #25191#34892#21629#20196
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 526
        Height = 121
        Align = alTop
        Caption = 'sql'#21629#20196
        TabOrder = 0
        object MMsql: TMemo
          Left = 2
          Top = 18
          Width = 522
          Height = 101
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -20
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object GroupBox4: TGroupBox
        Left = 0
        Top = 121
        Width = 526
        Height = 394
        Align = alClient
        Caption = #34920#35270#22270
        TabOrder = 1
        object DBGrid1: TDBGrid
          Left = 2
          Top = 18
          Width = 522
          Height = 374
          Align = alClient
          DataSource = dstemp
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -13
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 515
        Width = 526
        Height = 105
        Align = alBottom
        Caption = #25805#20316
        TabOrder = 2
        object Button1: TButton
          Left = 26
          Top = 32
          Width = 89
          Height = 41
          Caption = #25191#34892#34920#21629#20196
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 417
          Top = 32
          Width = 128
          Height = 41
          Caption = #25191#34892#25968#25454#24211#21629#20196
          TabOrder = 1
          OnClick = Button2Click
        end
        object Button5: TButton
          Left = 200
          Top = 40
          Width = 129
          Height = 25
          Caption = #26085#25253#20998#31867#22788#29702
          TabOrder = 2
          OnClick = Button5Click
        end
      end
    end
    object TabSheet4: TRzTabSheet
      Caption = #25209#22788#29702
      object GroupBox7: TGroupBox
        Left = 0
        Top = 0
        Width = 526
        Height = 274
        Align = alTop
        Caption = #36335#24452#36873#25321
        TabOrder = 0
        object cxShellTreeView1: TcxShellTreeView
          Left = 2
          Top = 18
          Width = 337
          Height = 254
          Align = alClient
          Indent = 19
          RightClickSelect = True
          TabOrder = 0
        end
        object GroupBox8: TGroupBox
          Left = 339
          Top = 18
          Width = 185
          Height = 254
          Align = alRight
          Caption = #22788#29702
          TabOrder = 1
          object Button7: TButton
            Left = 32
            Top = 86
            Width = 137
            Height = 41
            Caption = #25968#25454#22788#29702
            Enabled = False
            TabOrder = 0
            OnClick = Button7Click
          end
          object Button6: TButton
            Left = 32
            Top = 21
            Width = 137
            Height = 44
            Caption = #33719#21462#23545#24212#34920#26684#25991#20214
            TabOrder = 1
            OnClick = Button6Click
          end
          object Button8: TButton
            Left = 32
            Top = 154
            Width = 137
            Height = 41
            Caption = 'sheet'#27719#24635
            TabOrder = 2
            Visible = False
            OnClick = Button8Click
          end
        end
      end
      object ListBox1: TListBox
        Left = 0
        Top = 249
        Width = 526
        Height = 371
        Align = alBottom
        ImeName = #26497#28857#20116#31508#36755#20837#27861
        PopupMenu = pm1
        ScrollWidth = 2
        TabOrder = 1
      end
    end
  end
  object odFile: TOpenDialog
    Filter = 'Excel'#25991#20214#65288'*.XLS'#65289'|*.XLS'
    Left = 265
    Top = 484
  end
  object odDataBase: TOpenDialog
    Filter = 'Access'#25968#25454#24211#65288'*.MDB'#65289'|*.MDB'
    Left = 223
    Top = 496
  end
  object adoConn: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=E:\'#24352#26126#26126'\program\'#26085#25253'\D' +
      'ata\Eirc2010.mdb;Persist Security Info=False;'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 360
    Top = 488
  end
  object tblCol: TADOTable
    Connection = adoConn
    CursorLocation = clUseServer
    TableName = 'mapcol'
    Left = 148
    Top = 448
    object tblColXLSColName: TWideStringField
      FieldName = 'XLSColName'
      Size = 200
    end
    object tblColXLSColIdx: TIntegerField
      FieldName = 'XLSColIdx'
    end
    object tblColDBFieldDesc: TWideStringField
      FieldName = 'DBFieldDesc'
      Size = 50
    end
    object tblColDBFieldName: TWideStringField
      FieldName = 'DBFieldName'
      Size = 17
    end
    object tblColDataType: TWideStringField
      FieldName = 'DataType'
      Size = 50
    end
  end
  object tblField: TADOTable
    Connection = adoConn
    CursorType = ctStatic
    TableName = 'CompareFields'
    Left = 24
    Top = 448
  end
  object tblsheet: TADOTable
    Connection = adoConn
    CursorType = ctStatic
    TableName = 'MapSheets'
    Left = 60
    Top = 506
  end
  object qryCus: TADOQuery
    Connection = adoConn
    Parameters = <>
    Left = 437
    Top = 488
  end
  object tblSchema: TADOTable
    Connection = adoConn
    CursorType = ctStatic
    TableName = 'XLSSchema'
    Left = 32
    Top = 580
  end
  object dsCol: TDataSource
    DataSet = tblCol
    Left = 112
    Top = 448
  end
  object ADOCommand1: TADOCommand
    Connection = adoConn
    Parameters = <>
    Left = 401
    Top = 488
  end
  object dstemp: TDataSource
    DataSet = ADOtemp
    Left = 520
    Top = 484
  end
  object ADOtemp: TADOQuery
    Connection = adoConn
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from mapsheets where schemano=3')
    Left = 414
    Top = 428
  end
  object tblWell: TADOTable
    Connection = adoConn
    TableName = 'WellBaseInfo'
    Left = 80
    Top = 448
  end
  object tblLog: TADOTable
    Connection = adoConn
    TableName = 'Log'
    Left = 138
    Top = 530
  end
  object adosheet: TADOQuery
    Connection = adoConn
    CursorType = ctStatic
    Parameters = <>
    Left = 98
    Top = 584
  end
  object dssheet: TDataSource
    DataSet = adosheet
    Left = 164
    Top = 586
  end
  object tblCustData: TADOTable
    Connection = adoConn
    TableName = 'WellDayProd'
    Left = 202
    Top = 448
  end
  object pm1: TPopupMenu
    Left = 374
    Top = 314
    object Config1: TMenuItem
      Caption = #20174#25152#36873#34892#24320#22987#22788#29702'('#21253#25324#26412#34892')'
      OnClick = Config1Click
    end
    object N1: TMenuItem
      Caption = #22788#29702#21040#25152#36873#34892#65288#21253#25324#26412#34892#65289
      OnClick = N1Click
    end
  end
end
