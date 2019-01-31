unit UnitfrmMonDieTotal;

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
  curTitle = '怪物追踪';

type
  TIWfrmMonDieTotal = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    IWBtnBuild: TIWButton;
    IWedtItems: TIWEdit;
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
    procedure TIWAdvWebGrid1ColumnHeaderClick(Sender: TObject;
      ColumnIndex: Integer);
    procedure IWButton3Click(Sender: TObject);
  private
  public
    mynum: Integer;
    strMonName: string;
    procedure QueryMonName(slog: string; ServerIndex, num: Integer; sname: string; MinDateTime, MaxDateTime: TDateTime);
    procedure QueryMonNameEx(ispid, ServerIndex, num: Integer; sname: string; MinDateTime, MaxDateTime: TDateTime);
  end;

var
  IWfrmMonDieTotal: TIWfrmMonDieTotal;

implementation

uses ServerController, ConfigINI, Share;

{$R *.dfm}

{ TIWfrmMonDieTotal }

procedure TIWfrmMonDieTotal.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(curTitle);
  mynum:= 0;
  strMonName := '';
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
end;

procedure TIWfrmMonDieTotal.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date + pSTime.Time > pEDate.Date + pETime.Time then
  begin
    WebApplication.ShowMessage('起始日期应大于或等于结束日期，请重新选择');
    Exit;
  end;

  strMonName:= IWedtItems.Text;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    if not IWLogMode.Checked then
    begin
      UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
      try
        QueryMonName(psld.LogDB,psld.Index, 1, strMonName, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //新模式
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);

      try
        QueryMonNameEx(psld.Ispid, psld.Index, 1, strMonName, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);

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

procedure TIWfrmMonDieTotal.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'MonDieTotal' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmMonDieTotal.QueryMonName(slog: string; ServerIndex, num: Integer; sname: string; MinDateTime, MaxDateTime: TDateTime);
const
  sqlmondies = 'SELECT Logid,serverindex,Userid,Account, COUNT(1) AS iCount FROM log_common_%s WHERE Logid = 810 and %s and serverindex=%d and logdate>="%s" and logdate<="%s"  GROUP BY Userid,Account';
  sqlnomondies = 'SELECT Logid,serverindex,Userid,Account, COUNT(1) AS iCount FROM log_common_%s WHERE Logid = 810 and serverindex=%d and logdate>="%s" and logdate<="%s"  GROUP BY Userid,Account';
  sqlGroup  = 'SELECT Logid,serverindex,Userid,Account,sum(iCount) as iCount FROM(%s) a GROUP BY Userid order by Userid';
  sqlGroup2 = 'SELECT Logid,serverindex,Userid,Account,sum(iCount) as iCount FROM(%s) a GROUP BY Userid order by Account';
  sqlGroup3 = 'SELECT Logid,serverindex,Userid,Account,sum(iCount) as iCount FROM(%s) a GROUP BY Userid order by iCount';
  sqlnames = ' Account in (%s) ';
  sqlUnionALL  = ' UNION ALL ';
  sqldesc = ' desc';
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
  sSQL, sMonID,sMonname, strgroup: string;
