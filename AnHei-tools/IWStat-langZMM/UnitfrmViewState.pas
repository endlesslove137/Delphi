unit UnitfrmViewState;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl, IWAdvToolButton,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompLabel,
  IWVCLBaseContainer, IWContainer, IWHTMLContainer, IWHTML40Container,
  IWRegion, IWCompButton, IWCompEdit, IWCompListbox, IWCompRectangle,
  IWTMSCtrls, IWWebGrid, IWExchangeBar, IWCompMemo, IWAdvWebGrid,
  IWBaseComponent, IWBaseHTMLComponent, IWBaseHTML40Component, IWExtCtrls;

const
  curTitle = '系统状态列表';

type
  TIWfrmViewState = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWRegion3: TIWRegion;
    IWBtnBuild: TIWButton;
    IWTimerResult: TIWTimer;
    IWMemo1: TIWMemo;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
  private
    { Private declarations }
   procedure LoadGameStateList;
  public
  end;

var
  IWfrmViewState: TIWfrmViewState;

implementation

uses ServerController, ConfigINI, GSManageServer;

{$R *.dfm}

{ TIWfrmViewState }

procedure TIWfrmViewState.LoadGameStateList;
var
  i :Integer;
begin
   IWMemo1.Clear;
   for i := 0 to GameStateList.Count-1 do
   begin
     IWMemo1.Lines.Add(GameStateList.Strings[i]);
   end;
end;

procedure TIWfrmViewState.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  LoadGameStateList;
end;

procedure TIWfrmViewState.IWBtnBuildClick(Sender: TObject);
var
   I,SID: Integer;
   m_Server: TGSConnection;
   GSConnection: TGSConnection;
begin
  inherited;
  GameStateList.Clear;
  for i := 0 to FGSMServer.FConnectionList.Count-1 do
  begin
    GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
    m_Server := FGSMServer.GetServerByIndex(GSConnection.spid, GSConnection.ServerIndex);
    if m_Server <> nil then
    begin
       SID := SessionIDList.IndexOf(WebApplication.AppID);
       if SID <> -1 then
       begin
          m_Server.SendViewState(SID);
       end;
    end;
  end;
  IWTimerResult.Enabled := False;
  IWTimerResult.Enabled := True;
end;

procedure TIWfrmViewState.IWTimerResultTimer(Sender: TObject);
begin
  inherited;
  LoadGameStateList;
  IWTimerResult.Enabled := False;
end;

initialization
  RegisterClass(TIWfrmViewState);

end.
