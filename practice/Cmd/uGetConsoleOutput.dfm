object frmGetConsoleOutput: TfrmGetConsoleOutput
  Left = 192
  Top = 103
  Width = 696
  Height = 480
  Caption = 'frmGetConsoleOutput'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 20
    Width = 333
    Height = 353
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btnOpenFile: TButton
    Left = 364
    Top = 28
    Width = 75
    Height = 25
    Caption = '&OpenFile'
    TabOrder = 1
    OnClick = btnOpenFileClick
  end
  object btnRun: TButton
    Left = 364
    Top = 60
    Width = 75
    Height = 25
    Caption = '&Run'
    TabOrder = 2
    OnClick = btnRunClick
  end
  object editfilename: TEdit
    Left = 444
    Top = 32
    Width = 217
    Height = 21
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.*|*.*'
    Left = 364
    Top = 128
  end
end
