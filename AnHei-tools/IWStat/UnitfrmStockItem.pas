unit UnitfrmStockItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWWebGrid,
  IWAdvWebGrid;

type
  TIWfrmStockItem = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    IWBtnBuild: TIWButton;
    IWButton1: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel1: TIWLabel;
    IWComboBox1: TIWComboBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryStockItem;
  end;

var
  IWfrmStockItem: TIWfrmStockItem;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmStockItem.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbStockItem]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbStockItem]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbStockItem])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
end;

procedure TIWfrmStockItem.IWBtnBuildClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      QueryStockItem;
      TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;<b>%s</b>£º¹² %d ¸ö¼ÇÂ¼',[Langtostr(StatToolButtonStr[tbStockItem]),TIWAdvWebGrid1.TotalRows]);
    finally
      UserSession.SQLConnectionRole.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmStockItem.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'StockItem' + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmStockItem.QueryStockItem;
const
  sqlBag = 'SELECT (itemIdQuaStrong & 0xFFFF) as item,SUM(itemcountflag & 0xFF) as iCount FROM actorbagitem WHERE itemcountflag & 0xFF > 0 GROUP BY itemIdQuaStrong & 0xFFFF';
  sqlStorage = 'SELECT (itemIdQuaStrong & 0xFFFF) as item,SUM(itemcountflag & 0xFF) as iCount FROM actordepotitem WHERE itemcountflag & 0xFF > 0 GROUP BY itemIdQuaStrong & 0xFFFF';
  sqlMGStorage = 'SELECT (itemIdQuaStrong & 0xFFFF) as item,SUM(itemcountflag & 0xFF) as iCount FROM actordmkjitem WHERE itemcountflag & 0xFF > 0 GROUP BY itemIdQuaStrong & 0xFFFF';
  sqlGroupBy = 'SELECT item,iCount FROM (%s) tmp GROUP BY item ORDER BY iCount DESC';
var
  iCount: Integer;
  sSQL: string;
begin
  case IWComboBox1.ItemIndex of
    0: sSQL := Format(sqlGroupBy,[sqlBag+' UNION ALL '+sqlStorage+' UNION ALL '+sqlMGStorage]);
    1: sSQL := Format(sqlGroupBy,[sqlBag]);
    2: sSQL := Format(sqlGroupBy,[sqlStorage]);
    3: sSQL := Format(sqlGroupBy,[sqlMGStorage]);
  end;
  with UserSession.quRole,TIWAdvWebGrid1 do
  begin
    iCount := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    SQL.Text := sSQL;
    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      cells[1,iCount] := OnGetStdItemName(Fields[0].AsInteger);
      cells[2,iCount] := Fields[1].AsString;
      Inc(iCount);
      Next;
    end;
    TotalRows := iCount;
    RowCount := TotalRows;
    Close;
  end;
end;

end.