begin
   if sname <> '' then
   begin
     sMonID := GetGroupCONCAT(sname);
     if sMonID = ''  then Exit;
     iCount := 0; sMonname := ''; strgroup:= '';
     TIWAdvWebGrid1.ClearCells;
     case num of
        1: strgroup:= sqlGroup;
        2: strgroup:= sqlGroup2;
        3: strgroup:= sqlGroup3;
        10: strgroup:= sqlGroup + sqldesc;  //最大值升序
        20: strgroup:= sqlGroup2 + sqldesc;
        30: strgroup:= sqlGroup3 + sqldesc;
     else
       strgroup:= sqlGroup;
     end;
     if sMonID <> '' then
     begin
       sMonname := sMonname + Format(sqlnames,[sMonID]);
     end;

     while MinDateTime<=MaxDateTime do
     begin
       if UserSession.IsCheckTable(slog,Format('log_common_%s',[FormatDateTime('YYYYMMDD',MinDateTime)])) then
       begin
         sSQL := sSQL+ Format(sqlmondies,[FormatDateTime('YYYYMMDD',MinDateTime),sMonname,ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
       end;
       MinDateTime := MinDateTime+1;
     end;
     if sSQL <> '' then
     begin
       System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
       TIWAdvWebGrid1.ClearCells;
       with UserSession.quMondie,TIWAdvWebGrid1 do
       begin
         SQL.Text := Format(strgroup,[sSQL]);
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
   end
   else begin
     iCount := 0;
     strgroup:= '';
     TIWAdvWebGrid1.ClearCells;
     case num of
        1: strgroup:= sqlGroup;
        2: strgroup:= sqlGroup2;
        3: strgroup:= sqlGroup3;
        10: strgroup:= sqlGroup + sqldesc;
        20: strgroup:= sqlGroup2 + sqldesc;
        30: strgroup:= sqlGroup3 + sqldesc;
     else
       strgroup:= sqlGroup;
     end;
     while MinDateTime<=MaxDateTime do
     begin
       if UserSession.IsCheckTable(slog,Format('log_common_%s',[FormatDateTime('YYYYMMDD',MinDateTime)])) then
       begin
         sSQL := sSQL+ Format(sqlnomondies,[FormatDateTime('YYYYMMDD',MinDateTime),ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
       end;
       MinDateTime := MinDateTime+1;
     end;
     if sSQL <> '' then
     begin
       System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
       TIWAdvWebGrid1.ClearCells;
       with UserSession.quMondie,TIWAdvWebGrid1 do
       begin
         SQL.Text := Format(strgroup,[sSQL]);
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
end;

procedure TIWfrmMonDieTotal.QueryMonNameEx(Ispid, ServerIndex, num: Integer; sname: string; MinDateTime, MaxDateTime: TDateTime);
const
  sqlmondies = 'SELECT Logid,serverindex,Userid,Account, COUNT(1) AS iCount FROM log_common_%d_%d_%s WHERE Logid = 810 and %s and serverindex=%d and logdate>="%s" and logdate<="%s"  GROUP BY Userid,Account';
  sqlnomondies = 'SELECT Logid,serverindex,Userid,Account, COUNT(1) AS iCount FROM log_common_%d_%d_%s WHERE Logid = 810 and serverindex=%d and logdate>="%s" and logdate<="%s"  GROUP BY Userid,Account';
  sqlGroup  = 'SELECT Logid,serverindex,Userid,Account,sum(iCount) as iCount FROM(%s) a GROUP BY Userid order by Userid';
  sqlGroup2 = 'SELECT Logid,serverindex,Userid,Account,sum(iCount) as iCount FROM(%s) a GROUP BY Userid order by Account';
  sqlGroup3 = 'SELECT Logid,serverindex,Userid,Account,sum(iCount) as iCount FROM(%s) a GROUP BY Userid order by iCount';
  sqlnames = ' Account in (%s) ';
  sqlUnionALL  = ' UNION ALL ';
  sqldesc = ' desc';
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
  sSQL, sMonID,sMonname, strgroup: string;
begin
   if sname <> '' then
   begin
     sMonID := GetGroupCONCAT(sname);
     if sMonID = ''  then Exit;
     iCount := 0; sMonname := ''; strgroup:= '';
     TIWAdvWebGrid1.ClearCells;
     case num of
        1: strgroup:= sqlGroup;
        2: strgroup:= sqlGroup2;
        3: strgroup:= sqlGroup3;
        10: strgroup:= sqlGroup + sqldesc;  //最大值升序
        20: strgroup:= sqlGroup2 + sqldesc;
        30: strgroup:= sqlGroup3 + sqldesc;
     else
       strgroup:= sqlGroup;
     end;
     if sMonID <> '' then
     begin
       sMonname := sMonname + Format(sqlnames,[sMonID]);
     end;

     while MinDateTime<=MaxDateTime do
     begin
       if UserSession.IsCheckTableEx(UM_DATA_LOCALLOG,Format('log_common_%d_%d_%s',[Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime)])) then
       begin
         sSQL := sSQL+ Format(sqlmondies,[Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime),sMonname,ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
       end;
       MinDateTime := MinDateTime+1;
     end;
     if sSQL <> '' then
     begin
       System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
       TIWAdvWebGrid1.ClearCells;
       with UserSession.quMondieEx,TIWAdvWebGrid1 do
       begin
         SQL.Text := Format(strgroup,[sSQL]);
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
   end
   else begin
     iCount := 0;
     strgroup:= '';
     TIWAdvWebGrid1.ClearCells;
     case num of
        1: strgroup:= sqlGroup;
        2: strgroup:= sqlGroup2;
        3: strgroup:= sqlGroup3;
        10: strgroup:= sqlGroup + sqldesc;
        20: strgroup:= sqlGroup2 + sqldesc;
        30: strgroup:= sqlGroup3 + sqldesc;
     else
       strgroup:= sqlGroup;
     end;
     while MinDateTime<=MaxDateTime do
     begin
       if UserSession.IsCheckTableEx(UM_DATA_LOCALLOG,Format('log_common_%d_%d_%s',[Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime)])) then
       begin
         sSQL := sSQL+ Format(sqlnomondies,[Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime),ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
       end;
       MinDateTime := MinDateTime+1;
     end;
     if sSQL <> '' then
     begin
       System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
       TIWAdvWebGrid1.ClearCells;
       with UserSession.quMondieEx,TIWAdvWebGrid1 do
       begin
         SQL.Text := Format(strgroup,[sSQL]);
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
end;

procedure TIWfrmMonDieTotal.TIWAdvWebGrid1ColumnHeaderClick(Sender: TObject;
  ColumnIndex: Integer);
var
  psld: PTServerListData;
begin
  if strMonName <> '' then exit;  //如果有输入怪物名称将不使用排序

  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    case ColumnIndex of
        1: begin
             if mynum = 0 then mynum := 9
             else mynum := 0;
           end;
      2: begin
           if mynum = 0 then mynum := 18
           else mynum := 0;
         end;
      3: begin
           if mynum = 0 then mynum := 27
           else mynum := 0;
         end;
    else
       mynum := 0; //防止报错
    end;
    if not IWLogMode.Checked then
    begin
      UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
      try
        QueryMonName(psld.LogDB,psld.Index, ColumnIndex + mynum, strMonName, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
      finally
        UserSession.SQLConnectionRole.Close;
      end;
    end
    else begin
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        QueryMonNameEX(psld.Ispid, psld.Index, ColumnIndex + mynum, strMonName, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
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

initialization
  RegisterClass(TIWfrmMonDieTotal);

end.
