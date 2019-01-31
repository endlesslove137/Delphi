object Form1: TForm1
  Left = 837
  Top = 96
  Caption = 'Form1'
  ClientHeight = 333
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 264
    Top = 256
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object SpeedButton1: TSpeedButton
    Left = 21
    Top = 19
    Width = 209
    Height = 30
    Caption = 'Excel(1997-2003)'#25991#20214'>>>'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 33023
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Splitter1: TSplitter
    Left = 0
    Top = 0
    Height = 333
    ExplicitLeft = 190
    ExplicitTop = 306
    ExplicitHeight = 100
  end
  object PageControl1: TPageControl
    Left = 3
    Top = 0
    Width = 377
    Height = 333
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #21015
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 369
        Height = 112
        Align = alTop
        Caption = #25991#20214#21046#23450
        TabOrder = 0
        object SpeedButton2: TSpeedButton
          Left = 4
          Top = 11
          Width = 132
          Height = 41
          Caption = 'Excel(1997-2003)'#25991#20214'>>>'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 33023
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = SpeedButton2Click
        end
        object Label2: TLabel
          Left = 5
          Top = 61
          Width = 48
          Height = 13
          Caption = #25991#20214#21517#31216
          WordWrap = True
        end
        object Label7: TLabel
          Left = 6
          Top = 84
          Width = 48
          Height = 13
          Caption = #27491#22312#22788#29702
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object chkFront: TCheckBox
          Left = 157
          Top = 15
          Width = 75
          Height = 17
          Caption = #31383#20307#32622#21069
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = chkFrontClick
        end
        object RadioGroup2: TRadioGroup
          Left = 248
          Top = 10
          Width = 114
          Height = 95
          Align = alCustom
          Enabled = False
          Items.Strings = (
            '<'#39'@'#39'>'#20445#23384#20462#25913
            '<'#39' . '#39'>'#25918#24323#20445#23384
            '<'#39' H '#39'>'#20462#25913#21478#23384)
          TabOrder = 1
        end
        object CheckBox2: TCheckBox
          Left = 157
          Top = 35
          Width = 77
          Height = 17
          Caption = 'X'#31354#24037#20316#34920
          Enabled = False
          TabOrder = 2
        end
        object UpDown1: TUpDown
          Left = 136
          Top = 12
          Width = 16
          Height = 40
          Hint = '|'#22312#24037#20316#34920#20013#36339#36716
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = UpDown1Click
        end
        object btnEmpCol: TButton
          Left = 164
          Top = 74
          Width = 75
          Height = 25
          Caption = 'btnEmpCol'
          TabOrder = 4
          OnClick = btnEmpColClick
        end
        object DelEmptyCol: TButton
          Left = 83
          Top = 74
          Width = 75
          Height = 25
          Caption = 'DelEmptyCol'
          TabOrder = 5
          OnClick = DelEmptyColClick
        end
      end
      object RadioGroup1: TRadioGroup
        Left = 0
        Top = 112
        Width = 181
        Height = 152
        Align = alLeft
        Enabled = False
        Items.Strings = (
          #32479#35745#19981#37325#22797#30340#25968#25454
          #25764#28040#21512#24182','#29992#21512#24182#20869#23481#22635#20805' '
          #32473#21015#36171#20540)
        TabOrder = 1
      end
      object Edit1: TEdit
        Left = 79
        Top = 220
        Width = 83
        Height = 21
        ImeName = #26497#28857#20116#31508#36755#20837#27861
        TabOrder = 2
      end
      object ListBox1: TListBox
        Left = 189
        Top = 112
        Width = 180
        Height = 152
        Align = alRight
        ImeName = #26497#28857#20116#31508#36755#20837#27861
        ItemHeight = 13
        TabOrder = 3
      end
      object Panel1: TPanel
        Left = 0
        Top = 264
        Width = 369
        Height = 41
        Hint = #22312#24037#20316#34920#20013#36339#36716
        Align = alBottom
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        object BitBtn1: TBitBtn
          Left = 252
          Top = 8
          Width = 103
          Height = 25
          Caption = #25191#34892#25805#20316
          DoubleBuffered = True
          Enabled = False
          Kind = bkOK
          ParentDoubleBuffered = False
          Style = bsNew
          TabOrder = 0
          OnClick = BitBtn1Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #34892
      ImageIndex = 1
      object Button5: TButton
        Left = 3
        Top = 24
        Width = 75
        Height = 25
        Caption = #31354#34892
        TabOrder = 0
        OnClick = Button5Click
      end
      object Button6: TButton
        Left = 3
        Top = 55
        Width = 75
        Height = 25
        Caption = 'DelEmptyRow'
        TabOrder = 1
        OnClick = Button6Click
      end
      object Memo1: TMemo
        Left = 88
        Top = 10
        Width = 185
        Height = 117
        ImeName = #26497#28857#20116#31508#36755#20837#27861
        Lines.Strings = (
          '#'#26085'#'#27833'#'#28082'#'#27700'#'#31449'#'#20117#32452'#'#21512#35745'#')
        TabOrder = 2
      end
      object Button8: TButton
        Left = 3
        Top = 86
        Width = 75
        Height = 25
        Caption = 'DelSpecialRow'
        TabOrder = 3
        OnClick = Button8Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = #21306#22495
      ImageIndex = 2
      object GroupBox4: TGroupBox
        Left = 0
        Top = 0
        Width = 369
        Height = 76
        Align = alTop
        Caption = #22788#29702#34892#21015
        TabOrder = 0
        object Label3: TLabel
          Left = 58
          Top = 20
          Width = 12
          Height = 13
          Caption = #34892
          Color = clBtnFace
          ParentColor = False
        end
        object Label4: TLabel
          Left = 123
          Top = 18
          Width = 12
          Height = 13
          Caption = #21015
          Color = clBtnFace
          ParentColor = False
        end
        object Label5: TLabel
          Left = 58
          Top = 46
          Width = 12
          Height = 13
          Caption = #34892
          Color = clBtnFace
          ParentColor = False
        end
        object Label6: TLabel
          Left = 123
          Top = 46
          Width = 12
          Height = 13
          Caption = #21015
          Color = clBtnFace
          ParentColor = False
        end
        object lblSheet: TRzLabel
          Left = 199
          Top = 37
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
          WordWrap = True
        end
        object Label8: TLabel
          Left = 203
          Top = 18
          Width = 48
          Height = 13
          Caption = #34920#26684#21517#31216
          Transparent = True
        end
        object reHColEnd: TRzEdit
          Left = 72
          Top = 39
          Width = 51
          Height = 21
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 0
        end
        object reHColStart: TRzEdit
          Left = 72
          Top = 15
          Width = 51
          Height = 21
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 1
        end
        object reHRowEnd: TRzEdit
          Left = 3
          Top = 39
          Width = 51
          Height = 21
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 2
        end
        object reHRowStart: TRzEdit
          Left = 3
          Top = 15
          Width = 51
          Height = 21
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          TabOrder = 3
        end
        object RzButton3: TRzButton
          Left = 141
          Top = 15
          Width = 49
          Height = 22
          Caption = #36215#22987
          TabOrder = 4
          OnClick = RzButton3Click
        end
        object RzButton5: TRzButton
          Left = 141
          Top = 39
          Width = 49
          Height = 22
          Caption = #32467#26463
          TabOrder = 5
          OnClick = RzButton5Click
        end
        object RzButton17: TRzButton
          Left = 273
          Top = 17
          Width = 90
          Height = 22
          Caption = #19978#19968#34920#26684
          TabOrder = 6
          OnClick = RzButton17Click
        end
        object RzButton16: TRzButton
          Left = 273
          Top = 40
          Width = 90
          Height = 22
          Caption = #19979#19968#34920#26684
          TabOrder = 7
          OnClick = RzButton16Click
        end
      end
      object Button9: TButton
        Left = 8
        Top = 104
        Width = 75
        Height = 25
        Caption = #26159#19981#26159#31354#30340
        TabOrder = 1
        OnClick = Button9Click
      end
      object CheckBox1: TCheckBox
        Left = 100
        Top = 108
        Width = 97
        Height = 17
        Caption = #26174#31034#25152#26377#34892#21015
        TabOrder = 2
        OnClick = CheckBox1Click
      end
      object btn1: TButton
        Left = 199
        Top = 104
        Width = 104
        Height = 25
        Caption = #26174#31034#21306#22495#30340#20540
        TabOrder = 3
        OnClick = btn1Click
      end
    end
    object 测试: TTabSheet
      Caption = #25991#20214
      ImageIndex = 3
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 369
        Height = 219
        Align = alTop
        BevelInner = bvLowered
        BevelKind = bkSoft
        TabOrder = 0
        object ListBox2: TListBox
          Left = 236
          Top = 2
          Width = 127
          Height = 171
          Align = alClient
          ImeName = #26497#28857#20116#31508#36755#20837#27861
          ItemHeight = 13
          TabOrder = 0
        end
        object cxShellTreeView1: TcxShellTreeView
          Left = 2
          Top = 2
          Width = 226
          Height = 171
          Align = alLeft
          Indent = 19
          RightClickSelect = True
          TabOrder = 1
        end
        object cxSplitter1: TcxSplitter
          Left = 228
          Top = 2
          Width = 8
          Height = 171
          HotZoneClassName = 'TcxMediaPlayer9Style'
          Control = cxShellTreeView1
        end
        object Panel3: TPanel
          Left = 2
          Top = 181
          Width = 361
          Height = 32
          Align = alBottom
          BevelInner = bvLowered
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 3
          object Button3: TButton
            Left = 22
            Top = 4
            Width = 95
            Height = 25
            Caption = 'FindXls'
            TabOrder = 0
            OnClick = Button3Click
          end
          object Button2: TButton
            Left = 263
            Top = 2
            Width = 75
            Height = 25
            Caption = 'GetSheets'
            TabOrder = 1
            OnClick = Button2Click
          end
        end
        object cxSplitter2: TcxSplitter
          Left = 2
          Top = 173
          Width = 361
          Height = 8
          HotZoneClassName = 'TcxMediaPlayer9Style'
          AlignSplitter = salBottom
          Control = Panel3
        end
      end
      object Button7: TButton
        Left = 36
        Top = 236
        Width = 75
        Height = 25
        Caption = 'ShowAll'
        TabOrder = 1
        OnClick = Button7Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'test'
      ImageIndex = 4
      object Button4: TButton
        Left = 182
        Top = 134
        Width = 75
        Height = 25
        Caption = 'Button4'
        TabOrder = 0
        OnClick = Button4Click
      end
    end
  end
  object Button1: TButton
    Left = 168
    Top = 300
    Width = 75
    Height = 25
    Caption = #20851#38381#25991#20214
    TabOrder = 1
    OnClick = Button1Click
  end
end
