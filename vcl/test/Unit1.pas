unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, Wincodec,Rtti,pngimage,System.SysUtils,GIFImg, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Touch.GestureMgr, Vcl.ExtDlgs;

type
  TForm1 = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    btndt1: TButtonedEdit;
    lnklbl1: TLinkLabel;
    ctgrypnlgrp1: TCategoryPanelGroup;
    ctgrypnl1: TCategoryPanel;
    ctgrypnl2: TCategoryPanel;
    edt1: TEdit;
    gstrmngr1: TGestureManager;
    OpenPictureDialog1: TOpenPictureDialog;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure AppDeactivate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation



{$R *.dfm}

procedure TForm1.AppDeactivate(Sender: TObject);
begin
  Application.Minimize;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  Done: Boolean;
begin
  OpenPictureDialog1.DefaultExt := GraphicExtension(TIcon);
  OpenPictureDialog1.FileName := GraphicFileMask(TIcon);
  OpenPictureDialog1.Filter := GraphicFilter(TIcon);
  OpenPictureDialog1.Options := [ofFileMustExist, ofHideReadOnly, ofNoChangeDir];

  Done := False;
  while not Done do {这个循环是让你必须找一个}
  begin
    if OpenPictureDialog1.Execute then
      if not (ofExtensionDifferent in OpenPictureDialog1.Options) then
        begin
          Application.Icon.LoadFromFile(OpenPictureDialog1.FileName);
          Done := True;
        end
    else
      Done := True;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
RunError(204);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnDeactivate := AppDeactivate;

    BorderIcons := BorderIcons - [biMaximize];
end;

end.


