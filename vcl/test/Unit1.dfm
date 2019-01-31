object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 324
  ClientWidth = 470
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
  object pgc1: TPageControl
    Left = 0
    Top = 0
    Width = 470
    Height = 324
    ActivePage = ts1
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 136
    ExplicitTop = 64
    ExplicitWidth = 289
    ExplicitHeight = 193
    object ts1: TTabSheet
      Caption = #26032#25511#20214
      ExplicitWidth = 281
      ExplicitHeight = 162
      object btndt1: TButtonedEdit
        Left = 48
        Top = 16
        Width = 121
        Height = 24
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        TabOrder = 0
        Text = 'btndt1'
      end
      object lnklbl1: TLinkLabel
        Left = 232
        Top = 16
        Width = 40
        Height = 20
        Caption = 'lnklbl1'
        TabOrder = 1
      end
      object ctgrypnlgrp1: TCategoryPanelGroup
        Left = 262
        Top = 0
        Height = 293
        VertScrollBar.Tracking = True
        Align = alRight
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -13
        HeaderFont.Name = 'Tahoma'
        HeaderFont.Style = []
        TabOrder = 2
        object ctgrypnl2: TCategoryPanel
          Top = 200
          Caption = 'ctgrypnl2'
          TabOrder = 0
        end
        object ctgrypnl1: TCategoryPanel
          Top = 0
          Caption = 'ctgrypnl1'
          TabOrder = 1
        end
      end
      object edt1: TEdit
        Left = 48
        Top = 120
        Width = 121
        Height = 24
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        TabOrder = 3
        Text = 'edt1'
        TextHint = #22833#21435#28966#28857#26174#31034
      end
      object Button1: TButton
        Left = 48
        Top = 46
        Width = 145
        Height = 25
        Caption = 'Application.Icon'
        TabOrder = 4
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 48
        Top = 77
        Width = 145
        Height = 25
        Caption = 'RunError(204);'
        TabOrder = 5
        OnClick = Button2Click
      end
    end
    object ts2: TTabSheet
      Caption = 'ts2'
      ImageIndex = 1
      ExplicitWidth = 281
      ExplicitHeight = 162
    end
    object ts3: TTabSheet
      Caption = 'ts3'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitWidth = 281
      ExplicitHeight = 162
    end
  end
  object gstrmngr1: TGestureManager
    Left = 28
    Top = 195
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 212
    Top = 171
  end
end
