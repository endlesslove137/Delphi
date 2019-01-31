object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 364
  ClientWidth = 638
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object pgcClient: TPageControl
    Left = 0
    Top = 0
    Width = 638
    Height = 364
    ActivePage = TSTest
    Align = alClient
    TabOrder = 0
    object ts1: TTabSheet
      Caption = 'Base'
      object btnGuid: TButton
        Left = 307
        Top = 3
        Width = 102
        Height = 25
        Caption = 'Guid'
        TabOrder = 0
        OnClick = btnGuidClick
      end
      object edtGuid: TEdit
        Left = 16
        Top = 3
        Width = 285
        Height = 24
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        TabOrder = 1
        Text = 'edtGuid'
      end
    end
    object TSTest: TTabSheet
      Caption = 'TSTest'
      ImageIndex = 1
      object BtnTest: TButton
        Left = 24
        Top = 16
        Width = 75
        Height = 25
        Caption = 'BtnTest'
        TabOrder = 0
        OnClick = BtnTestClick
      end
    end
  end
end
