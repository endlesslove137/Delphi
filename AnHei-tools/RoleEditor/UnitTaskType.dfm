object frmTaskType: TfrmTaskType
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #20219#21153#20998#31867
  ClientHeight = 224
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 17
    Top = 14
    Width = 130
    Height = 21
    TabOrder = 0
  end
  object ListBox1: TListBox
    Left = 16
    Top = 41
    Width = 219
    Height = 134
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBox1Click
  end
  object Button1: TButton
    Left = 86
    Top = 186
    Width = 75
    Height = 25
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 2
  end
  object btnAdd: TButton
    Left = 153
    Top = 14
    Width = 40
    Height = 21
    Caption = #28155#21152
    TabOrder = 3
    OnClick = btnAddClick
  end
  object btnEdit: TButton
    Left = 195
    Top = 14
    Width = 40
    Height = 21
    Caption = #20462#25913
    TabOrder = 4
    OnClick = btnEditClick
  end
end
