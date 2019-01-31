unit UnitfrmAcross;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton,
  IWTMSImgCtrls, IWControl, IWAdvToolButton,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompLabel,
  IWVCLBaseContainer, IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls,
  IWCompCheckbox;

const
  curTitle = '跨服战查询';

type
  TIWfrmAcross = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    IWBtnBuild: TIWButton;
    IWLabel2: TIWLabel;
    IWedtAccount: TIWEdit;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel1: TIWLabel;
    IWedtRole: TIWEdit;
    IWLabel3: TIWLabel;
    IWcBoxIndex: TIWComboBox;
    IWSpidkBox: TIWCheckBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryAcross(spid,sAccount,sRole,sgstatic: string;ServerIndex: Integer);
  end;

var
  IWfrmAcross: TIWfrmAcross;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

{ TIWfrmAcross }

procedure TIWfrmAcross.IWAppFormCreate(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  inherited;
  ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  LoadGSServers(IWcBoxIndex.Items,ServerListData.spID, False);
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
end;

procedure TIWfrmAcross.IWBtnBuildClick(Sender: TObject);
var
  nIndex: Integer;
  psld: PTServerListData;
begin
  inherited;

  nIndex := 0;
  if IWcBoxIndex.ItemIndex <> -1 then
  begin
    nIndex := GetServerListData(IWcBoxIndex.Text).Index;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      if IWedtAccount.Text <> '' then
      begin
        if not IWSpidkBox.Checked then
        begin
          if Pos('_'+psld.spID,IWedtAccount.Text) = 0 then
          begin
            IWedtAccount.Text := IWedtAccount.Text + '_'+psld.spID;
          end;
        end;
      end;
      QueryAcross(psld^.spID,IWedtAccount.Text,IWedtRole.Text, psld.GstaticDB,nIndex);
      TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;<b>%s</b>：共 %d 个记录',[curTitle,TIWAdvWebGrid1.TotalRows]);
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

procedure TIWfrmAcross.QueryAcross(spid,sAccount, sRole, sgstatic: string;
  ServerIndex: Integer);
const
  sqlAcross = 'SELECT * FROM %s.acrossuser';
  sqlAccount = ' account="%s" AND ';
  sqlRole = ' charname="%s" AND ';
  sqlServerIndex = ' serverindex=%d AND ';
var
  I,iCount: Integer;
  sWhere,sSQL: string;
begin
  sWhere := ''; sSQL := Format(sqlAcross,[sgstatic]);
  if sAccount <> '' then
  begin
    sWhere := sWhere + Format(sqlAccount,[sAccount]);
  end;
  if sRole <> '' then
  begin
    sWhere := sWhere + Format(sqlRole,[sRole]);
  end;
  if ServerIndex <> 0 then
  begin
    sWhere := sWhere + Format(sqlServerIndex,[ServerIndex]);
  end;
  if sWhere <> '' then
  begin
    System.Delete(sWhere,Length(sWhere)-4,4);
    sWhere := ' WHERE ' + sWhere;
    sSQL := sSQL + sWhere;
  end;
  with UserSession.quAcross,TIWAdvWebGrid1 do
  begin
    iCount := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    SQL.Text := sSQL;
    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      for I := 1 to Columns.Count - 1 do
      begin
        if I = 3 then
          cells[I,iCount] := GetServerListName(spid,FieldList.Fields[I-1].AsInteger)
        else
          cells[I,iCount] := FieldList.Fields[I-1].AsString;
      end;
      Inc(iCount);
      Next;
    end;
    TotalRows := iCount;
    Close;
  end;
end;

initialization
  RegisterClass(TIWfrmAcross);
end.
