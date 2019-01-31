unit UnitfrmPayRoleLevel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompEdit, IWCompButton, IWTMSEdit, IWTMSCal,
  IWAdvChart, AdvChart, DateUtils, IWCompListbox, IWExchangeBar,
  IWCompRectangle, IWTMSCtrls;

const
  curTitle = 46;//'充值等级统计';

type
  TIWfrmPayRoleLevel = class(TIWFormBasic)
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
    IWLabel4: TIWLabel;
    pCDate: TTIWDateSelector;
    pCTime: TTIWAdvTimeEdit;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryPayRoleLevel(sgstatic: string;ServerIndex: Integer;MinDateTime,MaxDateTime,CreateDateTime: TDateTime);
  end;

var
  IWfrmPayRoleLevel: TIWfrmPayRoleLevel;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

{ TIWfrmPayRoleLevel }

procedure TIWfrmPayRoleLevel.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pCDate.Date := IncDay(Now(),-1);
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  pCTime.Time := StrToTime('00:00:00');
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

procedure TIWfrmPayRoleLevel.IWBtnBuildClick(Sender: TObject);
var
  Level: Integer;
  psld: PTServerListData;
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
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
    try
      QueryPayRoleLevel(psld.GstaticDB,psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time,pCDate.Date+pCTime.Time);
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

procedure TIWfrmPayRoleLevel.QueryPayRoleLevel(sgstatic: string;ServerIndex: Integer;
  MinDateTime, MaxDateTime, CreateDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT COUNT(1) AS iCount FROM %s.payuser c,actors a WHERE c.account=a.accountname AND a.serverindex=%d AND a.createtime < "%s" AND a.updatetime>= "%s" AND updatetime<="%s" AND a.level>%d AND a.level<=%d';
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
      SQL.Text := Format(sqlRoleCount,[sgstatic,ServerIndex,DateTimeToStr(CreateDateTime),
                  DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime),I*Level-Level,curLevel]);
      Open;
      Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                IntToStr(I*Level-Level)+'-'+IntToStr(curLevel)+langtostr(317));
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
  RegisterClass(TIWfrmPayRoleLevel);

end.
