unit UnitfrmLevelRole;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWWebGrid, IWAdvWebGrid, IWAdvChart, IWCompButton,
  IWCompEdit, IWTMSEdit, IWControl, IWTMSCal, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompLabel, AdvChart, AdvChartViewGDIP, IWAdvToolButton,
  IWTMSImgCtrls, IWCompListbox, IWExchangeBar,
  IWCompRectangle, IWTMSCtrls;

const
  curTitle = 74;//'职业等级';

type
  TIWfrmLevelRole = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure BuildChart(pSort: Boolean);
    procedure QueryLevelRole(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmLevelRole: TIWfrmLevelRole;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmLevelRole.BuildChart(pSort: Boolean);
var
  I,J: Integer;
  LChartSerie: TAdvGDIPChartSerie;
begin
  TIWAdvChart1.Chart.Series.Clear;
  TIWAdvChart1.Chart.Range.RangeFrom := 0;
  TIWAdvChart1.Chart.Range.RangeTo := TIWAdvWebGrid1.Columns.Count - 2{5};
  for I := 0 to TIWAdvWebGrid1.RowCount - 1 do
  begin
    if TIWAdvWebGrid1.Cells[0,I] = '' then continue;
    LChartSerie := TIWAdvChart1.Chart.Series.Add;
    LChartSerie.ChartType := ctBar;
    LChartSerie.BarShape := bsRectangle;
    LChartSerie.LegendText := TIWAdvWebGrid1.Cells[0,I];
    LChartSerie.Xaxis.Visible := False;
    LChartSerie.Yaxis.Visible := False;
    LChartSerie.ShowValue := True;
    LChartSerie.Color := RoleChartColor[I];
    LChartSerie.ValueFont.Color := RoleChartColor[I];
    LChartSerie.ValueFont.Style := [fsBold];
    TIWAdvChart1.Chart.Series[I].Autorange := arCommonZeroBased;//arCommon;
    for J := 1 to TIWAdvWebGrid1.Columns.Count - 1 do
    begin
      if TIWAdvWebGrid1.Columns[J].Visible then
      begin
        LChartSerie.AddSinglePoint(ChangeZero(StrToInt(TIWAdvWebGrid1.Cells[J,I])),Langtostr(sRoleJob[J]));
      end;
    end;
  end;
  if TIWAdvChart1.Chart.Series.Count > 0 then
  begin
    TIWAdvChart1.Chart.Series[0].XAxis.Visible := True;
    TIWAdvChart1.Chart.Series[0].YAxis.Visible := True;
  end;
  TIWAdvChart1.Visible := True;
end;

procedure TIWfrmLevelRole.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWBtnBuild.Caption := Langtostr(171);

  TIWAdvWebGrid1.Columns[0].Title:= Langtostr(263);
  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(267);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(268);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(269);
end;

procedure TIWfrmLevelRole.IWBtnBuildClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      QueryLevelRole(ServerListData.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
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

procedure TIWfrmLevelRole.QueryLevelRole(ServerIndex: Integer;MinDateTime, MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT job,COUNT(1) AS iCount FROM actors WHERE serverindex=%d AND updatetime> "%s" AND updatetime<="%s" AND level>%d AND level<=%d AND job>0 GROUP BY job';
var
  I: Integer;
begin
  with TIWAdvWebGrid1 do
  begin
    ClearCells;
    RowCount := Trunc(objINI.MaxLevel/10);
    TotalRows := RowCount;
    for I := 1 to RowCount do
    begin
      with UserSession.quLevelRole do
      begin
        SQL.Text := Format(sqlRoleCount,[ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime),I*10-10,I*10]);
        Open;
        try
          cells[0,I-1] := IntToStr(I*10-10)+'-'+IntToStr(I*10)+Langtostr(317);
          cells[1,I-1] := '0';
          cells[2,I-1] := '0';
          cells[3,I-1] := '0';
          while not Eof do
          begin
            cells[FieldByName('job').AsInteger,I-1] := FieldByName('iCount').AsString;
            Next;
          end;  
        finally
          Close;
        end;
      end;
    end;
  end;
  BuildChart(True);
end;

initialization
  RegisterClass(TIWfrmLevelRole);

end.
