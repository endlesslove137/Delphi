unit UnitfrmCopyTrack;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWTMSEdit, IWTMSCal,
  IWCompCheckbox;

const
  curTitle = '副本追踪';

type
  TIWfrmCopyTrack = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel2: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    pSTime: TTIWAdvTimeEdit;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    IWButton3: TIWButton;
    IWLogMode: TIWCheckBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
  public
    procedure QueryCopyTrack(slog: string; ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
    procedure QueryCopyTrackEx(Ispid, ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
  end;

var
  IWfrmCopyTrack: TIWfrmCopyTrack;

implementation

uses ServerController, ConfigINI, Share;

{$R *.dfm}

{ TIWfrmCopyTrack }

procedure TIWfrmCopyTrack.IWAppFormCreate(Sender: TObject);
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

procedure TIWfrmCopyTrack.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date + pSTime.Time > pEDate.Date + pETime.Time then
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
        QueryCopyTrack(psld.LogDB, psld.Index, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //新模式
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        QueryCopyTrackEx(psld.Ispid, psld.Index, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
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

procedure TIWfrmCopyTrack.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'CopyTrack' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmCopyTrack.QueryCopyTrack(slog: string; ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
const
  sqlmondies = 'SELECT Userid,Account FROM log_common_%s WHERE Logid = 514 and serverindex=%d and logdate>="%s" and logdate<="%s" ';
  sqlGroup = 'SELECT Userid,Account, COUNT(1) AS iCount FROM(%s) a GROUP BY Userid';
  sqlUnionALL  = ' UNION ALL ';
  function GetGroupCONCAT(strName: string): string;
  var
    I: Integer;
    strTmp: string;
    strList: TStringList;
  begin
    Result := '';
    strList := TStringList.Create;
    try
      strList.Delimiter := ',';
      strList.DelimitedText := strName;
      for I := 0 to strList.Count - 1 do
      begin
        strTmp := strList.Strings[I];
        Result := Result + QuerySQLStr(strTmp) + ',';
      end;
      if strList.Count > 0 then
      begin
        System.Delete(Result,Length(Result),1);
      end;
    finally
      strList.Free;
    end;
  end;
var
  iCount: Integer;
  sSQL: string;
begin
   iCount := 0;
   TIWAdvWebGrid1.ClearCells;

   while MinDateTime<=MaxDateTime do
   begin
     if UserSession.IsCheckTable(slog,Format('log_common_%s',[FormatDateTime('YYYYMMDD',MinDateTime)])) then
     begin
       sSQL := sSQL+ Format(sqlmondies,[FormatDateTime('YYYYMMDD',MinDateTime),ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
     end;
     MinDateTime := MinDateTime+1;
   end;
   if sSQL <> '' then
   begin
     System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
     TIWAdvWebGrid1.ClearCells;
     with UserSession.quCopytrack,TIWAdvWebGrid1 do
     begin
       SQL.Text := Format(sqlGroup,[sSQL]);
       Open;
       while not Eof do
       begin
         RowCount := iCount + 1;
         cells[1,iCount] := IntToStr(FieldByName('Userid').AsInteger);
         cells[2,iCount] := UTF8ToWideString(FieldByName('Account').AsAnsiString);
         cells[3,iCount] := IntToStr(FieldByName('iCount').AsInteger);
         Inc(iCount);
         Next;
       end;
       Close;
     end;
   end;
end;

procedure TIWfrmCopyTrack.QueryCopyTrackEx(Ispid, ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
const
  sqlmondies = 'SELECT Userid,Account FROM log_common_%d_%d_%s WHERE Logid = 514 and serverindex=%d and logdate>="%s" and logdate<="%s" ';
  sqlGroup = 'SELECT Userid,Account, COUNT(1) AS iCount FROM(%s) a GROUP BY Userid';
  sqlUnionALL  = ' UNION ALL ';
  function GetGroupCONCAT(strName: string): string;
  var
    I: Integer;
    strTmp: string;
    strList: TStringList;
  begin
    Result := '';
    strList := TStringList.Create;
    try
      strList.Delimiter := ',';
      strList.DelimitedText := strName;
      for I := 0 to strList.Count - 1 do
      begin
        strTmp := strList.Strings[I];
        Result := Result + QuerySQLStr(strTmp) + ',';
      end;
      if strList.Count > 0 then
      begin
        System.Delete(Result,Length(Result),1);
      end;
    finally
      strList.Free;
    end;
  end;
var
  iCount: Integer;
  sSQL: string;
begin
   iCount := 0;
   TIWAdvWebGrid1.ClearCells;

   while MinDateTime<=MaxDateTime do
   begin
     if UserSession.IsCheckTableEx(UM_DATA_LOCALLOG,Format('log_common_%d_%d_%s',[Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime)])) then
     begin
       sSQL := sSQL+ Format(sqlmondies,[Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime),ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
     end;
     MinDateTime := MinDateTime+1;
   end;
   if sSQL <> '' then
   begin
     System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
     TIWAdvWebGrid1.ClearCells;
     with UserSession.quCopytrackEx,TIWAdvWebGrid1 do
     begin
       SQL.Text := Format(sqlGroup,[sSQL]);
       Open;
       while not Eof do
       begin
         RowCount := iCount + 1;
         cells[1,iCount] := IntToStr(FieldByName('Userid').AsInteger);
         cells[2,iCount] := UTF8ToWideString(FieldByName('Account').AsAnsiString);
         cells[3,iCount] := IntToStr(FieldByName('iCount').AsInteger);
         Inc(iCount);
         Next;
       end;
       Close;
     end;
   end;
end;

initialization
  RegisterClass(TIWfrmCopyTrack);

end.
