unit Udetail;

interface

uses
  Windows, Messages, upublic,SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ComCtrls, udata,QRCtrls, QuickRpt, ExtCtrls;

type
  Tfdetail = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    QuickRep1: TQuickRep;
    ColumnHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    SummaryBand1: TQRBand;
    TitleBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRShape1: TQRShape;
    QRLabel2: TQRLabel;
    QRSysData1: TQRSysData;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel13: TQRLabel;
    QRExpr1: TQRExpr;
    QRLabel14: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QuickRep2: TQuickRep;
    ColumnHeaderBand2: TQRBand;
    DetailBand2: TQRBand;
    SummaryBand2: TQRBand;
    TitleBand2: TQRBand;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRSysData2: TQRSysData;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRLabel10: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRLabel17: TQRLabel;
    QRLabel18: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel21: TQRLabel;
    QRLabel22: TQRLabel;
    QRExpr3: TQRExpr;
    QuickRep3: TQuickRep;
    ColumnHeaderBand3: TQRBand;
    DetailBand3: TQRBand;
    SummaryBand3: TQRBand;
    TitleBand3: TQRBand;
    QRLabel20: TQRLabel;
    QRLabel23: TQRLabel;
    QRLabel24: TQRLabel;
    QRLabel25: TQRLabel;
    QRSysData3: TQRSysData;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRDBText12: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    QRDBText15: TQRDBText;
    QRLabel26: TQRLabel;
    QRLabel27: TQRLabel;
    QRLabel28: TQRLabel;
    QRLabel29: TQRLabel;
    QRLabel30: TQRLabel;
    QRExpr2: TQRExpr;
    QRLabel31: TQRLabel;
    TabSheet4: TTabSheet;
    QuickRep4: TQuickRep;
    TitleBand4: TQRBand;
    ColumnHeaderBand4: TQRBand;
    DetailBand4: TQRBand;
    QRLabel33: TQRLabel;
    QRLabel32: TQRLabel;
    QRLabel34: TQRLabel;
    QRDBText16: TQRDBText;
    QRDBText17: TQRDBText;
    TabSheet5: TTabSheet;
    QuickRep5: TQuickRep;
    ColumnHeaderBand5: TQRBand;
    DetailBand5: TQRBand;
    TitleBand5: TQRBand;
    QRLabel35: TQRLabel;
    QRLabel36: TQRLabel;
    QRLabel38: TQRLabel;
    QRLabel39: TQRLabel;
    QRLabel40: TQRLabel;
    QRLabel41: TQRLabel;
    QRLabel42: TQRLabel;
    QRLabel45: TQRLabel;
    QRDBText21: TQRDBText;
    QRDBText22: TQRDBText;
    QRDBText23: TQRDBText;
    QRDBText18: TQRDBText;
    QRDBText19: TQRDBText;
    QRDBText20: TQRDBText;
    QRDBText24: TQRDBText;
    QRDBText26: TQRDBText;
    QRDBText25: TQRDBText;
    QRLabel37: TQRLabel;
    QRLabel43: TQRLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fdetail: Tfdetail;

implementation

{$R *.dfm}

procedure Tfdetail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  isexit(self,action);
end;

end.
