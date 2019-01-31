unit UnitfrmGameFeedback;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWWebGrid,
  IWAdvWebGrid, IWTMSCal, IWTMSEdit, DateUtils, IWCompCheckbox;

type

  TIWfrmGameFeedback = class(TIWFormBasic)
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWRegion2: TIWRegion;
    IWLabel3: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel4: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    IWButton3: TIWButton;
    IWLabel2: TIWLabel;
    IWedtAccount: TIWEdit;
    IWLabel1: TIWLabel;
    IWedtCharname: TIWEdit;
    cboxFeedbackType: TIWComboBox;
    IWLabel5: TIWLabel;
    IWLogMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
    procedure TIWAdvWebGrid1ButtonClick(Sender: TObject; RowIndex,
      ColumnIndex: Integer);
  private
    spid: string;
    iRowIndex: Integer;
    sSerName,sAccount,sCharname,logDate: string;
    procedure LoadFeedbackType;
  public
    function UpdateGMComment(ServerName,LogDate,sAccount,sCharname,sMessage: string): Boolean;
    procedure QueryGameFeedback(spid,sAccount,sCharname: string;dMinDateTime,dMaxDateTime: TDateTime;iServerIndex,FeedbackType: Integer);
    procedure QueryGameFeedbackEx(spid,sAccount,sCharname: string;dMinDateTime,dMaxDateTime: TDateTime; Ispid, iServerIndex,FeedbackType: Integer);
  end;

var
  IWfrmGameFeedback: TIWfrmGameFeedback;

const
  FeedbackTypeStr: array[0..7] of Integer = (276, 519, 520, 521, 522, 523, 524,525);

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmGameFeedback.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(StatToolButtonStr[tbGameFeedback]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbGameFeedback]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbGameFeedback])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  LoadFeedbackType;

  IWLabel3.Caption := Langtostr(150);
  IWLabel4.Caption := Langtostr(151);

  IWLabel2.Caption := Langtostr(283);
  IWLabel1.Caption := Langtostr(291);
  IWLabel5.Caption := Langtostr(526);

  IWBtnBuild.Caption := Langtostr(14);
  IWButton3.Caption := Langtostr(182);
  IWLogMode.Caption := Langtostr(183);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(378);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(189);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(263);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(527);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(476);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(528);
  TIWAdvWebGrid1.Columns[8].Title:= Langtostr(529);
end;

procedure TIWfrmGameFeedback.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    if not IWLogMode.Checked then
    begin
      UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
      try
        spid := psld^.spID;
        QueryGameFeedback(psld^.spID,IWedtAccount.Text,IWedtCharname.Text,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time,psld^.Index,cboxFeedbackType.ItemIndex);
        TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(194),[Langtostr(StatToolButtonStr[tbGameFeedback]),TIWAdvWebGrid1.TotalRows]);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //ÐÂÄ£Ê½
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        spid := psld^.spID;
        QueryGameFeedbackEx(psld^.spID,IWedtAccount.Text,IWedtCharname.Text,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time, psld.Ispid, psld^.Index,cboxFeedbackType.ItemIndex);
        TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(194),[Langtostr(StatToolButtonStr[tbGameFeedback]),TIWAdvWebGrid1.TotalRows]);
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

procedure TIWfrmGameFeedback.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'Feedback' + DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmGameFeedback.LoadFeedbackType;
var
  I: Integer;
begin
  cboxFeedbackType.Items.Clear;
  for I := Low(FeedbackTypeStr) to High(FeedbackTypeStr) do
  begin
    cboxFeedbackType.Items.Add(Langtostr(FeedbackTypeStr[I]));
  end;
  cboxFeedbackType.ItemIndex := 0;
end;

procedure TIWfrmGameFeedback.QueryGameFeedback(spid,sAccount, sCharname: string;
  dMinDateTime, dMaxDateTime: TDateTime; iServerIndex,FeedbackType: Integer);
const
  sqlFeedback = 'SELECT charname,account,serverindex,state,suggesttype,titlestr,sugguststr,logdate FROM log_suggest_%s';
var
  I,iCount: Integer;
  strSQL: string;
  sqlMaxTime: TDateTime;
