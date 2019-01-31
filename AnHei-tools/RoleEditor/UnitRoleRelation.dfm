object frmRoleRelation: TfrmRoleRelation
  Left = 0
  Top = 0
  Caption = #20219#21153#20851#31995#26641
  ClientHeight = 380
  ClientWidth = 406
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    406
    380)
  PixelsPerInch = 96
  TextHeight = 12
  object TreeView1: TTreeView
    Left = 8
    Top = 8
    Width = 390
    Height = 321
    Anchors = [akLeft, akTop, akRight, akBottom]
    DragMode = dmAutomatic
    Indent = 19
    ReadOnly = True
    TabOrder = 0
    OnDragDrop = TreeView1DragDrop
    OnDragOver = TreeView1DragOver
    OnKeyDown = TreeView1KeyDown
  end
  object Button1: TButton
    Left = 323
    Top = 347
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #20851#38381'(&C)'
    ModalResult = 2
    TabOrder = 1
  end
end
