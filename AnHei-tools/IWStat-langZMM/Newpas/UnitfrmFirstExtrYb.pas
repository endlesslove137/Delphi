unit UnitfrmFirstExtrYb;

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
  curTitle = 55;//'首次提取元宝';

type
  TIWfrmFirstExtrYb = class(TIWFormBasic)
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
    TIWDateSelector1: TTIWDateSelector;
    TIWAdvTimeEdit1: TTIWAdvTimeEdit;
    IWButton3: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLogMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryRolelevel(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
    procedure QueryRolelevelEx(Ispid, ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmFirstExtrYb: TIWfrmFirstExtrYb;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmFirstExtrYb.IWAppFormCreate(Sender: TObject);
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

  IWLogMode.Caption := Langtostr(183);
  IWBtnBuild.Caption := Langtostr(171);
  IWButton3.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(356);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(357);
end;

procedure TIWfrmFirstExtrYb.IWBtnBuildClick(Sender: TObject);
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
    if not IWLogMode.Checked then
    begin
      UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
      try
        QueryRolelevel(psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //新模式
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        QueryRolelevelEx(psld.Ispid, psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
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

procedure TIWfrmFirstExtrYb.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'FirstExtrYb' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmFirstExtrYb.QueryRolelevel(ServerIndex: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT Para2 FROM log_common_%s WHERE serverindex= %d and Logid = 177 and Para0 = 3 and logdate>="%s" and logdate<="%s" ';
  sqlGroup =  'SELECT Para2, COUNT(1) AS iCount FROM (%s) b GROUP BY Para2 ';
  sqlUnionALL  = ' UNION ALL ';
var
  iCount, nCount: Integer;
  sSQL: string;
begin
  sSQL := '';

  while DateOf(MinDateTime)<=DateOf(MaxDateTime) do
  begin
     sSQL := sSQL + Format(sqlRoleCount,[FormatDateTime('YYYYMMDD',MinDateTime),
     ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
     MinDateTime := IncDay(MinDateTime,1);
  end;

  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    iCount := 0; nCount := 0;
    with UserSession.quHumDie,TIWAdvChart1.Chart do
    begin
      Series[0].ClearPoints;
      SQL.Text := Format(sqlGroup,[sSQL]);
      Open;
      try
        while not Eof do
        begin
          Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                                 inttostr(FieldByName('Para2').AsInteger) + Langtostr(317));
          Inc(iCount);
          Next;
        end;
      finally
        Close;
      end;

      Range.RangeFrom := 0;
      Range.RangeTo := iCount-1;
      Series[0].Autorange := arEnabledZeroBased;
      if iCount * objINI.AutoWidth < objINI.DefaultWidth then
        TIWAdvChart1.Width := objINI.DefaultWidth
      else
        TIWAdvChart1.Width := iCount * objINI.AutoWidth ;
    end;
    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      with UserSession.quExrtGoldTotal do
      begin
        SQL.Text := Format(sqlGroup,[sSQL]);
        Open;
        try
          while not Eof do
          begin
            RowCount := nCount + 1;
            cells[1,nCount] := IntToStr(FieldByName('Para2').AsInteger); //等级
            cells[2,nCount] := IntToStr(FieldByName('iCount').AsInteger); //人数
            Inc(nCount);
            Next;
          end;
        finally
          Close;
        end;
      end;
    end;
    TIWAdvChart1.Visible := True;
  end;
end;

procedure TIWfrmFirstExtrYb.QueryRolelevelEx(Ispid, ServerIndex: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT Para2 FROM log_common_%d_%d_%s WHERE serverindex= %d and Logid = 177 and Para0 = 3 and logdate>="%s" and logdate<="%s" ';
  sqlGroup =  'SELECT Para2, COUNT(1) AS iCount FROM (%s) b GROUP BY Para2 ';
  sqlUnionALL  = ' UNION ALL ';
var
  iCount, nCount: Integer;
  sSQL: string;
begin
  sSQL := '';

  while DateOf(MinDateTime)<=DateOf(MaxDateTime) do
  begin
     sSQL := sSQL + Format(sqlRoleCount,[Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime),
     ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
     MinDateTime := IncDay(MinDateTime,1);
  end;

  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    iCount := 0; nCount := 0;
    with UserSession.quExrtGoldTotalEx,TIWAdvChart1.Chart do
    begin
      Series[0].ClearPoints;
      SQL.Text := Format(sqlGroup,[sSQL]);
      Open;
      try
        while not Eof do
        begin
          Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                                 inttostr(FieldByName('Para2').AsInteger) + Langtostr(317));
          Inc(iCount);
          Next;
        end;
      finally
        Close;
      end;

      Range.RangeFrom := 0;
      Range.RangeTo := iCount-1;
      Series[0].Autorange := arEnabledZeroBased;
      if iCount * objINI.AutoWidth < objINI.DefaultWidth then
        TIWAdvChart1.Width := objINI.DefaultWidth
      else
        TIWAdvChart1.Width := iCount * objINI.AutoWidth ;
    end;
    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      with UserSession.quExrtGoldTotalEx do
      begin
        SQL.Text := Format(sqlGroup,[sSQL]);
        Open;
        try
          while not Eof do
          begin
            RowCount := nCount + 1;
            cells[1,nCount] := IntToStr(FieldByName('Para2').AsInteger); //等级
            cells[2,nCount] := IntToStr(FieldByName('iCount').AsInteger); //人数
            Inc(nCount);
            Next;
          end;
        finally
          Close;
        end;
      end;
    end;
    TIWAdvChart1.Visible := True;
  end;
end;

initialization
  RegisterClass(TIWfrmFirstExtrYb);

end.
