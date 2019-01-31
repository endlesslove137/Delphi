object fcheckproduct: Tfcheckproduct
  Left = 273
  Top = 117
  Width = 696
  Height = 480
  Caption = #26680#23545
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clBlue
  Font.Height = -16
  Font.Name = #26999#20307'_GB2312'
  Font.Style = [fsBold]
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 688
    Height = 446
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #20837#24211#26680#23545
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 83
        Height = 17
        AutoSize = False
        Caption = #25176#36816#21333#21495
      end
      object SpeedButton1: TSpeedButton
        Left = 184
        Top = 46
        Width = 83
        Height = 25
        Caption = #26597#30475#26126#32454
      end
      object ComboBox1: TComboBox
        Left = 36
        Top = 46
        Width = 145
        Height = 24
        ItemHeight = 16
        TabOrder = 0
        OnChange = ComboBox1Change
      end
      object CheckBox1: TCheckBox
        Left = 44
        Top = 88
        Width = 117
        Height = 33
        Caption = #26159#21542#19968#33268
        Enabled = False
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
    end
  end
end
