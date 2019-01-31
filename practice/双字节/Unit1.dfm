object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 497
  ClientWidth = 815
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 17
  object pgc1: TPageControl
    Left = 0
    Top = 0
    Width = 815
    Height = 497
    ActivePage = ts1
    Align = alClient
    TabOrder = 0
    object ts1: TTabSheet
      Caption = 'System'
      object lbledt4: TLabeledEdit
        Left = 80
        Top = 16
        Width = 169
        Height = 25
        EditLabel.Width = 42
        EditLabel.Height = 17
        EditLabel.Caption = #26381#21153#21517
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        LabelPosition = lpLeft
        TabOrder = 0
        Text = 'FtpServiceNet'
      end
      object btn7: TButton
        Left = 264
        Top = 16
        Width = 49
        Height = 25
        Caption = #20572#27490
        TabOrder = 1
        OnClick = btn7Click
      end
      object btn8: TButton
        Left = 216
        Top = 80
        Width = 75
        Height = 25
        Caption = 'btn8'
        TabOrder = 2
        OnClick = btn8Click
      end
      object btn9: TButton
        Left = 232
        Top = 144
        Width = 75
        Height = 25
        Caption = 'btn9'
        TabOrder = 3
        OnClick = btn9Click
      end
      object btn10: TButton
        Left = 240
        Top = 184
        Width = 75
        Height = 25
        Caption = 'btn10'
        TabOrder = 4
        OnClick = btn10Click
      end
    end
    object ts2: TTabSheet
      Caption = 'other'
      ImageIndex = 1
      object lbledt1: TLabeledEdit
        Left = 105
        Top = 39
        Width = 158
        Height = 25
        EditLabel.Width = 56
        EditLabel.Height = 17
        EditLabel.Caption = #21452#23383#33410#30721
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        LabelPosition = lpLeft
        TabOrder = 0
      end
      object lbledt2: TLabeledEdit
        Left = 105
        Top = 68
        Width = 158
        Height = 25
        EditLabel.Width = 63
        EditLabel.Height = 17
        EditLabel.Caption = 'Unicode'#30721
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        LabelPosition = lpLeft
        TabOrder = 1
      end
      object lbledt3: TLabeledEdit
        Left = 105
        Top = 10
        Width = 158
        Height = 25
        EditLabel.Width = 56
        EditLabel.Height = 17
        EditLabel.Caption = #30446#26631#23383#31526
        ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
        LabelPosition = lpLeft
        TabOrder = 2
      end
      object tv1: TTreeView
        Left = 31
        Top = 94
        Width = 232
        Height = 371
        Indent = 19
        TabOrder = 3
      end
      object btn5: TButton
        Left = 271
        Top = 115
        Width = 98
        Height = 33
        Caption = #28155#21152#33410#28857
        TabOrder = 4
        OnClick = btn5Click
      end
      object btn2: TButton
        Left = 271
        Top = 68
        Width = 98
        Height = 33
        Caption = 'PPchar'#30340#20351#29992
        TabOrder = 5
        OnClick = btn2Click
      end
      object btn1: TButton
        Left = 271
        Top = 27
        Width = 98
        Height = 33
        Caption = #33719#21462#32534#30721
        TabOrder = 6
        OnClick = btn1Click
      end
      object btn6: TButton
        Left = 439
        Top = 115
        Width = 138
        Height = 33
        Caption = #21024#38500#21160#24577#25968#32452#20013#30340#20803#32032
        TabOrder = 7
        OnClick = btn6Click
      end
      object btn4: TButton
        Left = 439
        Top = 68
        Width = 138
        Height = 33
        Caption = #36171#20540#21040#25351#38024
        TabOrder = 8
        OnClick = btn4Click
      end
      object btn3: TButton
        Left = 439
        Top = 27
        Width = 138
        Height = 33
        Caption = #33719#21462#24403#21069#31383#21475
        TabOrder = 9
        OnClick = btn3Click
      end
    end
  end
end
