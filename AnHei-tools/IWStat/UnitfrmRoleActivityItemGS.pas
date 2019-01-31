unit UnitfrmRoleActivityItemGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSPopup, Menus, IWWebGrid, IWAdvWebGrid, IWCompMemo,
  IWCompCheckbox, IWTMSEdit, IWCompEdit, IWCompButton, IWCompListbox,
  IWTMSImgCtrls, IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls,
  IWVCLBaseContainer, IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion;

type
  TIWfrmRoleActivityItemGS = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    IWBtnAdd: TIWButton;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    TIWsedtStrong: TTIWAdvSpinEdit;
    IWLabel4: TIWLabel;
    IWLabel5: TIWLabel;
    TIWsedtQuality: TTIWAdvSpinEdit;
    IWLabel6: TIWLabel;
    IWcBoxBind: TIWCheckBox;
    IWButton1: TIWButton;
    TIWsedtCount: TTIWAdvSpinEdit;
    IWedtStdItem: TIWEdit;
    IWMemoAccount: TIWMemo;
    IWCBoxStack: TIWCheckBox;
    IWMemoRemark: TIWMemo;
    IWLabel1: TIWLabel;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    TIWPopupMenuButton1: TTIWPopupMenuButton;
    IWLabel7: TIWLabel;
    TIWsedtAppr2: TTIWAdvSpinEdit;
    IWLabel8: TIWLabel;
    TIWsedtAppr1: TTIWAdvSpinEdit;
    IWLabel9: TIWLabel;
    TIWsedtDesc: TTIWAdvSpinEdit;
    IWLabel10: TIWLabel;
    TIWsedtAppr3: TTIWAdvSpinEdit;
    IWActivityMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnAddClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IWfrmRoleActivityItemGS: TIWfrmRoleActivityItemGS;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmRoleActivityItemGS.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbRoleActivityItemGS]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbRoleActivityItemGS]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbRoleActivityItemGS])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
end;

procedure TIWfrmRoleActivityItemGS.IWBtnAddClick(Sender: TObject);
const
  sqlactors = 'SELECT actorid FROM actors WHERE actorname=%s';
var
  I,Idx: Integer;
  UserID :DWORD;
  sRole,strTmp: string;
  pStdItem: pTStdItem;
  ServerListData: PTServerListData;
begin
  Idx := FStdItemList.IndexOf(IWedtStdItem.Text);
  if Idx = -1 then
  begin
    WebApplication.ShowMessage('物品不存在，请重新输入');
    Exit;
  end;
  pStdItem := pTStdItem(FStdItemList.Objects[Idx]);
  if IWCBoxStack.Checked then
  begin
    if TIWsedtCount.Value > pStdItem^.Dup then
    begin
      WebApplication.ShowMessage('叠加物品数不可以大于'+IntToStr(pStdItem^.Dup));
      Exit;
    end;
  end;
  if TIWsedtStrong.Value > 20 then
  begin
    WebApplication.ShowMessage('强化等级不可以大于20');
    Exit;
  end;
  if TIWsedtQuality.Value > 7 then
  begin
    WebApplication.ShowMessage('品质等级不可以大于7');
    Exit;
  end;
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      if FStdItemList.IndexOf(IWedtStdItem.Text) = -1 then
      begin
        WebApplication.ShowMessage('物品不存在，请重新输入');
        Exit;
      end;
      if TIWsedtCount.Value = 0 then
      begin
        WebApplication.ShowMessage('数量要大于0，请重新输入');
        Exit;
      end;
      strTmp := '';
      for I := 0 to IWMemoAccount.Lines.Count - 1 do
      begin
        sRole := IWMemoAccount.Lines.Strings[I];
        with UserSession.quActivityRItem,TIWAdvWebGrid1 do
        begin
          SQL.Text := Format(sqlactors,[QuerySQLStr(sRole)]);
          Open;
          UserID := Fields[0].AsLargeInt;
          if UserID > 0 then
          begin
            RowCount := RowCount + 1;
            Cells[1,RowCount-1] := UIntToStr(UserID);
            Cells[2,RowCount-1] := sRole;
            Cells[3,RowCount-1] := IWedtStdItem.Text;
            Cells[4,RowCount-1] := IntToStr(TIWsedtStrong.Value);
            Cells[5,RowCount-1] := IntToStr(TIWsedtQuality.Value);

            Cells[6,RowCount-1] := IntToStr(TIWsedtDesc.Value);
            Cells[7,RowCount-1] := IntToStr(TIWsedtAppr1.Value);
            Cells[8,RowCount-1] := IntToStr(TIWsedtAppr2.Value);
            Cells[9,RowCount-1] := IntToStr(TIWsedtAppr3.Value);

            Cells[10,RowCount-1] := IntToStr(TIWsedtCount.Value);
            Cells[11,RowCount-1] := sBind[Integer(IWcBoxBind.Checked)];
            Cells[12,RowCount-1] := sStack[Integer(IWCBoxStack.Checked)];
            Cells[13,RowCount-1] := IWMemoRemark.Text;
          end
          else begin
            strTmp := strTmp + sRole+',';
          end;
          Close;
        end;
      end;
      if strTmp <> '' then
      begin
        System.Delete(strTmp,Length(strTmp),1);
        WebApplication.ShowMessage('不存在的角色：'+strTmp);
      end;
      TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共 %d 个记录',[TIWAdvWebGrid1.TotalRows]);
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

