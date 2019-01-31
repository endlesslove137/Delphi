unit UnitIWfrmHumLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompEdit, IWTMSCal, IWCompButton, IWWebGrid,
  IWAdvWebGrid, IWTMSPopup, Menus,
  IWAppForm, DateUtils, IWCompListbox, IWExchangeBar, IWCompRectangle,
  IWTMSCtrls, IWTMSEdit, ServerController, IWCompCheckbox;

const
  curTitle = 82;//'人物日志';

type
  TIWfrmHumLog = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    IWLabel2: TIWLabel;
    EditHumName: TIWEdit;
    EditItemName: TIWEdit;
    IWbtTrace: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    PopupMenu1: TPopupMenu;
    H1: TMenuItem;
    H2: TMenuItem;
    L1: TMenuItem;
    L2: TMenuItem;
    T1: TMenuItem;
    TIWPopupMenuButton1: TTIWPopupMenuButton;
    IWLabel5: TIWLabel;
    IWcBoxLogIdent: TIWComboBox;
    IWLabel3: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel4: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWButton1: TIWButton;
    IWLabel6: TIWLabel;
    EditORLogIdent: TIWEdit;
    IWLabel9: TIWLabel;
    IWLogMode: TIWCheckBox;
    procedure T1Click(Sender: TObject);
    procedure L2Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure H2Click(Sender: TObject);
    procedure H1Click(Sender: TObject);
    procedure IWbtTraceClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
  private
    IsExport: Boolean;
  public
    FLogRecords: array of TLogRecord;
    procedure QueryHumLog(ServerIndex: Integer;sHumName, sItemName: string; DateStart, DateEnd: TDateTime;sLogid: string);
    function FormatQueryText(ServerIndex: Integer;sHunName, sItemName, sDate: string; DateStart, DateEnd: TDateTime; sLogid: string): string;
    procedure QueryHumLogEx(ispid, ServerIndex: Integer;sHumName, sItemName: string; DateStart, DateEnd: TDateTime;sLogid: string);
    function FormatQueryTextEx(ispid, ServerIndex: Integer;sHunName, sItemName, sDate: string; DateStart, DateEnd: TDateTime; sLogid: string): string;

    procedure SetWebGridData;
  end;

var
  IWfrmHumLog: TIWfrmHumLog;

implementation

uses ConfigINI;

{$R *.dfm}

function TIWfrmHumLog.FormatQueryText(ServerIndex: Integer;sHunName, sItemName, sDate: string;
  DateStart, DateEnd: TDateTime;sLogid: string): string;
const
  sSelectFrom = 'select Logid,Account,midstr0,Para0,Para1,Para2,LongStr0,LongStr1,LongStr2,logdate from log_common_%s where serverindex=%d AND ';
  sConditionOfHuman = ' account=%s ';
  sConditionOfItem = ' LongStr2="%s" ';
  sqlLogident = ' Logid in (%s) ';
  slogdate = ' logdate>="%s" AND logdate<="%s" ';
  sOderBy = 'order by logdate ';
var
  boNeedAnd: Boolean;
begin
  boNeedAnd := False;
  Result := Format(sSelectFrom, [sDate,ServerIndex]);
  if sHunName <> '' then
  begin
    Result := Result + Format(sConditionOfHuman, [QuerySQLStr(sHunName), QuerySQLStr(sHunName)]);
    boNeedAnd := True;
  end;
  if sItemName <> '' then
  begin
    if boNeedAnd then Result := Result + ' and ';
    Result := Result + Format(sConditionOfItem, [QuerySQLStr(sItemName)]);
    boNeedAnd := True;
  end;
  if (sLogid <> '') and (sLogid <> '0') then
  begin
    if boNeedAnd then Result := Result + ' and ';
    Result := Result + Format(sqlLogident,[sLogid]);
  end;
  Result := Result + ' and ';
  Result := Result + Format(slogdate,[DateTimeToStr(DateStart),DateTimeToStr(DateEnd)]);
  Result := Result + sOderBy;
end;

function TIWfrmHumLog.FormatQueryTextEx(ispid, ServerIndex: Integer;sHunName, sItemName, sDate: string;
  DateStart, DateEnd: TDateTime;sLogid: string): string;
const
  sSelectFrom = 'select Logid,Account,midstr0,Para0,Para1,Para2,midstr1,midstr2,LongStr0,LongStr1,LongStr2,logdate from log_common_%d_%d_%s where serverindex=%d AND ';
  sConditionOfHuman = ' account=%s ';
  sConditionOfItem = ' LongStr2=%s ';
  sqlLogident = ' Logid in (%s) ';
  slogdate = ' logdate>="%s" AND logdate<="%s" ';
  sOderBy = 'order by logdate ';
