unit UnitfrmCreateAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWCompListbox, IWCompEdit,
  IWTMSEdit, IWTMSCal, IWAdvChart, DateUtils, AdvChart, IWExchangeBar,
  IWCompRectangle, IWTMSCtrls;

type
  TIWfrmCreateAccount = class(TIWFormBasic)
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
    procedure QueryCreateAccount(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmCreateAccount: TIWfrmCreateAccount;

const
  TickTypeStr : array[0..6] of Integer = (173,174,175,176,177,178,179);

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

{ TIWfrmCreateAccount }

procedure TIWfrmCreateAccount.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(StatToolButtonStr[tbCreateAccount]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbCreateAccount]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbCreateAccount])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel4.Caption := Langtostr(170);
  IWBtnBuild.Caption := Langtostr(171);
  LoadTicksType;
end;

procedure TIWfrmCreateAccount.LoadTicksType;
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

procedure TIWfrmCreateAccount.IWBtnBuildClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172));//('起始日期应小于或等于结束日期，请重新选择'));
    Exit;
  end;
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      QueryCreateAccount(ServerListData.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
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

procedure TIWfrmCreateAccount.QueryCreateAccount(ServerIndex: Integer;
  MinDateTime, MaxDateTime: TDateTime);
const
  sqlCreateAccount = 'SELECT COUNT(DISTINCT accountname) as iCount,createtime FROM actors WHERE serverindex=%d AND createtime>"%s" AND createtime<="%s"';
var
  XFormat: string;
  sqlMaxTime: TDateTime;
  iCount,iAutoWidth,iTotalCount: Integer;
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
          iAutoWidth := objINI.AutoWidth-10;
          XFormat := 'MM-DD';
          Result := IncWeek(tmpDateTime,1);
        end;
      5:begin
          XFormat := 'DD HH:MM';
          Result := IncMinute(tmpDateTime,30);
        end;
      6:begin
          XFormat := 'DD HH:MM';
          Result := IncMinute(tmpDateTime,20);
        end;
      7:begin
          XFormat := 'DD HH:MM';
          Result := IncMinute(tmpDateTime,10);
        end;
    end;
  end;
begin
  iCount := 0; iTotalCount := 0;
  with TIWAdvChart1.Chart do
  begin
    Series[0].ClearPoints;
    while MinDateTime<=MaxDateTime do
    begin
      sqlMaxTime := IncChartDateTime(MinDateTime);
      with UserSession.quCreateAccount do
      begin
        SQL.Text := Format(sqlCreateAccount,[ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime)]);
        Open;
        if FieldByName('createtime').AsString = '' then
        begin
          Series[0].AddSinglePoint(-1,FormatDateTime(XFormat,sqlMaxTime));
        end
        else
        begin
          Inc(iTotalCount, FieldByName('iCount').AsInteger);
          Series[0].AddSinglePoint(FieldByName('iCount').AsInteger,
                    FormatDateTime(XFormat,FieldByName('createtime').AsDateTime));
        end;
        Close;
        Inc(iCount);
      end;
      if sqlMaxTime > Now() then break; 
      MinDateTime := sqlMaxTime;
    end;
    Range.RangeFrom := 0;
    Range.RangeTo := iCount-1;
    Title.Text := Format(Langtostr(StatToolButtonStr[tbCreateAccount])+'(%d)',[iTotalCount]);
    Series[0].Autorange := arEnabledZeroBased;
  end;
  if iCount * iAutoWidth < objINI.DefaultWidth then
    TIWAdvChart1.Width := objINI.DefaultWidth
  else
    TIWAdvChart1.Width := iCount * iAutoWidth;
  TIWAdvChart1.Visible := True;
end;

initialization
  RegisterClass(TIWfrmCreateAccount);

end.
