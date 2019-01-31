object Form1: TForm1
  Left = 275
  Top = 218
  VertScrollBar.Color = clOlive
  VertScrollBar.ParentColor = False
  BiDiMode = bdRightToLeftReadingOnly
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Form1'
  ClientHeight = 198
  ClientWidth = 210
  Color = 10080902
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 34
    Top = 20
    Width = 135
    Height = 71
    AutoSize = False
    Caption = #35828#26126#65306'Jxc_data.mdf'#8221#12289#13#13'      Jxc_data'#8221#24517#13#13'  '#38656#22312#23433#35013#31243#24207#30446#24405#19979#12290
    Color = 10930672
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentColor = False
    ParentFont = False
    WordWrap = True
  end
  object BitBtn1: TBitBtn
    Left = 26
    Top = 116
    Width = 155
    Height = 35
    Caption = '&'#24320#22987#38468#21152#25968#25454#24211
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkYes
  end
  object ADOCommand1: TADOCommand
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Data Source=.'
    Prepared = True
    Parameters = <>
    Left = 42
    Top = 46
  end
end
