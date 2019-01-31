object TreeViewForm: TTreeViewForm
  Left = 379
  Top = 101
  Width = 326
  Height = 309
  BorderIcons = []
  Caption = 'Open directory'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblSelect: TLabel
    Left = 8
    Top = 0
    Width = 136
    Height = 13
    Caption = 'Select directory to compress:'
    ParentShowHint = False
    ShowHint = True
  end
  object stvOpen: TShellTreeView
    Left = 8
    Top = 22
    Width = 297
    Height = 209
    ObjectTypes = [otFolders]
    Root = 'rfMyComputer'
    UseShellImages = True
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    ParentShowHint = False
    RightClickSelect = True
    ShowHint = True
    ShowRoot = False
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 142
    Top = 240
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 224
    Top = 240
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
end
