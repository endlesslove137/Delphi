object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 388
  ClientWidth = 833
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object pgc1: TPageControl
    Left = 0
    Top = 25
    Width = 833
    Height = 281
    ActivePage = ts1
    Align = alClient
    TabOrder = 0
    object ts1: TTabSheet
      Caption = 'ts1'
      object dbgrd1: TDBGrid
        Left = 0
        Top = 0
        Width = 825
        Height = 250
        Align = alClient
        DataSource = dsStudents
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object ts2: TTabSheet
      Caption = 'ts2'
      ImageIndex = 1
    end
    object ts3: TTabSheet
      Caption = 'ts3'
      ImageIndex = 2
    end
  end
  object stat1: TStatusBar
    Left = 0
    Top = 369
    Width = 833
    Height = 19
    Panels = <
      item
        Width = 177
      end>
  end
  object dbnvgr1: TDBNavigator
    Left = 0
    Top = 0
    Width = 833
    Height = 25
    DataSource = dsStudents
    Align = alTop
    TabOrder = 2
  end
  object pnl1: TPanel
    Left = 0
    Top = 306
    Width = 833
    Height = 63
    Align = alBottom
    TabOrder = 3
    object Button1: TButton
      Left = 22
      Top = 14
      Width = 103
      Height = 37
      Caption = 'update'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 143
      Top = 16
      Width = 75
      Height = 35
      Caption = 'Button2'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object dsStudents: TDataSource
    DataSet = ClientModule1.CdsStudents
    Left = 252
    Top = 92
  end
end
