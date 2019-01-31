unit UnitfrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWControl, IWTMSCal, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWCompLabel, DateUtils, AdvChart, IWAdvChart,
  IWAdvToolButton, IWTMSImgCtrls, IWCompListbox, IWCompEdit,
  IWTMSEdit, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = 30;//'µÇÂ½Í³¼Æ';

type
  TIWfrmLogin = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    TIWAdvChart2: TTIWAdvChart;
    IWComboBox1: TIWComboBox;
    IWLabel4: TIWLabel;
    pSTime: TTIWAdvTimeEdit;
    pETime: TTIWAdvTimeEdit;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWComboBox1Change(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTicksType;
  public
    procedure QueryLogin(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmLogin: TIWfrmLogin;
const
  TickTypeStr : array[0..6] of Integer = (173,174,175,176,177,178,179);

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmLogin.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := IncDay(Now(),-6);
  pEDate.Date := Now();
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel4.Caption := Langtostr(170);
  IWBtnBuild.Caption := Langtostr(171);
  LoadTicksType;
end;

procedure TIWfrmLogin.LoadTicksType;
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

procedure TIWfrmLogin.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date > pEDate.Date then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  if DayOf(pEDate.Date)-DayOf(pSDate.Date) >= 10 then
  begin
    WebApplication.ShowMessage(Langtostr(238));
    Exit;
  end;
  if (IWComboBox1.ItemIndex <> 0) and (pSDate.Date <> pEDate.Date) then
  begin
    WebApplication.ShowMessage(Langtostr(239));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    if psld.Index <> 0 then
    begin
      if psld.OpenTime = '' then
      begin
        Exit;
      end;
      if pSDate.Date < StrToDateTime(psld.OpenTime) then
      begin
        pSDate.Date := StrToDateTime(psld.OpenTime);
      end;
      if pEDate.Date < StrToDateTime(psld.OpenTime) then
      begin
        pEDate.Date := StrToDateTime(psld.OpenTime);
      end;
    end;
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryLogin(psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
    finally
      UserSession.SQLConnectionLog.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmLogin.IWComboBox1Change(Sender: TObject);
begin
  inherited;
  if IWComboBox1.ItemIndex <> 0 then
  begin
    pSDate.Date := pEDate.Date;
  end
  else
  begin
    pSTime.Time := StrToTime('00:00:00');
    pETime.Time := StrToTime('23:59:59');
  end;
end;

procedure TIWfrmLogin.QueryLogin(ServerIndex: Integer;MinDateTime, MaxDateTime: TDateTime);
const
  sqlLoginCount = 'SELECT COUNT(1) AS iCount FROM %s WHERE %s AND logdate>="%s" AND logdate<="%s"';
  sqlAccountCount = 'SELECT COUNT(DISTINCT account) AS iCount FROM %s WHERE %s AND logdate>="%s" AND logdate<="%s"';
  tServerIndex = 'serverindex=%d';
  tGServerIndex = 'Logid = 7';//'Logid = 1';
  tTableName = 'log_login_%s';
var
  XFormat: string;
  iCount,iAutoWidth: Integer;
  sqlMaxDate: string;
  sTableName,LoginSQL,AccountSQL: string;
  function IncChartDateTime(tmpDateTime: TDateTime): TDateTime;
  begin
    Result := tmpDateTime;
    iAutoWidth := objINI.AutoWidth;
    case IWComboBox1.ItemIndex of
      0:begin
          iAutoWidth := objINI.AutoWidth-10;
          XFormat := 'MM-DD';
          Result := IncDay(tmpDateTime,1);
        end;
      1:begin
          XFormat := 'MM-DD HH';
          Result := IncHour(tmpDateTime,1);
        end;
      2:begin
          XFormat := 'MM-DD HH';
          Result := IncHour(tmpDateTime,2);
        end;
      3:begin
          XFormat := 'MM-DD HH';
          Result := IncHour(tmpDateTime,4);
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
  iCount := 0;
  if MaxDateTime > Now then MaxDateTime := Now;
  TIWAdvChart1.Chart.Series[0].ClearPoints;
  TIWAdvChart2.Chart.Series[0].ClearPoints;
  while MinDateTime<=MaxDateTime do
  begin
    sTableName := Format(tTableName,[FormatDateTime('YYYYMMDD',MinDateTime)]);
    sqlMaxDate := DateTimeToStr(IncChartDateTime(MinDateTime));
//    if UserSession.IsCheckTable('globallog',sTableName) then
//    begin
      LoginSQL := Format(sqlLoginCount,[sTableName,tGServerIndex,DateTimeToStr(MinDateTime),sqlMaxDate]);
      AccountSQL := Format(sqlAccountCount,[sTableName,tGServerIndex,DateTimeToStr(MinDateTime),sqlMaxDate]);
      if ServerIndex <> 0 then
      begin
        LoginSQL := Format(sqlLoginCount,[sTableName,Format(tServerIndex,[ServerIndex]),DateTimeToStr(MinDateTime),sqlMaxDate]);
        AccountSQL := Format(sqlAccountCount,[sTableName,format(tServerIndex,[ServerIndex]),DateTimeToStr(MinDateTime),sqlMaxDate]);
      end;
      with UserSession.quLoginCount do
      begin
        SQL.Text := LoginSQL;
        Open;
        TIWAdvChart1.Chart.Series[0].LegendText := Langtostr(240);//'µÇÂ½´ÎÊý';
        TIWAdvChart1.Chart.Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),FormatDateTime(XFormat,MinDateTime));
        Close;
      end;
      with UserSession.quAccountCount do
      begin
        SQL.Text := AccountSQL;
        Open;
        TIWAdvChart2.Chart.Series[0].LegendText := Langtostr(241);//'µÇÂ½ÕÊºÅÊý';
        TIWAdvChart2.Chart.Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),FormatDateTime(XFormat,MinDateTime));
        Close;
      end;
      Inc(iCount);
    //end;
    if StrToDateTime(sqlMaxDate) > Now() then break;
    MinDateTime := StrToDateTime(sqlMaxDate);
  end;
  TIWAdvChart1.Chart.Range.RangeFrom := 0;
  TIWAdvChart1.Chart.Range.RangeTo := iCount-1;
  if iCount * objINI.AutoWidth < objINI.DefaultWidth then
    TIWAdvChart1.Width := objINI.DefaultWidth
  else
    TIWAdvChart1.Width := iCount * objINI.AutoWidth;
  TIWAdvChart2.Chart.Range.RangeFrom := 0;
  TIWAdvChart2.Chart.Range.RangeTo := iCount-1;
  if iCount * objINI.AutoWidth < objINI.DefaultWidth then
    TIWAdvChart2.Width := objINI.DefaultWidth
  else
    TIWAdvChart2.Width := iCount * objINI.AutoWidth;
  TIWAdvChart1.Visible := True;
  TIWAdvChart2.Visible := True;
end;

initialization
  RegisterClass(TIWfrmLogin);

end.
