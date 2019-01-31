unit UnitfrmGameEngineList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWTMSImgCtrls, IWCompButton, IWCompListbox,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWWebGrid,
  IWAdvWebGrid;

type
  TIWfrmGameEngineList = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWBtnBuild: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IWfrmGameEngineList: TIWfrmGameEngineList;

implementation

uses ServerController, ConfigINI, GSManageServer;

{$R *.dfm}

procedure TIWfrmGameEngineList.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbGameEngineList]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbGameEngineList]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbGameEngineList])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
end;

procedure TIWfrmGameEngineList.IWBtnBuildClick(Sender: TObject);
var
  I,iCount: Integer;
  GSConnection: TGSConnection;
begin
  inherited;
  iCount := FGSMServer.FConnectionList.Count;
  TIWAdvWebGrid1.ClearCells;
  TIWAdvWebGrid1.RowCount := iCount;
  TIWAdvWebGrid1.TotalRows := iCount;
  for I := 0 to iCount-1 do
  begin
    GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
    TIWAdvWebGrid1.Cells[1,I] := GSConnection.ServerName;
    TIWAdvWebGrid1.Cells[2,I] := GSConnection.spid;
    TIWAdvWebGrid1.Cells[3,I] := Format('%s:%d',[GSConnection.RemoteAddress,GSConnection.RemotePort]);
    TIWAdvWebGrid1.Cells[4,I] := IntToStr(GSConnection.ServerIndex);
  end;
  TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;&nbsp;&nbsp;共 %d 个已连接引擎 &nbsp;&nbsp;',[iCount]);
end;

end.
