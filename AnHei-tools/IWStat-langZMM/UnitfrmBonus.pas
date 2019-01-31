unit UnitfrmBonus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, IWCompButton, IWTMSCal, DateUtils,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompEdit,
  IWCompCheckbox;

const
  curTitle = 44;//'红利统计';

type
  TIWfrmBonus = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    IWLabel4: TIWLabel;
    TIWAdvChart1: TTIWAdvChart;
    TIWAdvChart2: TTIWAdvChart;
    IWLabARPU: TIWLabel;
    IWAmdbMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryBonus(samdb,spid: string;ServerIndex,ServerID: Integer;dRate: Double;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmBonus: TIWfrmBonus;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmBonus.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := IncDay(Now(),-DayOf(Now())+1);
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

procedure TIWfrmBonus.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  inherited;
  if pSDate.Date > pEDate.Date then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      QueryBonus(psld.Amdb,psld.spID,psld.Index,psld.ServerID,psld.CurrencyRate,pSDate.Date,pEDate.Date);
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

procedure TIWfrmBonus.QueryBonus(samdb,spid: string;ServerIndex, ServerID: Integer; dRate: Double;
  MinDateTime, MaxDateTime: TDateTime);
const
  sqlPayTotalMoney = 'SELECT date(orderdate),SUM(money) AS TotalMoney FROM %s.payorder WHERE yunying="_%s" AND type=2 AND %s orderdate>="%s" AND orderdate<="%s" GROUP BY date(orderdate)';
  sqlPayTotalMoney2 = 'SELECT date(orderdate),SUM(money) AS TotalMoney FROM %s.payorder_%s WHERE yunying="_%s" AND type=2 AND %s orderdate>="%s" AND orderdate<="%s" GROUP BY date(orderdate)';
  sqlPayTotalUser = 'SELECT date(orderdate),COUNT(DISTINCT account) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type=2 AND %s orderdate>="%s" AND orderdate<="%s" GROUP BY date(orderdate)';
  sqlPayTotalUser2 = 'SELECT date(orderdate),COUNT(DISTINCT account) AS iCount FROM %s.payorder_%s WHERE yunying="_%s" AND type=2 AND %s orderdate>="%s" AND orderdate<="%s" GROUP BY date(orderdate)';
  sqlServerIndex = 'serverid in (%s) AND';
  sTipText = 307;//'  自 %s 到 %s 的总计红利金额(RMB)为：%s，总计充值用户数为：%d ，ARPU值为：%.1f';
  sARPUText = 308;//' 今日红利金额(RMB)为：%s，充值用户数为：%d ，ARPU值为：%.1f';
var
  PayTotalUser,curUser,iCount: Integer;
  PayTotalMoney,curMoney,dValue: Double;
  sServerIndex: string;
begin
  sServerIndex := '';
  if ServerIndex <> 0 then sServerIndex := Format(sqlServerIndex,[GetJoinServerIndex(ServerIndex)]);
  TIWAdvChart1.Chart.Series[0].ClearPoints;
  TIWAdvChart2.Chart.Series[0].ClearPoints;

  with UserSession.quPay do
  begin
    if IWAmdbMode.Checked then
      SQL.Text := Format(sqlPayTotalMoney2,[samdb,FormatDateTime('YYYYMM',MinDateTime),spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime+StrToTime('23:59:59'))])
    else
    SQL.Text := Format(sqlPayTotalMoney,[samdb,spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime+StrToTime('23:59:59'))]);

    Open;
    PayTotalMoney := 0; PayTotalUser := 0;
    iCount := 0; curMoney := 0; curUser := 0;
    while not Eof do
    begin
      dValue := DivZero(FieldByName('TotalMoney').AsInteger,10) * dRate;
      curMoney := StrToFloat(Format('%.1f',[dValue]));
      PayTotalMoney := PayTotalMoney + curMoney;
      TIWAdvChart1.Chart.Series[0].AddSinglePoint(ChangeZero(curMoney),FormatDateTime('MM-DD',Fields[0].AsDateTime));
      Inc(iCount);
      Next;
    end;
    Close;
    TIWAdvChart1.Chart.Range.RangeFrom := 0;
    TIWAdvChart1.Chart.Range.RangeTo := iCount-1;
    TIWAdvChart1.Chart.Series[0].ValueFormat := objINI.RMBFormat;
    if iCount * (objINI.AutoWidth+20) < objINI.DefaultWidth then
      TIWAdvChart1.Width := objINI.DefaultWidth
    else
      TIWAdvChart1.Width := iCount * (objINI.AutoWidth+20);
    iCount := 0;
    if IWAmdbMode.Checked then
      SQL.Text := Format(sqlPayTotalUser2,[samdb,FormatDateTime('YYYYMM',MinDateTime),spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime+StrToTime('23:59:59'))])
    else
      SQL.Text := Format(sqlPayTotalUser,[samdb,spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime+StrToTime('23:59:59'))]);
    Open;
    while not Eof do
    begin
      curUser := FieldByName('iCount').AsInteger;
      TIWAdvChart2.Chart.Series[0].AddSinglePoint(ChangeZero(curUser),FormatDateTime('MM-DD',Fields[0].AsDateTime));
      Inc(PayTotalUser,curUser);
      Inc(iCount);
      Next;
    end;
    Close;
    TIWAdvChart2.Chart.Range.RangeFrom := 0;
    TIWAdvChart2.Chart.Range.RangeTo := iCount-1;
    if iCount * (objINI.AutoWidth+20) < objINI.DefaultWidth then
      TIWAdvChart2.Width := objINI.DefaultWidth
    else
      TIWAdvChart2.Width := iCount * (objINI.AutoWidth+20);
  end;
  dValue := PayTotalMoney;
  if dValue <> 0 then dValue := PayTotalMoney/PayTotalUser;
  IWLabel4.Caption := Format(Langtostr(sTipText),[FormatDateTime('YYYY-MM-DD',MinDateTime),FormatDateTime('YYYY-MM-DD',MaxDateTime),Format(objINI.RMBFormat,[PayTotalMoney]),PayTotalUser,dValue]);
  dValue := curMoney;
  if dValue <> 0 then dValue := curMoney/curUser;
  IWLabARPU.Caption := Format(Langtostr(sARPUText),[Format(objINI.RMBFormat,[curMoney]),curUser,dValue]);
  TIWAdvChart1.Visible := True;
  TIWAdvChart2.Visible := True;
end;

initialization
  RegisterClass(TIWfrmBonus);

end.
