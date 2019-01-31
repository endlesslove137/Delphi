object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 388
  ClientWidth = 693
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object StringGrid1: TStringGrid
    Left = 72
    Top = 24
    Width = 369
    Height = 153
    TabOrder = 0
    OnClick = StringGrid1Click
    OnDrawCell = StringGrid1DrawCell
    OnSelectCell = StringGrid1SelectCell
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object btn1: TBitBtn
    Left = 168
    Top = 232
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 1
    OnClick = btn1Click
  end
end
