object FrmMainForm: TFrmMainForm
  Left = 192
  Top = 114
  Width = 696
  Height = 480
  Caption = #20027#31243#24207
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 105
    Top = 0
    Width = 583
    Height = 446
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #26700#38754
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 105
    Height = 446
    Align = alLeft
    TabOrder = 1
    object Button1: TButton
      Left = 16
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
