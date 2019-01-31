unit UnitfrmOverview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWAdvChart,
  IWTMSCal, IWCompCheckbox;

type
  TIWfrmOverview = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegionStat: TIWRegion;
    TIWHTMLLabPayMoney: TTIWHTMLLabel;
    TIWHTMLLabPayCount: TTIWHTMLLabel;
    TIWHTMLLabConsumeMoney: TTIWHTMLLabel;
    TIWHTMLLabConsumeCount: TTIWHTMLLabel;
    TIWHTMLLabOnlineCount: TTIWHTMLLabel;
    TIWHTMLLabRegCount: TTIWHTMLLabel;
    TIWHTMLLabServer: TTIWHTMLLabel;
    TIWHTMLLabOpenServer: TTIWHTMLLabel;
    TIWAdvChartPay: TTIWAdvChart;
    TIWAdvChartOnline: TTIWAdvChart;
    IWButton1: TIWButton;
    IWAmdbMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWcBoxZJHTServersChange(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure GetServerStatData;
    procedure PayStatChart(samdb,ServerID: string;dMinDate,dMaxDate: TDate; dRate: Double);
    procedure OnlineRegStatChart(Idx: Integer;InServer: string;dMinDate, dMaxDate: TDate);
    function GetServerFirstOpenTime(SPID: string): TDateTime;
  end;

var
  IWfrmOverview: TIWfrmOverview;

implementation

uses ConfigINI, ServerController, DateUtils, Share;

{$R *.dfm}

{ TIWfrmOverview }

function TIWfrmOverview.GetServerFirstOpenTime(SPID: string): TDateTime;
var
  I: Integer;
  psld: PTServerListData;
begin
  Result := Now;
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := PTServerListData(ServerList.Objects[I]);
    if (psld^.spID = SPID) and (psld^.Index <> 0)  then
    begin
      Result := StrToDateTime(psld^.OpenTime);
      break;
    end;
  end;
end;

procedure TIWfrmOverview.GetServerStatData;
const
{  ServerTitle = '<br><p>&nbsp;服务器名称：%s</p>';
  OpenServerTitle = '<br><p>&nbsp;已开区：%d天 &nbsp;&nbsp;  开服时间：%s</p>';
  PayMoneyTitle = '<br><p>&nbsp;今日充值金额：￥%s</p><p>&nbsp;总充值金额：<FONT color="#FF0000"><B>￥%s</B></FONT></p><p>&nbsp;最高充值金额：%s &nbsp;&nbsp; %s</p>';
  PayCountTitle = '<br><p>&nbsp;今日充值人数：%d &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 今日ARPU值：￥%s</p><p>&nbsp;总充值人数：<FONT color="#FF0000"><B>%d</B></FONT></p>&nbsp;平均ARPU值：<FONT color="#FF0000"><B>￥%s</B></FONT>';
  DayConsumeTitle = '<br><p>&nbsp;今日消费金额：￥%s</p><p>&nbsp;总消费金额：￥%s</p>';
  MaxConsumeTitle = '<br><p>&nbsp;充值余额：<FONT color="#FF0000"><B>￥%s  （%s）</B></FONT></p><p>&nbsp;最高消费金额：￥%s  &nbsp;&nbsp; %s</p>';
  OnlineCountTitle = '<br><p>&nbsp;当前在线：<FONT color="#FF0000"><B>%d</B></FONT></p><p>&nbsp;最高在线：%d &nbsp;&nbsp; %s</p><p>&nbsp;平均在线：%d</p>';
  RegCountTitle = '<br><p>&nbsp;今日注册量：%d &nbsp;&nbsp;&nbsp; 今日登陆账号：%d</p><p>&nbsp;总注册量：%d</p><p>&nbsp;最高注册量：%d &nbsp;&nbsp; %s</p>';
} ServerTitle = 152;
  OpenServerTitle = 153;
  PayMoneyTitle = 154;
  PayCountTitle = 155;
  DayConsumeTitle = 156;
  MaxConsumeTitle = 157;
  OnlineCountTitle = 158;
  RegCountTitle = 159;

  sqlDayPay = 'SELECT %s FROM %s.payorder WHERE orderdate>="%s 00:00:00" AND orderdate<="%s 23:59:59" AND type = 3 and state = 1 ';
  sqlTotalPay = 'SELECT %s FROM %s.payorder WHERE orderdate>="%s 00:00:00" AND orderdate<="%s 23:59:59"'+' AND type = 3 and state = 1 ';
  sqlMaxPayMoney = 'SELECT MAX(CONCAT(length(floor(money)),"/",money,"/",orderdate)) FROM (SELECT date(orderdate) AS orderdate,SUM(money) AS money FROM %s.payorder WHERE orderdate>="%s 00:00:00" AND orderdate<="%s 23:59:59" '+'AND type = 3 and state = 1 %s GROUP BY date(orderdate)) tmp ';
  sqlDayPay2 = 'SELECT %s FROM %s.payorder_%s WHERE orderdate>="%s 00:00:00" AND orderdate<="%s 23:59:59" AND type = 3 and state = 1 ';
  sqlTotalPay2 = 'SELECT %s FROM %s.payorder_%s WHERE orderdate>="%s 00:00:00" AND orderdate<="%s 23:59:59"'+' AND type = 3 and state = 1 ';
  sqlMaxPayMoney2 = 'SELECT MAX(CONCAT(length(floor(money)),"/",money,"/",orderdate)) FROM (SELECT date(orderdate) AS orderdate,SUM(money) AS money FROM %s.payorder_%s WHERE orderdate>="%s 00:00:00" AND orderdate<="%s 23:59:59" '+'AND type = 3 and state = 1 %s GROUP BY date(orderdate)) tmp ';

  sqlDayConsume = 'SELECT %s FROM log_consume_%s WHERE account not in (SELECT account FROM %s.insideraccount) and logid not in (122,142) AND paymentcount<=0 AND moneytype=3 ';
  sqlOnlineCount = 'SELECT onlinecount FROM (SELECT serverindex,max(logdate)as ldate FROM log_onlinecount_%s WHERE onlinecount>0 group by serverindex)a LEFT JOIN log_onlinecount_%s b ON a.ldate=b.logdate AND a.serverindex=b.serverindex WHERE a.serverindex=%d';
  sqlMaxOnlineCount = 'SELECT MAX(CONCAT(length(floor(onlinecount)),"/",onlinecount,"/",logdate)) FROM log_onlinecount_%s ';
  sqlRegCount = 'SELECT COUNT(1) FROM globaluser WHERE createtime>="%s 00:00:00" AND createtime<="%s 23:59:59"';
  sqlTotalRegCount = 'SELECT COUNT(1) FROM globaluser';
  sqlMaxRegCount ='SELECT MAX(CONCAT(length(floor(iCount)),"/",iCount,"/",createtime)) FROM (SELECT date(createdate) AS createdate,COUNT(1) AS iCount FROM globaluser WHERE createtime>="%s 00:00:00" AND createtime<="%s 23:59:59" GROUP BY date(createtime)) tmp';
  sqlLoginCount = 'SELECT COUNT(DISTINCT account) FROM log_login_%s WHERE Logid = 7 '{1};
var
  psld: PTServerListData;
  MinDT: TDate;
  OpenServerTime: TDateTime;
  ServerID,ServerIndex,InServer: string;
  dDayPayMoney,dTotalPayMoney,dTotalConsumeMoney: Double;
  DayPayMoney,TotalPayMoney,MaxPayMoney,MaxPayTime: string;
  DayPayCount,TotalPayCount,MaxConsumeCount,iTmp: Integer;
  OnlineCount,MaxOnlineCount,AVGOnlineCount: Integer;
  DayConsumeMoney,TotalConsumeMoney,RemainingMoney,RemainingRate,MaxConsumeTime,MaxConsumeMoney: string;
  MaxOnlineTime,MaxRegTime,tmpSQL: string;
  DayRegCount,TotalRegCount,MaxRegCount,DayLoginCount, iCount: Integer;
  AVGValue: array of Integer;
  function GetParameterStrValue(Str: string;iPos: Integer): string;
  var
    I: Integer;
    strTmp: string;
  begin
    Result := '';
    strTmp := Str+'/';
    for I := 0 to iPos - 1 do
    begin
      Result := Copy(strTmp,1,Pos('/',strTmp)-1);
      System.Delete(strTmp,1,Pos('/',strTmp));
    end;
  end;
  function GetAVGValue(xx:array of integer): integer;
  var
    t: integer;
  begin
    Result := 0;
    for t := low(xx) to high(xx) do
      result := result + xx[t];
    result := result div (high(xx) - low(xx) + 1);
  end;
begin
  TIWHTMLLabServer.HTMLText := Format(Langtostr(ServerTitle),[UserSession.pServerName]);
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    if psld.Index = 0 then
    begin
      ServerID := '';
      ServerIndex := '';
      InServer := '';
      OpenServerTime := GetServerFirstOpenTime(psld.spID);
    end
    else begin
      ServerID := Format(' AND serverid in (%s) ',[GetJoinServerIndex(psld.Index)]);
      ServerIndex := Format(' AND serverindex=%d ',[psld.Index]);
      InServer := Format(' AND inserver=%d',[psld.Index]);
      OpenServerTime := StrToDateTime(psld.OpenTime);
    end;
    TIWHTMLLabOpenServer.HTMLText := Format(Langtostr(OpenServerTitle),[DaysBetween(OpenServerTime,Now),FormatDateTime('YYYY/MM/DD HH:MM:SS',OpenServerTime)]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      with UserSession.quPay do
      begin                                    //SUM(Money)
        if IWAmdbMode.Checked then
          SQL.Text := Format(sqlDayPay2+ServerID,['SUM(rmb)',psld.Amdb,FormatDateTime('YYYYMM',pSDate.Date),DateToSTr(Date),DateToSTr(Date)])
        else
          SQL.Text := Format(sqlDayPay+ServerID,['SUM(rmb)',psld.Amdb,DateToSTr(Date),DateToSTr(Date)]);
        Open;
       // dDayPayMoney := DivZero(Fields[0].AsInteger,10);
        dDayPayMoney := DivZero(Fields[0].AsInteger,psld.CurrencyRate);
        DayPayMoney := Format(objINI.RMBFormat,[dDayPayMoney]);
        Close;                          //SUM(Money)
        if IWAmdbMode.Checked then
          SQL.Text := Format(sqlTotalPay2,['SUM(rmb)',psld.Amdb,FormatDateTime('YYYYMM',pSDate.Date),DateToSTr(pSDate.Date),DateToSTr(pEDate.Date)])+ServerID
        else
          SQL.Text := Format(sqlTotalPay,['SUM(rmb)',psld.Amdb,DateToSTr(pSDate.Date),DateToSTr(pEDate.Date)])+ServerID;
        Open;
        //dTotalPayMoney := DivZero(Fields[0].AsInteger,10);
        dTotalPayMoney := DivZero(Fields[0].AsInteger,psld.CurrencyRate);
        TotalPayMoney := Format(objINI.RMBFormat,[dTotalPayMoney]);
        Close;
        if IWAmdbMode.Checked then
          SQL.Text := Format(sqlMaxPayMoney2,[psld.Amdb,FormatDateTime('YYYYMM',pSDate.Date),DateToSTr(pSDate.Date),DateToSTr(pEDate.Date),ServerID])
        else
          SQL.Text := Format(sqlMaxPayMoney,[psld.Amdb,DateToSTr(pSDate.Date),DateToSTr(pEDate.Date),ServerID]);
        Open;
        TryStrToInt(GetParameterStrValue(Fields[0].AsString,2),iTmp);
        //MaxPayMoney := Format(objINI.RMBFormat,[DivZero(iTmp,10)]);
        MaxPayMoney := Format(objINI.RMBFormat,[DivZero(iTmp / 10,psld.CurrencyRate)]);
        MaxPayTime := GetParameterStrValue(Fields[0].AsString,3);
        TIWHTMLLabPayMoney.HTMLText := Format(Langtostr(PayMoneyTitle),[DayPayMoney,TotalPayMoney,MaxPayMoney,MaxPayTime]);
        Close;
        if IWAmdbMode.Checked then
          SQL.Text := Format(sqlDayPay2+ServerID,['COUNT(DISTINCT account)',psld.Amdb,FormatDateTime('YYYYMM',pSDate.Date),DateToSTr(Date),DateToSTr(Date)])
        else
          SQL.Text := Format(sqlDayPay+ServerID,['COUNT(DISTINCT account)',psld.Amdb,DateToSTr(Date),DateToSTr(Date)]);
        Open;
        DayPayCount := Fields[0].AsInteger;
        Close;
        if IWAmdbMode.Checked then
         SQL.Text := Format(sqlTotalPay2+ServerID,['COUNT(DISTINCT account)',psld.Amdb,FormatDateTime('YYYYMM',pSDate.Date),DateToSTr(pSDate.Date),DateToSTr(pEDate.Date)])
        else
         SQL.Text := Format(sqlTotalPay+ServerID,['COUNT(DISTINCT account)',psld.Amdb,DateToSTr(pSDate.Date),DateToSTr(pEDate.Date)]);
        Open;
        TotalPayCount := Fields[0].AsInteger;
        Close;
        TIWHTMLLabPayCount.HTMLText := Format(Langtostr(PayCountTitle),[DayPayCount,Format(objINI.RMBFormat,[DivZero(dDayPayMoney,DayPayCount)]),
              TotalPayCount,Format(objINI.RMBFormat,[DivZero(dTotalPayMoney,TotalPayCount)])]);
      end;
      with UserSession.quConsume,TIWAdvChartPay.Chart do
      begin
        Series[0].ClearPoints;
        Series[1].ClearPoints;  iCount := 0;
         //新增检测列表是否存在
        if UserSession.IsCheckConTable(psld.LogDB,Format('log_consume_%s',[FormatDateTime('YYYYMMDD',Date)])) then
        begin
          SQL.Text := Format(sqlDayConsume+ServerIndex,['SUM(paymentcount*-1)',FormatDateTime('YYYYMMDD',Date), psld.GstaticDB]);
          Open;
          DayConsumeMoney := Format(objINI.RMBFormat,[DivZero(Fields[0].AsInteger,10) ]);
       //   DayConsumeMoney := Format(objINI.RMBFormat,[DivZero(Fields[0].AsInteger / 10 ,psld.CurrencyRate)]);
          Close;
        end;
        MinDT := pSDate.Date;  dTotalConsumeMoney := 0; MaxConsumeCount := 0;
        while MinDT<=pEDate.Date do
        begin
          //新增检测列表是否存在
          if UserSession.IsCheckConTable(psld.LogDB,Format('log_consume_%s',[FormatDateTime('YYYYMMDD',MinDT)])) then
          begin
            SQL.Text := Format(sqlDayConsume+ServerIndex,['SUM(paymentcount*-1)',FormatDateTime('YYYYMMDD',MinDT), psld.GstaticDB]);
            Open;
            Series[1].AddSinglePoint(ChangeZero(DivZero(Fields[0].AsInteger,10)),FormatDateTime('MM-DD',MinDT));
           // Series[1].AddSinglePoint(ChangeZero(DivZero(Fields[0].AsInteger / 10,psld.CurrencyRate)),FormatDateTime('MM-DD',MinDT));
            dTotalConsumeMoney := dTotalConsumeMoney + DivZero(Fields[0].AsInteger,10);
          //  dTotalConsumeMoney := dTotalConsumeMoney + DivZero(Fields[0].AsInteger / 10 ,psld.CurrencyRate);
            if Fields[0].AsInteger > MaxConsumeCount then
            begin
              MaxConsumeCount := Fields[0].AsInteger;
              MaxConsumeTime := FormatDateTime('YYYY/MM/DD',MinDT);
            end;
            Close;
            Inc(iCount);
          end;
          MinDT := MinDT+1;
        end;
        TotalConsumeMoney := Format(objINI.RMBFormat,[dTotalConsumeMoney]);
        TIWAdvChartPay.Chart.Range.RangeFrom := 0;
        TIWAdvChartPay.Chart.Range.RangeTo := iCount-1;
        TIWAdvChartOnline.Chart.Title.Text:= Langtostr(160);
        TIWAdvChartPay.Chart.Series[0].LegendText := Format(Langtostr(162){'充值金额(%s)'},[TotalPayMoney]);
        TIWAdvChartPay.Chart.Series[1].LegendText := Format(Langtostr(163){'消费金额(%s)'},[TotalConsumeMoney]);
        if iCount * (objINI.AutoWidth+20) < objINI.DefaultWidth then
          TIWAdvChartPay.Width := objINI.DefaultWidth
        else
          TIWAdvChartPay.Width := iCount * (objINI.AutoWidth+20);
        Series[1].ShowValue := True;
        if TIWAdvChartPay.Width > 15000 then
        begin
          Series[1].ShowValue := False;
          TIWAdvChartPay.Width := 15000;
        end;
        TIWAdvChartPay.Visible := True;
        TIWHTMLLabConsumeMoney.HTMLText := Format(Langtostr(DayConsumeTitle),[DayConsumeMoney,TotalConsumeMoney]);
        RemainingMoney := Format(objINI.RMBFormat,[dTotalPayMoney-dTotalConsumeMoney]);
        RemainingRate := Format('%.1f%%',[DivZero((dTotalPayMoney-dTotalConsumeMoney),dTotalPayMoney)*10]);
       // RemainingRate := Format('%.1f%%',[DivZero((dTotalPayMoney-dTotalConsumeMoney),dTotalPayMoney)]);
        MaxConsumeMoney := Format(objINI.RMBFormat,[DivZero(MaxConsumeCount,10)]);
      //  MaxConsumeMoney := Format(objINI.RMBFormat,[DivZero(MaxConsumeCount / 10,psld.CurrencyRate)]);
        TIWHTMLLabConsumeCount.HTMLText := Format(Langtostr(MaxConsumeTitle),[RemainingMoney,RemainingRate,MaxConsumeMoney,MaxConsumeTime]);
      end;
      with UserSession.quOnlineCount do
      begin
        SQL.Text := Format(sqlOnlineCount,[FormatDateTime('YYYYMMDD',Date),FormatDateTime('YYYYMMDD',Date),psld.Index]);
        Open;
        OnlineCount := Fields[0].AsInteger;
        Close;
        SetLength(AVGValue,1); MaxOnlineCount := 0;
        MinDT := pSDate.Date;
        while MinDT<=pEDate.Date do
        begin
          if ServerIndex <> '' then
          begin
            tmpSQL := ' WHERE '+Copy(ServerIndex,5,Length(ServerIndex));
          end;
          SQL.Text := Format(sqlMaxOnlineCount+tmpSQL,[FormatDateTime('YYYYMMDD',MinDT)]);
          Open;
          TryStrToInt(GetParameterStrValue(Fields[0].AsString,2),iTmp);
          if iTmp > MaxOnlineCount then
          begin
            MaxOnlineCount := iTmp;
            MaxOnlineTime := GetParameterStrValue(Fields[0].AsString,3);
          end;
          AVGValue[High(AVGValue)] := MaxOnlineCount;
          Close;
          SetLength(AVGValue,High(AVGValue)+2);
         MinDT := MinDT+1;
        end;
        AVGOnlineCount := GetAVGValue(AVGValue);
        TIWHTMLLabOnlineCount.HTMLText := Format(Langtostr(OnlineCountTitle),[OnlineCount,MaxOnlineCount,MaxOnlineTime,AVGOnlineCount]);
      end;
      with UserSession.quGlobalAccount do
      begin
        SQL.Text := Format(sqlRegCount+InServer,[DateToSTr(Date),DateToSTr(Date)]);
        Open;
        DayRegCount := Fields[0].AsInteger;
        Close;
        SQL.Text := sqlTotalRegCount;
        Open;
        TotalRegCount := Fields[0].AsInteger;
        Close;
//      SQL.Text := Format(sqlMaxRegCount,[DateToSTr(pSDate.Date),DateToSTr(pEDate.Date)]);
//      Open;
//      TryStrToInt(GetParameterStrValue(Fields[0].AsString,2),MaxRegCount);
//      MaxRegTime := GetParameterStrValue(Fields[0].AsString,3);
//      Close;
      end;
      with UserSession.quLoginCount do
      begin
        SQL.Text := Format(sqlLoginCount+ServerIndex,[FormatDateTime('YYYYMMDD',Date)]);
        Open;
        DayLoginCount := Fields[0].AsInteger;
        Close;
        TIWHTMLLabRegCount.HTMLText := Format(Langtostr(RegCountTitle),[DayRegCount,DayLoginCount,TotalRegCount,MaxRegCount,MaxRegTime]);
      end;
      PayStatChart(psld.Amdb,ServerID,pSDate.Date,pEDate.Date, psld.CurrencyRate);
      OnlineRegStatChart(psld.Index,InServer,pSDate.Date,pEDate.Date);
    finally
      UserSession.SQLConnectionSession.Close;
      UserSession.SQLConnectionLog.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmOverview.IWAppFormCreate(Sender: TObject);
var
  OpenServerTime: TDateTime;
  plsd: PTServerListData;
begin
  inherited;
  plsd := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  if plsd.Index = 0 then
  begin
    OpenServerTime := GetServerFirstOpenTime(plsd.spID);
  end
  else begin
    OpenServerTime := StrToDateTime(plsd.OpenTime);
  end;
  pSDate.Date := Now();//IncDay(Now(),-DayOf(Now())+1); 默认不以月初开始
  if pSDate.Date < OpenServerTime then
  begin
    pSDate.Date := OpenServerTime;
  end;
  pEDate.Date := Now();
  SetServerListSelect(Langtostr(StatToolButtonStr[tbOverview]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbOverview]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbOverview])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWBtnBuild.Caption := Langtostr(14);
  IWButton1.Caption := Langtostr(167);
end;

procedure TIWfrmOverview.IWBtnBuildClick(Sender: TObject);
begin
  inherited;
  try
    try
     GetServerStatData;
    finally
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmOverview.IWButton1Click(Sender: TObject);
var
  plsd: PTServerListData;
begin
  inherited;
  plsd := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  if plsd.Index = 0 then
  begin
    pSDate.Date := GetServerFirstOpenTime(plsd.spID);
  end
  else begin
    pSDate.Date := StrToDateTime(plsd.OpenTime);
  end;
  IWBtnBuild.OnClick(self);
end;

procedure TIWfrmOverview.IWcBoxZJHTServersChange(Sender: TObject);
begin
  inherited;
  GetServerStatData;
  IWRegion1.Visible := True;
end;

procedure TIWfrmOverview.OnlineRegStatChart(Idx: Integer; InServer: string;
  dMinDate, dMaxDate: TDate);
const
  sqlOnlineCount = 'SELECT Logdate,MAX(OnlineCount) FROM log_onlinecount_%s WHERE serverindex=%d';
  sqlRegCount = 'SELECT createtime,COUNT(account) as iCount FROM globaluser WHERE createtime>="%s 00:00:00" AND createtime<="%s 23:59:59"';
var
  iCount,iRegTotal,iOnlineMax: Integer;
begin
  TIWAdvChartOnline.Chart.Series[0].ClearPoints;
  TIWAdvChartOnline.Chart.Series[1].ClearPoints;
  iCount := 0;  iRegTotal := 0; iOnlineMax := 0;
  while dMinDate<=dMaxDate do
  begin
    with UserSession.quOnlineCount,TIWAdvChartOnline.Chart do
    begin
      SQL.Text := Format(sqlOnlineCount,[FormatDateTime('YYYYMMDD',dMinDate),Idx]);
      Open;
      if Fields[1].AsInteger > iOnlineMax then iOnlineMax := Fields[1].AsInteger;
      Series[0].AddSinglePoint(ChangeZero(Fields[1].AsInteger),FormatDateTime('MM-DD',Fields[0].AsDateTime));
    end;
    with UserSession.quGlobalAccount,TIWAdvChartOnline.Chart do
    begin
      SQL.Text := Format(sqlRegCount+InServer,[DateToStr(dMinDate),DateToStr(dMinDate)]);
      Open;
      Inc(iRegTotal,Fields[1].AsInteger);
      Series[1].AddSinglePoint(ChangeZero(Fields[1].AsInteger),FormatDateTime('MM-DD',Fields[0].AsDateTime));
    end;
    Inc(iCount);
    dMinDate := dMinDate+1;
  end;
  TIWAdvChartOnline.Chart.Title.Text:= Langtostr(161);
  TIWAdvChartOnline.Chart.Series[0].LegendText := Format(Langtostr(164){'最大在线数: %d'},[iOnlineMax]);
  TIWAdvChartOnline.Chart.Series[1].LegendText := Format(Langtostr(165){'注册账号数: %d'},[iRegTotal]);
  TIWAdvChartOnline.Chart.Range.RangeFrom := 0;
  TIWAdvChartOnline.Chart.Range.RangeTo := iCount-1;
  if iCount * objINI.AutoWidth < objINI.DefaultWidth then
    TIWAdvChartOnline.Width := objINI.DefaultWidth
  else
    TIWAdvChartOnline.Width := iCount * objINI.AutoWidth;
  if TIWAdvChartOnline.Width > 15000 then
  begin
    TIWAdvChartOnline.Width := 15000;
  end;
  TIWAdvChartOnline.Visible := True;
end;

procedure TIWfrmOverview.PayStatChart(samdb,ServerID: string; dMinDate,
  dMaxDate: TDate; dRate: Double);
const
  sqlPayTotalMoney = 'SELECT date(orderdate),SUM(rmb) AS TotalMoney FROM %s.payorder WHERE type = 3 and state = 1 AND orderdate>="%s 00:00:00" AND orderdate<="%s 23:59:59" %s GROUP BY date(orderdate)';
  sqlPayTotalMoney2 = 'SELECT date(orderdate),SUM(rmb) AS TotalMoney FROM %s.payorder_%s WHERE type = 3 and state = 1 AND orderdate>="%s 00:00:00" AND orderdate<="%s 23:59:59" %s GROUP BY date(orderdate)';
var
  Idx: Integer;
  PayList: TStringList;
begin
  PayList := TStringList.Create;
  try
    try
      TIWAdvChartPay.Chart.Series[0].ClearPoints;
      PayList.Clear;
      with UserSession.quPay do
      begin
        if IWAmdbMode.Checked then
         SQL.Text := Format(sqlPayTotalMoney2,[samdb,FormatDateTime('YYYYMM',dMinDate),DateToStr(dMinDate),DateToStr(dMaxDate),ServerID])
        else
         SQL.Text := Format(sqlPayTotalMoney,[samdb,DateToStr(dMinDate),DateToStr(dMaxDate),ServerID]);
        Open;
        while not Eof do
        begin
          PayList.AddObject(Fields[0].AsString,TObject(Fields[1].AsInteger));
          Next;
        end;
        Close;
      end;
      while dMinDate<=dMaxDate do
      begin
        Idx := PayList.IndexOf(DateToStr(dMinDate));
        if Idx <> -1 then
        begin
          Idx := Integer(PayList.Objects[Idx]);
          TIWAdvChartPay.Chart.Series[0].AddSinglePoint(ChangeZero(DivZero(Idx,dRate)),FormatDateTime('MM-DD',dMinDate));
        end
        else begin
          TIWAdvChartPay.Chart.Series[0].AddSinglePoint(-1,FormatDateTime('MM-DD',dMinDate));
        end;
        dMinDate := dMinDate+1;
      end;
    finally
      PayList.Free;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
  TIWAdvChartPay.Chart.Series[0].ValueFormat := objINI.RMBFormat;
  TIWAdvChartPay.Chart.Series[1].ValueFormat := objINI.RMBFormat;
  TIWAdvChartPay.Visible := True;
end;

initialization
  RegisterClass(TIWfrmOverview);
  
end.