var
  boNeedAnd: Boolean;
begin
  boNeedAnd := False;
  Result := Format(sSelectFrom, [ispid,ServerIndex,sDate,ServerIndex]);
  if sHunName <> '' then
  begin
    Result := Result + Format(sConditionOfHuman, [QuerySQLStr(sHunName), QuerySQLStr(sHunName)]);
    boNeedAnd := True;
  end;
  if sItemName <> '' then
  begin
    if boNeedAnd then Result := Result + ' and ';
    Result := Result + Format(sConditionOfItem, [QuerySQLStr(sItemName)]);
    boNeedAnd := True;
  end;
  if (sLogid <> '') and (sLogid <> '0') then
  begin
    if boNeedAnd then Result := Result + ' and ';
    Result := Result + Format(sqlLogident,[sLogid]);
  end;
  Result := Result + ' and ';
  Result := Result + Format(slogdate,[DateTimeToStr(DateStart),DateTimeToStr(DateEnd)]);
  Result := Result + sOderBy;
end;

procedure TIWfrmHumLog.H1Click(Sender: TObject);
var
  iRow: Integer;
  sHumName: string;
begin
  iRow := TIWAdvWebGrid1.RowOffset+TIWAdvWebGrid1.RadioSelection;
  if iRow <> -1 then
  begin
    sHumName := GetCellName(TIWAdvWebGrid1.Cells[1,iRow]);
    if sHumName = EditHumName.Text then Exit;
    ShowHumlog(sHumName,EditItemName.Text,pSDate.Date,pEDate.Date);
  end;
end;

procedure TIWfrmHumLog.H2Click(Sender: TObject);
var
  iRow: Integer;
  sHumName: string;
begin
  iRow := TIWAdvWebGrid1.RowOffset+TIWAdvWebGrid1.RadioSelection;
  if iRow <> -1 then
  begin
    sHumName := GetCellName(TIWAdvWebGrid1.Cells[3,iRow]);
    if sHumName = EditHumName.Text then Exit;
    ShowHumlog(sHumName,EditItemName.Text,pSDate.Date,pEDate.Date);
  end;
end;

procedure TIWfrmHumLog.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date();
  pEDate.Date := Date();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  IsExport := False;
  IWcBoxLogIdent.Items.AddStrings(LogIdentList);
  IWcBoxLogIdent.Items.Insert(0,Langtostr(445));
  IWcBoxLogIdent.ItemIndex := 0;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel3.Caption := Langtostr(150);
  IWLabel4.Caption := Langtostr(151);
  IWLabel1.Caption := Langtostr(440);
  IWLabel2.Caption := Langtostr(441);
  IWLabel5.Caption := Langtostr(442);
  IWLabel6.Caption := Langtostr(444);
  IWLabel9.Caption := Langtostr(443);
  IWbtTrace.Caption := Langtostr(14);
  IWButton1.Caption := Langtostr(182);
  IWLogMode.Caption := Langtostr(183);
  TIWPopupMenuButton1.Caption := Langtostr(447);

  H1.Caption := Langtostr(448);
  H2.Caption := Langtostr(449);
  L1.Caption := Langtostr(450);
  L2.Caption := Langtostr(451);
  T1.Caption := Langtostr(452);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(366);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(457);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(454);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(402);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(455);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(456);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(403);
  TIWAdvWebGrid1.Columns[8].Title:= Langtostr(404);
  TIWAdvWebGrid1.Columns[9].Title:= Langtostr(458);
  TIWAdvWebGrid1.Columns[10].Title:= Langtostr(459);
end;

procedure TIWfrmHumLog.IWbtTraceClick(Sender: TObject);
var
  sLogid: string;
  psld: PTServerListData;
begin
  if ((Trim(EditHumName.Text) = '') and (IWcBoxLogIdent.ItemIndex=0)) and (Trim(EditORLogIdent.Text) = '') then
  begin
    WebApplication.ShowMessage(Langtostr(446));
    Exit;
  end;
  if DayOf(pEDate.Date)-DayOf(pSDate.Date) >= 7 then
  begin
    WebApplication.ShowMessage(Langtostr(436));
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
    end;
    if not IWLogMode.Checked then
    begin
      UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
      try
        if EditORLogIdent.Text = '' then
         sLogid := Copy(IWcBoxLogIdent.Text,1,Pos('、',IWcBoxLogIdent.Text)-1)
        else  sLogid := EditORLogIdent.Text;

        QueryHumLog( psld.Index, EditHumName.Text, EditItemName.Text, pSDate.Date+pSTime.Time, pEDate.Date+pETime.Time,sLogid);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //新模式
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        if EditORLogIdent.Text = '' then
         sLogid := Copy(IWcBoxLogIdent.Text,1,Pos('、',IWcBoxLogIdent.Text)-1)
        else  sLogid := EditORLogIdent.Text;

        QueryHumLogEx( psld.Ispid, psld.Index, EditHumName.Text, EditItemName.Text, pSDate.Date+pSTime.Time, pEDate.Date+pETime.Time,sLogid);
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

