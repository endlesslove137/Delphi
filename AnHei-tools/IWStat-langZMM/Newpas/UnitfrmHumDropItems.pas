unit UnitfrmHumDropItems;

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
  curTitle = '人物死亡掉落部位';

type
  TIWfrmHumDropItems = class(TIWFormBasic)
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
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton3: TIWButton;
    IWLogMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryRoleMap(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
    procedure QueryRoleMapEx(Ispid, ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmHumDropItems: TIWfrmHumDropItems;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmHumDropItems.IWAppFormCreate(Sender: TObject);
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

procedure TIWfrmHumDropItems.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
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
        QueryRoleMap(psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //新模式
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        QueryRoleMapEx(psld.Ispid, psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
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

procedure TIWfrmHumDropItems.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'HumDropItems' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmHumDropItems.QueryRoleMap(ServerIndex: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT LongStr1 FROM log_common_%s WHERE serverindex= %d and Logid = 807 and logdate>="%s" and logdate<="%s" and LongStr1 >= 0 and LongStr1 <= 14';
  sqlGroup =  'SELECT LongStr1,COUNT(1) AS iCount FROM (%s) b GROUP BY LongStr1 ';
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
                                 ItemTypeStr(Str_ToInt(string(FieldByName('LongStr1').AsAnsiString), 0)));  //数组—字符串转int
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
        TIWAdvChart1.Width := iCount * (objINI.AutoWidth + 20);
    end;
    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      with UserSession.quHumDie do
      begin
        SQL.Text := Format(sqlGroup,[sSQL]);
        Open;
        try
          while not Eof do
          begin
            RowCount := nCount + 1;
            cells[1,nCount] := ItemTypeStr(Str_ToInt(string(FieldByName('LongStr1').AsAnsiString), 0));
            cells[2,nCount] := IntToStr(FieldByName('iCount').AsInteger);
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

procedure TIWfrmHumDropItems.QueryRoleMapEx(Ispid, ServerIndex: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT LongStr1 FROM log_common_%d_%d_%s WHERE serverindex= %d and Logid = 807 and logdate>="%s" and logdate<="%s" and LongStr1 >= 0 and LongStr1 <= 14';
  sqlGroup =  'SELECT LongStr1,COUNT(1) AS iCount FROM (%s) b GROUP BY LongStr1 ';
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
    with UserSession.quHumDieEx,TIWAdvChart1.Chart do
    begin
      Series[0].ClearPoints;
      SQL.Text := Format(sqlGroup,[sSQL]);
      Open;
      try
        while not Eof do
        begin
         Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
                                 ItemTypeStr(Str_ToInt(string(FieldByName('LongStr1').AsAnsiString), 0)));  //数组—字符串转int
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
        TIWAdvChart1.Width := iCount * (objINI.AutoWidth + 20);
    end;
    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      with UserSession.quHumDieEx do
      begin
        SQL.Text := Format(sqlGroup,[sSQL]);
        Open;
        try
          while not Eof do
          begin
            RowCount := nCount + 1;
            cells[1,nCount] := ItemTypeStr(Str_ToInt(string(FieldByName('LongStr1').AsAnsiString), 0));
            cells[2,nCount] := IntToStr(FieldByName('iCount').AsInteger);
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
  RegisterClass(TIWfrmHumDropItems);

end.
