unit UnitfrmFinCurrencyTotal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWTMSEdit, IWTMSCal;

const
  curTitle = 53;//'货币状况查询统计';

type
  TChoiceTypen = (ftNone,ftCons,ftGet);
  TCurrTypen = (mtNone,mtBindCoin,mtCoin,mtBindYuanbao, mtYuanbao, mtStorePoint, mtHonour);

  TIWfrmFinCurrencyTotal = class(TIWFormBasic)
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
    IWLabel2: TIWLabel;
    IWLabel4: TIWLabel;
    IWComboBox1: TIWComboBox;
    IWComboBox2: TIWComboBox;
    IWButton3: TIWButton;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    procedure LoadChoiceType;
    procedure LoadCurrencyType;
  public
    procedure QueryItemsName(slog: string;ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
  end;

var
  IWfrmFinCurrencyTotal: TIWfrmFinCurrencyTotal;

const
  ChoiceTypeStr : array[0..2] of Integer =(337,335,336);
  CurrencyTypeStr: array[0..6] of Integer =(337,338,339,340,341,342,343);

implementation

uses ServerController, ConfigINI, Share;

{$R *.dfm}

{ TIWfrmGetHonorTotal }

procedure TIWfrmFinCurrencyTotal.IWAppFormCreate(Sender: TObject);
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

  LoadChoiceType;  //获取选项
  LoadCurrencyType; //获取类型

  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel2.Caption := Langtostr(333);
  IWLabel4.Caption := Langtostr(334);
  IWBtnBuild.Caption := Langtostr(14);
  IWButton3.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(346);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(347);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(348);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(349);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(350);
end;

procedure TIWfrmFinCurrencyTotal.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date + pSTime.Time > pEDate.Date + pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  if IWComboBox1.ItemIndex = 0 then
  begin
    WebApplication.ShowMessage(Langtostr(344));
    Exit;
  end;
  if IWComboBox2.ItemIndex = 0 then
  begin
    WebApplication.ShowMessage(Langtostr(345));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);

    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryItemsName(psld.LogDB,psld.Index, pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
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

procedure TIWfrmFinCurrencyTotal.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'FinCurrencyTotal' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmFinCurrencyTotal.LoadChoiceType;
var
  cstr: Integer;
begin
  IWComboBox1.Items.Clear;
  for cstr in ChoiceTypeStr do
  begin
    IWComboBox1.Items.Add(Langtostr(cstr));
  end;
  IWComboBox1.ItemIndex := 0;
end;

procedure TIWfrmFinCurrencyTotal.LoadCurrencyType;
var
  cstr: Integer;
begin
  IWComboBox2.Items.Clear;
  for cstr in CurrencyTypeStr do
  begin
    IWComboBox2.Items.Add(Langtostr(cstr));
  end;
  IWComboBox2.ItemIndex := 0;
end;

procedure TIWfrmFinCurrencyTotal.QueryItemsName(slog: string;ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
const
  //获得查询
  sqlChoiceTotal = 'SELECT Logid,ConsumeDescr,serverindex,(PaymentCount) as cgold,ConsumeCount FROM log_consume_%s WHERE serverindex=%d and moneytype = %d and PaymentCount > 0 and logdate>="%s" and logdate<="%s"';
  //消耗查询
  sqlCurrenTotal = 'SELECT Logid,ConsumeDescr,serverindex,(PaymentCount*-1) as cgold,ConsumeCount FROM log_consume_%s WHERE serverindex=%d and moneytype = %d and PaymentCount < 0 and logdate>="%s" and logdate<="%s"';
  sqlGroup =   'SELECT Logid,ConsumeDescr,serverindex,sum(cgold) as igold,ConsumeCount, COUNT(1) AS iCount FROM(%s) a GROUP BY ConsumeDescr ';

  sqlUnionALL  = ' UNION ALL ';
var
  iCount: Integer;
  sSQL: string;
begin
  while MinDateTime<=MaxDateTime do
  begin
    if IWComboBox1.ItemIndex = 1 then //获得
    begin
       if UserSession.IsCheckTable(slog,Format('log_consume_%s',[FormatDateTime('YYYYMMDD',MinDateTime)])) then
       begin
         sSQL := sSQL+ Format(sqlChoiceTotal,[FormatDateTime('YYYYMMDD',MinDateTime),ServerIndex, (IWComboBox2.ItemIndex - 1),DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
       end;
    end
    else if IWComboBox1.ItemIndex = 2 then //消耗
    begin
       if UserSession.IsCheckTable(slog,Format('log_consume_%s',[FormatDateTime('YYYYMMDD',MinDateTime)])) then
       begin
         sSQL := sSQL+ Format(sqlCurrenTotal,[FormatDateTime('YYYYMMDD',MinDateTime),ServerIndex, (IWComboBox2.ItemIndex - 1),DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
       end;
    end;

    MinDateTime := MinDateTime+1;
  end;
  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    iCount := 0;
    TIWAdvWebGrid1.ClearCells;

    with UserSession.quExrtGoldTotal,TIWAdvWebGrid1 do
    begin
      SQL.Text := Format(sqlGroup ,[sSQL]);
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := IntToStr(FieldByName('Logid').AsInteger);
        cells[2,iCount] := UTF8ToWideString(FieldByName('ConsumeDescr').AsAnsiString);
        cells[3,iCount] := IntToStr(FieldByName('igold').AsInteger);
        cells[4,iCount] := IntToStr(FieldByName('ConsumeCount').AsInteger);
        cells[5,iCount] := IntToStr(FieldByName('iCount').AsInteger);
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmFinCurrencyTotal);

end.
