unit UnitfrmMoneyRank;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, UnitfrmWebGrid, IWTMSImgCtrls, IWCompLabel,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWWebGrid, IWAdvWebGrid, IWVCLBaseContainer, IWContainer,
  IWHTMLContainer, IWHTML40Container, IWRegion, IWCompButton, IWCompListbox,
  IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompEdit;

const
  curTitle = 62;//'金币排行统计';
    
type
  TIWfrmMoneyRank = class(TIWfrmWebGrid)
    IWRegion2: TIWRegion;
    IWButton3: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  IWfrmMoneyRank: TIWfrmMoneyRank;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmMoneyRank.IWAppFormCreate(Sender: TObject);
const
  sqlsex = 365;
  sqlMoneyRank = 'select accountname, actorname, IF(sex=0,';
  sqlMoneyRank2 = '), %s,circle,level, (nonbindcoin) from actors where (status & 2) = 2 order by  nonbindcoin desc limit %d';
var
  psld: PTServerListData;
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
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(339);
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
    UserSession.quWebGrid.SQLConnection := UserSession.SQLConnectionRole;
    try
      QueryWebGrid(Format(sqlMoneyRank + Langtostr(sqlsex) + sqlMoneyRank2,[GetSQLJob,TopCount]));
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

procedure TIWfrmMoneyRank.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'MoneyRank' + DateToStr(Now) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

initialization
  RegisterClass(TIWfrmMoneyRank);

end.