procedure TIWfrmRoleActivityItemGS.IWButton1Click(Sender: TObject);
const
  sqlGiftBag = 'INSERT INTO useritem(actorid,itemid,bind,strong,quality,itemcount,memo) VALUES ';
  sqlGiftBagValues = '(%d,%d,%d,%d,%d,%d,%s),';
  sqlGiftBagEx = 'INSERT INTO useritem(actorid,itemid,bind,strong,quality,itemcount,memo,smith1,smith2,smith3,initsmith) VALUES ';
  sqlGiftBagValuesEx = '(%d,%d,%d,%d,%d,%d,%s,%d,%d,%d,%d),';
var
  I,J,Idx,iCount,iBind,iRecord: Integer;
  nStrong,nQuality,nCount: Integer;
  snith1, snith2, snith3, initsmith: Integer;
  ServerListData: PTServerListData;
  strGiftItem,strAction: string;
  UserID: Int64;
begin
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      iCount := 0;
      for I := 0 to TIWAdvWebGrid1.TotalRows - 1 do
      begin
        UserID := StrToInt64(TIWAdvWebGrid1.Cells[1,I]);
        nStrong := StrToInt(TIWAdvWebGrid1.Cells[4,I]);
        nQuality := StrToInt(TIWAdvWebGrid1.Cells[5,I]);

        initsmith :=  StrToInt(TIWAdvWebGrid1.Cells[6,I]);
        snith1 :=  StrToInt(TIWAdvWebGrid1.Cells[7,I]);
        snith2 :=  StrToInt(TIWAdvWebGrid1.Cells[8,I]);
        snith3 :=  StrToInt(TIWAdvWebGrid1.Cells[9,I]);

        nCount := StrToInt(TIWAdvWebGrid1.Cells[10,I]);
        Idx := FStdItemList.IndexOf(TIWAdvWebGrid1.Cells[3,I]);

        iBind := 0;
        if TIWAdvWebGrid1.Cells[11,I] = sBind[1] then iBind := 1;
        if Idx>0 then
        begin
          strAction := GetServerListName(ServerListData^.spID,ServerListData.Index,True)+'/'+TIWAdvWebGrid1.Cells[3,I]+'/'+TIWAdvWebGrid1.Cells[4,I]+'/'+TIWAdvWebGrid1.Cells[5,I]+'/'+TIWAdvWebGrid1.Cells[6,I]+'/'+TIWAdvWebGrid1.Cells[7,I]+'/'+TIWAdvWebGrid1.Cells[8,I]+'/'+TIWAdvWebGrid1.Cells[9,I]+'/'+TIWAdvWebGrid1.Cells[10,I]+'/'+TIWAdvWebGrid1.Cells[11,I]+'/'+TIWAdvWebGrid1.Cells[12,I];
          strGiftItem := '';
          if TIWAdvWebGrid1.Cells[12,I] = sStack[1] then
          begin
            if not IWActivityMode.Checked then
              strGiftItem := strGiftItem+Format(sqlGiftBagValues,[UserID,Idx,iBind,nStrong,nQuality,nCount,QuerySQLStr('后台补发A')]) //QuerySQLStr(TIWAdvWebGrid1.Cells[13,I])
            else
              strGiftItem := strGiftItem+Format(sqlGiftBagValuesEx,[UserID,Idx,iBind,nStrong,nQuality,nCount,QuerySQLStr('后台补发A'),snith1, snith2, snith3, initsmith]); //QuerySQLStr(TIWAdvWebGrid1.Cells[13,I])
          end
          else begin
            for J := 0 to nCount - 1 do
            begin
              if not IWActivityMode.Checked then
               strGiftItem := strGiftItem+Format(sqlGiftBagValues,[UserID,Idx,iBind,nStrong,nQuality,1,QuerySQLStr('后台补发B')]) //QuerySQLStr(TIWAdvWebGrid1.Cells[13,I])
              else
               strGiftItem := strGiftItem+Format(sqlGiftBagValuesEx,[UserID,Idx,iBind,nStrong,nQuality,1,QuerySQLStr('后台补发B'),snith1, snith2, snith3, initsmith]); //QuerySQLStr(TIWAdvWebGrid1.Cells[13,I])
            end;
          end;
          if strGiftItem <> '' then
          begin
            with UserSession.quActivityRItem do
            begin
              System.Delete(strGiftItem,Length(strGiftItem),1);
              if not IWActivityMode.Checked then
                SQL.Text := sqlGiftBag+strGiftItem
              else
                SQL.Text := sqlGiftBagEx+strGiftItem;
              iRecord := ExecSQL;
              if iRecord > 0 then
              begin
                UserSession.AddHTOperateLog(1,TIWAdvWebGrid1.Cells[2,I],strAction,TIWAdvWebGrid1.Cells[13,I]);
              end;
              Inc(iCount,iRecord);
              Close;
            end;
          end;
        end;
      end;
      WebApplication.ShowMessage(Format('完成，操作插入了%d条记录',[iCount]));
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

procedure TIWfrmRoleActivityItemGS.N1Click(Sender: TObject);
begin
  inherited;
  if TIWAdvWebGrid1.RadioSelection > -1 then
  begin
    TIWAdvWebGrid1.DeleteRows(TIWAdvWebGrid1.RadioSelection,1);
    TIWAdvWebGrid1.RowCount := TIWAdvWebGrid1.TotalRows;
  end;
end;

procedure TIWfrmRoleActivityItemGS.N2Click(Sender: TObject);
begin
  inherited;
  TIWAdvWebGrid1.ClearCells;
  TIWAdvWebGrid1.RowCount := 0;
  TIWAdvWebGrid1.TotalRows := 0;
end;

initialization
  RegisterClass(TIWfrmRoleActivityItemGS);

end.
