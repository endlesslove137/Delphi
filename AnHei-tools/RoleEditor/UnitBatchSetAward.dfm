object frmBatchSetAward: TfrmBatchSetAward
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #25209#37327#35843#25972#22870#21169
  ClientHeight = 238
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object Bevel1: TBevel
    Left = 10
    Top = 10
    Width = 360
    Height = 169
  end
  object Label1: TLabel
    Left = 52
    Top = 42
    Width = 42
    Height = 17
    Caption = #31867#22411#65306
  end
  object Label2: TLabel
    Left = 52
    Top = 106
    Width = 42
    Height = 17
    Caption = #20493#29575#65306
  end
  object ComboBox1: TComboBox
    Left = 115
    Top = 38
    Width = 190
    Height = 21
    Style = csDropDownList
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    ItemHeight = 0
    TabOrder = 0
  end
  object edtDouble: TEdit
    Left = 115
    Top = 105
    Width = 190
    Height = 21
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 1
  end
  object Button1: TButton
    Left = 143
    Top = 192
    Width = 98
    Height = 33
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 268
    Top = 192
    Width = 98
    Height = 33
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 3
  end
end
