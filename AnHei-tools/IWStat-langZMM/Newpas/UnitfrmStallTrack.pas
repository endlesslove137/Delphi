unit UnitfrmStallTrack;

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
  curTitle = 100;//'摆摊追踪';

type
  TIWfrmStallTrack = class(TIWFormBasic)
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
    procedure QueryStallTrack(slog: string; ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
    procedure QueryStallTrackEx(ispid, ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
  end;

var
  IWfrmStallTrack: TIWfrmStallTrack;

implementation

uses ServerController, ConfigINI, Share;

{$R *.dfm}

{ TIWfrmStallTrack }

procedure TIWfrmStallTrack.IWAppFormCreate(Sender: TObject);
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

  IWBtnBuild.Caption := Langtostr(14);
  IWButton3.Caption := Langtostr(182);
  IWLogMode.Caption := Langtostr(183);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(402);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(403);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(535);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(536);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(537);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(538);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(539);
end;

procedure TIWfrmStallTrack.IWBtnBuildClick(Sender: TObject);
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
        QueryStallTrack(psld.LogDB,psld.Index, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //新模式
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);

      try
        QueryStallTrackEx(psld.Ispid, psld.Index, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
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


procedure TIWfrmStallTrack.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'StallTrack' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmStallTrack.QueryStallTrack(slog: string; ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
const
  sqlSeedTotal = 'SELECT Logid,serverindex,Userid,Account,Para0,Para1,Para2,ShortStr0,MidStr0 FROM log_common_%s WHERE  Logid = 811 and serverindex=%d and logdate>="%s" and logdate<="%s"';
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
      SQL.Text := sSQL;
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := IntToStr(FieldByName('Userid').AsInteger);
        cells[2,iCount] := UTF8ToWideString(FieldByName('Account').AsAnsiString);
        cells[3,iCount] := IntToStr(FieldByName('Para0').AsInteger);
        cells[4,iCount] := InttoCurrType(FieldByName('Para1').AsInteger); //增加
        cells[5,iCount] := IntToStr(FieldByName('Para2').AsInteger);
        cells[6,iCount] := IntToStr(FieldByName('ShortStr0').AsInteger);
        cells[7,iCount] := IntToStr(FieldByName('MidStr0').AsInteger);
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;
end;

procedure TIWfrmStallTrack.QueryStallTrackEx(ispid, ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
const
  sqlSeedTotal = 'SELECT Logid,serverindex,Userid,Account,Para0,Para1,Para2,ShortStr0,MidStr0 FROM log_common_%d_%d_%s WHERE  Logid = 811 and serverindex=%d and logdate>="%s" and logdate<="%s"';
  sqlUnionALL  = ' UNION ALL ';
var
  iCount: Integer;
  sSQL: string;
begin
  while MinDateTime<=MaxDateTime do
  begin
    if UserSession.IsCheckTableEx(UM_DATA_LOCALLOG,Format('log_common_%d_%d_%s',[ispid, ServerIndex,FormatDateTime('YYYYMMDD',MinDateTime)])) then
    begin
      sSQL := sSQL+ Format(sqlSeedTotal,[ispid, ServerIndex,FormatDateTime('YYYYMMDD',MinDateTime),ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
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
      SQL.Text := sSQL;
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := IntToStr(FieldByName('Userid').AsInteger);
        cells[2,iCount] := UTF8ToWideString(FieldByName('Account').AsAnsiString);
        cells[3,iCount] := IntToStr(FieldByName('Para0').AsInteger);
        cells[4,iCount] := InttoCurrType(FieldByName('Para1').AsInteger); //增加
        cells[5,iCount] := IntToStr(FieldByName('Para2').AsInteger);
        cells[6,iCount] := IntToStr(FieldByName('ShortStr0').AsInteger);
        cells[7,iCount] := IntToStr(FieldByName('MidStr0').AsInteger);
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmStallTrack);

end.
