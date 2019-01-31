unit UnitIWfrmConsume;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWAdvToolButton, IWControl, IWTMSCal, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompEdit, IWTMSEdit,
  IWVCLBaseContainer, IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion,
  IWWebGrid, IWAdvWebGrid, IWCompButton, DateUtils, IWTMSImgCtrls, IWCompListbox,
  IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompCheckbox, IWExtCtrls;

const
  curTitle = '商城排行统计';

type
  PTConsumeData = ^TConsumeData;
  TConsumeData = record
    ConsumeDescr: string;
    ConsumeCount: Integer;
    BuyCount: Integer;
    PeopleCount: Integer;
    PaymentCount: Double;
    ServerIndex: Integer;
    ConsumeDate:TDateTime;
  end;
  
  TIWfrmConsume = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton1: TIWButton;
    IWRGroupShopType: TIWRadioGroup;
    TIWGradientLabel1: TTIWGradientLabel;
    IWCheckBox1: TIWCheckBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
  private
    ConsumeDataList: TStringList;
    procedure ClearConsumeData;
  public
    procedure QueryConsume(sgstatic:string;ServerIndex,ConsumeType: Integer;dRate: Double;MinDateTime,MaxDateTime: TDateTime);
    procedure LoadConsumeType;
  end;

var
  IWfrmConsume: TIWfrmConsume;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmConsume.ClearConsumeData;
var
  I: Integer;
begin
  for I := 0 to ConsumeDataList.Count - 1 do
  begin
    System.DisPose(PTConsumeData(ConsumeDataList.Objects[I]));
  end;
  ConsumeDataList.Clear;
end;

procedure TIWfrmConsume.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  ConsumeDataList := TStringList.Create;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  LoadConsumeType;  
end;

procedure TIWfrmConsume.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
  ClearConsumeData;
  ConsumeDataList.Free;
end;

procedure TIWfrmConsume.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage('起始日期应大于或等于结束日期，请重新选择');
    Exit;
  end;
  if UserSession.UserName <> AdminUser then
  begin
    if DayOf(pEDate.Date)-DayOf(pSDate.Date) > 10 then
    begin
      WebApplication.ShowMessage('查询很耗时，请将查询范围限制在10天以内');
      Exit;
    end;
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
      QueryConsume(psld.GstaticDB,psld.Index,Integer(IWRGroupShopType.Items.Objects[IWRGroupShopType.ItemIndex]),
        psld.CurrencyRate,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
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

procedure TIWfrmConsume.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'Consume'+DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+WideString(sFileName));
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmConsume.LoadConsumeType;
begin
  IWRGroupShopType.Items.AddObject('元宝',TObject(3));
  IWRGroupShopType.Items.AddObject('礼券',TObject(2));
  IWRGroupShopType.Items.AddObject('全部',TObject(0));
  if IWRGroupShopType.Items.Count > 0 then
  begin
    IWRGroupShopType.ItemIndex := 0;
  end;
end;

procedure TIWfrmConsume.QueryConsume(sgstatic:string;ServerIndex,ConsumeType: Integer;dRate: Double;MinDateTime, MaxDateTime: TDateTime);
const
  sqlConsume = 'SELECT Logdate,Serverindex,consumedescr,SUM(consumecount) AS consumecount,COUNT(1) AS buycount,COUNT(DISTINCT account) AS peoplecount,SUM(paymentcount*-1) AS paymentcount FROM '+'log_consume_%s WHERE logid not in (122,142) AND paymentcount<=0 AND %s logdate>="%s" AND logdate <="%s" AND account not in (SELECT account FROM %s.insideraccount) %s GROUP BY consumedescr ';
  sqlConsumeEx = 'SELECT Logdate,Serverindex,consumedescr,SUM(consumecount) AS consumecount,COUNT(1) AS buycount,COUNT(DISTINCT account) AS peoplecount,SUM(paymentcount*-1) AS paymentcount FROM '+'log_consume_%s WHERE logid not in (122,142) AND paymentcount<=0 AND %s logdate>="%s" AND logdate <="%s" AND account not in (SELECT account FROM %s.insideraccount) %s GROUP BY consumedescr,Serverindex ';
  sqlGroup = 'SELECT Logdate,Serverindex,consumedescr,SUM(consumecount) AS consumecount,SUM(paymentcount) AS paymentcount,SUM(buycount) AS buycount,SUM(peoplecount) AS peoplecount FROM (%s) tmp GROUP BY consumedescr ORDER BY paymentcount DESC';
  tServerID = 'serverindex=%d AND ';
  tConsumeType = ' AND moneytype=%d';
  sqlUnionall = ' UNION ALL ';