procedure TIWfrmHumLog.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  IsExport := True;
  try
    IWbtTrace.OnClick(self);
    sFileName := 'HumLog'+DateToStr(pSDate.Date) + '.csv';
    TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
    WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
    DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
  finally
    IsExport := False;
  end;
end;

procedure TIWfrmHumLog.L1Click(Sender: TObject);
var
  iRow: Integer;
  sHumName: string;
begin
  iRow := TIWAdvWebGrid1.RowOffset+TIWAdvWebGrid1.RadioSelection;
  if iRow <> -1 then
  begin
    sHumName := GetCellName(TIWAdvWebGrid1.Cells[1,iRow]);
    ShowLoginLog(0,sHumName,pSDate.Date,pEDate.Date);
  end;
end;

procedure TIWfrmHumLog.L2Click(Sender: TObject);
var
  iRow: Integer;
  sHumName: string;
begin
  iRow := TIWAdvWebGrid1.RowOffset+TIWAdvWebGrid1.RadioSelection;
  if iRow <> -1 then
  begin
    sHumName := GetCellName(TIWAdvWebGrid1.Cells[3,iRow]);
    ShowLoginLog(0,sHumName,pSDate.Date,pEDate.Date);
  end;
end;

procedure TIWfrmHumLog.QueryHumLog(ServerIndex: Integer;sHumName, sItemName: string; DateStart,
  DateEnd: TDateTime;sLogid: string);
var
  sDate: string;
  pRec: PTLogRecord;
  sqlMaxTime: TDate;
  nRecSize, nMaxSize: Integer;
begin
  SetLength( FLogRecords, 0 );
  nMaxSize := 0; nRecSize := 0;
  pRec := nil;
  TIWAdvWebGrid1.RadioSelection := -1;
  TIWAdvWebGrid1.RowOffset := 0;
  TIWAdvWebGrid1.ClearCells;
  if DateEnd > Now then DateEnd := Now;
  sqlMaxTime := DateOf(DateStart);
  while sqlMaxTime <= DateEnd do
  begin
    sDate := FormatDateTime('yyyymmdd', sqlMaxTime);
    with UserSession.quHumLog do
    begin
      SQL.Text := FormatQueryText(ServerIndex, sHumName, sItemName, sDate, DateStart,DateEnd ,sLogid);
      Open;
      try
        First;
        while not Eof do
        begin
          if nRecSize >= nMaxSize then
          begin
            Inc( nMaxSize, 200 );
            SetLength(FLogRecords, nMaxSize);
            pRec := @FLogRecords[nRecSize];
          end;
          pRec.nIdent := Fields[0].AsInteger;
          pRec.sSender := Utf8ToString(Fields[1].AsAnsiString);
          pRec.sMidStr0 := Utf8ToString(Fields[2].AsAnsiString);
          pRec.nType := Fields[3].AsInteger;
          pRec.nChange := Fields[4].AsInteger;
          pRec.nCount := Fields[5].AsInteger;
          pRec.sRemark := Utf8ToString(Fields[8].AsAnsiString + ' ' + Fields[6].AsAnsiString + ' '  + Fields[7].AsAnsiString);
          pRec.sObjId := Utf8ToString(Fields[9].AsAnsiString);
          pRec.sObjName := Utf8ToString(Fields[10].AsAnsiString);
          pRec.sDate := Utf8ToString(Fields[11].AsAnsiString);
          Next;
          Inc( pRec );
          Inc( nRecSize );
        end;
      finally
        Close;
      end;
      sqlMaxTime := IncDay(sqlMaxTime,1);
    end;
  end;
  TIWAdvWebGrid1.TotalRows := nRecSize;
  if nRecSize < objINI.MaxPageCount then
  begin
    TIWAdvWebGrid1.RowCount := nRecSize;
  end
  else
  begin
    TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;
  end;
  SetWebGridData;
  TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共 %d 个记录 &nbsp;&nbsp;',[nRecSize]);
end;

procedure TIWfrmHumLog.QueryHumLogEx(ispid, ServerIndex: Integer;sHumName, sItemName: string; DateStart,
  DateEnd: TDateTime;sLogid: string);
var
  sDate: string;
  pRec: PTLogRecord;
  sqlMaxTime: TDate;
  nRecSize, nMaxSize: Integer;
