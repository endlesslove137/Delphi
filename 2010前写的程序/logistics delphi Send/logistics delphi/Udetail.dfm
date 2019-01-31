object fdetail: Tfdetail
  Left = 67
  Top = 90
  Width = 890
  Height = 620
  Caption = #26126#32454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 882
    Height = 586
    ActivePage = TabSheet5
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #25176#36816#25152#24471
      object QuickRep2: TQuickRep
        Left = 0
        Top = 2
        Width = 794
        Height = 1123
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        DataSet = fdata.procedure1
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #26999#20307'_GB2312'
        Font.Style = []
        Functions.Strings = (
          'PAGENUMBER'
          'COLUMNNUMBER'
          'REPORTTITLE')
        Functions.DATA = (
          '0'
          '0'
          #39#39)
        Options = [FirstPageHeader, LastPageFooter]
        Page.Columns = 1
        Page.Orientation = poPortrait
        Page.PaperSize = A4
        Page.Values = (
          100.000000000000000000
          2970.000000000000000000
          100.000000000000000000
          2100.000000000000000000
          100.000000000000000000
          100.000000000000000000
          0.000000000000000000)
        PrinterSettings.Copies = 1
        PrinterSettings.Duplex = False
        PrinterSettings.FirstPage = 0
        PrinterSettings.LastPage = 0
        PrinterSettings.OutputBin = Auto
        PrintIfEmpty = True
        SnapToGrid = True
        Units = MM
        Zoom = 100
        object ColumnHeaderBand2: TQRBand
          Left = 38
          Top = 121
          Width = 718
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            105.833333333333300000
            1899.708333333333000000)
          BandType = rbColumnHeader
          object QRLabel10: TQRLabel
            Left = 380
            Top = 14
            Width = 65
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1005.416666666667000000
              37.041666666666670000
              171.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #21040#36798#26085#26399
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel15: TQRLabel
            Left = 496
            Top = 14
            Width = 65
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1312.333333333333000000
              37.041666666666670000
              171.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #25176#36816#36153#29992
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel16: TQRLabel
            Left = 265
            Top = 14
            Width = 33
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              701.145833333333400000
              37.041666666666670000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #23458#25143
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel17: TQRLabel
            Left = 34
            Top = 14
            Width = 65
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              89.958333333333340000
              37.041666666666670000
              171.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #25176#36816#21333'ID'
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel18: TQRLabel
            Left = 149
            Top = 14
            Width = 49
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              394.229166666666700000
              37.041666666666670000
              129.645833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #36127#36131#20154
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel19: TQRLabel
            Left = 612
            Top = 14
            Width = 33
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1619.250000000000000000
              37.041666666666670000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #29366#24577
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
        end
        object DetailBand2: TQRBand
          Left = 38
          Top = 161
          Width = 718
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            105.833333333333300000
            1899.708333333333000000)
          BandType = rbDetail
          object QRDBText6: TQRDBText
            Left = 151
            Top = 12
            Width = 49
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              399.520833333333400000
              31.750000000000000000
              129.645833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = #36127#36131#20154
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText7: TQRDBText
            Left = 50
            Top = 12
            Width = 65
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              132.291666666666700000
              31.750000000000000000
              171.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = #25176#36816#21333'ID'
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText8: TQRDBText
            Left = 267
            Top = 12
            Width = 33
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              706.437500000000000000
              31.750000000000000000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = #23458#25143
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText9: TQRDBText
            Left = 498
            Top = 12
            Width = 41
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1317.625000000000000000
              31.750000000000000000
              108.479166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = 'money'
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText10: TQRDBText
            Left = 382
            Top = 12
            Width = 65
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1010.708333333333000000
              31.750000000000000000
              171.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = #21040#36798#26085#26399
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText11: TQRDBText
            Left = 614
            Top = 12
            Width = 33
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1624.541666666667000000
              31.750000000000000000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = #29366#24577
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
        end
        object SummaryBand2: TQRBand
          Left = 38
          Top = 201
          Width = 718
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          LinkBand = DetailBand2
          Size.Values = (
            105.833333333333300000
            1899.708333333333000000)
          BandType = rbSummary
          object QRLabel21: TQRLabel
            Left = 610
            Top = 14
            Width = 17
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1613.958333333333000000
              37.041666666666670000
              44.979166666666670000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #20803
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clRed
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel22: TQRLabel
            Left = 360
            Top = 14
            Width = 105
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              952.500000000000000000
              37.041666666666670000
              277.812500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #25176#36816#25152#24471#24635#35745':'
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRExpr3: TQRExpr
            Left = 468
            Top = 14
            Width = 81
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1238.250000000000000000
              37.041666666666670000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            Color = clWhite
            ParentFont = False
            ResetAfterPrint = False
            Transparent = False
            WordWrap = True
            Expression = 'sum(money)'
            FontSize = 12
          end
        end
        object TitleBand2: TQRBand
          Left = 38
          Top = 38
          Width = 718
          Height = 83
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            219.604166666666700000
            1899.708333333333000000)
          BandType = rbTitle
          object QRLabel8: TQRLabel
            Left = 234
            Top = 14
            Width = 97
            Height = 22
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              58.208333333333340000
              619.125000000000000000
              37.041666666666670000
              256.645833333333400000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = 'QRLabel8'
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -21
            Font.Name = #26999#20307'_GB2312'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 16
          end
          object QRLabel9: TQRLabel
            Left = 374
            Top = 14
            Width = 97
            Height = 22
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              58.208333333333340000
              989.541666666666800000
              37.041666666666670000
              256.645833333333400000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = 'QRLabel9'
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -21
            Font.Name = #26999#20307'_GB2312'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 16
          end
          object QRLabel11: TQRLabel
            Left = 298
            Top = 48
            Width = 93
            Height = 22
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              58.208333333333340000
              788.458333333333400000
              127.000000000000000000
              246.062500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #25176#36816#25152#24471
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -21
            Font.Name = #26999#20307'_GB2312'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 16
          end
          object QRLabel12: TQRLabel
            Left = 478
            Top = 60
            Width = 49
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1264.708333333333000000
              158.750000000000000000
              129.645833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #26085#26399#65306
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRSysData2: TQRSysData
            Left = 536
            Top = 60
            Width = 89
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1418.166666666667000000
              158.750000000000000000
              235.479166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            Color = clWhite
            Data = qrsDateTime
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            FontSize = 12
          end
          object QRShape2: TQRShape
            Left = 12
            Top = 76
            Width = 689
            Height = 5
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              13.229166666666670000
              31.750000000000000000
              201.083333333333300000
              1822.979166666667000000)
            Shape = qrsHorLine
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #24037#36164#20998#37197
      ImageIndex = 1
      object QuickRep1: TQuickRep
        Left = 4
        Top = 6
        Width = 794
        Height = 1123
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        DataSet = fdata.employees
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #26999#20307'_GB2312'
        Font.Style = []
        Functions.Strings = (
          'PAGENUMBER'
          'COLUMNNUMBER'
          'REPORTTITLE')
        Functions.DATA = (
          '0'
          '0'
          #39#39)
        Options = [FirstPageHeader, LastPageFooter]
        Page.Columns = 1
        Page.Orientation = poPortrait
        Page.PaperSize = A4
        Page.Values = (
          100.000000000000000000
          2970.000000000000000000
          100.000000000000000000
          2100.000000000000000000
          100.000000000000000000
          100.000000000000000000
          0.000000000000000000)
        PrinterSettings.Copies = 1
        PrinterSettings.Duplex = False
        PrinterSettings.FirstPage = 0
        PrinterSettings.LastPage = 0
        PrinterSettings.OutputBin = Auto
        PrintIfEmpty = True
        SnapToGrid = True
        Units = MM
        Zoom = 100
        object ColumnHeaderBand1: TQRBand
          Left = 38
          Top = 107
          Width = 718
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            105.833333333333300000
            1899.708333333333000000)
          BandType = rbColumnHeader
          object QRLabel3: TQRLabel
            Left = 34
            Top = 14
            Width = 33
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              89.958333333333340000
              37.041666666666670000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #22995#21517
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel4: TQRLabel
            Left = 436
            Top = 14
            Width = 33
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1153.583333333333000000
              37.041666666666670000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #30005#35805
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel5: TQRLabel
            Left = 300
            Top = 14
            Width = 33
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              793.750000000000000000
              37.041666666666670000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #24037#36164
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel6: TQRLabel
            Left = 164
            Top = 14
            Width = 33
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              433.916666666666800000
              37.041666666666670000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #24615#21035
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel7: TQRLabel
            Left = 572
            Top = 14
            Width = 33
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1513.416666666667000000
              37.041666666666670000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #37096#38376
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
        end
        object DetailBand1: TQRBand
          Left = 38
          Top = 147
          Width = 718
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            105.833333333333300000
            1899.708333333333000000)
          BandType = rbDetail
          object QRDBText1: TQRDBText
            Left = 300
            Top = 14
            Width = 49
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              793.750000000000000000
              37.041666666666670000
              129.645833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.employees
            DataField = 'salary'
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText2: TQRDBText
            Left = 425
            Top = 16
            Width = 41
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1124.479166666667000000
              42.333333333333340000
              108.479166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.employees
            DataField = 'phone'
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText3: TQRDBText
            Left = 30
            Top = 14
            Width = 33
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              79.375000000000000000
              37.041666666666670000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.employees
            DataField = 'name'
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText4: TQRDBText
            Left = 169
            Top = 14
            Width = 25
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              447.145833333333400000
              37.041666666666670000
              66.145833333333340000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.employees
            DataField = 'sex'
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText5: TQRDBText
            Left = 564
            Top = 14
            Width = 81
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1492.250000000000000000
              37.041666666666670000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.employees
            DataField = 'department'
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
        end
        object SummaryBand1: TQRBand
          Left = 38
          Top = 187
          Width = 718
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          LinkBand = DetailBand1
          Size.Values = (
            105.833333333333300000
            1899.708333333333000000)
          BandType = rbSummary
          object QRLabel13: TQRLabel
            Left = 264
            Top = 16
            Width = 161
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              698.500000000000000000
              42.333333333333340000
              425.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #26412#26376#24212#21457#25918#24037#36164#24635#39069#65306
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRExpr1: TQRExpr
            Left = 430
            Top = 16
            Width = 89
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1137.708333333333000000
              42.333333333333340000
              235.479166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Font.Charset = GB2312_CHARSET
            Font.Color = clRed
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            Color = clWhite
            ParentFont = False
            ResetAfterPrint = False
            Transparent = False
            WordWrap = True
            Expression = 'sum(salary)'
            FontSize = 12
          end
          object QRLabel14: TQRLabel
            Left = 554
            Top = 18
            Width = 17
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1465.791666666667000000
              47.625000000000000000
              44.979166666666670000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #20803
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
        end
        object TitleBand1: TQRBand
          Left = 38
          Top = 38
          Width = 718
          Height = 69
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            182.562500000000000000
            1899.708333333333000000)
          BandType = rbTitle
          object QRLabel1: TQRLabel
            Left = 258
            Top = 22
            Width = 162
            Height = 25
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              66.145833333333340000
              682.625000000000000000
              58.208333333333340000
              428.625000000000000000)
            Alignment = taCenter
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #38599#21592#24037#36164#24773#20917#12288
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -21
            Font.Name = #26999#20307'_GB2312'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 16
          end
          object QRShape1: TQRShape
            Left = 10
            Top = 50
            Width = 695
            Height = 13
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              34.395833333333340000
              26.458333333333330000
              132.291666666666700000
              1838.854166666667000000)
            Shape = qrsHorLine
          end
          object QRLabel2: TQRLabel
            Left = 468
            Top = 34
            Width = 49
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1238.250000000000000000
              89.958333333333340000
              129.645833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #26085#26399#65306
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRSysData1: TQRSysData
            Left = 526
            Top = 34
            Width = 89
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1391.708333333333000000
              89.958333333333340000
              235.479166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            Color = clWhite
            Data = qrsDateTime
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            FontSize = 12
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #21496#26426#25152#24471
      ImageIndex = 2
      object QuickRep3: TQuickRep
        Left = -6
        Top = -2
        Width = 794
        Height = 1123
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        DataSet = fdata.procedure1
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #26999#20307'_GB2312'
        Font.Style = []
        Functions.Strings = (
          'PAGENUMBER'
          'COLUMNNUMBER'
          'REPORTTITLE')
        Functions.DATA = (
          '0'
          '0'
          #39#39)
        Options = [FirstPageHeader, LastPageFooter]
        Page.Columns = 1
        Page.Orientation = poPortrait
        Page.PaperSize = A4
        Page.Values = (
          100.000000000000000000
          2970.000000000000000000
          100.000000000000000000
          2100.000000000000000000
          100.000000000000000000
          100.000000000000000000
          0.000000000000000000)
        PrinterSettings.Copies = 1
        PrinterSettings.Duplex = False
        PrinterSettings.FirstPage = 0
        PrinterSettings.LastPage = 0
        PrinterSettings.OutputBin = Auto
        PrintIfEmpty = True
        SnapToGrid = True
        Units = MM
        Zoom = 100
        object ColumnHeaderBand3: TQRBand
          Left = 38
          Top = 125
          Width = 718
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            105.833333333333300000
            1899.708333333333000000)
          BandType = rbColumnHeader
          object QRLabel26: TQRLabel
            Left = 396
            Top = 12
            Width = 65
            Height = 19
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              50.270833333333330000
              1047.750000000000000000
              31.750000000000000000
              171.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #36816#36865#36335#31243
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel27: TQRLabel
            Left = 217
            Top = 12
            Width = 65
            Height = 19
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              50.270833333333330000
              574.145833333333400000
              31.750000000000000000
              171.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #36816#36865#21333#21495
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel28: TQRLabel
            Left = 38
            Top = 12
            Width = 33
            Height = 19
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              50.270833333333330000
              100.541666666666700000
              31.750000000000000000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #21496#26426
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel29: TQRLabel
            Left = 576
            Top = 12
            Width = 65
            Height = 19
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              50.270833333333330000
              1524.000000000000000000
              31.750000000000000000
              171.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #25152#24471#24037#36164
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
        end
        object DetailBand3: TQRBand
          Left = 38
          Top = 165
          Width = 718
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            105.833333333333300000
            1899.708333333333000000)
          BandType = rbDetail
          object QRDBText12: TQRDBText
            Left = 408
            Top = 14
            Width = 65
            Height = 19
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              50.270833333333330000
              1079.500000000000000000
              37.041666666666670000
              171.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = #36816#36865#36335#31243
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText13: TQRDBText
            Left = 232
            Top = 14
            Width = 65
            Height = 19
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              50.270833333333330000
              613.833333333333400000
              37.041666666666670000
              171.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = #36816#36865#21333#21495
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText14: TQRDBText
            Left = 40
            Top = 14
            Width = 33
            Height = 19
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              50.270833333333330000
              105.833333333333300000
              37.041666666666670000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = #21496#26426
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText15: TQRDBText
            Left = 590
            Top = 14
            Width = 49
            Height = 19
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              50.270833333333330000
              1561.041666666667000000
              37.041666666666670000
              129.645833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = 'salary'
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
        end
        object SummaryBand3: TQRBand
          Left = 38
          Top = 205
          Width = 718
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          LinkBand = DetailBand3
          Size.Values = (
            105.833333333333300000
            1899.708333333333000000)
          BandType = rbSummary
          object QRLabel30: TQRLabel
            Left = 360
            Top = 14
            Width = 105
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              952.500000000000000000
              37.041666666666670000
              277.812500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #21496#26426#25152#24471#24635#35745':'
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRExpr2: TQRExpr
            Left = 468
            Top = 14
            Width = 89
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1238.250000000000000000
              37.041666666666670000
              235.479166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            Color = clWhite
            ParentFont = False
            ResetAfterPrint = False
            Transparent = False
            WordWrap = True
            Expression = 'sum(salary)'
            FontSize = 12
          end
          object QRLabel31: TQRLabel
            Left = 610
            Top = 14
            Width = 17
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1613.958333333333000000
              37.041666666666670000
              44.979166666666670000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #20803
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clRed
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
        end
        object TitleBand3: TQRBand
          Left = 38
          Top = 38
          Width = 718
          Height = 87
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            230.187500000000000000
            1899.708333333333000000)
          BandType = rbTitle
          object QRLabel20: TQRLabel
            Left = 234
            Top = 14
            Width = 97
            Height = 22
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              58.208333333333340000
              619.125000000000000000
              37.041666666666670000
              256.645833333333400000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = 'QRLabel8'
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -21
            Font.Name = #26999#20307'_GB2312'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 16
          end
          object QRLabel23: TQRLabel
            Left = 374
            Top = 14
            Width = 97
            Height = 22
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              58.208333333333340000
              989.541666666666800000
              37.041666666666670000
              256.645833333333400000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = 'QRLabel9'
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -21
            Font.Name = #26999#20307'_GB2312'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 16
          end
          object QRLabel24: TQRLabel
            Left = 298
            Top = 48
            Width = 93
            Height = 22
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              58.208333333333340000
              788.458333333333400000
              127.000000000000000000
              246.062500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #21496#26426#25152#24471
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -21
            Font.Name = #26999#20307'_GB2312'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 16
          end
          object QRLabel25: TQRLabel
            Left = 478
            Top = 62
            Width = 49
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1264.708333333333000000
              164.041666666666700000
              129.645833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #26085#26399#65306
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRSysData3: TQRSysData
            Left = 536
            Top = 62
            Width = 89
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              1418.166666666667000000
              164.041666666666700000
              235.479166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            Color = clWhite
            Data = qrsDateTime
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -16
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            FontSize = 12
          end
          object QRShape3: TQRShape
            Left = 12
            Top = 76
            Width = 689
            Height = 5
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              13.229166666666670000
              31.750000000000000000
              201.083333333333300000
              1822.979166666667000000)
            Shape = qrsHorLine
          end
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #26412#21333#21495#20135#21697#22914#19979
      ImageIndex = 3
      object QuickRep4: TQuickRep
        Left = 0
        Top = 0
        Width = 794
        Height = 1123
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        DataSet = fdata.procedure1
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #26999#20307'_GB2312'
        Font.Style = []
        Functions.Strings = (
          'PAGENUMBER'
          'COLUMNNUMBER'
          'REPORTTITLE')
        Functions.DATA = (
          '0'
          '0'
          #39#39)
        Options = [FirstPageHeader, LastPageFooter]
        Page.Columns = 3
        Page.Orientation = poPortrait
        Page.PaperSize = A4
        Page.Values = (
          100.000000000000000000
          2970.000000000000000000
          100.000000000000000000
          2100.000000000000000000
          100.000000000000000000
          100.000000000000000000
          0.000000000000000000)
        PrinterSettings.Copies = 1
        PrinterSettings.Duplex = False
        PrinterSettings.FirstPage = 0
        PrinterSettings.LastPage = 0
        PrinterSettings.OutputBin = Auto
        PrintIfEmpty = True
        SnapToGrid = True
        Units = MM
        Zoom = 100
        object TitleBand4: TQRBand
          Left = 38
          Top = 38
          Width = 718
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            105.833333333333300000
            1899.708333333333000000)
          BandType = rbTitle
          object QRLabel33: TQRLabel
            Left = 262
            Top = 12
            Width = 97
            Height = 22
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              58.208333333333340000
              693.208333333333400000
              31.750000000000000000
              256.645833333333400000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = 'QRLabel8'
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -21
            Font.Name = #26999#20307'_GB2312'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 16
          end
        end
        object ColumnHeaderBand4: TQRBand
          Left = 38
          Top = 78
          Width = 239
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            105.833333333333300000
            632.354166666666800000)
          BandType = rbColumnHeader
          object QRLabel32: TQRLabel
            Left = 18
            Top = 12
            Width = 49
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              47.625000000000000000
              31.750000000000000000
              129.645833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #20135#21697#21517
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRLabel34: TQRLabel
            Left = 122
            Top = 12
            Width = 65
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              322.791666666666700000
              31.750000000000000000
              171.979166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #20135#21697#25968#37327
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
        end
        object DetailBand4: TQRBand
          Left = 38
          Top = 118
          Width = 239
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            105.833333333333300000
            632.354166666666800000)
          BandType = rbDetail
          object QRDBText16: TQRDBText
            Left = 20
            Top = 12
            Width = 33
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              52.916666666666660000
              31.750000000000000000
              87.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = 'name'
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
          object QRDBText17: TQRDBText
            Left = 134
            Top = 12
            Width = 49
            Height = 17
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              44.979166666666670000
              354.541666666666700000
              31.750000000000000000
              129.645833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = 'number'
            Transparent = False
            WordWrap = True
            FontSize = 12
          end
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #26681#25454#23450#21333#25171#21360#30456#24212#20449#24687
      ImageIndex = 4
      object QuickRep5: TQuickRep
        Left = -6
        Top = -4
        Width = 794
        Height = 1123
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        DataSet = fdata.procedure1
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = #26999#20307'_GB2312'
        Font.Style = []
        Functions.Strings = (
          'PAGENUMBER'
          'COLUMNNUMBER'
          'REPORTTITLE')
        Functions.DATA = (
          '0'
          '0'
          #39#39)
        Options = [FirstPageHeader, LastPageFooter]
        Page.Columns = 1
        Page.Orientation = poPortrait
        Page.PaperSize = A4
        Page.Values = (
          100.000000000000000000
          2970.000000000000000000
          100.000000000000000000
          2100.000000000000000000
          100.000000000000000000
          100.000000000000000000
          0.000000000000000000)
        PrinterSettings.Copies = 1
        PrinterSettings.Duplex = False
        PrinterSettings.FirstPage = 0
        PrinterSettings.LastPage = 0
        PrinterSettings.OutputBin = Auto
        PrintIfEmpty = True
        SnapToGrid = True
        Units = MM
        Zoom = 100
        object ColumnHeaderBand5: TQRBand
          Left = 38
          Top = 78
          Width = 718
          Height = 107
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            283.104166666666700000
            1899.708333333333000000)
          BandType = rbColumnHeader
          object QRLabel35: TQRLabel
            Left = 435
            Top = 2
            Width = 81
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              1150.937500000000000000
              5.291666666666667000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #25910#21462#36153#29992
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRLabel36: TQRLabel
            Left = 334
            Top = 4
            Width = 81
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              883.708333333333400000
              10.583333333333330000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #26159#21542#25237#20445
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRLabel38: TQRLabel
            Left = 529
            Top = 2
            Width = 61
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              1399.645833333333000000
              5.291666666666667000
              161.395833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #30446#30340#22320
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRLabel39: TQRLabel
            Left = 87
            Top = 4
            Width = 61
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              230.187500000000000000
              10.583333333333330000
              161.395833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #20184#36131#20154
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRLabel40: TQRLabel
            Left = -8
            Top = 4
            Width = 81
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              -21.166666666666670000
              10.583333333333330000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #25176#36816#32534#21495
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRLabel41: TQRLabel
            Left = 231
            Top = 4
            Width = 81
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              611.187500000000000000
              10.583333333333330000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #23457#35831#26085#26399
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRLabel42: TQRLabel
            Left = 164
            Top = 4
            Width = 41
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              433.916666666666800000
              10.583333333333330000
              108.479166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #23458#25143
            Color = clWhite
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRDBText21: TQRDBText
            Left = 20
            Top = 44
            Width = 81
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              52.916666666666660000
              116.416666666666700000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.temp
            DataField = #25176#36816#32534#21495
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRDBText22: TQRDBText
            Left = 87
            Top = 44
            Width = 61
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              230.187500000000000000
              116.416666666666700000
              161.395833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.temp
            DataField = #20184#36131#20154
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRDBText23: TQRDBText
            Left = 156
            Top = 44
            Width = 41
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              412.750000000000100000
              116.416666666666700000
              108.479166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.temp
            DataField = #23458#25143
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRDBText18: TQRDBText
            Left = 229
            Top = 44
            Width = 81
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              605.895833333333400000
              116.416666666666700000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.temp
            DataField = #23457#35831#26085#26399
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRDBText19: TQRDBText
            Left = 348
            Top = 44
            Width = 81
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              920.750000000000000000
              116.416666666666700000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.temp
            DataField = #26159#21542#25237#20445
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRDBText20: TQRDBText
            Left = 457
            Top = 44
            Width = 81
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              1209.145833333333000000
              116.416666666666700000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.temp
            DataField = #25910#21462#36153#29992
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRDBText24: TQRDBText
            Left = 526
            Top = 44
            Width = 61
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              1391.708333333333000000
              116.416666666666700000
              161.395833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.temp
            DataField = #30446#30340#22320
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRLabel37: TQRLabel
            Left = 504
            Top = 84
            Width = 81
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              1333.500000000000000000
              222.250000000000000000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #25176#36816#29289#21697
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -19
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRLabel43: TQRLabel
            Left = 600
            Top = 84
            Width = 81
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              1587.500000000000000000
              222.250000000000000000
              214.312500000000000000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = #25176#36816#25968#37327
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -19
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
        end
        object DetailBand5: TQRBand
          Left = 38
          Top = 185
          Width = 718
          Height = 34
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            89.958333333333340000
            1899.708333333333000000)
          BandType = rbDetail
          object QRDBText26: TQRDBText
            Left = 523
            Top = 10
            Width = 41
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              1383.770833333333000000
              26.458333333333330000
              108.479166666666700000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = 'name'
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -19
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
          object QRDBText25: TQRDBText
            Left = 612
            Top = 10
            Width = 61
            Height = 20
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              52.916666666666660000
              1619.250000000000000000
              26.458333333333330000
              161.395833333333300000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Color = clWhite
            DataSet = fdata.procedure1
            DataField = 'number'
            Font.Charset = GB2312_CHARSET
            Font.Color = clFuchsia
            Font.Height = -19
            Font.Name = #26999#20307'_GB2312'
            Font.Style = []
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 14
          end
        end
        object TitleBand5: TQRBand
          Left = 38
          Top = 38
          Width = 718
          Height = 40
          Frame.Color = clBlack
          Frame.DrawTop = False
          Frame.DrawBottom = False
          Frame.DrawLeft = False
          Frame.DrawRight = False
          AlignToBottom = False
          Color = clWhite
          ForceNewColumn = False
          ForceNewPage = False
          Size.Values = (
            105.833333333333300000
            1899.708333333333000000)
          BandType = rbTitle
          object QRLabel45: TQRLabel
            Left = 276
            Top = 10
            Width = 97
            Height = 22
            Frame.Color = clBlack
            Frame.DrawTop = False
            Frame.DrawBottom = False
            Frame.DrawLeft = False
            Frame.DrawRight = False
            Size.Values = (
              58.208333333333340000
              730.250000000000000000
              26.458333333333330000
              256.645833333333400000)
            Alignment = taLeftJustify
            AlignToBand = False
            AutoSize = True
            AutoStretch = False
            Caption = 'QRLabel8'
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -21
            Font.Name = #26999#20307'_GB2312'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            WordWrap = True
            FontSize = 16
          end
        end
      end
    end
  end
end
