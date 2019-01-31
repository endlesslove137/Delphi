object frmMain: TfrmMain
  Left = 198
  Top = 101
  BorderStyle = bsDialog
  Caption = 'Delphi'#25805#20316'WPS'#34920#26684#31034#20363
  ClientHeight = 538
  ClientWidth = 692
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 28
    Top = 59
    Width = 210
    Height = 12
    Caption = #20197#19979#25805#20316#24517#39035#21551#21160'wps'#34920#26684#21518#25165#33021#36827#34892#65281
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 160
    Top = 131
    Width = 102
    Height = 12
    Caption = 'a1=3    b4='#39#20320#22909#39
  end
  object Label3: TLabel
    Left = 440
    Top = 131
    Width = 252
    Height = 12
    Caption = #21464#37327'a '#30340#20540#20026#8220#20320#22909#8221#65292#23558#20854#20256#21040'b5'#21333#20803#26684#20013#12290
  end
  object Label4: TLabel
    Left = 201
    Top = 202
    Width = 192
    Height = 12
    Caption = #23558#24403#21069#21333#20803#26684#30340'dwcm'#20256#21040' a1 '#26684#20013#12290
  end
  object Label5: TLabel
    Left = 17
    Top = 469
    Width = 660
    Height = 24
    Caption = 
      #39134#19968#26679#30340#23548#20986#36895#24230#65306#22312#23558#34920#26684#20013#30340#25968#25454#23548#20986#21040'wps'#34920#26684#26102#65292#25171#24320'wps'#34920#26684#65292#28982#21518#23558#20854#26368#23567#21270#12290#26368#23567#21270#21040#20219#21153#26639#19978#21518#65292#21491#20987'wps'#34920#26684#65292#28982#21518#21035 +
      #21160#12290#27492#26102#20320#20250#30475#21040#39134#19968#26679#30340#23548#20986#36895#24230#65292#21363#20351#20960#21315#34892#25968#25454#20063#33021#24456#24555#23548#20986#23436#27605#12290#27492#25216#24039#30001#8220#27827#21271#20336#29305#20844#21496#8221#21592#24037#21457#29616#12290
    Transparent = False
    WordWrap = True
  end
  object Label6: TLabel
    Left = 24
    Top = 500
    Width = 276
    Height = 12
    Caption = #22810#24180#26469#65292#19968#30452#20351#29992#37329#23665#20844#21496#30340#36719#20214#65292#24863#35874#37329#23665#20844#21496#65281
  end
  object Label7: TLabel
    Left = 24
    Top = 516
    Width = 210
    Height = 12
    Caption = 'QQ'#65306'121079461    Email:whxlc@qq.com'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 265
    Width = 645
    Height = 92
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object Button7: TButton
    Left = 24
    Top = 127
    Width = 166
    Height = 29
    Caption = #24448#21333#20803#26684#36171#20540
    TabOrder = 1
    OnClick = Button7Click
  end
  object Button6: TButton
    Left = 491
    Top = 86
    Width = 161
    Height = 29
    Caption = #25351#23450'sheet2'#20026#24403#21069#24037#20316#34920
    TabOrder = 2
    OnClick = Button6Click
  end
  object Button5: TButton
    Left = 311
    Top = 86
    Width = 161
    Height = 29
    Caption = #25351#23450#26576#24037#20316#34920#20026#24403#21069#24037#20316#34920'1'
    TabOrder = 3
    OnClick = Button5Click
  end
  object Button4: TButton
    Left = 176
    Top = 86
    Width = 111
    Height = 29
    Caption = #25171#24320#25351#23450#24037#20316#31807
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button3: TButton
    Left = 24
    Top = 86
    Width = 111
    Height = 29
    Caption = #26032#24314#24037#20316#31807
    TabOrder = 5
    OnClick = Button3Click
  end
  object btnStart: TButton
    Left = 24
    Top = 16
    Width = 91
    Height = 29
    Caption = #21551#21160'WPS'#34920#26684
    TabOrder = 6
    OnClick = btnStartClick
  end
  object btnClose: TButton
    Left = 138
    Top = 16
    Width = 91
    Height = 29
    Caption = #20851#38381'WPS'#34920#26684
    TabOrder = 7
    OnClick = btnCloseClick
  end
  object Button2: TButton
    Left = 360
    Top = 16
    Width = 91
    Height = 29
    Caption = #38544#34255
    TabOrder = 8
    OnClick = Button2Click
  end
  object Button1: TButton
    Left = 252
    Top = 16
    Width = 91
    Height = 29
    Caption = #26174#31034
    TabOrder = 9
    OnClick = Button1Click
  end
  object Button8: TButton
    Left = 296
    Top = 126
    Width = 166
    Height = 29
    Caption = #24448#21333#20803#26684#20013#36171#20540
    TabOrder = 10
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 24
    Top = 196
    Width = 166
    Height = 29
    Caption = #23558#34920#20013#25968#25454#20256#21040#21333#20803#26684#20013
    TabOrder = 11
    OnClick = Button9Click
  end
  object DBGrid2: TDBGrid
    Left = 24
    Top = 362
    Width = 644
    Height = 102
    DataSource = DataSource2
    TabOrder = 12
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object DBEditdjh: TDBEdit
    Left = 536
    Top = 296
    Width = 65
    Height = 20
    DataField = 'djh'
    DataSource = DataSource1
    TabOrder = 13
    Visible = False
    OnChange = DBEditdjhChange
  end
  object Button10: TButton
    Left = 24
    Top = 232
    Width = 166
    Height = 29
    Caption = #23558#34920#26684#20013#25968#25454#23548#20986#21040'wps'#34920#26684
    TabOrder = 14
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 207
    Top = 232
    Width = 166
    Height = 29
    Caption = #29992#20989#25968#23558#25968#25454#23548#20986#21040'wps'#34920#26684
    TabOrder = 15
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 24
    Top = 161
    Width = 112
    Height = 29
    Caption = #36873#25321#34892
    TabOrder = 16
    OnClick = Button12Click
  end
  object Button13: TButton
    Left = 150
    Top = 161
    Width = 112
    Height = 29
    Caption = #21024#38500#34892
    TabOrder = 17
    OnClick = Button13Click
  end
  object Button14: TButton
    Left = 281
    Top = 161
    Width = 112
    Height = 29
    Caption = #25554#20837#34892
    TabOrder = 18
    OnClick = Button14Click
  end
  object btntd: TButton
    Left = 383
    Top = 232
    Width = 166
    Height = 29
    Caption = #23558#34920#26684#20013#30340#25968#25454#22871#25171
    TabOrder = 19
    OnClick = btntdClick
  end
  object Button17: TButton
    Left = 565
    Top = 231
    Width = 104
    Height = 29
    Caption = #30452#25509#25171#21360
    TabOrder = 20
    OnClick = Button17Click
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='#28436#31034#25968#25454'.mdb;Persist Se' +
      'curity Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 144
    Top = 288
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 200
    Top = 288
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 248
    Top = 288
  end
  object ADOQuery2: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 424
    Top = 264
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 456
    Top = 272
  end
end
