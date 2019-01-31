unit UnitfrmIllegalInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWTMSEdit, IWTMSCal,
  IWCompCheckbox, DateUtils;

const
  curTitle = 133;//'查看外挂记录';

type
  TIWfrmIllegalInfo = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
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
    IWedtCharname: TIWEdit;
    IWLabel4: TIWLabel;
    IWedtAccount: TIWEdit;
    IWLogMode: TIWCheckBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
  public
    procedure QueryIllegalInfo(spid: string; ServerIndex: Integer; sAccount, sCharname: string; MinDateTime, MaxDateTime: TDateTime);
    procedure QueryIllegalInfoEx(spid: string; ispid, ServerIndex: Integer; sAccount, sCharname: string; MinDateTime, MaxDateTime: TDateTime);

  end;

var
  IWfrmIllegalInfo: TIWfrmIllegalInfo;

implementation

uses ServerController, ConfigINI, Share;

{$R *.dfm}

{ TIWfrmIllegalInfo }

procedure TIWfrmIllegalInfo.IWAppFormCreate(Sender: TObject);
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

  IWLabel2.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel1.Caption := Langtostr(558);
  IWLabel4.Caption := Langtostr(548);

  IWBtnBuild.Caption := Langtostr(14);
  IWButton3.Caption := Langtostr(182);
  IWLogMode.Caption := Langtostr(183);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(599);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(189);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(366);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(263);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(609);
  TIWAdvWebGrid1.Columns[7].Title := Langtostr(610);
end;

