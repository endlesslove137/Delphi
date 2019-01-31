unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

const WM_MYMESSAGE=WM_USER+1;

type
  TCallBaseForm=procedure(ParentApp:TApplication;FHandle:HWND);
  TFrmMainForm = class(TForm)
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MyMessage(var msg: TMessage); message WM_MYMESSAGE;
  private
    { Private declarations }
    MsgIDMain:Cardinal;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }

  end;

var
  FrmMainForm: TFrmMainForm;
  dllints:Cardinal;
implementation

{$R *.dfm}

procedure TFrmMainForm.Button1Click(Sender: TObject);
var
  FCallBack:TCallBaseForm;
  tbs:TTabSheet;
begin
  dllints:=LoadLibrary('../Dll/TestDll.dll');
  if dllints=0 then
    ShowMessage('‘ÿ»ÎDLL ß∞‹');
  tbs:=TTabSheet.Create(Application);
  tbs.Caption:='≤‚ ‘“≥«©';
  tbs.PageControl:=PageControl1;
  PageControl1.ActivePage:=tbs;
  FCallBack:=GetProcAddress(dllints,'CallTestForm');
  FCallBack(Application,tbs.Handle);
end;

procedure TFrmMainForm.WndProc(var Message: TMessage);
begin
  if Message.Msg=Self.MsgIDMain then
    TTabSheet(FindControl(Message.LParam)).Free
  else
    inherited;

end;

procedure TFrmMainForm.FormCreate(Sender: TObject);
begin
  Self.MsgIDMain:=RegisterWindowMessage(pansichar('YESDLLOFCLOSE'));
end;

procedure TFrmMainForm.MyMessage(var msg: TMessage);
begin
//
  if msg.Msg=WM_MYMESSAGE then
  begin
    TTabSheet(FindControl(msg.LParam)).Destroy;  
  end;
end;

end.
