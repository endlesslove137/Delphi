unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,upublic,StdCtrls, DB, ADODB,udispatch, Buttons, jpeg, ExtCtrls,
  uanalyse,urightcontrol,uorder,umoney, Ustorage,uremind,udatamanager, Menus
  ;
  //WinSkinData

type
  TFmain = class(TForm)
    Image1: TImage;
    sbjbxx: TSpeedButton;
    sbjd: TSpeedButton;
    sbrk: TSpeedButton;
    sbfp: TSpeedButton;
    sbck: TSpeedButton;
    sbys: TSpeedButton;
    sbsjfs: TSpeedButton;
    sbqc: TSpeedButton;
    sbjm: TSpeedButton;
    sbsjgl: TSpeedButton;
    sbwxtx: TSpeedButton;
    sbqxgl: TSpeedButton;
    sbjsb: TSpeedButton;
    sbjsq: TSpeedButton;
    sbexit: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    procedure sbfpClick(Sender: TObject);
    procedure sbjsbClick(Sender: TObject);
    procedure sbjsqClick(Sender: TObject);
    procedure sbsjglMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure sbexitClick(Sender: TObject);
    procedure sbjbxxClick(Sender: TObject);
    procedure sbsjfsClick(Sender: TObject);
    procedure sbsjglClick(Sender: TObject);
    procedure sbwxtxClick(Sender: TObject);
    procedure sbqcClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure sbrkClick(Sender: TObject);
    procedure sbjdClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fmain: TFmain;

implementation

uses Uinformation, Udatepicker;

{$R *.dfm}

procedure TFmain.sbfpClick(Sender: TObject);
begin
 showform( TFdispatch,Fdispatch);
end;

procedure TFmain.sbjsbClick(Sender: TObject);
begin
 winexec('notepad',sw_normal);
end;

procedure TFmain.sbjsqClick(Sender: TObject);
begin
 winexec('calc',0);
end;

procedure TFmain.sbsjglMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  dynimic(self,Sender);

end;

procedure TFmain.FormCreate(Sender: TObject);
var
 b,i:integer;

begin
  b:=7;
  for i:=0 to self.ComponentCount-1 do
   begin
    if self.Components[i] is tspeedbutton then
    begin
      tspeedbutton(self.Components[i]).OnMouseMove:=sbsjglMouseMove;
      tspeedbutton(self.Components[i]).Font.Name:='楷体_GB2312';
      tspeedbutton(self.Components[i]).font.charset:=GB2312_CHARSET;
      tspeedbutton(self.Components[i]).font.Size:=12;
      tspeedbutton(self.Components[i]).font.Style:=[fsBold];
      if (tspeedbutton(self.Components[i]).Tag=0) then
      begin
      tspeedbutton(self.Components[i]).Tag:=b;
      inc(b);
      end;
      tspeedbutton(self.Components[i]).OnMouseMove:=sbsjglMouseMove;
    end;
   end;

end;

procedure TFmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if isexit(self,action) then
      animatewindow(self.Handle,1000,aw_center+aw_hide);
end;

procedure TFmain.FormShow(Sender: TObject);
begin
 label4.Caption:=user;
 timer1.Enabled:=true;
 if not(department='管理员') then
 begin
  sbsjgl.Enabled:=false;
 end else
 begin
  sbsjgl.Enabled:=true;
 end;
 showform(tfmain,sender as tform);
end;

procedure TFmain.sbexitClick(Sender: TObject);
begin
 close
end;

procedure TFmain.sbjbxxClick(Sender: TObject);
begin
 showform( TFinformation,Finformation);
end;

procedure TFmain.sbsjfsClick(Sender: TObject);
begin
 showform( TFanalyse,Fanalyse);
end;

procedure TFmain.sbsjglClick(Sender: TObject);
begin
 showform( TFdatamanager,Fdatamanager);
end;

procedure TFmain.sbwxtxClick(Sender: TObject);
begin
 showform( TFremind,Fremind);

end;

procedure TFmain.sbqcClick(Sender: TObject);
begin
 showform(TFdatepicker,Fdatepicker);
end;

procedure TFmain.Timer1Timer(Sender: TObject);
begin
 label5.Caption:=datetimetostr(now);
end;

procedure TFmain.N1Click(Sender: TObject);
begin
//chgskn(skin,(sender as tmenuitem).Caption);
end;

procedure TFmain.sbrkClick(Sender: TObject);
begin
 showform(tfstorage,fstorage);
end;

procedure TFmain.sbjdClick(Sender: TObject);
begin
 showform(tforder,forder);
end;

end.
