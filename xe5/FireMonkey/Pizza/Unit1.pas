unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ListBox, FMX.Edit, FMX.Effects, FMX.Filter.Effects, FMX.Ani,
  FMX.Objects;

type
  TForm1 = class(TForm)
    edt1: TEdit;
    btn1: TButton;
    lst1: TListBox;
    rflctnfct1: TReflectionEffect;
    crmpltrnstnfct1: TCrumpleTransitionEffect;
    scldlyt1: TScaledLayout;
    fltnmtn1: TFloatAnimation;
    imageLable: TStyleBook;
    stylbk1: TStyleBook;
    CBedt1: TComboEdit;
    fltnmtn2: TFloatAnimation;
    img1: TImage;
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  lst1.Items.Add(edt1.Text)
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 fltnmtn1.Start;
end;

end.
