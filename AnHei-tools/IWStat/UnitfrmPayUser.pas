unit UnitfrmPayUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, IWCompButton, IWCompEdit,
  SqlExpr, IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;
  
const
  curTitle = 48;//'³äÖµÕËºÅÍ³¼Æ';
  PayUserChartColor : array [0..2] of Integer = (clRed, clGreen, clYellow);

type
  TIWfrmPayUser = class(TIWFormBasic)
    TIWAdvChart1: TTIWAdvChart;
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryPayUser(spid,samdb: string;ServerIndex, ServerID: Integer);
  end;

var
  IWfrmPayUser: TIWfrmPayUser;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

{ TIWfrmPayUser }

procedure TIWfrmPayUser.IWAppFormCreate(Sender: TObject);
var
  psld: PTServerListData;
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      QueryPayUser(psld.spID,psld.Amdb,psld.Index,psld.ServerID);
    finally
      UserSession.SQLConnectionRole.Close;
      UserSession.SQLConnectionSession.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmPayUser.QueryPayUser(spid,samdb: string;ServerIndex,ServerID: Integer);
const
  sqlAccount = 'SELECT COUNT(DISTINCT(accountname)) AS iCount FROM actors WHERE serverindex=%d';
  sqlPayUser = 'SELECT COUNT(DISTINCT(account)) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type in (1,3) AND serverid in (%s) ';
  sqlAddPay = 'SELECT COUNT(1) AS iCount FROM (SELECT account,COUNT(1) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type in (1,3) AND serverid in (%s) GROUP BY account) TMP WHERE iCount>1';
var
  iAccount,iPayUser,iAddPay: Integer;
  function GetQueryCount(SQLQuer: TSQLQuery): Integer;
  begin
    with SQLQuer do
    begin
      Open;
      try
        Result := Fields[0].AsInteger;
      finally
        Close;
      end;
    end;
  end;  
begin
  UserSession.quRole.SQL.Text := Format(sqlAccount,[ServerIndex]);
  iAccount := GetQueryCount(UserSession.quRole);
  UserSession.quPayUser.SQL.Text := Format(sqlPayUser,[samdb,spid,GetJoinServerIndex(ServerIndex)]);
  iPayUser := GetQueryCount(UserSession.quPayUser);
  UserSession.quPayUser.SQL.Text := Format(sqlAddPay,[samdb,spid,GetJoinServerIndex(ServerIndex)]);
  iAddPay := GetQueryCount(UserSession.quPayUser);
  with TIWAdvChart1,Chart do
  begin
    Series[0].ClearPoints;
    Series[0].AddSinglePoint(iAccount-iPayUser,PayUserChartColor[0],Langtostr(312) + IntToStr(iAccount-iPayUser) + ' ');
    Series[0].AddSinglePoint(iPayUser-iAddPay,PayUserChartColor[1],Langtostr(313) + IntToStr(iPayUser-iAddPay) + ' ');
    Series[0].AddSinglePoint(iAddPay,PayUserChartColor[2],Langtostr(314) + IntToStr(iAddPay) + ' ');
    Visible := True;
  end;
end;

initialization
  RegisterClass(TIWfrmPayUser);

end.
