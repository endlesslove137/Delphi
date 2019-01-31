unit UnitfrmLoginModeTotal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWAdvChart,
  IWTMSEdit, IWTMSCal, AdvChart, DateUtils, IWWebGrid, IWAdvWebGrid;

type
  TIWfrmLoginModeTotal = class(TIWFormBasic)
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
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTicksType;
  public
    procedure QueryLoginMode(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmLoginModeTotal: TIWfrmLoginModeTotal;

const
  TickTypeStr : array[0..6] of Integer = (173,174,175,176,177,178,179);

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmLoginModeTotal.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(StatToolButtonStr[tbLoginModeTotal]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbLoginModeTotal]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbLoginModeTotal])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  LoadTicksType;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel4.Caption := Langtostr(170);
  IWBtnBuild.Caption := Langtostr(171);

  TIWAdvWebGrid1.Columns[1].Title := Langtostr(244);
  TIWAdvWebGrid1.Columns[2].Title := Langtostr(245);
  TIWAdvWebGrid1.Columns[3].Title := Langtostr(246);
  TIWAdvWebGrid1.Columns[4].Title := Langtostr(247);
end;

procedure TIWfrmLoginModeTotal.LoadTicksType;
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

procedure TIWfrmLoginModeTotal.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryLoginMode(psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
    finally
      UserSession.SQLConnectionLog.Close;
      UserSession.SQLConnectionSession.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmLoginModeTotal.QueryLoginMode(ServerIndex: Integer;
  MinDateTime, MaxDateTime: TDateTime);
const
  sqlOnlineCount = 'SELECT MAX(OnlineCount) AS OnlineCount,Logdate FROM log_onlinecount_%s WHERE Serverindex=%d AND Logdate>"%s" AND Logdate<="%s" GROUP BY Serverindex';
  sqlGlobalAccount = 'SELECT COUNT(account) as iCount,createtime FROM globaluser WHERE createtime>"%s" AND createtime<="%s" AND inserver=%d';

  sqlWebLogin= '(SELECT COUNT(DISTINCT account) AS iCount FROM log_login_%s where %s and logdate>="%s" AND logdate<="%s") as iCount,';
  sqlGameLogin= '(SELECT COUNT(DISTINCT account) AS iCount FROM log_login_%s where %s and logdate>="%s" AND logdate<="%s") as iCount2';
  sqlGroup = 'SELECT %s %s';
  tServerIndex = ' and serverindex=%d';
  tGWebIndex = 'Logid = 7';
  tGameIndex = 'Logid = 8';
var
  XFormat: string;
  sqlMaxTime: TDateTime;
  iCount,iAutoWidth: Integer;
  iGameOnline,iWebOnline: Integer;
  Gidx,Widx: Integer;
  sqlweb, sqlgame: string;
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
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  iCount := 0;
  Gidx := 0; Widx := 0;
  with TIWAdvChart1.Chart do
  begin
    Series[0].ClearPoints;
    Series[1].ClearPoints;
    while MinDateTime<=MaxDateTime do
    begin
      sqlMaxTime := IncChartDateTime(MinDateTime);

      sqlweb:=Format(sqlWebLogin,[FormatDateTime('YYYYMMDD',MinDateTime),tGWebIndex,DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime)]);
      sqlgame:=Format(sqlGameLogin,[FormatDateTime('YYYYMMDD',MinDateTime),tGameIndex,DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime)]);

      if ServerIndex <> 0 then
      begin
        sqlweb:=Format(sqlWebLogin,[FormatDateTime('YYYYMMDD',MinDateTime),tGWebIndex + format(tServerIndex,[ServerIndex]),DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime)]);
        sqlgame:=Format(sqlGameLogin,[FormatDateTime('YYYYMMDD',MinDateTime),tGameIndex + format(tServerIndex,[ServerIndex]),DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime)]);
      end;
      with UserSession.quAccountCount do
      begin
        SQL.Text := Format(sqlGroup,[sqlweb,sqlgame]);
        Open;
        iWebOnline := FieldByName('iCount').AsInteger;
        iGameOnline := FieldByName('iCount2').AsInteger;

        Gidx:= Gidx + (iWebOnline-iGameOnline);

        Series[0].AddSinglePoint(ChangeZero(iWebOnline - iGameOnline),
                  FormatDateTime(XFormat,MinDateTime));
        Widx:= Widx + iGameOnline;

        Series[1].AddSinglePoint(ChangeZero(iGameOnline),
                  FormatDateTime(XFormat,MinDateTime));

        with TIWAdvWebGrid1 do
        begin
           while not Eof do
           begin
              RowCount := iCount + 1;
              cells[1,iCount] := FormatDateTime('YYYYMMDD',MinDateTime); //日期
              cells[2,iCount] := IntToStr(iWebOnline); //新增人数
              cells[3,iCount] := IntToStr(iWebOnline - iGameOnline); //今天人数
              cells[4,iCount] := IntToStr(iGameOnline); //昨天人数
              Next;
           end;
        end;

        Close;
      end;

      Inc(iCount);
      if sqlMaxTime > Now() then break;
      MinDateTime := sqlMaxTime;
    end;
    Title.Text:= Langtostr(31);
    Series[0].LegendText := Format(Langtostr(242),[Gidx]);
    Series[1].LegendText := Format(Langtostr(243),[Widx]);
    Range.RangeFrom := 0;
    Range.RangeTo := iCount-1;
  end;
  if iCount * iAutoWidth < objINI.DefaultWidth then
    TIWAdvChart1.Width := objINI.DefaultWidth
  else
    TIWAdvChart1.Width := iCount * iAutoWidth;
  TIWAdvChart1.Visible := True;
end;

initialization
  RegisterClass(TIWfrmLoginModeTotal);
  
end.
