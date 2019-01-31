object Form2: TForm2
  Left = 201
  Top = 117
  Width = 450
  Height = 450
  Caption = #22797#21046#25991#20214
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 399
    Width = 442
    Height = 17
    Align = alBottom
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 442
    Height = 399
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox2: TGroupBox
      Left = 0
      Top = 41
      Width = 442
      Height = 212
      Align = alClient
      Caption = #28304#36335#24452#25991#20214#21015#34920
      TabOrder = 0
      object Memo2: TMemo
        Left = 2
        Top = 15
        Width = 438
        Height = 195
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 358
      Width = 442
      Height = 41
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        442
        41)
      object Label1: TLabel
        Left = 16
        Top = 12
        Width = 60
        Height = 13
        Caption = #30446#26631#36335#24452#65306
      end
      object Edit1: TEdit
        Left = 82
        Top = 8
        Width = 349
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 442
      Height = 41
      Align = alTop
      TabOrder = 2
      DesignSize = (
        442
        41)
      object Label2: TLabel
        Left = 16
        Top = 12
        Width = 48
        Height = 13
        Caption = #28304#36335#24452#65306
      end
      object Edit2: TEdit
        Left = 77
        Top = 8
        Width = 266
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object Button1: TButton
        Left = 358
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #22797#21046#25991#20214
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 253
      Width = 442
      Height = 105
      Align = alBottom
      Caption = #25805#20316#26085#24535
      TabOrder = 3
      object Memo1: TMemo
        Left = 2
        Top = 15
        Width = 438
        Height = 88
        Align = alClient
        Lines.Strings = (
          '')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
end
