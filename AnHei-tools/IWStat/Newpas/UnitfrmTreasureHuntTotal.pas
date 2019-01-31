unit UnitfrmTreasureHuntTotal;

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
  curTitle = 99;//'寻宝情况';

type
  TIWfrmTreasureHuntTotal = class(TIWFormBasic)
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
    procedure QueryItemsName(slog: string; ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
    procedure QueryItemsNameEx(ispid, ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
  end;

var
  IWfrmTreasureHuntTotal: TIWfrmTreasureHuntTotal;

implementation

uses ServerController, ConfigINI, Share;

{$R *.dfm}

{ TIWfrmTreasureHuntTotal }

procedure TIWfrmTreasureHuntTotal.IWAppFormCreate(Sender: TObject);
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
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(187);
end;

procedure TIWfrmTreasureHuntTotal.IWBtnBuildClick(Sender: TObject);
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
        QueryItemsName(psld.LogDB,psld.Index, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //新模式
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);

      try
        QueryItemsNameEx(psld.Ispid, psld.Index, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
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


procedure TIWfrmTreasureHuntTotal.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'TreasureHuntTotal' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmTreasureHuntTotal.QueryItemsName(slog: string; ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
const
  sqlSeedTotal = 'SELECT serverindex,LongStr2,para0,para1 FROM log_common_%s WHERE  Logid = 78 AND serverindex=%d AND logdate>="%s" AND logdate<="%s"';
  sqlGroup = 'SELECT serverindex,LongStr2,Para0,sum(para1)as iCount FROM(%s) b GROUP BY LongStr2,Para0';
  sqlUnionALL = ' UNION ALL ';
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
      SQL.Text :=Format(sqlGroup,[sSQl]);
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := IntToStr(FieldByName('para0').AsInteger);
        cells[2,iCount] := UTF8ToWideString(FieldByName('LongStr2').AsAnsiString);
        cells[3,iCount] := IntToStr(FieldByName('iCount').AsInteger);

        Inc(iCount);

        Next;
      end;
      Close;
    end;
  end;
end;

procedure TIWfrmTreasureHuntTotal.QueryItemsNameEx(ispid, ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
const
  sqlSeedTotal = 'SELECT serverindex,LongStr2,para0,para1 FROM log_common_%d_%d_%s WHERE  Logid = 78 AND serverindex=%d AND logdate>="%s" AND logdate<="%s"';
  sqlGroup = 'SELECT serverindex,LongStr2,Para0,sum(para1)as iCount FROM(%s) b GROUP BY LongStr2,Para0';
  sqlUnionALL = ' UNION ALL ';
var
  iCount: Integer;
  sSQL: string;
begin
  while MinDateTime<=MaxDateTime do
  begin
    if UserSession.IsCheckTableEx(UM_DATA_LOCALLOG,Format('log_common_%d_%d_%s',[ispid, ServerIndex,FormatDateTime('YYYYMMDD',MinDateTime)])) then
    begin
      sSQL := sSQL+ Format(sqlSeedTotal,[ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime),ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
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
      SQL.Text :=Format(sqlGroup,[sSQl]);
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := IntToStr(FieldByName('para0').AsInteger);
        cells[2,iCount] := UTF8ToWideString(FieldByName('LongStr2').AsAnsiString);
        cells[3,iCount] := IntToStr(FieldByName('iCount').AsInteger);

        Inc(iCount);

        Next;
      end;
      Close;
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmTreasureHuntTotal);

end.