begin
  SetLength( FLogRecords, 0 );
  nMaxSize := 0; nRecSize := 0;
  pRec := nil;
  TIWAdvWebGrid1.RadioSelection := -1;
  TIWAdvWebGrid1.RowOffset := 0;
  TIWAdvWebGrid1.ClearCells;
  if DateEnd > Now then DateEnd := Now;
  sqlMaxTime := DateOf(DateStart);
  while sqlMaxTime <= DateEnd do
  begin
    sDate := FormatDateTime('yyyymmdd', sqlMaxTime);
    with UserSession.quHumLogEx do
    begin
      SQL.Text := FormatQueryTextEx(ispid, ServerIndex, sHumName, sItemName, sDate, DateStart,DateEnd ,sLogid);
      Open;
      try
        First;
        while not Eof do
        begin
          if nRecSize >= nMaxSize then
          begin
            Inc( nMaxSize, 200 );
            SetLength(FLogRecords, nMaxSize);
            pRec := @FLogRecords[nRecSize];
          end;
          pRec.nIdent := Fields[0].AsInteger;
          pRec.sSender := Utf8ToString(Fields[1].AsAnsiString);
          pRec.sMidStr0 := Utf8ToString(Fields[2].AsAnsiString);
          pRec.nType := Fields[3].AsInteger;
          pRec.nChange := Fields[4].AsInteger;
          pRec.nCount := Fields[5].AsInteger;
          pRec.sRemark := Utf8ToString(Fields[8].AsAnsiString + ' '  + Fields[6].AsAnsiString + ' '  + Fields[7].AsAnsiString);
          pRec.sObjId := Utf8ToString(Fields[9].AsAnsiString);
          pRec.sObjName := Utf8ToString(Fields[10].AsAnsiString);
          pRec.sDate := Utf8ToString(Fields[11].AsAnsiString);
          Next;
          Inc( pRec );
          Inc( nRecSize );
        end;
      finally
        Close;
      end;
      sqlMaxTime := IncDay(sqlMaxTime,1);
    end;
  end;
  TIWAdvWebGrid1.TotalRows := nRecSize;
  if nRecSize < objINI.MaxPageCount then
  begin
    TIWAdvWebGrid1.RowCount := nRecSize;
  end
  else
  begin
    TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;
  end;
  SetWebGridData;
  TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(453),[nRecSize]);
end;

procedure TIWfrmHumLog.SetWebGridData;
var
  I: Integer;
  sFontColor: string;
  pLogRec: PTLogRecord;
begin
  if Length(FLogRecords) = 0 then Exit;
  for I := 0 to TIWAdvWebGrid1.TotalRows - 1 do
  begin
    pLogRec := @FLogRecords[I];
    sFontColor := '%s';
    if (pLogRec^.sSender <> EditHumName.Text) and not IsExport then
    begin
//      sFontColor := '<FONT color=red>%s</FONT>';
    end;
    TIWAdvWebGrid1.Cells[1,I] := Format(sFontColor,[pLogRec^.sSender]);
    TIWAdvWebGrid1.Cells[2,I] := Format(sFontColor,[GetLogIdentStr(pLogRec^.nIdent)]);
    TIWAdvWebGrid1.Cells[3,I] := Format(sFontColor,[pLogRec^.sMidStr0]);
    TIWAdvWebGrid1.Cells[4,I] := Format(sFontColor,[IntToStr(pLogRec^.nType)]);
    TIWAdvWebGrid1.Cells[5,I] := Format(sFontColor,[IntToStr(pLogRec^.nChange)]);
    TIWAdvWebGrid1.Cells[6,I] := Format(sFontColor,[IntToStr(pLogRec^.nCount)]);
    TIWAdvWebGrid1.Cells[7,I] := Format(sFontColor,[pLogRec^.sObjName]);
    TIWAdvWebGrid1.Cells[8,I] := Format(sFontColor,[pLogRec^.sObjId]);
    TIWAdvWebGrid1.Cells[9,I] := Format(sFontColor,[pLogRec^.sDate]);
    TIWAdvWebGrid1.Cells[10,I] := Format(sFontColor,[pLogRec^.sRemark]);
  end;
end;

procedure TIWfrmHumLog.T1Click(Sender: TObject);
var
  iRow: Integer;
  ItemID: string;
begin
  iRow := TIWAdvWebGrid1.RowOffset+TIWAdvWebGrid1.RadioSelection;
  if iRow <> -1 then
  begin
    ItemID := GetCellName(TIWAdvWebGrid1.Cells[8,iRow]);
    ShowItemTrace(ItemID,pSDate.Date,pEDate.Date);
  end;
end;

initialization
  RegisterClass(TIWfrmHumLog);

end.
