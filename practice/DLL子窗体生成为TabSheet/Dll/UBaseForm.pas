unit UBaseForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ActnList, ImgList, ToolWin;

const WM_MYMESSAGE=WM_USER+1;

type
  TFrmBaseForm = class(TForm)
    ActionList1: TActionList;
    close_event: TAction;
    ilBaseTool: TImageList;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    tbtPageFirst: TToolButton;
    tbtPagePrevious: TToolButton;
    tbtPageNext: TToolButton;
    tbtPageLast: TToolButton;
    ToolButton2: TToolButton;
    tbtClose: TToolButton;
    ToolButton3: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure close_eventExecute(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
  private
    { Private declarations }

  protected
      //--------------页签 ---------------//
    FParentControl: TWinControl;
    FParentHandle: THandle;
    FAsChild: Boolean;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;
    procedure InitComponent; dynamic;
  public
    { Public declarations }
    TabID: Integer; //TabSheet句柄
    MsgID: Cardinal; //消息ID
    piFlag: Integer;

    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; AParent: TWinControl); reintroduce; overload;
    constructor Create(AOwner: TComponent; AParentHandle: THandle); reintroduce; overload;
  end;



var
  FrmBaseForm: TFrmBaseForm;
  
implementation

{$R *.dfm}


constructor TFrmBaseForm.Create(AOwner: TComponent);
begin
  FAsChild := False;
  inherited Create(AOwner);
  InitComponent;

end;

constructor TFrmBaseForm.Create(AOwner: TComponent; AParent: TWinControl);
begin
  FAsChild := True;
  FParentControl := AParent;
  inherited Create(AOwner);
  InitComponent;
end;

constructor TFrmBaseForm.Create(AOwner: TComponent; AParentHandle: THandle);
begin
  FAsChild := True;
  FParentHandle := AParentHandle;
  inherited Create(AOwner);
  InitComponent;
end;

procedure TFrmBaseForm.CreateParams(var Params: TCreateParams);
begin
   inherited CreateParams(Params);
  if FAsChild then
    Params.Style := Params.Style or WS_CHILD;
end;

procedure TFrmBaseForm.InitComponent;
begin

end;

procedure TFrmBaseForm.Loaded;
begin
 inherited;
  if FAsChild then
  begin
    align := alClient;
    BorderStyle := bsNone;
    BorderIcons := [];
    if FParentHandle <> 0 then
    begin
      Parent := FindControl(FParentHandle);
    end
    else
    begin
      Parent := FParentControl;
    end;
    Position := poDefault;
  end;

end;

procedure TFrmBaseForm.FormCreate(Sender: TObject);
begin
  MsgID:=RegisterWindowMessage(pansichar('YESDLLOFCLOSE'));//主程序也得注册同名的消息
end;
{发送消息可以通过注册消息来实现，也可以通过发送自定义消息来实现}
procedure TFrmBaseForm.close_eventExecute(Sender: TObject);
var
  h:HWND;
begin
  Close; //这句可以不要，释放TabSheet时会自动释放窗体

  h:=FindWindow('TFrmMainForm',nil);
  if h<>0 then
  begin
    PostMessage(h,Self.MsgID,0,Self.TabID);
    //SendMessage(h,Self.MsgID,0,Self.TabID);//用SendMessage会报错:Abstract Error
  end;
end;

procedure TFrmBaseForm.ToolButton3Click(Sender: TObject);
var
  h:HWND;
begin
  h:=FindWindow('TFrmMainForm',nil);
  if h<>0 then
  begin
    PostMessage(h,WM_MYMESSAGE,0,Self.TabID);
    //SendMessage(h,Self.MsgID,0,Self.TabID);//用SendMessage会报错:Abstract Error
  end;
end;

end.
