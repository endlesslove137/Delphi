object frmLPConnect: TfrmLPConnect
  Left = 474
  Top = 288
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #36830#25509#35821#35328#26381#21153#22120
  ClientHeight = 165
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 40
    Width = 270
    Height = 29
    Alignment = taCenter
    Caption = #27491#22312#36830#25509#35821#35328#26381#21153#22120
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 64
    Top = 88
    Width = 273
    Height = 25
    BevelOuter = bvLowered
    TabOrder = 0
    object Panel2: TPanel
      Left = 16
      Top = 1
      Width = 41
      Height = 22
      BevelOuter = bvNone
      Color = clHighlight
      TabOrder = 0
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 168
    Top = 64
  end
end
