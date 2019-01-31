unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    btn1: TBitBtn;
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  fcheck,fnocheck:tbitmap;
implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
   StringGrid1.Options:= StringGrid1.Options + [goEditing, goTabs];
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 bmp:TBitmap;
begin
  FCheck:= TBitmap.Create;
  FNoCheck:= TBitmap.Create;
  bmp:= TBitmap.create;
  try
  　 bmp.handle := LoadBitmap( 0, PChar(OBM_CHECKBOXES ));
  　 With FNoCheck Do
     Begin
  　　 width := bmp.width div 4;
  　　 height := bmp.height div 3;
  　　 canvas.copyrect( canvas.cliprect, bmp.canvas, canvas.cliprect );
  　 End;
     With FCheck Do
     Begin
    　 width := bmp.width div 4;
    　 height := bmp.height div 3;
    　 canvas.copyrect(canvas.cliprect, bmp.canvas, rect( width, 0, 2*width, height ));
     End;
  finally
  　 bmp.free
  end;



end;

procedure TForm1.StringGrid1Click(Sender: TObject);
begin
 if TStringGrid(Sender).col <> 3 then Exit;

 if TStringGrid(Sender).Cells[TStringGrid(Sender).col,TStringGrid(Sender).row]='0' then
 begin
　 TStringGrid(Sender).Cells[TStringGrid(Sender).col,TStringGrid(Sender).row]:='1';
 end
 else
 begin
　 TStringGrid(Sender).Cells[TStringGrid(Sender).col,TStringGrid(Sender).row]:='0';
 end;
end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (ACol <> 3) or (ARow = 0) then Exit;

//  if not (gdFixed in State) then
//  if tbEditMode.Tag = -1 then
  with TStringGrid(Sender).Canvas do
  begin
  　 brush.Color:=clWindow;
  　 FillRect(Rect);
  　 if TStringGrid(Sender).Cells[ACol,ARow] <> '0' then
  　　 Draw( (rect.right + rect.left - FCheck.width) div 2, (rect.bottom + rect.top - FCheck.height) div 2, FCheck )
  　 else
  　　 Draw( (rect.right + rect.left - FCheck.width) div 2, (rect.bottom + rect.top - FCheck.height) div 2, FNoCheck );
  end;


end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
 i : Integer;
begin
//   ShowMessage(IntToStr(StringGrid1.Col) + ' : ' + IntToStr(ACol));
   if ACol = 3 then
   begin
    CanSelect := false;
 if TStringGrid(Sender).Cells[TStringGrid(Sender).col,TStringGrid(Sender).row]='0' then
 begin
　 TStringGrid(Sender).Cells[TStringGrid(Sender).col,TStringGrid(Sender).row]:='1';
 end
 else
 begin
　 TStringGrid(Sender).Cells[TStringGrid(Sender).col,TStringGrid(Sender).row]:='0';
 end;
    Exit;
   end;
// if ACol <> 3 then StringGrid1.H;

end;

end.
