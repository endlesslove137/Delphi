unit UnitIWfrmUserConsumeOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvToolButton, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompLabel, IWCompButton,
  IWCompEdit, IWTMSCal, IWWebGrid, IWAdvWebGrid, DateUtils,
  IWTMSImgCtrls, IWCompListbox, IWExchangeBar, IWCompRectangle,
  IWTMSCtrls;

const
  curTitle = 59;//'消费排行统计';
    
type
  TIWfrmUserConsumeOrder = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWadvWebGrid1: TTIWAdvWebGrid;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryUserConsumeOrder(spid: string;ServerIndex: Integer;dRate: Double;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmUserConsumeOrder: TIWfrmUserConsumeOrder;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmUserConsumeOrder.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := IncDay(Now(),-1); //-14
  pEDate.Date := Now();
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWBtnBuild.Caption := Langtostr(171);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(366);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(321);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(322);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(323);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(189);
end;

procedure TIWfrmUserConsumeOrder.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date > pEDate.Date then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  if DayOf(pEDate.Date)-DayOf(pSDate.Date) >= 32 then
  begin
    WebApplication.ShowMessage(Langtostr(309));
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
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryUserConsumeOrder(psld^.spID,psld^.Index,psld.CurrencyRate,pSDate.Date,pEDate.Date);
    finally
      UserSession.SQLConnectionLog.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmUserConsumeOrder.QueryUserConsumeOrder(spid: string;ServerIndex: Integer; dRate: Double;
  MinDateTime, MaxDateTime: TDateTime);
const
  //老的有bug
  //sqlUserConsumeOrder = 'SELECT account, charname, SUM(CASE moneytype WHEN 3 THEN paymentcount*-1 ELSE 0 END) as Gold,SUM(CASE moneytype WHEN 2 THEN paymentcount*-1 ELSE 0 END) as BindGold,SUM(paymentcount*-1) AS paymentcount,serverindex FROM '+'%s WHERE paymentcount<0 and logid not in (122,142) %s GROUP BY charname';
  //sqlUnionAll = 'SELECT account, charname, SUM(Gold) AS Gold, SUM(BindGold) as BindGold,SUM(paymentcount) AS paymentcount,serverindex FROM (%s) tmp GROUP BY charname ORDER BY Gold DESC LIMIT %d';
  sqlUserConsumeOrder = 'SELECT account, charname, SUM(CASE moneytype WHEN 3 THEN paymentcount*-1 ELSE 0 END) as Gold,SUM(CASE moneytype WHEN 2 THEN paymentcount*-1 ELSE 0 END) as BindGold,serverindex FROM '+'%s WHERE paymentcount<0 AND right(account,4)= "_%s" and logid not in (122,142) %s GROUP BY charname';
  sqlUnionAll = 'SELECT account, charname, SUM(Gold) AS Gold, SUM(BindGold) as BindGold,SUM(Gold + BindGold) AS paymentcount,serverindex FROM (%s) tmp GROUP BY charname ORDER BY Gold DESC LIMIT %d';

  tTableName = 'log_consume_%s';
  tServerID = 'AND serverindex=%d ';
var
  iCount,TotalGoldCount,TotalBindGoldCount: Integer;
  SQLList: TStrings;
  sServerIndex,sTableName: string;
begin
  with UserSession.quUserConsumeOrder,TIWadvWebGrid1 do
  begin
    if MaxDateTime > Now then MaxDateTime := Now;
    Controller.Caption := Format(Langtostr(360),[TopCount]);
    sServerIndex := '';
    if ServerIndex <> 0 then sServerIndex := Format(tServerID,[ServerIndex]);
    SQLList := TStringList.Create;
    try
      while MinDateTime<=MaxDateTime do
      begin
        sTableName := Format(tTableName,[FormatDateTime('YYYYMMDD',MinDateTime)]);
//        if UserSession.IsCheckTable('globallog',sTableName) then
//        begin
          SQLList.Add(Format(sqlUserConsumeOrder,[sTableName, spid,sServerIndex]));
          SQLList.Add('UNION ALL');
//        end;
        MinDateTime := IncDay(MinDateTime,1);
      end;
      if SQLList.Count = 0 then Exit;
      TotalGoldCount := 0; TotalBindGoldCount := 0;
      SQLList.Delete(SQLList.Count-1);
      ClearCells;
      SQL.Text := Format(sqlUnionAll,[SQLList.Text,TopCount]);
      Open;
      iCount := 0;
      RowCount := objINI.MaxPageCount;
      while not Eof do
      begin
        TotalRows := RowCount+iCount;
        cells[1,iCount] := UTF8ToString(FieldByName('account').AsAnsiString);
        cells[2,iCount] := UTF8ToString(FieldByName('charname').AsAnsiString);
        Inc(TotalGoldCount,FieldByName('Gold').AsInteger);
        cells[3,iCount] := IntToStr(FieldByName('Gold').AsInteger);
        Inc(TotalBindGoldCount,FieldByName('BindGold').AsInteger);
        cells[4,iCount] := IntToStr(FieldByName('BindGold').AsInteger);
        cells[5,iCount] := IntToStr(FieldByName('paymentcount').AsInteger);
        cells[6,iCount] := GetServerListName(spid,FieldByName('serverindex').AsInteger);
        Inc(iCount);
        Next;
      end;
      TotalRows := iCount;
      Close;
    finally
      SQLList.Free;
    end;
    Columns.Items[2].FooterText := Langtostr(361);
    Columns.Items[3].FooterText := IntToStr(TotalGoldCount);
    Columns.Items[4].FooterText := IntToStr(TotalBindGoldCount);
    Columns.Items[5].FooterText := IntToStr(TotalGoldCount+TotalBindGoldCount);
  end;
end;

initialization
  RegisterClass(TIWfrmUserConsumeOrder);

end.
