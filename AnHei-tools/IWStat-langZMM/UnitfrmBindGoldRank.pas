unit UnitfrmBindGoldRank;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, UnitfrmWebGrid, IWCompEdit, IWCompButton, IWCompListbox,
  IWTMSImgCtrls, IWExchangeBar, IWCompLabel, IWCompRectangle, IWTMSCtrls,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl, IWWebGrid,
  IWAdvWebGrid, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion;

const
  curTitle = 64;//'¿Ò»Ø≈≈––Õ≥º∆';

type
  TIWfrmBindGold = class(TIWfrmWebGrid)
    IWRegion2: TIWRegion;
    IWButton3: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IWfrmBindGold: TIWfrmBindGold;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmBindGold.IWAppFormCreate(Sender: TObject);
const
  sqlsex = 365;
  sqlGoldRank = 'select accountname, actorname, IF(sex=0,';
  sqlGoldRank2 = '), %s,circle,level, bindyuanbao from actors where (status & 2) = 2 order by  bindyuanbao desc limit %d';
var
  ServerListData: PTServerListData;
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWButton3.Caption := Langtostr(182);
  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(366);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(367);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(368);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(369);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(263);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(340);
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    UserSession.quWebGrid.SQLConnection := UserSession.SQLConnectionRole;
    try
      QueryWebGrid(Format(sqlGoldRank + Langtostr(sqlsex) + sqlGoldRank2,[GetSQLJob,TopCount]));
      TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;<b>%s TOP%d</b>',[Langtostr(curTitle),TopCount]);
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

procedure TIWfrmBindGold.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'BindGold' + DateToStr(Now) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

initialization
  RegisterClass(TIWfrmBindGold);

end.
