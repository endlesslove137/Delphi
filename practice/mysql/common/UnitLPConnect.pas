unit UnitLPConnect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, COMLangPackLib;

type
  TfrmLPConnect = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FLPClient: ILangPackClient;
  public
    { Public declarations }
    function WaitFor(dwWaitMilSec: DWord = INFINITE): Integer;
    property LPClient: ILangPackClient read FLPClient write FLPClient;
  end;

implementation

{$R *.dfm}

function TfrmLPConnect.WaitFor(dwWaitMilSec: DWord): Integer;
var
  dwTimeOut: DWORD;
begin       
  Result := 0;

  if dwWaitMilSec <> INFINITE then
    dwTimeOut := GetTickCount() + dwWaitMilSec
  else dwTimeOut := INFINITE;

  Timer1Timer(Timer1);

  while Visible do
  begin
    if GetTickCount() >= dwTimeOut then
    begin
      Result := WAIT_TIMEOUT;
      break;
    end;
    Application.ProcessMessages();
  end;
end;

procedure TfrmLPConnect.Timer1Timer(Sender: TObject);
begin
  if not FLPClient.connected() then
  begin
    if not Visible then
    begin         
      Timer1.Interval := 10;
      ShowModal();
    end;  
    Panel2.Left := Panel2.Left + 2;
    if Panel2.Left >= Panel1.Width then
      Panel2.Left := -Panel2.Width;
  end
  else begin
    Close();
    Timer1.Interval := 1000;
  end;
end;

end.
