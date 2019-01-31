object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #35821#35328#21253#32534#36753#22120' V1.0.0.4 - '#20013#25991#29256
  ClientHeight = 756
  ClientWidth = 779
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 17
  object grp1: TGroupBox
    Left = 0
    Top = 44
    Width = 779
    Height = 559
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Caption = #35821#35328#21253#32534#36753#22120
    TabOrder = 0
    object ListViewSetDesc: TRzListView
      Left = 2
      Top = 19
      Width = 775
      Height = 538
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Columns = <
        item
          Caption = #32534#21495
          Width = 131
        end
        item
          Caption = #26631#39064#21517#31216
          Width = 619
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      GridLines = True
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewSetDescClick
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 779
    Height = 44
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Caption = #25171#24320#35821#35328#21253#25991#20214
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = pnl1Click
  end
  object TPanel
    Left = 0
    Top = 603
    Width = 779
    Height = 153
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 2
    object lbl2: TLabel
      Left = 13
      Top = 61
      Width = 33
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #21517#31216':'
    end
    object lbl1: TLabel
      Left = 16
      Top = 20
      Width = 33
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #32534#21495':'
    end
    object lbl3: TLabel
      Left = 341
      Top = 22
      Width = 33
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #24635#25968':'
    end
    object lbl4: TLabel
      Left = 384
      Top = 22
      Width = 4
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object ButtonFilterDel: TRzButton
      Left = 649
      Top = 95
      Width = 104
      Height = 48
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      FrameColor = 7617536
      Caption = #21024#38500
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      HotTrack = True
      ParentFont = False
      TabOrder = 0
      Visible = False
      OnClick = ButtonFilterDelClick
    end
    object ButtonFilterAdd: TRzButton
      Left = 404
      Top = 98
      Width = 114
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      FrameColor = 7617536
      Caption = #22686#21152
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      HotTrack = True
      ParentFont = False
      TabOrder = 1
      OnClick = ButtonFilterAddClick
    end
    object ButtonFilterChg: TRzButton
      Left = 531
      Top = 95
      Width = 107
      Height = 48
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      FrameColor = 7617536
      Caption = #20462#25913
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      HotTrack = True
      ParentFont = False
      TabOrder = 2
      OnClick = ButtonFilterChgClick
    end
    object Edit2: TEdit
      Left = 65
      Top = 56
      Width = 695
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      TabOrder = 3
    end
    object Edit1: TEdit
      Left = 65
      Top = 18
      Width = 259
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = clInactiveBorder
      DragCursor = crHandPoint
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      ReadOnly = True
      TabOrder = 4
    end
  end
  object OpenDialog: TOpenDialog
    Filter = #25991#20214'|*.xml'
    Left = 10
    Top = 71
  end
end
