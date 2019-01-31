unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DBXDataSnap, IPPeerClient,
  Data.DBXCommon, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.DBCtrls, Data.DB,
  Datasnap.DBClient, Datasnap.DSConnect, Data.SqlExpr;

type
  TForm2 = class(TForm)
    con1: TSQLConnection;
    con2: TDSProviderConnection;
    Cds1: TClientDataSet;
    ds1: TDataSource;
    dbnvgr1: TDBNavigator;
    dbgrd1: TDBGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

end.
