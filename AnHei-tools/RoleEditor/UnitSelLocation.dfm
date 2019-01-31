object frmSelLocation: TfrmSelLocation
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #36873#25321#30830#20999#30340#38656#27714#20301#32622
  ClientHeight = 271
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 16
    Top = 14
    Width = 432
    Height = 12
    Caption = #30001#20110#23384#22312#22810#20010#22320#28857#65292#20219#21153#32534#36753#22120#26080#27861#20915#23450#20351#29992#21738#20010#22320#28857#65292#20320#24517#39035#20146#33258#30830#35748#24182#36873#25321#65306
  end
  object ListView1: TListView
    Left = 16
    Top = 40
    Width = 425
    Height = 185
    Columns = <
      item
        Caption = #22320#22270#21517#31216
        Width = 120
      end
      item
        Caption = #24618#29289#21517#31216
        Width = 120
      end
      item
        Caption = #21047#24618#20301#32622
        Width = 100
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListView1DblClick
    OnKeyDown = FormKeyDown
    OnSelectItem = ListView1SelectItem
  end
  object Button1: TButton
    Left = 366
    Top = 231
    Width = 75
    Height = 25
    Caption = #30830#23450'(&O)'
    Enabled = False
    ModalResult = 1
    TabOrder = 1
    OnKeyDown = FormKeyDown
  end
end
