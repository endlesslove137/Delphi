unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComObj, BinIntf, ComCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    lbl1: TLabel;
    grpItems: TGroupBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    edtQuantity: TEdit;
    edtDescription: TEdit;
    edtValue: TEdit;
    btnAdd: TButton;
    btnOptimize: TButton;
    tvBins: TTreeView;
    edtBinSize: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
   FOneD: IzmmOneDBin;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
   FOneD := CreateComObject(Class_zMMNextFit) as IzmmOneDBin;

end;

end.
