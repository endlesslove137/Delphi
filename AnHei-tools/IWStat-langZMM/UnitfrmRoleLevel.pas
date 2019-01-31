unit UnitfrmRoleLevel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, IWCompButton, IWCompEdit, IWTMSEdit, IWControl,
  IWTMSCal, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompLabel,
  AdvChart, IWAdvToolButton, IWTMSImgCtrls,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = 73;//'等级统计';

type
  TIWfrmRoleLevel = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    IWLabel2: TIWLabel;
    IWedtLevel: TIWEdit;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    IWLabel4: TIWLabel;
    TIWDateSelector1: TTIWDateSelector;
    TIWAdvTimeEdit1: TTIWAdvTimeEdit;
    pCDate: TTIWDateSelector;
    pCTime: TTIWAdvTimeEdit;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryRoleLevel(ServerIndex: Integer;MinDateTime,MaxDateTime,CreateDateTime: TDateTime);
  end;

var
  IWfrmRoleLevel: TIWfrmRoleLevel;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmRoleLevel.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pCDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  pCTime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel4.Caption := Langtostr(318);
  IWLabel2.Caption := Langtostr(319);
  IWBtnBuild.Caption := Langtostr(171);
end;

procedure TIWfrmRoleLevel.IWBtnBuildClick(Sender: TObject);
var
  Level: Integer;
  ServerListData: PTServerListData;
begin
  Level := StrToInt(IWedtLevel.Text);
  if (Level > objINI.MaxLevel) or (Level = 0) then
  begin
    WebApplication.ShowMessage(Langtostr(315)+IntToStr(objINI.MaxLevel)+Langtostr(316));
    Exit;
  end;
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      QueryRoleLevel(ServerListData.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time,pCDate.Date+pCTime.Time);
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

procedure TIWfrmRoleLevel.QueryRoleLevel(ServerIndex: Integer; MinDateTime,
  MaxDateTime,CreateDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT COUNT(1) AS iCount FROM actors WHERE serverindex=%d AND createtime < "%s" AND updatetime>= "%s" AND updatetime<="%s" AND level>%d AND level<=%d';
var
  I,Level,iCount,curLevel: Integer;
begin
  Level := StrToInt(IWedtLevel.Text);
  with UserSession.quRoleLevel,TIWAdvChart1.Chart do
  begin
    Series[0].ClearPoints;
    iCount := objINI.MaxLevel div Level;
    if objINI.MaxLevel mod Level > 0 then Inc(iCount);
    for I := 1 to iCount do
    begin
      curLevel := I*Level;
      if curLevel > objINI.MaxLevel then curLevel := objINI.MaxLevel;
      SQL.Text := Format(sqlRoleCount,[ServerIndex,DateTimeToStr(CreateDateTime),
                  DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime),I*Level-Level,curLevel]);
      Open;
      Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                IntToStr(I*Level-Level)+'-'+IntToStr(curLevel)+Langtostr(317));
      Close;
    end;
    Range.RangeFrom := 0;
    Range.RangeTo := iCount-1;
    Series[0].Autorange := arEnabledZeroBased;
  end;
  if iCount * objINI.AutoWidth < objINI.DefaultWidth then
    TIWAdvChart1.Width := objINI.DefaultWidth
  else
    TIWAdvChart1.Width := iCount * objINI.AutoWidth;
  TIWAdvChart1.Visible := True;
end;

initialization
  RegisterClass(TIWfrmRoleLevel);

end.
