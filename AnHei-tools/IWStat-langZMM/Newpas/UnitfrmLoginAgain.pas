unit UnitfrmLoginAgain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWControl, IWTMSCal, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWCompLabel, DateUtils, AdvChart, IWAdvChart,
  IWAdvToolButton, IWTMSImgCtrls, IWCompListbox, IWCompEdit,
  IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWWebGrid, IWAdvWebGrid;

const
  curTitle = 32;//'二次登录率统计';

type
  TIWfrmLoginAgain = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart2: TTIWAdvChart;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel2: TIWLabel;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryLoginAgain(sgstatic,slog:string;ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmLoginAgain: TIWfrmLoginAgain;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmLoginAgain.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := IncDay(Now(),-3);
  pEDate.Date := IncDay(Now(),-1);
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel2.Caption := Langtostr(248);
  IWBtnBuild.Caption := Langtostr(171);
  TIWAdvWebGrid1.Columns[1].Title := Langtostr(244);
  TIWAdvWebGrid1.Columns[2].Title := Langtostr(249);
  TIWAdvWebGrid1.Columns[3].Title := Langtostr(250);
  TIWAdvWebGrid1.Columns[4].Title := Langtostr(251);
  TIWAdvWebGrid1.Columns[5].Title := Langtostr(252);
end;

procedure TIWfrmLoginAgain.IWBtnBuildClick(Sender: TObject);
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
    end
    else begin
      WebApplication.ShowMessage(Langtostr(253));
      Exit;
    end;
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryLoginAgain(psld.GstaticDB,psld.LogDB,psld.Index,pSDate.Date,pEDate.Date);
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

procedure TIWfrmLoginAgain.QueryLoginAgain(sgstatic,slog:string;ServerIndex: Integer;MinDateTime, MaxDateTime: TDateTime);
const
  sqlAccountCount= '(SELECT COUNT(DISTINCT account) AS iCount FROM %s where %s) as iCount,';
  sqlAccountCount2= '(SELECT COUNT(DISTINCT account) AS iCount FROM %s where %s) as iCount2,';
  sqlIncrement = '(SELECT increment FROM %s.loginstatus where %s and status = 28 and staticdate="%s" ) as iCount3';
  sqlGroup = 'SELECT %s %s %s';
  tServerIndex = 'serverindex=%d';
  tGServerIndex ='Logid = 7';// 'Logid = 1';
  tTableName = '%s.log_login_%s';
var
  Tday, Yday, Nday: Integer;
  iCount: Integer;
  iValue, icoint: Double;
  AccountSQL,AccountSQL2, IncSql: string;
  sqlMaxDate: string;
  sTableName,sTableName2: string;
begin
  iCount := 0;

  TIWAdvChart2.Chart.Series[0].ClearPoints;
  TIWAdvWebGrid1.ClearCells;
  while MinDateTime<=MaxDateTime do
  begin
    sTableName := Format(tTableName,[slog,FormatDateTime('YYYYMMDD',IncDay(MinDateTime,-1))]);
    sTableName2 := Format(tTableName,[slog,FormatDateTime('YYYYMMDD',MinDateTime)]);
    sqlMaxDate := DateTimeToStr(IncDay(MinDateTime, 1));

    AccountSQL := Format(sqlAccountCount,[sTableName, format(tServerIndex,[ServerIndex])]); //前天
    AccountSQL2 := Format(sqlAccountCount2,[sTableName2, format(tServerIndex,[ServerIndex])]);           //当天
    IncSql := Format(sqlIncrement,[sgstatic,format(tServerIndex,[ServerIndex]),DateTimeToStr(MinDateTime)]);

    with UserSession.quAccountAgain do
    begin
      SQL.Text := Format(sqlGroup,[AccountSQL, AccountSQL2, IncSql]);
      Open;
      Tday:= FieldByName('iCount2').AsInteger;  // 今天
      Yday:= FieldByName('iCount').AsInteger;   // 昨天
      Nday:= FieldByName('iCount3').AsInteger;  //当天新增
      iValue:= DivZero(Tday - Nday , Yday);
      icoint:= StrToFloat(Format('%2.2f',[iValue * 100]));

      with TIWAdvWebGrid1 do
      begin
      //  TIWAdvWebGrid1.TotalRows := iCount;
         while not Eof do
         begin
            RowCount := iCount + 1;
            cells[1,iCount] := FormatDateTime('YYYYMMDD',MinDateTime); //日期
            cells[2,iCount] := IntToStr(Nday); //新增人数
            cells[3,iCount] := IntToStr(Tday); //今天人数
            cells[4,iCount] := IntToStr(Yday); //昨天人数
            cells[5,iCount] := Format('%2.2f',[iValue * 100])+'%'; //昨天人数
            Next;
         end;
      end;
      TIWAdvChart2.Chart.Series[0].LegendText := Langtostr(curTitle);
      TIWAdvChart2.Chart.Series[0].AddSinglePoint( ChangeZero(icoint), FormatDateTime('MM-DD',MinDateTime));

      Close;
    end;

    Inc(iCount);

    if StrToDateTime(sqlMaxDate) > Now() then break;
    MinDateTime := StrToDateTime(sqlMaxDate);
  end;

  TIWAdvChart2.Chart.Range.RangeFrom := 0;
  TIWAdvChart2.Chart.Range.RangeTo := iCount-1;
  if iCount * objINI.AutoWidth < objINI.DefaultWidth then
    TIWAdvChart2.Width := objINI.DefaultWidth
  else
    TIWAdvChart2.Width := iCount * objINI.AutoWidth;

  TIWAdvChart2.Visible := True;
end;

initialization
  RegisterClass(TIWfrmLoginAgain);

end.
