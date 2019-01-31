unit UTestForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UBaseForm, ImgList, ActnList, ComCtrls, ToolWin, StdCtrls;

type
  TFrmTestForm = class(TFrmBaseForm)
    Button1: TButton;
    Edit1: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure CallTestForm(ParnentApp:TApplication;FHandle:HWND);

var
  FrmTestForm: TFrmTestForm;

implementation

{$R *.dfm}
procedure CallTestForm(ParnentApp:TApplication;FHandle:HWND);
begin
  Application:=ParnentApp;
  FrmTestForm:=TFrmTestForm.Create(Application,FHandle);
  FrmTestForm.TabID:=FHandle;
  FrmTestForm.Show;    
end;
procedure TFrmTestForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  //
end;

end.
