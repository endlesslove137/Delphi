unit UnitfrmOnlineRegister;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWAdvChart,
  IWTMSEdit, IWTMSCal, AdvChart, DateUtils;

type
  TIWfrmOnlineRegister = class(TIWFormBasic)
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
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTicksType;
  public
    procedure QueryOnlineRegister(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmOnlineRegister: TIWfrmOnlineRegister;

const
  TickTypeStr : array[0..6] of Integer = (173,174,175,176,177,178,179);

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmOnlineRegister.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(StatToolButtonStr[tbOnlineRegister]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbOnlineRegister]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbOnlineRegister])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  LoadTicksType;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel4.Caption := Langtostr(170);
  IWBtnBuild.Caption := Langtostr(171);
end;

procedure TIWfrmOnlineRegister.LoadTicksType;
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

procedure TIWfrmOnlineRegister.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172));//('起始日期应小于或等于结束日期，请重新选择'));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryOnlineRegister(psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
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

procedure TIWfrmOnlineRegister.QueryOnlineRegister(ServerIndex: Integer;
  MinDateTime, MaxDateTime: TDateTime);
const
  sqlOnlineCount = 'SELECT MAX(OnlineCount) AS OnlineCount,Logdate FROM log_onlinecount_%s WHERE Serverindex=%d AND Logdate>"%s" AND Logdate<="%s" GROUP BY Serverindex';
  sqlGlobalAccount = 'SELECT COUNT(account) as iCount,createtime FROM globaluser WHERE createtime>"%s" AND createtime<="%s" AND inserver=%d';
var
  XFormat: string;
  sqlMaxTime: TDateTime;
  iCount,iAutoWidth: Integer;
  iRegTotal,iOnlineMax: Integer;
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
    WebApplication.ShowMessage(Langtostr(172));//('起始日期应小于或等于结束日期，请重新选择'));
    Exit;
  end;
  iCount := 0;  iRegTotal := 0; iOnlineMax := 0;
  with TIWAdvChart1.Chart do
  begin
    Series[0].ClearPoints;
    Series[1].ClearPoints;
    while MinDateTime<=MaxDateTime do
    begin
      sqlMaxTime := IncChartDateTime(MinDateTime);
      with UserSession.quOnlineCount do
      begin
        SQL.Text := Format(sqlOnlineCount,[FormatDateTime('yyyymmdd', MinDateTime),ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime)]);
        Open;
        if FieldByName('OnlineCount').AsInteger > iOnlineMax then iOnlineMax := FieldByName('OnlineCount').AsInteger;
        Series[0].AddSinglePoint(ChangeZero(FieldByName('OnlineCount').AsInteger),
                  FormatDateTime(XFormat,MinDateTime));
        Close;
      end;
      with UserSession.quGlobalAccount do
      begin
        SQL.Text := Format(sqlGlobalAccount,[DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime),ServerIndex]);
        Open;
        Inc(iRegTotal,FieldByName('iCount').AsInteger);
        Series[1].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                  FormatDateTime(XFormat,MinDateTime));
        Close;
      end;
      Inc(iCount);
      if sqlMaxTime > Now() then break;
      MinDateTime := sqlMaxTime;
    end;
    Title.Text := Langtostr(StatToolButtonStr[tbOnlineRegister]);
    Series[0].LegendText := Format(Langtostr(164){'最大在线数: %d'},[iOnlineMax]);
    Series[1].LegendText := Format(Langtostr(165){'注册账号数: %d'},[iRegTotal]);
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
  RegisterClass(TIWfrmOnlineRegister);
  
end.
