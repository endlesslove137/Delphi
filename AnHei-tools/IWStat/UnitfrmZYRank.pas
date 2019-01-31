unit UnitfrmZYRank;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmWebGrid, IWCompEdit, IWCompButton, IWCompListbox,
  IWTMSImgCtrls, IWExchangeBar, IWCompLabel, IWCompRectangle, IWTMSCtrls,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl, IWWebGrid,
  IWAdvWebGrid, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion;

const
  curTitle = 'ÕóÓª¹±Ï×ÅÅÐÐ';
  
type
  TIWfrmZYRank = class(TIWfrmWebGrid)
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IWfrmZYRank: TIWfrmZYRank;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}
procedure TIWfrmZYRank.IWAppFormCreate(Sender: TObject);
const
  sqlZyRank = 'select accountname,actorname, IF(sex=0,"ÄÐ","Å®"), %s,circle,level, zycont from actors where (status & 2) = 2 order by zycont desc limit %d';
var
  ServerListData: PTServerListData;
begin
  inherited;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    UserSession.quWebGrid.SQLConnection := UserSession.SQLConnectionRole;
    try
      QueryWebGrid(Format(sqlZyRank,[GetSQLJob,TopCount]));
      TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;<b>%s TOP%d</b>',[curTitle,TopCount]);
    finally
      UserSession.SQLConnectionRole.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmZYRank);
  
end.
