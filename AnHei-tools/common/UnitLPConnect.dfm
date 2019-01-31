object frmLPConnect: TfrmLPConnect
  Left = 474
  Top = 288
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #36830#25509#35821#35328#26381#21153#22120
  ClientHeight = 203
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 79
    Top = 49
    Width = 324
    Height = 35
    Alignment = taCenter
    Caption = #27491#22312#36830#25509#35821#35328#26381#21153#22120
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 79
    Top = 108
    Width = 336
    Height = 31
    BevelOuter = bvLowered
    TabOrder = 0
    object Panel2: TPanel
      Left = 20
      Top = 1
      Width = 50
      Height = 27
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
