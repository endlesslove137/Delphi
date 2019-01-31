unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QRCtrls, QuickRpt, ExtCtrls, StdCtrls;

type
  TFqryf = class(TForm)
    QuickRep1: TQuickRep;
    ColumnHeaderBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    DetailBand1: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    PageFooterBand1: TQRBand;
    PageHeaderBand1: TQRBand;
    QRLabel5: TQRLabel;
    SummaryBand1: TQRBand;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel16: TQRLabel;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText2: TQRDBText;
    QRLabel6: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel9: TQRLabel;
    QRShape1: TQRShape;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fqryf: TFqryf;

implementation
   uses udata2;
   {$R *.dfm}

end.
