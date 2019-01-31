unit UnitfrmFirstConsume;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWTMSEdit, IWTMSCal,
  IWCompCheckbox;

const
  curTitle = 56;//'首次消费功能';

type
  TIWfrmFirstConsume = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel3: TIWLabel;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    pETime: TTIWAdvTimeEdit;
    pEDate: TTIWDateSelector;
    IWButton3: TIWButton;
    IWLogMode: TIWCheckBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
  public
    procedure QueryFirstConsume(slog: string; ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
    procedure QueryFirstConsumeEx(Ispid, ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
  end;

var
  IWfrmFirstConsume: TIWfrmFirstConsume;

implementation

uses ServerController, ConfigINI, Share;

{$R *.dfm}

{ TIWfrmFirstConsume }

procedure TIWfrmFirstConsume.IWAppFormCreate(Sender: TObject);
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

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(347);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(341);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(358);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(359);
end;

procedure TIWfrmFirstConsume.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date + pSTime.Time > pEDate.Date + pETime.Time then
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
        QueryFirstConsume(psld.LogDB,psld.Index, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //新模式
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        QueryFirstConsumeEx(psld.Ispid, psld.Index, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
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


procedure TIWfrmFirstConsume.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'FirstConsume' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmFirstConsume.QueryFirstConsume(slog: string; ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
const
  sqlSeedTotal = 'SELECT LongStr2,Para1 FROM log_common_%s WHERE Logid = 178 and Para0 = 3 and serverindex=%d and logdate>="%s" and logdate<="%s"';
  sqlGroup  = 'SELECT LongStr2,sum(Para1) as igold ,COUNT(1) AS iCount FROM (%s) b GROUP BY LongStr2';
  sqlUnionALL  = ' UNION ALL ';
var
  iCount: Integer;
  sSQL: string;
begin
  while MinDateTime<=MaxDateTime do
  begin
    if UserSession.IsCheckTable(slog,Format('log_common_%s',[FormatDateTime('YYYYMMDD',MinDateTime)])) then
    begin
      sSQL := sSQL+ Format(sqlSeedTotal,[FormatDateTime('YYYYMMDD',MinDateTime),ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
    end;
    MinDateTime := MinDateTime+1;
  end;
  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    TIWAdvWebGrid1.ClearCells;
    iCount := 0;
    with UserSession.quExrtGoldTotal,TIWAdvWebGrid1 do
    begin
      SQL.Text := Format(sqlGroup,[sSQL]);
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := Utf8ToString(FieldByName('LongStr2').AsAnsiString);
        cells[2,iCount] := IntToStr(FieldByName('igold').AsInteger);
        cells[3,iCount] := IntToStr(FieldByName('iCount').AsInteger); //暂时代替
        cells[4,iCount] := IntToStr(FieldByName('iCount').AsInteger);
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;
end;

procedure TIWfrmFirstConsume.QueryFirstConsumeEx(Ispid, ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
const
  sqlSeedTotal = 'SELECT LongStr2,Para1 FROM log_common_%d_%d_%s WHERE Logid = 178 and Para0 = 3 and serverindex=%d and logdate>="%s" and logdate<="%s"';
  sqlGroup  = 'SELECT LongStr2,sum(Para1) as igold ,COUNT(1) AS iCount FROM (%s) b GROUP BY LongStr2';
  sqlUnionALL  = ' UNION ALL ';
var
  iCount: Integer;
  sSQL: string;
begin
  while MinDateTime<=MaxDateTime do
  begin
    if UserSession.IsCheckTableEx(UM_DATA_LOCALLOG,Format('log_common_%d_%d_%s',[Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime)])) then
    begin
      sSQL := sSQL+ Format(sqlSeedTotal,[Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime),ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
    end;
    MinDateTime := MinDateTime+1;
  end;
  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    TIWAdvWebGrid1.ClearCells;
    iCount := 0;
    with UserSession.quExrtGoldTotalEx,TIWAdvWebGrid1 do
    begin
      SQL.Text := Format(sqlGroup,[sSQL]);
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := Utf8ToString(FieldByName('LongStr2').AsAnsiString);
        cells[2,iCount] := IntToStr(FieldByName('igold').AsInteger);
        cells[3,iCount] := IntToStr(FieldByName('iCount').AsInteger); //暂时代替
        cells[4,iCount] := IntToStr(FieldByName('iCount').AsInteger);
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmFirstConsume);

end.
