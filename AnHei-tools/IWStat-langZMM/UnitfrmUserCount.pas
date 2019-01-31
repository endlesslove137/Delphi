unit UnitfrmUserCount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWControl, IWTMSCal, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWCompLabel, DateUtils, AdvChart, IWAdvChart,
  IWAdvToolButton, IWTMSImgCtrls, IWCompListbox, IWExchangeBar,
  IWCompRectangle, IWTMSCtrls, IWCompEdit;

const
  curTitle = 33;//'用户数统计';

type
  TIWfrmUserCount = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    TIWAdvChart2: TTIWAdvChart;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryUserCount(spID: string;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmUserCount: TIWfrmUserCount;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmUserCount.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := IncDay(Now(),-6);
  pEDate.Date := Now();
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWBtnBuild.Caption := Langtostr(171);
end;

procedure TIWfrmUserCount.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date > pEDate.Date then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      QueryUserCount(psld.spID,pSDate.Date,pEDate.Date);
    finally
      UserSession.SQLConnectionSession.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmUserCount.QueryUserCount(spID: string;MinDateTime, MaxDateTime: TDateTime);
const
  sqlUserCount = 'SELECT date(createtime) AS UserCDate,COUNT(1) AS iCount FROM globaluser WHERE createtime>="%s" and createtime<="%s" %s GROUP BY date(createtime)';
  sqlTotalUCount = 'SELECT COUNT(1) AS iCount FROM globaluser WHERE createtime<"%s" %s';
var
  iCount,iTotalUserCount: Integer;
  sAccount: string;
begin
  sAccount := '';
  if THTType(objINI.HTType) = htJOINYuYing then
  begin
    sAccount := 'AND account like '+Quotedstr('%_'+spID);
  end;
  with UserSession.quUserCount do
  begin
    SQL.Text := format(sqlTotalUCount,[DateTimeToStr(MinDateTime),sAccount]);
    Open;
    iTotalUserCount := FieldByName('iCount').AsInteger;
    Close;
    SQL.Text := Format(sqlUserCount,[DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime+StrToTime('23:59:59')),sAccount]);
    Open;
    try
      iCount := 0;
      TIWAdvChart1.Chart.Series[0].ClearPoints;
      TIWAdvChart2.Chart.Series[0].ClearPoints;
      while not Eof do
      begin
        iTotalUserCount := iTotalUserCount + FieldByName('iCount').AsInteger;
        TIWAdvChart1.Chart.Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),FormatDateTime('MM-DD',FieldByName('UserCDate').AsDateTime));
        TIWAdvChart2.Chart.Series[0].AddSinglePoint(ChangeZero(iTotalUserCount),FormatDateTime('MM-DD',FieldByName('UserCDate').AsDateTime));
        Inc(iCount);
        Next;
      end;
    finally
      Close;
    end;
    TIWAdvChart1.Chart.Title.Text:= Langtostr(254);
    TIWAdvChart1.Chart.Range.RangeFrom := 0;
    TIWAdvChart1.Chart.Range.RangeTo := iCount-1;
    TIWAdvChart1.Chart.Series[0].Autorange := arEnabledZeroBased;
    if iCount * objINI.AutoWidth < objINI.DefaultWidth then
      TIWAdvChart1.Width := objINI.DefaultWidth
    else
      TIWAdvChart1.Width := iCount * objINI.AutoWidth;
    TIWAdvChart2.Chart.Title.Text:= Langtostr(255);
    TIWAdvChart2.Chart.Range.RangeFrom := 0;
    TIWAdvChart2.Chart.Range.RangeTo := iCount-1;
    TIWAdvChart2.Chart.Series[0].Autorange := arEnabledZeroBased;
    if iCount * objINI.AutoWidth < objINI.DefaultWidth then
      TIWAdvChart2.Width := objINI.DefaultWidth
    else
      TIWAdvChart2.Width := iCount * (objINI.AutoWidth+10);
  end;
  TIWAdvChart1.Visible := True;
  TIWAdvChart2.Visible := True;
end;

initialization
  RegisterClass(TIWfrmUserCount);

end.
