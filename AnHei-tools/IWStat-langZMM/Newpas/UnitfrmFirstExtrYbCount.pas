unit UnitfrmFirstExtrYbCount;

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
  curTitle = 54;//'�״���ȡԪ������';

type
  TIWfrmFirstExtrYbCount = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    IWLabel2: TIWLabel;
    IWedtMinGold: TIWEdit;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    TIWDateSelector1: TTIWDateSelector;
    TIWAdvTimeEdit1: TTIWAdvTimeEdit;
    IWLabel4: TIWLabel;
    IWedtMaxGold: TIWEdit;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton3: TIWButton;
    IWLogMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryFirstExtrYbCount(ServerIndex, iMinGold, iMaxGold: Integer;MinDateTime,MaxDateTime: TDateTime);
    procedure QueryFirstExtrYbCountEx(Ispid, ServerIndex, iMinGold, iMaxGold: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmFirstExtrYbCount: TIWfrmFirstExtrYbCount;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmFirstExtrYbCount.IWAppFormCreate(Sender: TObject);
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
  IWLabel2.Caption := Langtostr(353);
  IWLabel3.Caption := Langtostr(151);
  IWLabel4.Caption := Langtostr(354);
  IWLogMode.Caption := Langtostr(183);
  IWBtnBuild.Caption := Langtostr(171);
  IWButton3.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(355);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(356);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(357);
end;

procedure TIWfrmFirstExtrYbCount.IWBtnBuildClick(Sender: TObject);
var
  MinGold, MaxGold: Integer;
  psld: PTServerListData;
begin
  MinGold := StrToInt(IWedtMinGold.Text);
  MaxGold := StrToInt(IWedtMaxGold.Text);
  if (MinGold < 0) or (MaxGold < 0) then
  begin
    WebApplication.ShowMessage(Langtostr(351));
    Exit;
  end;

  if MinGold > MaxGold then
  begin
    WebApplication.ShowMessage(Langtostr(352));
    Exit;
  end;

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
        QueryFirstExtrYbCount(psld.Index, MinGold, MaxGold,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //��ģʽ
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        QueryFirstExtrYbCountEx(psld.Ispid, psld.Index, MinGold, MaxGold,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
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

procedure TIWfrmFirstExtrYbCount.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'FirstExtrYbCount' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmFirstExtrYbCount.QueryFirstExtrYbCount(ServerIndex, iMinGold, iMaxGold: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT serverindex,Para1,Para2 FROM log_common_%s WHERE serverindex= %d and logdate>="%s" and logdate<="%s" and Logid = 177  and Para0 = 3 and Para1>%d and Para1<=%d ';
  sqlGroup =  'SELECT serverindex,Para1,Para2,COUNT(1) AS iCount FROM (%s) b GROUP BY Para2';
  sqlGroupex =  'SELECT serverindex,Para1,Para2,COUNT(1) AS iCount FROM (%s) b GROUP BY Para1,Para2';
  sqlUnionALL  = ' UNION ALL ';
var
  iCount, nCount: Integer;
  sSQL: string;
begin
  sSQL := '';

  while DateOf(MinDateTime)<=DateOf(MaxDateTime) do
  begin
     sSQL := sSQL + Format(sqlRoleCount,[FormatDateTime('YYYYMMDD',MinDateTime),
     ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime), iMinGold, iMaxGold]) + sqlUnionALL;
     MinDateTime := IncDay(MinDateTime,1);
  end;

  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    iCount := 0; nCount := 0;
    with UserSession.quExrtGoldTotal,TIWAdvChart1.Chart do
    begin
      Series[0].ClearPoints;
      SQL.Text := Format(sqlGroup,[sSQL]);
      Open;
      try
        while not Eof do
        begin
          Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                                  IntToStr(FieldByName('Para2').AsInteger) + Langtostr(317));
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
        TIWAdvChart1.Width := iCount * objINI.AutoWidth;
    end;
    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      with UserSession.quExrtGoldTotal do
      begin
        SQL.Text := Format(sqlGroupex,[sSQL]);
        Open;
        try
          while not Eof do
          begin
            RowCount := nCount + 1;
            cells[1,nCount] := IntToStr(FieldByName('Para1').AsInteger);  //����
            cells[2,nCount] := IntToStr(FieldByName('Para2').AsInteger); //�ȼ�
            cells[3,nCount] := IntToStr(FieldByName('iCount').AsInteger); //����
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

procedure TIWfrmFirstExtrYbCount.QueryFirstExtrYbCountEx(Ispid, ServerIndex, iMinGold, iMaxGold: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT serverindex,Para1,Para2 FROM log_common_%d_%d_%s WHERE serverindex= %d and logdate>="%s" and logdate<="%s" and Logid = 177  and Para0 = 3 and Para1>%d and Para1<=%d ';
  sqlGroup =  'SELECT serverindex,Para1,Para2,COUNT(1) AS iCount FROM (%s) b GROUP BY Para2';
  sqlGroupex =  'SELECT serverindex,Para1,Para2,COUNT(1) AS iCount FROM (%s) b GROUP BY Para1,Para2';
  sqlUnionALL  = ' UNION ALL ';
var
  iCount, nCount: Integer;
  sSQL: string;
begin
  sSQL := '';

  while DateOf(MinDateTime)<=DateOf(MaxDateTime) do
  begin
     sSQL := sSQL + Format(sqlRoleCount,[Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime),
     ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime), iMinGold, iMaxGold]) + sqlUnionALL;
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
                                  IntToStr(FieldByName('Para2').AsInteger) + Langtostr(317));
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
        TIWAdvChart1.Width := iCount * objINI.AutoWidth;
    end;
    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      with UserSession.quExrtGoldTotalEx do
      begin
        SQL.Text := Format(sqlGroupex,[sSQL]);
        Open;
        try
          while not Eof do
          begin
            RowCount := nCount + 1;
            cells[1,nCount] := IntToStr(FieldByName('Para1').AsInteger);  //����
            cells[2,nCount] := IntToStr(FieldByName('Para2').AsInteger); //�ȼ�
            cells[3,nCount] := IntToStr(FieldByName('iCount').AsInteger); //����
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
  RegisterClass(TIWfrmFirstExtrYbCount);

end.