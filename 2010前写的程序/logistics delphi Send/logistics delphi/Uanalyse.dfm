object Fanalyse: TFanalyse
  Left = 251
  Top = 129
  Width = 696
  Height = 480
  Caption = #25968#25454#20998#26512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 688
    Height = 446
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #21496#26426#36816#36755#25104#21151#29575
      object SpeedButton1: TSpeedButton
        Left = 224
        Top = 18
        Width = 191
        Height = 37
        Caption = #24320#22987#20998#26512
        OnClick = SpeedButton1Click
      end
      object DBChart1: TDBChart
        Left = 0
        Top = 70
        Width = 680
        Height = 348
        BackWall.Brush.Color = clWhite
        Title.Text.Strings = (
          'TDBChart')
        View3DOptions.Elevation = 315
        View3DOptions.Orthogonal = False
        View3DOptions.Perspective = 0
        View3DOptions.Rotation = 360
        Align = alBottom
        TabOrder = 0
        object Series1: TFastLineSeries
          ColorEachPoint = True
          Marks.ArrowLength = 8
          Marks.Visible = True
          SeriesColor = clRed
          LinePen.Color = clGreen
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
    end
  end
end