var
  I,Idx,TotalBuy,TotalPeople,TotalCount: Integer;
  dValue,TotalRMB: Double;
  sServerIndex,sConsumeType,sSQL: string;
  dbConsumeData: PTConsumeData;
begin
  sServerIndex := Format(tServerID,[ServerIndex]);
  sConsumeType := Format(tConsumeType,[ConsumeType]);
  if ServerIndex = 0 then sServerIndex := '';
  if ConsumeType = 0 then sConsumeType := '';
  with UserSession.quConsume,TIWAdvWebGrid1 do
  begin
    ClearConsumeData;
    ClearCells; TotalBuy := 0; TotalPeople := 0;  TotalRMB := 0; TotalCount := 0;
    sSQL := '';
    while DateOf(MinDateTime)<=DateOf(MaxDateTime) do
    begin
      if IWCheckBox1.Checked then
        sSQL := sSQL + Format(sqlConsumeEx,[FormatDateTime('YYYYMMDD',MinDateTime),sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime),sgstatic,sConsumeType])+sqlUnionall
      else
        sSQL := sSQL + Format(sqlConsume,[FormatDateTime('YYYYMMDD',MinDateTime),sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime),sgstatic,sConsumeType])+sqlUnionall;

      MinDateTime := IncDay(MinDateTime,1);
    end;
    if sSQL <> '' then
    begin
      System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
      if IWCheckBox1.Checked then
       SQL.Text := sSQL
      else
       SQL.Text := Format(sqlGroup,[sSQL]);

      Open;
      while not Eof do
      begin
        Idx := ConsumeDataList.IndexOf(FieldByName('consumedescr').AsString);
        if Idx = -1 then
        begin
          New(dbConsumeData);
          FillChar(dbConsumeData^,SizeOf(dbConsumeData^),0);
        end
        else begin
          dbConsumeData := PTConsumeData(ConsumeDataList.Objects[Idx]);
        end;
        dbConsumeData^.ConsumeDescr := Utf8ToString(FieldByName('consumedescr').AsAnsiString);
        dbConsumeData^.ConsumeCount := dbConsumeData^.ConsumeCount+FieldByName('consumecount').AsInteger;
        Inc(TotalCount,dbConsumeData^.ConsumeCount);
        dbConsumeData^.BuyCount := dbConsumeData^.BuyCount+FieldByName('buycount').AsInteger;
        Inc(TotalBuy,dbConsumeData^.BuyCount);
        dbConsumeData^.PeopleCount := dbConsumeData^.PeopleCount+FieldByName('peoplecount').AsInteger;
        Inc(TotalPeople,dbConsumeData^.PeopleCount);
        dValue := DivZero(FieldByName('paymentcount').AsInteger,10) * dRate;
        TotalRMB := TotalRMB + dValue;
        dbConsumeData^.PaymentCount := dbConsumeData^.PaymentCount+dValue;

        dbConsumeData^.ServerIndex := FieldByName('Serverindex').AsInteger;
        dbConsumeData^.ConsumeDate := FieldByName('Logdate').AsDateTime;
        if Idx = -1 then
          ConsumeDataList.AddObject(dbConsumeData.ConsumeDescr,TObject(dbConsumeData));
        Next;
      end;
      Close;
    end;
    RowCount := objINI.MaxPageCount;
    if objINI.MaxPageCount > ConsumeDataList.Count then
    begin
      RowCount := ConsumeDataList.Count;
    end;
    TotalRows := ConsumeDataList.Count;
    for I := 0 to ConsumeDataList.Count - 1 do
    begin
      dbConsumeData := PTConsumeData(ConsumeDataList.Objects[I]);
      cells[1,I] := dbConsumeData.ConsumeDescr;
      cells[2,I] := IntToStr(dbConsumeData.ConsumeCount);
      cells[3,I] := IntToStr(dbConsumeData.BuyCount);
      cells[4,I] := IntToStr(dbConsumeData.PeopleCount);
      cells[5,I] := Format(objINI.RMBFormat,[dbConsumeData.PaymentCount]);
      cells[6,I] := IntToStr(dbConsumeData.ServerIndex);
      cells[7,I] := FormatDateTime('YYYY-MM-DD',dbConsumeData.ConsumeDate);
    end;    
    Columns[1].FooterText := '总计：';
    Columns[2].FooterText := IntToStr(TotalCount);
    Columns[3].FooterText := IntToStr(TotalBuy);
    Columns[4].FooterText := IntToStr(TotalPeople);
    Columns[5].FooterText := Format(objINI.RMBFormat,[TotalRMB]);
    Controller.Caption := Format('&nbsp;<b>%s</b> 共 %d 个记录',[curTitle,ConsumeDataList.Count]);
  end;
end;

initialization
  RegisterClass(TIWfrmConsume);

end.
