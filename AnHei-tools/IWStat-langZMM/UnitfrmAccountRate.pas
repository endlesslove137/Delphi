unit UnitfrmAccountRate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWAdvChart,
  IWTMSEdit, IWTMSCal, DateUtils;

type
  TIWfrmAccountRate = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWLabel4: TIWLabel;
    IWComboBox1: TIWComboBox;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTicksType;
  public
    procedure QueryAccountRate(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmAccountRate: TIWfrmAccountRate;

const
  TickTypeStr : array[0..6] of Integer = (173,174,175,176,177,178,179);

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

{ TIWfrmAccountRate }

procedure TIWfrmAccountRate.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(StatToolButtonStr[tbAccountRate]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbAccountRate]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbAccountRate])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  LoadTicksType;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel4.Caption := Langtostr(170);
  IWBtnBuild.Caption := Langtostr(171);
end;

procedure TIWfrmAccountRate.LoadTicksType;
var
  cstr: Integer;
begin
  IWComboBox1.Items.Clear;
  for cstr in TickTypeStr do
  begin
    IWComboBox1.Items.Add(Langtostr(cstr));
  end;
  IWComboBox1.ItemIndex := 0;
end;


procedure TIWfrmAccountRate.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172));//'起始日期应小于或等于结束日期，请重新选择');
    Exit;
  end;
  case IWComboBox1.ItemIndex of
    0,1,2:
    begin
      if DaysBetween(pEDate.Date,pSDate.Date) > 3 then
      begin
       // WebApplication.ShowMessage('查询很耗时，请将查询范围限制在3天以内');
        WebApplication.ShowMessage(Langtostr(172));
        Exit;
      end;
    end;
    3:
    begin
      if DaysBetween(pEDate.Date,pSDate.Date) > 7 then
      begin
        WebApplication.ShowMessage(Langtostr(300));
        //WebApplication.ShowMessage('查询很耗时，请将查询范围限制在3天以内');
        Exit;
      end;
    end;
    4,5,6:
    begin
      if DaysBetween(pEDate.Date,pSDate.Date) > 1 then
      begin
        //WebApplication.ShowMessage('查询很耗时，请将查询范围限制在1天以内');
        WebApplication.ShowMessage(Langtostr(172));
        Exit;
      end;
    end;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryAccountRate(psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
    finally
      UserSession.SQLConnectionRole.Close;
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

procedure TIWfrmAccountRate.QueryAccountRate(ServerIndex: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlOnlineCount = 'SELECT MAX(OnlineCount) AS OnlineCount,Logdate FROM log_onlinecount_%s WHERE Serverindex=%d AND Logdate>"%s" AND Logdate<="%s" GROUP BY Serverindex';
  sqlCreateAccount = 'SELECT COUNT(DISTINCT accountname) as iCount,createtime FROM actors WHERE serverindex=%d AND createtime>"%s" AND createtime<="%s"';
  sqlGlobalAccount = 'SELECT COUNT(account) as iCount,createtime FROM globaluser WHERE createtime>"%s" AND createtime<="%s" AND inserver=%d';
  sqlLoginAccount = 'SELECT COUNT(account) as iCount,createtime FROM globaluser WHERE createtime>"%s" AND createtime<="%s" AND inserver=%d AND updatetime is not null';
  sqlAccountCount = 'SELECT COUNT(DISTINCT(accountname)) as iCount,createtime FROM actors WHERE level>0 AND createtime>"%s" AND createtime<="%s"';
var
  XFormat: string;
  sqlMaxTime: TDateTime;
  dCValue,dLValue,dOValue,dEValue: Double;
  iCount,iAutoWidth,iCCount,iRCount,iLCount,iOCount,iECount: Integer;
  function IncChartDateTime(tmpDateTime: TDateTime): TDateTime;
  begin
    Result := tmpDateTime;
    iAutoWidth := objINI.AutoWidth;
    case IWComboBox1.ItemIndex of
      0:begin
          XFormat := 'MM-DD HH';
          Result := IncHour(tmpDateTime,1);
        end;
      1:begin
          XFormat := 'MM-DD HH';
          Result := IncHour(tmpDateTime,2);
        end;
      2:begin
          XFormat := 'MM-DD HH';
          Result := IncHour(tmpDateTime,4);
        end;
      3:begin
          iAutoWidth := objINI.AutoWidth-10;
          XFormat := 'MM-DD';
          Result := IncDay(tmpDateTime,1);
        end;
      4:begin
          XFormat := 'DD HH:MM';
          Result := IncMinute(tmpDateTime,30);
        end;
      5:begin
          XFormat := 'DD HH:MM';
          Result := IncMinute(tmpDateTime,20);
        end;
      6:begin
          XFormat := 'DD HH:MM';
          Result := IncMinute(tmpDateTime,10);
        end;
    end;
  end;  
begin
  iCount := 0; iRCount := 0; iLCount := 0; iOCount := 0; iECount := 0; dEValue := 0;
  with TIWAdvChart1.Chart do
  begin
    Series[0].ClearPoints;
    Series[2].ClearPoints;
    Series[3].ClearPoints;
    Series[1].ClearPoints;
    Series[4].ClearPoints;
    with UserSession.quCreateAccount do
    begin
      SQL.Text := Format(sqlCreateAccount,[ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]);
      Open;
      iCCount := Fields[0].AsInteger;
      Close;
    end;
    while MinDateTime<=MaxDateTime do
    begin
      sqlMaxTime := IncChartDateTime(MinDateTime);
      with UserSession.quCreateAccount do
      begin
        SQL.Text := Format(sqlCreateAccount,[ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime)]);
        Open;
        Series[2].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                    FormatDateTime(XFormat,FieldByName('createtime').AsDateTime));
        Close;
      end;
      with UserSession.quGlobalAccount do
      begin
        SQL.Text := Format(sqlGlobalAccount,[DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime),ServerIndex]);
        Open;
        Inc(iRCount, FieldByName('iCount').AsInteger);
        Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                    FormatDateTime(XFormat,FieldByName('createtime').AsDateTime));
        Close;
      end;
      with UserSession.quCreateAccount do
      begin
        SQL.Text := Format(sqlAccountCount,[DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime)]);
        Open;
        Inc(iLCount, FieldByName('iCount').AsInteger);
        Series[3].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),FormatDateTime(XFormat,MinDateTime));
        Close;
      end;
      with UserSession.quGlobalAccount do
      begin
        SQL.Text := Format(sqlLoginAccount,[DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime),ServerIndex]);
        Open;
        Inc(iOCount, FieldByName('iCount').AsInteger);
        Series[1].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                    FormatDateTime(XFormat,FieldByName('createtime').AsDateTime));
        Close;
      end;
      with UserSession.quOnlineCount do
      begin
        SQL.Text := Format(sqlOnlineCount,[FormatDateTime('yyyymmdd', MinDateTime),ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime)]);
        Open;
        if FieldByName('OnlineCount').AsInteger > iECount then iECount := FieldByName('OnlineCount').AsInteger;
        Series[4].AddSinglePoint(ChangeZero(FieldByName('OnlineCount').AsInteger),
                  FormatDateTime(XFormat,FieldByName('Logdate').AsDateTime));
        Close;
      end;
      Inc(iCount);
      if sqlMaxTime > Now() then break;
      MinDateTime := sqlMaxTime;
    end;
    Range.RangeFrom := 0;
    Range.RangeTo := iCount-1;
    Series[0].LegendText := Langtostr(165){'注册账号数: '}+IntToStr(iRCount);
    dCValue := 0; dLValue:= 0; dOValue := 0;
    if iRCount <> 0 then
    begin
      dCValue := iCCount/iRCount*100;
      dLValue := iLCount/iRCount*100;
      dOValue := iOCount/iRCount*100;
      dEValue := iECount/iRCount*100;
    end;
    Series[2].LegendText := Format(Langtostr(301){'创建账号数: %d (%.1f%%)'},[iCCount,dCValue]);
    Series[3].LegendText := Format(Langtostr(302){'进入游戏数: %d (%.1f%%)'},[iLCount,dLValue]);
    Series[1].LegendText := Format(Langtostr(303){'登陆账号数: %d (%.1f%%)'},[iOCount,dOValue]);
    Series[4].LegendText := Format(Langtostr(304){'最高在线数: %d (%.1f%%)'},[iECount,dEValue]);
  end;
  TIWAdvChart1.Chart.Legend.Top := -75;
  if iCount * (iAutoWidth*2) < objINI.DefaultWidth then
    TIWAdvChart1.Width := objINI.DefaultWidth
  else
    TIWAdvChart1.Width := iCount * (iAutoWidth*2);
  TIWAdvChart1.Visible := True;
end;

initialization
  RegisterClass(TIWfrmAccountRate);
  
end.
