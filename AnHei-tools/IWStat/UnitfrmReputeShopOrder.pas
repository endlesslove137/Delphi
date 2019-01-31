unit UnitfrmReputeShopOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWWebGrid, IWAdvWebGrid, IWCompButton, IWCompEdit,
  IWTMSCal, IWTMSImgCtrls, IWControl, IWAdvToolButton,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompLabel,
  IWVCLBaseContainer, IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = '声望商城排行统计';

type
  TIWfrmReputeShopOrder = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryReputeShop(ServerIndex: Integer;dRate: Double;SelectDateTime: TDateTime);
  end;

var
  IWfrmReputeShopOrder: TIWfrmReputeShopOrder;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmReputeShopOrder }

procedure TIWfrmReputeShopOrder.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
end;

procedure TIWfrmReputeShopOrder.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
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
    end;
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryReputeShop(psld.Index,psld.CurrencyRate,pSDate.Date);
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

procedure TIWfrmReputeShopOrder.QueryReputeShop(ServerIndex: Integer;
  dRate: Double; SelectDateTime: TDateTime);
const
  sqlReputeShop = 'SELECT shortstr0 as Item,COUNT(1) as BuyCount,COUNT(1) as BuyTimes,COUNT(DISTINCT account) as BuyRole,SUM(para1*-1) as Repute FROM log_common_%s WHERE logid=601 %s GROUP BY shortstr0 ORDER BY Repute DESC';
  sqlServerindex = ' AND serverindex = %d ';
var
  I,iCount: Integer;
  TotalCount,TotalQuantity,TotalRole,TotalRepute: Integer;
  sServerIndex: string;
begin
  sServerIndex := '';
  if ServerIndex <> 0 then sServerIndex := Format(sqlServerindex,[ServerIndex]);
  with UserSession.quReputeShop,TIWAdvWebGrid1 do
  begin
    iCount := 0; TotalCount := 0; TotalQuantity := 0; TotalRole := 0; TotalRepute := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    SQL.Text := Format(sqlReputeShop,[FormatDateTime('YYYYMMDD',SelectDateTime),sServerIndex]);
    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      for I := 1 to Columns.Count - 1 do
      begin
        cells[1,iCount] := Utf8ToString(FieldByName('Item').AsAnsiString);
        Inc(TotalCount,FieldByName('BuyCount').AsInteger);
        cells[2,iCount] := FieldByName('BuyCount').AsString;
        Inc(TotalQuantity,FieldByName('BuyTimes').AsInteger);
        cells[3,iCount] := FieldByName('BuyTimes').AsString;
        Inc(TotalRole,FieldByName('BuyRole').AsInteger);
        cells[4,iCount] := FieldByName('BuyRole').AsString;
        Inc(TotalRepute,FieldByName('Repute').AsInteger);
        cells[5,iCount] := FieldByName('Repute').AsString;
      end;
      Inc(iCount);
      Next;
    end;
    Columns[1].FooterText := '总计：';
    Columns[2].FooterText := IntToStr(TotalCount);
    Columns[3].FooterText := IntToStr(TotalQuantity);
    Columns[4].FooterText := IntToStr(TotalRole);
    Columns[5].FooterText := IntToStr(TotalRepute);
    TotalRows := iCount;
    Close;
  end;
end;

initialization
  RegisterClass(TIWfrmReputeShopOrder);

end.