begin
  strSQL := '';
  if iServerIndex <> 0 then
  begin
    strSQL := strSQL + Format(' serverindex=%d AND ',[iServerIndex]);
  end;
  if FeedbackType <> 0 then
  begin
    strSQL := strSQL + Format(' suggesttype=%d AND ',[FeedbackType]);
  end;
  if sAccount <> '' then
  begin
    strSQL := strSQL + Format(' account=%s AND ',[QuerySQLStr(sAccount)]);
  end;
  if sCharname <> '' then
  begin
    strSQL := strSQL + Format(' charname=%s AND ',[QuerySQLStr(sCharname)]);
  end;
  if strSQL <> '' then
  begin
    System.Delete(strSQL,Length(strSQL)-4,4);
    strSQL := ' WHERE '+strSQL;
  end;
  sqlMaxTime := DateOf(dMinDateTime);
  TIWAdvWebGrid1.ClearCells;  iCount := 0;
  TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;
  while sqlMaxTime <= dMaxDateTime do
  begin
    with TIWAdvWebGrid1,UserSession.quConsume do
    begin
      SQL.Text := Format(sqlFeedback,[FormatDateTime('YYYYMMDD',sqlMaxTime)])+strSQL;
      Open;
      while not Eof do
      begin
        TotalRows := RowCount+iCount;
        for I := 1 to Columns.Count-1 do
        begin
          case I of
            3: cells[I,iCount] := GetServerListName(spid,FieldList.Fields[I-1].AsInteger);
            5: cells[I,iCount] := Langtostr(FeedbackTypeStr[Fields[I-1].AsInteger])
            else begin
              cells[I,iCount] := Utf8ToString(Fields[I-1].AsAnsiString);
            end;
          end;
        end;
        Inc(iCount);
        Next;
      end;
      Close;
    end;
    sqlMaxTime := IncDay(sqlMaxTime,1);
  end;
  TIWAdvWebGrid1.TotalRows := iCount;
end;

procedure TIWfrmGameFeedback.QueryGameFeedbackEx(spid,sAccount, sCharname: string;
  dMinDateTime, dMaxDateTime: TDateTime; Ispid, iServerIndex,FeedbackType: Integer);
const
  sqlFeedback = 'SELECT charname,account,serverindex,state,suggesttype,titlestr,sugguststr,logdate FROM log_suggest_%d_%d_%s';
var
  I,iCount: Integer;
  strSQL: string;
  sqlMaxTime: TDateTime;
begin
  strSQL := '';
  if iServerIndex <> 0 then
  begin
    strSQL := strSQL + Format(' serverindex=%d AND ',[iServerIndex]);
  end;
  if FeedbackType <> 0 then
  begin
    strSQL := strSQL + Format(' suggesttype=%d AND ',[FeedbackType]);
  end;
  if sAccount <> '' then
  begin
    strSQL := strSQL + Format(' account=%s AND ',[QuerySQLStr(sAccount)]);
  end;
  if sCharname <> '' then
  begin
    strSQL := strSQL + Format(' charname=%s AND ',[QuerySQLStr(sCharname)]);
  end;
  if strSQL <> '' then
  begin
    System.Delete(strSQL,Length(strSQL)-4,4);
    strSQL := ' WHERE '+strSQL;
  end;
  sqlMaxTime := DateOf(dMinDateTime);
  TIWAdvWebGrid1.ClearCells;  iCount := 0;
  TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;
  while sqlMaxTime <= dMaxDateTime do
  begin
    with TIWAdvWebGrid1,UserSession.quConsumeEx do
    begin
      SQL.Text := Format(sqlFeedback,[Ispid,iServerIndex,FormatDateTime('YYYYMMDD',sqlMaxTime)])+strSQL;
      Open;
      while not Eof do
      begin
        TotalRows := RowCount+iCount;
        for I := 1 to Columns.Count-1 do
        begin
          case I of
            3: cells[I,iCount] := GetServerListName(spid,FieldList.Fields[I-1].AsInteger);
            5: cells[I,iCount] := Langtostr(FeedbackTypeStr[Fields[I-1].AsInteger])
            else begin
              cells[I,iCount] := Utf8ToString(Fields[I-1].AsAnsiString);
            end;
          end;
        end;
        Inc(iCount);
        Next;
      end;
      Close;
    end;
    sqlMaxTime := IncDay(sqlMaxTime,1);
  end;
  TIWAdvWebGrid1.TotalRows := iCount;
end;

procedure TIWfrmGameFeedback.TIWAdvWebGrid1ButtonClick(Sender: TObject;
  RowIndex, ColumnIndex: Integer);
begin
  inherited;
  if ColumnIndex = 9 then
  begin
    logDate := TIWAdvWebGrid1.Cells[8,RowIndex];
    sAccount := TIWAdvWebGrid1.Cells[1,RowIndex];
    sCharname := TIWAdvWebGrid1.Cells[2,RowIndex];
    sSerName := TIWAdvWebGrid1.Cells[3,RowIndex];
    iRowIndex := RowIndex;
  end;
end;

function TIWfrmGameFeedback.UpdateGMComment(ServerName,LogDate, sAccount, sCharname,
  sMessage: string): Boolean;
const
  sqlUpdate = 'UPDATE log_suggest_%s SET gmcomment=%s,state=1 WHERE logdate="%s" AND account=%s AND charname=%s';
var
  sDate: string;
  psld: PTServerListData;
begin
  Result := False;
  try
    psld := GetServerListData(ServerName);
    if psld <> nil then
    begin
      UserSession.ConnectionLogMysql(psld^.LogDB,psld^.LogHostName);
      try
        sDate := FormatDateTime('YYYYMMDD',StrToDateTime(LogDate));
        UserSession.quCommon.SQL.Text := Format(sqlUpdate,[sDate,QuerySQLStr(sMessage),LogDate,QuerySQLStr(sAccount),QuerySQLStr(sCharname)]);
        Result := UserSession.quCommon.ExecSQL > 0;
        UserSession.quCommon.Close;
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

end.
