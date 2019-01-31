unit UnitIWfrmPayOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWCompEdit, IWTMSEdit, IWControl, IWTMSCal,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompLabel,
  IWWebGrid, IWAdvWebGrid, IWAdvToolButton, IWTMSImgCtrls,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompCheckbox;

const
  curTitle = 60;//'充值排行统计';

type
  PTPayOrderData = ^TPayOrderData;
  TPayOrderData = record
    AccountName: string;
    PayMoney: string;
    ServerName: string;
  end;

  TIWfrmPayOrder = class(TIWFormBasic)
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
    IWButton3: TIWButton;
    IWAmdbMode: TIWCheckBox;
    procedure TIWAdvWebGrid1ColumnHeaderClick(Sender: TObject;
      ColumnIndex: Integer);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
    PayOrderDataList: TStrings;
    procedure ClearPayOrderDataList;
  public
    { Public declarations }
    procedure QueryPayOrder(samdb,spid: string;ServerIndex,ServerID: Integer;dRate: Double;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmPayOrder: TIWfrmPayOrder;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmPayOrder.ClearPayOrderDataList;
var
  I: Integer;
begin
  for I := 0 to PayOrderDataList.Count - 1 do
  begin
    System.DisPose(PTPayOrderData(PayOrderDataList.Objects[I]));
  end;
  PayOrderDataList.Clear;
end;

procedure TIWfrmPayOrder.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  PayOrderDataList := TStringList.Create;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);

  IWBtnBuild.Caption := Langtostr(171);
  IWButton3.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(364);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(289);
end;

procedure TIWfrmPayOrder.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
  ClearPayOrderDataList;
  PayOrderDataList.Free;
end;

procedure TIWfrmPayOrder.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      QueryPayOrder(psld.Amdb,psld.spID,psld.Index,psld.ServerID,psld.CurrencyRate,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
    finally
      UserSession.SQLConnectionSession.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmPayOrder.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'PayOrder' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmPayOrder.QueryPayOrder(samdb,spid: string;ServerIndex,ServerID: Integer; dRate: Double; MinDateTime,
  MaxDateTime: TDateTime);
const
  slqPayOrder = 'SELECT account, sum(rmb) AS rmb, serverid FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND %s orderdate>="%s" AND orderdate<"%s" GROUP BY account ORDER BY rmb DESC LIMIT %d';
  slqPayOrder2 = 'SELECT account, sum(rmb) AS rmb, serverid FROM %s.payorder_%s WHERE yunying="_%s" AND type = 3 and state = 1 AND %s orderdate>="%s" AND orderdate<"%s" GROUP BY account ORDER BY rmb DESC LIMIT %d';
  sqlServerIndex = 'serverid in (%s) AND';
var
  I: Integer;
  dValue,dTotal: Double;
  sServerIndex: string;
  PayOrderData: PTPayOrderData;
begin
  TIWadvWebGrid1.Controller.Caption := Format(Langtostr(362),[TopCount]);
  sServerIndex := ''; dTotal := 0;
  if ServerIndex <> 0 then sServerIndex := Format(sqlServerIndex,[GetJoinServerIndex(ServerIndex)]);
  ClearPayOrderDataList;
  with UserSession.quPayOrder do
  begin
    if IWAmdbMode.Checked then
      SQL.Text := Format(slqPayOrder2,[samdb,FormatDateTime('YYYYMM',MinDateTime),spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime),TopCount])
    else
     SQL.Text := Format(slqPayOrder,[samdb,spid,sServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime),TopCount]);

    Open;
    try
      while not Eof do
      begin
        New(PayOrderData);
        PayOrderData.AccountName := Utf8ToString(FieldByName('account').AsAnsiString);
        dValue := DivZero(FieldByName('rmb').AsInteger,dRate) ;
        dTotal := dTotal + dValue;
        PayOrderData.PayMoney := Format('%.1f',[dValue]);
        serverindex := FieldByName('serverid').AsInteger+ServerID;
        PayOrderData.ServerName := GetServerListName(spid,serverindex);
        PayOrderDataList.AddObject(PayOrderData.AccountName,TObject(PayOrderData));
        Next;
      end;
    finally
      Close;
    end;
  end;
  with TIWAdvWebGrid1 do
  begin
    ClearCells;
    TotalRows := PayOrderDataList.Count;
    RowCount := PayOrderDataList.Count;
    Columns[2].Tag := -1;
    for I := 0 to PayOrderDataList.Count - 1 do
    begin
      PayOrderData := PTPayOrderData(PayOrderDataList.Objects[I]);
      cells[1,I] := PayOrderData.AccountName;
      cells[2,I] := Format(objINI.RMBFormat,[StrToFloat(PayOrderData.PayMoney)]);
      cells[3,I] := PayOrderData.ServerName;
    end;
    Columns.Items[1].FooterText := langtostr(363);
    Columns.Items[2].FooterText := Format(objINI.RMBFormat,[dTotal]);
  end;
end;

procedure TIWfrmPayOrder.TIWAdvWebGrid1ColumnHeaderClick(Sender: TObject;
  ColumnIndex: Integer);
var
  I,iSort: Integer;
  SL: TStringList;
  PayOrderData: PTPayOrderData;
begin
  TIWadvWebGrid1.Columns[ColumnIndex].Tag := not TIWadvWebGrid1.Columns[ColumnIndex].Tag;
  SL := TStringList.Create;
  try
    for I := 0 to PayOrderDataList.Count - 1 do
    begin
      PayOrderData := PTPayOrderData(PayOrderDataList.Objects[I]);
      case ColumnIndex of
        1: SL.AddObject(PayOrderData.AccountName,TObject(PayOrderData.AccountName));
        2: SL.AddObject(PayOrderData.PayMoney,TObject(PayOrderData.AccountName));
        3: SL.AddObject(GetServerIndex(PayOrderData.ServerName),TObject(PayOrderData.AccountName));
      end;
    end;
    if ColumnIndex IN [2,3] then
      SL.CustomSort(NumBerSort)
    else
      SL.Sorted := True;
    for I := 0 to SL.Count - 1 do
    begin
      iSort := I;
      if not Boolean(TIWadvWebGrid1.Columns[ColumnIndex].Tag) then iSort := SL.Count - I - 1;
      PayOrderData := PTPayOrderData(PayOrderDataList.Objects[PayOrderDataList.IndexOf(string(SL.Objects[iSort]))]);
      with TIWAdvWebGrid1 do
      begin
        cells[1,I] := PayOrderData.AccountName;
        cells[2,I] := Format(objINI.RMBFormat,[StrToFloat(PayOrderData.PayMoney)]);
        cells[3,I] := PayOrderData.ServerName;
      end;
    end;
  finally
    SL.Free;
  end;
end;

initialization
  RegisterClass(TIWfrmPayOrder);

end.
