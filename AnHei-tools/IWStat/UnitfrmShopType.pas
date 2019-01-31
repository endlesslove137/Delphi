unit UnitfrmShopType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl, ActiveX,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer, DateUtils,
  IWHTML40Container, IWRegion, IWTMSCal, IWCompButton, IWAdvChart,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompEdit;

const
  curTitle = '商城分类统计';
  ShopChartColor : array [0..15] of Integer = (clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clLtGray, clGreen, clBlack, clMaroon, clOlive, clNavy, clPurple, clTeal, clGray, clSilver);

type
  TIWfrmShopType = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWBtnBuild: TIWButton;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryShopType(ServerIndex: Integer;dRate: Double;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmShopType: TIWfrmShopType;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

{ TIWfrmShopType }

procedure TIWfrmShopType.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
end;

procedure TIWfrmShopType.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date > pEDate.Date then
  begin
    WebApplication.ShowMessage('起始日期应大于或等于结束日期，请重新选择');
    Exit;
  end;
  if DayOf(pEDate.Date)-DayOf(pSDate.Date) >= 10 then
  begin
    WebApplication.ShowMessage('查询很耗时，请将查询范围限制在10天以内');
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
    UserSession.ConnectionLogMysql(psld.LogDB, psld.LogHostName);
    try
      QueryShopType(psld.Index,psld.CurrencyRate,pSDate.Date,pEDate.Date);
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

procedure TIWfrmShopType.QueryShopType(ServerIndex: Integer; dRate: Double;
  MinDateTime, MaxDateTime: TDateTime);
const
  tServerID = 'serverindex=%d AND ';
var
  ShopColor: Integer;
  I,J,nField,curMoney: Integer;
  dValue,TotalCount: Double;
  sServerIndex,strItems,strClass: string;
  ClassList,ItemList: TStringList;
  procedure AddChartData(sIndex: string;ClsList: TStringList;sClass,sItems: string;MinDTime,MaxDTime: TDateTime);
  const
    sqlShopType = 'SELECT IFNULL(SUM(paymentcount*-1),0) AS paymentcount FROM %s WHERE logid=115 AND %s consumedescr in (%s)';
    tTableName = 'log_consume_%s';
  var
    Idx: Integer;
    sTableName: string;
  begin
    System.Delete(sItems,Length(sItems),1);    
    with UserSession.quShop do
    begin
      while DateOf(MinDTime)<=DateOf(MaxDTime) do
      begin
        sTableName := Format(tTableName,[FormatDateTime('YYYYMMDD',MinDTime)]);
        SQL.Text := Format(sqlShopType,[sTableName,sIndex,sItems]);
        Open;
        try
          Idx := ClsList.IndexOf(sClass);
          if Idx = -1 then
            ClsList.AddObject(sClass,TObject(Fields[0].AsInteger))
          else
            ClsList.Objects[Idx] := TObject(Integer(ClsList.Objects[Idx]) + Fields[0].AsInteger);
        finally
          Close;
        end;
        MinDTime := IncDay(MinDTime,1);
      end;
    end;
  end;
begin
  if MaxDateTime > Now then MaxDateTime := Now;
  if MinDateTime > Now then MinDateTime := Now;
  sServerIndex := Format(tServerID,[ServerIndex]);
  if ServerIndex = 0 then sServerIndex := '';
  ClassList := TStringList.Create;
  try
    nField := 0;
    for I := 0 to ShopList.Count - 1 do
    begin
      strClass := ShopList.Strings[I];
      ItemList := TStringList(ShopList.Objects[I]);
      for J := 0 to ItemList.Count - 1 do
      begin
        strItems := strItems + QuerySQLStr(ItemList.Strings[J])+ ',';
        Inc(nField);
        if nField = 200 then
        begin
          nField := 0;
          AddChartData(sServerIndex,ClassList,strClass,strItems,MinDateTime,MaxDateTime);
          strItems := '';
        end;
      end;
      if nField > 0 then
      begin
        nField := 0;
        AddChartData(sServerIndex,ClassList,strClass,strItems,MinDateTime,MaxDateTime);
        strItems := '';
      end;
    end;

    TotalCount := 0;
    TIWAdvChart1.Chart.Series[0].ClearPoints;
    for I := 0 to ClassList.Count - 1 do
    begin
      curMoney := Integer(ClassList.Objects[I]);
      dValue := curMoney;
      if dValue <> 0 then dValue := dValue/10;
      dValue := dValue * dRate;
      TotalCount := TotalCount + dValue;
      if I <= High(ShopChartColor) then
      begin
        ShopColor := ShopChartColor[I];
      end
      else begin
        Randomize;
        ShopColor := RGB(Random(255),Random(255),Random(255));
      end;
      TIWAdvChart1.Chart.Series[0].AddSinglePoint(dValue,ShopColor,ClassList.Strings[I]+' '+ Format(objINI.RMBFormat,[dValue]));
    end;
    TIWAdvChart1.Chart.Title.Text := Format('%s(%s)',[curTitle,Format(objINI.RMBFormat,[TotalCount])]);
    TIWAdvChart1.Visible := True;
  finally
    ClassList.Free;
    CoUninitialize;
  end;
end;

initialization
  RegisterClass(TIWfrmShopType);

end.
