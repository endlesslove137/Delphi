unit UnitfrmReputeRank;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, UnitfrmWebGrid, IWTMSImgCtrls, IWAdvToolButton,
  IWCompLabel, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWWebGrid, IWAdvWebGrid, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWCompListbox, IWExchangeBar,
  IWCompRectangle, IWTMSCtrls, IWCompEdit;

const
  curTitle = 69;//'声望排行统计';

type
  TIWfrmReputeRank = class(TIWfrmWebGrid)
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  IWfrmReputeRank: TIWfrmReputeRank;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

{ TIWfrmReputeRank }

procedure TIWfrmReputeRank.IWAppFormCreate(Sender: TObject);
const
  sqlsex = 365;
  sqlReputeRank = 'select accountname, actorname, IF(sex=0,';
  sqlReputeRank2 = '), %s,circle,level,qianlongling  from actors where (status & 2) = 2 order by qianlongling desc limit %d';
var
  psld: PTServerListData;
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(366);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(367);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(368);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(369);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(263);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(371);
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
    UserSession.quWebGrid.SQLConnection := UserSession.SQLConnectionRole;
    try
      QueryWebGrid(Format(sqlReputeRank + Langtostr(sqlsex) + sqlReputeRank2,[GetSQLJob,TopCount]));
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

initialization
  RegisterClass(TIWfrmReputeRank);
  
end.
