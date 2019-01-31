object FrmSettings: TFrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #36873#39033
  ClientHeight = 195
  ClientWidth = 637
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    637
    195)
  PixelsPerInch = 120
  TextHeight = 17
  object Label2: TLabel
    Left = 10
    Top = 146
    Width = 47
    Height = 17
    Caption = #29992#25143#21517':'
  end
  object grpSetting: TGroupBox
    Left = 10
    Top = 10
    Width = 605
    Height = 117
    Caption = #37197#32622
    TabOrder = 0
    object lblCbpPath: TLabel
      Left = 24
      Top = 37
      Width = 123
      Height = 17
      Caption = 'Cbp'#25991#20214#20445#23384#36335#24452#65306
    end
    object btnSelectcbp: TButton
      Left = 541
      Top = 33
      Width = 34
      Height = 28
      Caption = '...'
      TabOrder = 0
      OnClick = btnSelectcbpClick
    end
    object edtCbpPath: TEdit
      Left = 166
      Top = 33
      Width = 368
      Height = 25
      ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
      TabOrder = 1
    end
    object chkkeepCheck: TCheckBox
      Left = 24
      Top = 76
      Width = 126
      Height = 22
      Caption = #35760#20303#36873#25321#35821#35328
      TabOrder = 2
    end
  end
  object btnOk: TButton
    Left = 415
    Top = 140
    Width = 98
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 520
    Top = 140
    Width = 99
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 65
    Top = 143
    Width = 193
    Height = 25
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 3
  end
end
