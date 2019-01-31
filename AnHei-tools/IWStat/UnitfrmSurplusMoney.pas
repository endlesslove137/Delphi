unit UnitfrmSurplusMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWWebGrid,
  IWAdvWebGrid, IWTMSCal, DateUtils, IWCompCheckbox;

type
  TIWfrmSurplusMoney = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWAmdbMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QuerySurplusMoney(sMinTime,sMaxTime: string);
  end;

var
  IWfrmSurplusMoney: TIWfrmSurplusMoney;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmSurplusMoney.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := IncDay(Now(),-DayOf(Now())+1);
  pEDate.Date := Now();
  SetServerListSelect(Langtostr(StatToolButtonStr[tbSurplusMoney]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbSurplusMoney]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbSurplusMoney])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
end;

procedure TIWfrmSurplusMoney.IWBtnBuildClick(Sender: TObject);
begin
  inherited;
  try
    try
      QuerySurplusMoney(DateToStr(pSDate.Date),DateToStr(pEDate.Date));
      TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;<b>%s</b>：共 %d 个运营商',[Langtostr(StatToolButtonStr[tbSurplusMoney]),TIWAdvWebGrid1.TotalRows]);
    finally
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmSurplusMoney.QuerySurplusMoney(sMinTime, sMaxTime: string);
const
  sqlPayTotalMoney = 'SELECT SUM(money) AS TotalMoney,SUM(IFNULL(rmb,money/10)) AS TotalRMB FROM %s.payorder WHERE yunying="_%s" AND type in (1,3) AND orderdate>="%s" AND orderdate<="%s 23:59:59"';
  sqlPayTotalMoney2 = 'SELECT SUM(money) AS TotalMoney,SUM(IFNULL(rmb,money/10)) AS TotalRMB FROM %s.payorder_%s WHERE yunying="_%s" AND type in (1,3) AND orderdate>="%s" AND orderdate<="%s 23:59:59"';
  sqlStockGold = 'SELECT SUM(gold) FROM %s.stockgold WHERE logdate>="%s" AND logdate<="%s" AND account not in (SELECT account FROM %s.insideraccount)';
var
  I,iCount,TotalGold,TotalSurplus: Integer;
  psld: PTServerListData;
  TotalRMB: Double;
begin
  iCount := 0; TotalGold := 0; TotalRMB := 0; TotalSurplus := 0;
  TIWAdvWebGrid1.ClearCells;
  TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := PTServerListData(ServerList.Objects[I]);
    if psld^.Index = 0 then
    begin
      UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
      UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
      try
        with TIWAdvWebGrid1,UserSession.quPay do
        begin
          TotalRows := RowCount+iCount;
          if IWAmdbMode.Checked then
           SQL.Text := Format(sqlPayTotalMoney2,[psld^.amdb,FormatDateTime('YYYYMM',pSDate.Date),psld^.spID,sMinTime,sMaxTime])
          else
           SQL.Text := Format(sqlPayTotalMoney,[psld^.amdb,psld^.spID,sMinTime,sMaxTime]);
          Open;
          cells[1,iCount] := ServerList.Strings[I];
          cells[3,iCount] := IntToStr(Fields[0].AsInteger);
          Inc(TotalGold,Fields[0].AsInteger);
          cells[2,iCount] := Format(objINI.RMBFormat,[Fields[1].AsFloat]);
          TotalRMB := TotalRMB + Fields[1].AsFloat;
          Close;
        end;
        with UserSession.quConsume do
        begin
          SQL.Text := Format(sqlStockGold,[psld^.GstaticDB,sMinTime,sMaxTime,psld^.GstaticDB]);
          Open;
          TIWAdvWebGrid1.cells[4,iCount] := IntToStr(Fields[0].AsInteger);
          Inc(TotalSurplus,Fields[0].AsInteger);
          Close;
        end;
        Inc(iCount);
      finally
        UserSession.SQLConnectionSession.Close;
        UserSession.SQLConnectionLog.Close;
      end;
    end;
  end;
  TIWAdvWebGrid1.RowCount := iCount;
  TIWAdvWebGrid1.TotalRows := iCount;
  TIWAdvWebGrid1.Columns[1].FooterText := '合计：';
  TIWAdvWebGrid1.Columns[2].FooterText := Format(objINI.RMBFormat,[TotalRMB]);
  TIWAdvWebGrid1.Columns[3].FooterText := IntToStr(TotalGold);
  TIWAdvWebGrid1.Columns[4].FooterText := IntToStr(TotalSurplus);
end;

end.
