unit UnitfrmHumDieLevel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, IWCompButton, IWCompEdit, IWTMSEdit, IWControl,
  IWTMSCal, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompLabel,
  AdvChart, IWAdvToolButton, IWTMSImgCtrls, DateUtils,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWWebGrid,
  IWAdvWebGrid, IWCompCheckbox;

const
  curTitle = '人物死亡等级统计';

type
  TIWfrmHumDieLevel = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    IWLabel2: TIWLabel;
    IWedtLevel: TIWEdit;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    TIWDateSelector1: TTIWDateSelector;
    TIWAdvTimeEdit1: TTIWAdvTimeEdit;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton3: TIWButton;
    IWLogMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryRoleLevel(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
    procedure QueryRoleLevelEx(Ispid, ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmHumDieLevel: TIWfrmHumDieLevel;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmHumDieLevel.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
end;

procedure TIWfrmHumDieLevel.IWBtnBuildClick(Sender: TObject);
var
  Level: Integer;
  psld: PTServerListData;
begin
  Level := StrToInt(IWedtLevel.Text);
  if (Level > objINI.MaxLevel) or (Level = 0) then
  begin
    WebApplication.ShowMessage('等级段应大于0小于等于最大等级'+IntToStr(objINI.MaxLevel)+'，请重新输入');
    Exit;
  end;
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage('起始日期应大于或等于结束日期，请重新选择');
    Exit;
  end;

  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    if not IWLogMode.Checked then
    begin
      UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
      try
        QueryRoleLevel(psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //新模式
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        QueryRoleLevelEx(psld.Ispid, psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
      finally
        UserSession.SQLConnectionLocalLog.Close;
      end;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmHumDieLevel.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'HumDieLevel' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmHumDieLevel.QueryRoleLevel(ServerIndex: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT (Para1 - 1) div %d as idx,serverindex,Para1,count(*) as iCount FROM log_common_%s WHERE serverindex= %d and logdate>="%s" and logdate<="%s" and Logid in (503,504) group by (Para1-1) div %d';
  sqlUnionALL  = ' UNION ALL ';
var
  Level,iCount, nCount: Integer;
  sSQL: string;
begin
  sSQL := '';
  Level := StrToInt(IWedtLevel.Text);

  while DateOf(MinDateTime)<=DateOf(MaxDateTime) do
  begin
     sSQL := sSQL + Format(sqlRoleCount,[Level, FormatDateTime('YYYYMMDD',MinDateTime),
     ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime), Level])+ sqlUnionALL;
     MinDateTime := IncDay(MinDateTime,1);
  end;

  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    iCount := 0; nCount := 0;

    with UserSession.quHumDie,TIWAdvChart1.Chart do
    begin
      Series[0].ClearPoints;

      SQL.Text := sSQL;
      Open;
      try
        while not Eof do
        begin
          Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                                   IntToStr(FieldByName('idx').AsInteger * Level)+'-'+IntToStr(FieldByName('idx').AsInteger * Level + 5)+'级');
          Inc(iCount);
          Next;
        end;
      finally
        Close;
      end;

      Range.RangeFrom := 0;
      Range.RangeTo := iCount-1;
      Series[0].Autorange := arEnabledZeroBased;
    end;
    if iCount * objINI.AutoWidth < objINI.DefaultWidth then
      TIWAdvChart1.Width := objINI.DefaultWidth
    else
      TIWAdvChart1.Width := iCount * objINI.AutoWidth;

    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      with UserSession.quHumDie do
      begin
        SQL.Text := sSQL;
        Open;
        try
          while not Eof do
          begin
            RowCount := nCount + 1;
            cells[1,nCount] := IntToStr(FieldByName('idx').AsInteger) ;
            cells[2,nCount] := IntToStr(FieldByName('idx').AsInteger * Level)+'-'+IntToStr(FieldByName('idx').AsInteger * Level + 5)+'级';
            cells[3,nCount] := IntToStr(FieldByName('iCount').AsInteger);
            Inc(nCount);
            Next;
          end;
        finally
          Close;
        end;
      end;
    end;
  end;
   TIWAdvChart1.Visible := True;
end;

procedure TIWfrmHumDieLevel.QueryRoleLevelEx(Ispid, ServerIndex: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT (Para1 - 1) div %d as idx,serverindex,Para1,count(*) as iCount FROM log_common_%d_%d_%s WHERE serverindex= %d and logdate>="%s" and logdate<="%s" and Logid in (503,504) group by (Para1-1) div %d';
  sqlUnionALL  = ' UNION ALL ';
var
  Level,iCount, nCount: Integer;
  sSQL: string;
begin
  sSQL := '';
  Level := StrToInt(IWedtLevel.Text);

  while DateOf(MinDateTime)<=DateOf(MaxDateTime) do
  begin
     sSQL := sSQL + Format(sqlRoleCount,[Level,Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime),
     ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime), Level])+ sqlUnionALL;
     MinDateTime := IncDay(MinDateTime,1);
  end;

  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    iCount := 0; nCount := 0;

    with UserSession.quHumDieEx,TIWAdvChart1.Chart do
    begin
      Series[0].ClearPoints;

      SQL.Text := sSQL;
      Open;
      try
        while not Eof do
        begin
          Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                                   IntToStr(FieldByName('idx').AsInteger * Level)+'-'+IntToStr(FieldByName('idx').AsInteger * Level + 5)+'级');
          Inc(iCount);
          Next;
        end;
      finally
        Close;
      end;

      Range.RangeFrom := 0;
      Range.RangeTo := iCount-1;
      Series[0].Autorange := arEnabledZeroBased;
    end;
    if iCount * objINI.AutoWidth < objINI.DefaultWidth then
      TIWAdvChart1.Width := objINI.DefaultWidth
    else
      TIWAdvChart1.Width := iCount * objINI.AutoWidth;

    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      with UserSession.quHumDieEx do
      begin
        SQL.Text := sSQL;
        Open;
        try
          while not Eof do
          begin
            RowCount := nCount + 1;
            cells[1,nCount] := IntToStr(FieldByName('idx').AsInteger) ;
            cells[2,nCount] := IntToStr(FieldByName('idx').AsInteger * Level)+'-'+IntToStr(FieldByName('idx').AsInteger * Level + 5)+'级';
            cells[3,nCount] := IntToStr(FieldByName('iCount').AsInteger);
            Inc(nCount);
            Next;
          end;
        finally
          Close;
        end;
      end;
    end;
  end;
   TIWAdvChart1.Visible := True;
end;

initialization
  RegisterClass(TIWfrmHumDieLevel);

end.
