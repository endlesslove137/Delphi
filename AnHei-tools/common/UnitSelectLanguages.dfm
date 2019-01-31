object frmSelectLanguages: TfrmSelectLanguages
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #36873#25321#35821#35328
  ClientHeight = 122
  ClientWidth = 403
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    403
    122)
  PixelsPerInch = 120
  TextHeight = 17
  object Label1: TLabel
    Left = 17
    Top = 21
    Width = 42
    Height = 17
    Caption = #35821#35328#65306
  end
  object cbLanguages: TComboBox
    Left = 76
    Top = 16
    Width = 284
    Height = 25
    Style = csDropDownList
    ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 0
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 175
    Top = 78
    Width = 98
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 1
  end
  object btnCannel: TButton
    Left = 294
    Top = 78
    Width = 98
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 2
  end
  object chkkeepCheck: TCheckBox
    Left = 17
    Top = 85
    Width = 127
    Height = 22
    Caption = #35760#20303#36873#25321
    TabOrder = 3
  end
end
