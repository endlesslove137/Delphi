object Form1: TForm1
  Left = 337
  Top = 249
  Caption = #27979#35797'SQLite 3'
  ClientHeight = 484
  ClientWidth = 530
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 24
    Top = 96
    Width = 30
    Height = 12
    Caption = 'Notes'
  end
  object Label2: TLabel
    Left = 24
    Top = 44
    Width = 24
    Height = 12
    Caption = 'Name'
  end
  object Label3: TLabel
    Left = 24
    Top = 72
    Width = 42
    Height = 12
    Caption = 'Number:'
  end
  object Label4: TLabel
    Left = 24
    Top = 12
    Width = 12
    Height = 12
    Caption = 'ID'
  end
  object Image1: TImage
    Left = 272
    Top = 12
    Width = 241
    Height = 169
    Proportional = True
    Stretch = True
  end
  object Label5: TLabel
    Left = 16
    Top = 272
    Width = 72
    Height = 12
    Caption = #22810#32447#31243#27979#35797#65306
  end
  object Label6: TLabel
    Left = 112
    Top = 272
    Width = 36
    Height = 12
    Caption = #32447#31243#25968
  end
  object Label7: TLabel
    Left = 247
    Top = 274
    Width = 60
    Height = 12
    Caption = #27599#32447#31243#27425#25968
  end
  object btnTest: TButton
    Left = 24
    Top = 191
    Width = 97
    Height = 30
    Caption = #27979#35797'SQLite 3'
    TabOrder = 0
    OnClick = btnTestClick
  end
  object memNotes: TMemo
    Left = 66
    Top = 96
    Width = 190
    Height = 85
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ebName: TEdit
    Left = 66
    Top = 40
    Width = 190
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    TabOrder = 2
  end
  object ebNumber: TEdit
    Left = 66
    Top = 68
    Width = 190
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    TabOrder = 3
  end
  object ebID: TEdit
    Left = 66
    Top = 12
    Width = 190
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    TabOrder = 4
  end
  object btnLoadImage: TButton
    Left = 166
    Top = 193
    Width = 97
    Height = 30
    Caption = #20889#20837#22270#29255
    TabOrder = 5
    OnClick = btnLoadImageClick
  end
  object btnDisplayImage: TButton
    Left = 270
    Top = 193
    Width = 97
    Height = 30
    Caption = #35835#20986#22270#29255
    TabOrder = 6
    OnClick = btnDisplayImageClick
  end
  object btnBackup: TButton
    Left = 416
    Top = 193
    Width = 97
    Height = 30
    Caption = #22791#20221#25968#25454#24211
    TabOrder = 7
    OnClick = btnBackupClick
  end
  object pnStatus: TPanel
    Left = 0
    Top = 234
    Width = 530
    Height = 20
    BevelOuter = bvLowered
    TabOrder = 8
  end
  object Edit1: TEdit
    Left = 155
    Top = 270
    Width = 81
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    TabOrder = 9
    Text = '10'
  end
  object Button1: TButton
    Left = 416
    Top = 267
    Width = 97
    Height = 28
    Caption = #24320#22987#27979#35797
    TabOrder = 10
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 313
    Top = 270
    Width = 94
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    TabOrder = 11
    Text = '1000'
  end
  object Memo1: TMemo
    Left = 16
    Top = 304
    Width = 497
    Height = 166
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 12
  end
end
