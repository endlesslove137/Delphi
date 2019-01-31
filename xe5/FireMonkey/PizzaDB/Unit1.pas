unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, FMX.Layouts, Fmx.Bind.Navigator,
  Data.Bind.Components, Data.Bind.DBScope, Data.DB, Datasnap.DBClient,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Memo, FMX.Objects,
  FMX.Edit, Data.Bind.DBLinks, Fmx.Bind.DBLinks;

type
  TForm1 = class(TForm)
    Cds1: TClientDataSet;
    ds2: TDataSource;
    bndsrcdb1: TBindSourceDB;
    bndngslst1: TBindingsList;
    Nav1: TBindNavigator;
    IFCds1ID: TIntegerField;
    SFCds1Name: TStringField;
    SFCds1Description: TStringField;
    CFCds1Price: TCurrencyField;
    GFCds1Image: TGraphicField;
    BDBEdtID: TBindDBEditLink;
    edtID: TEdit;
    BDBEdtName: TBindDBEditLink;
    edtName: TEdit;
    edtPrice: TEdit;
    mmoDescription: TMemo;
    BDBEdt1: TBindDBEditLink;
    bndbmlnk1: TBindDBMemoLink;
    bndbmglnk1: TBindDBImageLink;
    img1: TImageControl;
    btn1: TCornerButton;
    dlgOpen1: TOpenDialog;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btn1Click(Sender: TObject);
begin
  if dlgOpen1.Execute then
  begin
    Cds1.Edit;
    cds1.Append;
    (Cds1.FieldbyName('image') as TGraphicField).loadfromfile(dlgOpen1.FileName);
//    Cds1.Post;
    Cds1.SaveToFile('d:\pizza.cds');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Cds1.Open;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 Cds1.Post;
 Cds1.Close;
end;

end.