procedure TIWfrmIllegalInfo.IWBtnBuildClick(Sender: TObject);
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
        QueryIllegalInfo(psld^.spID, psld^.Index, IWedtAccount.Text, IWedtCharname.Text, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //新模式
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        QueryIllegalInfoEx(psld^.spID, psld.Ispid, psld^.Index, IWedtAccount.Text, IWedtCharname.Text, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
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

procedure TIWfrmIllegalInfo.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'IllegalInfo' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmIllegalInfo.QueryIllegalInfo(spid: string; ServerIndex: Integer; sAccount, sCharname: string; MinDateTime, MaxDateTime: TDateTime);
const
  sqlusermode = 'SELECT charname,account,serverindex,state,suggesttype,logdate,COUNT(1) AS iCount FROM log_suggest_%s %s GROUP BY serverindex,suggesttype,charname,account';
  sqlGroup    = 'SELECT charname,account,serverindex,state,suggesttype,logdate,sum(iCount) as iCount FROM(%s) a GROUP BY serverindex,suggesttype,charname,account';
  sqlUnionALL = ' UNION ALL ';
  function GetIllegalInfo(idx: Integer; sAccounts, sCharnames: string): string;
  begin
    Result := '';
    if idx <> 0 then
    begin
      Result := Result + Format(' serverindex=%d AND ',[idx]);
    end;

    Result := Result + ' suggesttype in (6, 7) AND ';

    if sAccounts <> '' then
    begin
      Result := Result + Format(' account=%s AND ',[QuerySQLStr(sAccounts)]);
    end;
    if sCharnames <> '' then
    begin
      Result := Result + Format(' charname=%s AND ',[QuerySQLStr(sCharnames)]);
    end;
    if Result <> '' then
    begin
      System.Delete(Result,Length(Result)-4,4);
      Result := ' WHERE '+Result;
    end;
  end;
  function IllegalTypeStr(idx: Integer): string;
  begin
     Result := '';
     case idx of
         6: Result := Langtostr(524);
         7: Result := Langtostr(608);
     end;
  end;
var
  iCount: Integer;
  sSQL, sudata: string;
begin
   sudata:= '';   sSQL:= '';
   sudata:= GetIllegalInfo(ServerIndex, sAccount, sCharname);

   while MinDateTime<=MaxDateTime do
   begin
     sSQL := sSQL + Format(sqlusermode,[FormatDateTime('YYYYMMDD',MinDateTime), sudata]) + sqlUnionALL;
     MinDateTime := MinDateTime+1;
   end;

   if sSQL <> '' then
   begin
     System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
     TIWAdvWebGrid1.ClearCells;
     iCount := 0;
     with TIWAdvWebGrid1,UserSession.quConsume do
     begin
       SQL.Text := Format(sqlGroup,[sSQL]);
       Open;
       while not Eof do
       begin
         RowCount := iCount + 1;
         cells[1,iCount] := FormatDateTime('YYYY-MM-DD',FieldByName('logdate').AsDateTime);
         cells[2,iCount] := GetServerListName(spid, FieldByName('serverindex').AsInteger);
         cells[3,iCount] := UTF8ToWideString(FieldByName('charname').AsAnsiString);
         cells[4,iCount] := UTF8ToWideString(FieldByName('Account').AsAnsiString);
         cells[5,iCount] := IntToStr(FieldByName('state').AsInteger);
         cells[6,iCount] := IllegalTypeStr(FieldByName('suggesttype').AsInteger);
         cells[7,iCount] := IntToStr(FieldByName('iCount').AsInteger);
         Inc(iCount);
         Next;
       end;
       Close;
     end;
   end;
end;

procedure TIWfrmIllegalInfo.QueryIllegalInfoEx(spid: string; ispid, ServerIndex: Integer; sAccount, sCharname: string; MinDateTime, MaxDateTime: TDateTime);
const
  sqlusermode = 'SELECT charname,account,serverindex,state,suggesttype,logdate,COUNT(1) AS iCount FROM log_suggest_%d_%d_%s %s GROUP BY serverindex,suggesttype,charname,account';
  sqlGroup    = 'SELECT charname,account,serverindex,state,suggesttype,logdate,sum(iCount) as iCount FROM(%s) a GROUP BY serverindex,suggesttype,charname,account';
  sqlUnionALL = ' UNION ALL ';
  function GetIllegalInfo(idx: Integer; sAccounts, sCharnames: string): string;
  begin
    Result := '';
    if idx <> 0 then
    begin
      Result := Result + Format(' serverindex=%d AND ',[idx]);
    end;

    Result := Result + ' suggesttype in (6, 7) AND ';

    if sAccounts <> '' then
    begin
      Result := Result + Format(' account=%s AND ',[QuerySQLStr(sAccounts)]);
    end;
    if sCharnames <> '' then
    begin
      Result := Result + Format(' charname=%s AND ',[QuerySQLStr(sCharnames)]);
    end;
    if Result <> '' then
    begin
      System.Delete(Result,Length(Result)-4,4);
      Result := ' WHERE '+Result;
    end;
  end;
  function IllegalTypeStr(idx: Integer): string;
  begin
     Result := '';
     case idx of
         6: Result := Langtostr(524);
         7: Result := Langtostr(608);
     end;
  end;
var
  iCount: Integer;
  sSQL, sudata: string;
begin
   sudata:= '';   sSQL:= '';
   sudata:= GetIllegalInfo(ServerIndex, sAccount, sCharname);

   while MinDateTime<=MaxDateTime do
   begin
     sSQL := sSQL + Format(sqlusermode,[ispid, ServerIndex,FormatDateTime('YYYYMMDD',MinDateTime), sudata]) + sqlUnionALL;
     MinDateTime := MinDateTime+1;
   end;

   if sSQL <> '' then
   begin
     System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
     TIWAdvWebGrid1.ClearCells;
     iCount := 0;
     with TIWAdvWebGrid1,UserSession.quConsumeEx do
     begin
       SQL.Text := Format(sqlGroup,[sSQL]);
       Open;
       while not Eof do
       begin
         RowCount := iCount + 1;
         cells[1,iCount] := FormatDateTime('YYYY-MM-DD',FieldByName('logdate').AsDateTime);
         cells[2,iCount] := GetServerListName(spid, FieldByName('serverindex').AsInteger);
         cells[3,iCount] := UTF8ToWideString(FieldByName('charname').AsAnsiString);
         cells[4,iCount] := UTF8ToWideString(FieldByName('Account').AsAnsiString);
         cells[5,iCount] := IntToStr(FieldByName('state').AsInteger);
         cells[6,iCount] := IllegalTypeStr(FieldByName('suggesttype').AsInteger);
         cells[7,iCount] := IntToStr(FieldByName('iCount').AsInteger);
         Inc(iCount);
         Next;
       end;
       Close;
     end;
   end;
end;


initialization
  RegisterClass(TIWfrmIllegalInfo);

end.
