unit UnitIWfrmPay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, IWCompButton, IWControl, IWTMSCal,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompLabel,DateUtils, AdvChart,
  IWAdvToolButton, IWTMSImgCtrls, IWCompListbox, IWExchangeBar,
  IWCompRectangle, IWTMSCtrls, IWCompEdit, IWWebGrid, IWAdvWebGrid,
  IWCompCheckbox;

const
  curTitle = 41;//'充值统计';

type
  TIWfrmPay = class(TIWFormBasic)
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
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton3: TIWButton;
    IWAmdbMode: TIWCheckBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryPay(samdb,spid: string;ServerIndex,ServerID: Integer;dRate: Double;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmPay: TIWfrmPay;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmPay.IWAppFormCreate(Sender: TObject);
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

procedure TIWfrmPay.IWBtnBuildClick(Sender: TObject);
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
      QueryPay(psld.Amdb,psld.spID,psld.Index,psld.ServerID,psld.CurrencyRate,pSDate.Date,pEDate.Date);
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

procedure TIWfrmPay.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'Pay' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmPay.QueryPay(samdb, spid: string;ServerIndex,ServerID: Integer;dRate: Double;MinDateTime, MaxDateTime: TDateTime);
const
  sqlPayTotalMoney = 'SELECT date(orderdate),SUM(rmb) AS TotalMoney FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND %s orderdate>="%s" AND orderdate<="%s" GROUP BY date(orderdate)';
  sqlPayTotalUser = 'SELECT COUNT(DISTINCT account) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND %s orderdate>="%s" AND orderdate<="%s"';
  sqlPayUser = 'SELECT date(orderdate),COUNT(DISTINCT account) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND %s orderdate>="%s" AND orderdate<="%s" GROUP BY date(orderdate)';
  sqlPayTotalMoney2 = 'SELECT date(orderdate),SUM(rmb) AS TotalMoney FROM %s.payorder_%s WHERE yunying="_%s" AND type = 3 and state = 1 AND %s orderdate>="%s" AND orderdate<="%s" GROUP BY date(orderdate)';
  sqlPayTotalUser2 = 'SELECT COUNT(DISTINCT account) AS iCount FROM %s.payorder_%s WHERE yunying="_%s" AND type = 3 and state = 1 AND %s orderdate>="%s" AND orderdate<="%s"';
  sqlPayUser2 = 'SELECT date(orderdate),COUNT(DISTINCT account) AS iCount FROM %s.payorder_%s WHERE yunying="_%s" AND type = 3 and state = 1 AND %s orderdate>="%s" AND orderdate<="%s" GROUP BY date(orderdate)';
  sqlServerIndex = 'serverid in (%s) AND';
  sTipText = 307;//'  自 %s 到 %s 的总计充值金额(RMB)为：%s，总计充值用户数为：%d ，ARPU值为：%.1f';
  sARPUText = 308;//' 今日充值金额(RMB)为：%s，充值用户数为：%d ，ARPU值为：%.1f';
var
  PayTotalUser,curUser,iCount,iCount2: Integer;
  PayTotalMoney,curMoney,dValue: Double;
  sServerIndex: string;
  PayMinTime, PayMinTime2: TDateTime;
begin
  sServerIndex := '';
  if ServerIndex <> 0 then sServerIndex := Format(sqlServerIndex,[GetJoinServerIndex(ServerIndex)]);
  TIWAdvChart1.Chart.Series[0].ClearPoints;
  TIWAdvChart2.Chart.Series[0].ClearPoints;
  TIWAdvWebGrid1.ClearCells;
  with UserSession.quPay do
  begin
    if IWAmdbMode.Checked then
     SQL.Text := Format(sqlPayTotalMoney2,[samdb,FormatDateTime('YYYYMM',MinDateTime),spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime+StrToTime('23:59:59'))])
    else
    SQL.Text := Format(sqlPayTotalMoney,[samdb,spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime+StrToTime('23:59:59'))]);
    Open;
    PayTotalMoney := 0;
    iCount := 0; curMoney := 0; curUser := 0;
    PayMinTime := Fields[0].AsDateTime;
    while not Eof do
    begin
      TIWAdvWebGrid1.RowCount := iCount + 1;
      dValue := DivZero(FieldByName('TotalMoney').AsInteger,dRate);
      //  dValue := DivZero(FieldByName('TotalMoney').AsInteger,10) * dRate;
      curMoney := StrToFloat(Format('%.1f',[dValue]));
      PayTotalMoney := PayTotalMoney + curMoney;
      TIWAdvChart1.Chart.Series[0].AddSinglePoint(ChangeZero(curMoney),FormatDateTime('MM-DD',Fields[0].AsDateTime));
      TIWAdvWebGrid1.cells[1,iCount] := FormatDateTime('MM-DD',Fields[0].AsDateTime);
      TIWAdvWebGrid1.cells[2,iCount] := Format(objINI.RMBFormat,[curMoney]);
      Inc(iCount);
      Next;
      PayMinTime := PayMinTime+1;
      while not SameDateTime(TDate(PayMinTime),TDate(Fields[0].AsDateTime)) and not Eof do
      begin
        TIWAdvWebGrid1.RowCount := iCount + 1;
        TIWAdvChart1.Chart.Series[0].AddSinglePoint(-1,FormatDateTime('MM-DD',PayMinTime));
        TIWAdvWebGrid1.cells[1,iCount] := FormatDateTime('MM-DD',PayMinTime);
        TIWAdvWebGrid1.cells[2,iCount] := '0';
        PayMinTime := PayMinTime+1;
        Inc(iCount);
      end;
    end;
    Close;
    TIWAdvChart1.Chart.Range.RangeFrom := 0;
    TIWAdvChart1.Chart.Range.RangeTo := iCount-1;
    TIWAdvChart1.Chart.Series[0].ValueFormat := objINI.RMBFormat;
    if iCount * (objINI.AutoWidth+20) < objINI.DefaultWidth then
      TIWAdvChart1.Width := objINI.DefaultWidth
    else
      TIWAdvChart1.Width := iCount * (objINI.AutoWidth+20);
    iCount := 0; iCount2 := 0;
    if IWAmdbMode.Checked then
      SQL.Text := Format(sqlPayUser2,[samdb,FormatDateTime('YYYYMM',MinDateTime),spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime+StrToTime('23:59:59'))])
    else
    SQL.Text := Format(sqlPayUser,[samdb,spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime+StrToTime('23:59:59'))]);

    Open;
    PayMinTime2 := Fields[0].AsDateTime;
    while not Eof do
    begin
      TIWAdvWebGrid1.RowCount := iCount2 + 1;
      curUser := FieldByName('iCount').AsInteger;
      TIWAdvChart2.Chart.Series[0].AddSinglePoint(ChangeZero(curUser),FormatDateTime('MM-DD',Fields[0].AsDateTime));
      TIWAdvWebGrid1.cells[3,iCount2] := IntToStr(curUser);
      Inc(iCount);
      Inc(iCount2);
      Next;
      PayMinTime2 := PayMinTime2+1;
      while not SameDateTime(TDate(PayMinTime2),TDate(Fields[0].AsDateTime)) and not Eof do
      begin
        TIWAdvWebGrid1.RowCount := iCount2 + 1;
        TIWAdvWebGrid1.cells[3,iCount2] := '0';
        PayMinTime2 := PayMinTime2+1;
        Inc(iCount2);
      end;
    end;
    Close;
    if IWAmdbMode.Checked then
      SQL.Text := Format(sqlPayTotalUser2,[samdb,FormatDateTime('YYYYMM',MinDateTime),spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime+StrToTime('23:59:59'))])
    else
     SQL.Text := Format(sqlPayTotalUser,[samdb,spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime+StrToTime('23:59:59'))]);
    Open;
    PayTotalUser := Fields[0].AsInteger;
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
  RegisterClass(TIWfrmPay);

end.
