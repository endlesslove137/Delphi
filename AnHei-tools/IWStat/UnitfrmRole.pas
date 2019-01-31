unit UnitfrmRole;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, IWCompButton, IWCompEdit, IWTMSEdit, IWControl,
  IWTMSCal, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompLabel,
  IWAdvToolButton, IWTMSImgCtrls, IWCompListbox, IWExchangeBar,
  IWCompRectangle, IWTMSCtrls;

const
  curTitle = 72;//'职业统计';

type
  TIWfrmRole = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    TIWAdvChart1: TTIWAdvChart;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryRole(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);    
  end;

var
  IWfrmRole: TIWfrmRole;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmRole.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  TIWAdvChart1.Chart.Title.Text := Langtostr(374);

  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWBtnBuild.Caption := Langtostr(171);
end;

procedure TIWfrmRole.IWBtnBuildClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      QueryRole(ServerListData.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
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

procedure TIWfrmRole.QueryRole(ServerIndex: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT job,COUNT(1) AS iCount FROM actors WHERE serverindex = %d AND updatetime>= "%s" AND updatetime<="%s" GROUP BY job';
var
  iCount,iColor,iTotal: Integer;
begin
  with UserSession.quRoleCount,TIWAdvChart1.Chart do
  begin
    SQL.Text := Format(sqlRoleCount,[ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]);
    Open;
    try
      iCount := 0; iColor := $FFFFFF; iTotal := 0;
      Series[0].ClearPoints;
      while not Eof do
      begin
        if iCount <= Length(RoleChartColor) then
          iColor := RoleChartColor[iCount];
        Series[0].AddSinglePoint(FieldByName('iCount').AsInteger,iColor,Langtostr(sRoleJob[FieldByName('job').AsInteger]) + ' ' + IntToStr(FieldByName('iCount').AsInteger) + ' ');
        Inc(iTotal,FieldByName('iCount').AsInteger);
        Inc(iCount);
        Next;
      end;
    finally
      Close;
    end;
    TIWAdvChart1.Chart.Title.Text := Format(Langtostr(374),[iTotal]);
  end;
  TIWAdvChart1.Visible := True;
end;

initialization
  RegisterClass(TIWfrmRole);

end.
