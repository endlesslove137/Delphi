unit UnitfrmSex;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWAdvChart,
  IWTMSEdit, IWTMSCal;

type
  TIWfrmSex = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    TIWAdvChart1: TTIWAdvChart;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QuerySex(ServerIndex: Integer;MinDate,MaxDate: TDateTime);
  end;

var
  IWfrmSex: TIWfrmSex;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmSex.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(StatToolButtonStr[tbSex]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbSex]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbSex])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWBtnBuild.Caption := Langtostr(171);
end;

procedure TIWfrmSex.IWBtnBuildClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  if pSDate.Date + pSTime.Time > pEDate.Date + pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      QuerySex(ServerListData.Index,pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
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

procedure TIWfrmSex.QuerySex(ServerIndex: Integer;MinDate, MaxDate: TDateTime);
const
  sqlSex = 'SELECT sex,COUNT(1) AS iCount FROM actors WHERE serverindex=%d AND updatetime>="%s" AND updatetime<="%s" GROUP BY sex';
  sSex : array [0..1] of Integer = (372, 373);
  SexChartColor : array [0..1] of Integer = (clRed, clGreen);
begin
  with UserSession.quCountryCount,TIWAdvChart1.Chart do
  begin
    Series[0].ClearPoints;
    SQL.Text := Format(sqlSex,[ServerIndex,DateTimeToStr(MinDate),DateTimeToStr(MaxDate)]);
    Open;
    while not Eof do
    begin
      Series[0].AddSinglePoint(Fields[1].AsInteger,SexChartColor[Fields[0].AsInteger],Langtostr(sSex[Fields[0].AsInteger])+ ' ' + IntToStr(Fields[1].AsInteger) + ' ');
      Next;
    end;
    Close;
  end;
  TIWAdvChart1.Visible := True;
end;

initialization
  RegisterClass(TIWfrmSex);

end.
