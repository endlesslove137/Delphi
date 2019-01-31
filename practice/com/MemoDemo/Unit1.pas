unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    mmo1: TMemo;
    btn1: TButton;
    btn2: TButton;
    dlgFont1: TFontDialog;
    dlgColor1: TColorDialog;
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetColor:TColor;
    procedure SetColor(color :TColor);
    function GetFont:TFont;
    procedure SetFont(Font :TFont);
    function GetString:TStrings;
    procedure SetString(Strings :TStrings);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
 if dlgFont1.Execute then
 mmo1.Font.Assign(dlgFont1.Font);
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
 if dlgColor1.Execute  then
  mmo1.Color := dlgColor1.color;
end;

function TForm1.GetColor: TColor;
begin
 Result := mmo1.Color;
end;

function TForm1.GetFont: TFont;
begin
 result := mmo1.Font;
end;

function TForm1.GetString: TStrings;
begin
result := mmo1.Lines;
end;

procedure TForm1.SetColor(color: TColor);
begin
 mmo1.Color := color;

end;

procedure TForm1.SetFont(Font: TFont);
begin
 mmo1.Font.Assign(Font);
end;

procedure TForm1.SetString(Strings: TStrings);
begin
 mmo1.Lines.Assign(Strings);
end;

end.
