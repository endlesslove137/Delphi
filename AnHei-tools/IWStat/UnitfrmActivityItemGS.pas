unit UnitfrmActivityItemGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompEdit, IWCompButton, IWCompCheckbox,
  IWTMSEdit, IWCompListbox, IWWebGrid, IWAdvWebGrid, IWTMSPopup, Menus,
  IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompMemo;

type
  TIWfrmActivityItemGS = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    IWBtnAdd: TIWButton;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWLabel6: TIWLabel;
    IWcBoxBind: TIWCheckBox;
    IWButton1: TIWButton;
    TIWsedtCount: TTIWAdvSpinEdit;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    TIWPopupMenuButton1: TTIWPopupMenuButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    IWedtStdItem: TIWEdit;
    N2: TMenuItem;
    IWMemoAccount: TIWMemo;
    IWCBoxStack: TIWCheckBox;
    IWLabel4: TIWLabel;
    IWLabel5: TIWLabel;
    TIWsedtQuality: TTIWAdvSpinEdit;
    TIWsedtStrong: TTIWAdvSpinEdit;
    TIWsedtAppr3: TTIWAdvSpinEdit;
    IWLabel10: TIWLabel;
    TIWsedtDesc: TTIWAdvSpinEdit;
    IWLabel9: TIWLabel;
    TIWsedtAppr1: TTIWAdvSpinEdit;
    IWLabel8: TIWLabel;
    TIWsedtAppr2: TTIWAdvSpinEdit;
    IWLabel7: TIWLabel;
    IWLabel1: TIWLabel;
    IWMemoRemark: TIWMemo;
    IWActivityMode: TIWCheckBox;
    IWSpidkBox: TIWCheckBox;
    procedure IWBtnAddClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
    nIndex: Integer;
  public
    function CheckMemoMode: Boolean;
  end;

var
  IWfrmActivityItemGS: TIWfrmActivityItemGS;

implementation

uses ServerController, ConfigINI, MiniDateTime;

{$R *.dfm}

{ TIWfrmActivityItemGS }

function TIWfrmActivityItemGS.CheckMemoMode: Boolean;
var
  I,iCount: Integer;
begin
  for I := IWMemoAccount.Lines.Count - 1 downto 0 do
  begin
    if IWMemoAccount.Lines.Strings[I] = '' then
    begin
      IWMemoAccount.Lines.Delete(I);
    end;
  end;
  iCount := 0;
  for I := 0 to IWMemoAccount.Lines.Count - 1 do
  begin
    if (ParameterIntValue(IWMemoAccount.Lines.Strings[I]) > 0) and
       (ParameterStrValue(IWMemoAccount.Lines.Strings[I]) <> '') then
    begin
      Inc(iCount);
    end;
  end;
  Result := (iCount <> 0) and (iCount=IWMemoAccount.Lines.Count);
end;

procedure TIWfrmActivityItemGS.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbActivityItemGS]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbActivityItemGS]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbActivityItemGS])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
end;

procedure TIWfrmActivityItemGS.IWBtnAddClick(Sender: TObject);
const
  sqlglobaluser = 'SELECT userid FROM globaluser WHERE account=%s';
var
  I,Idx,UserID: Integer;
  Account,strTmp: string;
  pStdItem: pTStdItem;
  psld: PTServerListData;
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
  if not CheckMemoMode then
  begin
    WebApplication.ShowMessage('账号格式不正确，请检查');
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    nIndex := psld.Index;
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
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
        Account := ParameterStrValue(IWMemoAccount.Lines.Strings[I]);
        with UserSession.quActivityItem,TIWAdvWebGrid1 do
        begin
          if not IWSpidkBox.Checked then
          begin
            if Pos('_'+psld.spID,Account) = 0 then
            begin
              Account := Account + '_'+psld.spID;
            end;
          end;
          SQL.Text := Format(sqlglobaluser,[QuerySQLStr(Account)]);
          Open;
          UserID := Fields[0].AsInteger;
          if UserID > 0 then
          begin
            RowCount := RowCount + 1;
            Cells[1,RowCount-1] := IntToStr(UserID);
            Cells[2,RowCount-1] := Account;
            Cells[3,RowCount-1] := GetServerListName(psld^.spid,ParameterIntValue(IWMemoAccount.Lines.Strings[I])+psld.ServerID,True);
            Cells[4,RowCount-1] := IWedtStdItem.Text;
            Cells[5,RowCount-1] := IntToStr(TIWsedtStrong.Value);
            Cells[6,RowCount-1] := IntToStr(TIWsedtQuality.Value);

            Cells[7,RowCount-1] := IntToStr(TIWsedtDesc.Value);
            Cells[8,RowCount-1] := IntToStr(TIWsedtAppr1.Value);
            Cells[9,RowCount-1] := IntToStr(TIWsedtAppr2.Value);
            Cells[10,RowCount-1] := IntToStr(TIWsedtAppr3.Value);

            Cells[11,RowCount-1] := IntToStr(TIWsedtCount.Value);
            Cells[12,RowCount-1] := sBind[Integer(IWcBoxBind.Checked)];
            Cells[13,RowCount-1] := sStack[Integer(IWCBoxStack.Checked)];
            Cells[14,RowCount-1] := IWMemoRemark.Text;
          end
          else begin
            strTmp := strTmp + Account+',';
          end;
          Close;
        end;
      end;
      if strTmp <> '' then
      begin
        System.Delete(strTmp,Length(strTmp),1);
        WebApplication.ShowMessage('不存在的账号：'+strTmp);
      end;
      TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共 %d 个记录',[TIWAdvWebGrid1.TotalRows]);
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

procedure TIWfrmActivityItemGS.IWButton1Click(Sender: TObject);
const
  sqlGiftBag = 'INSERT INTO useritem(accountid,itemid,bind,strong,quality,itemcount,serverindex,memo) VALUES ';
  sqlGiftBagValues = '(%d,%d,%d,%d,%d,%d,%d,%s),';
  sqlGiftBagEx = 'INSERT INTO useritem(accountid,itemid,bind,strong,quality,itemcount,serverindex,memo,smith1,smith2,smith3,initsmith) VALUES ';
  sqlGiftBagValuesEx = '(%d,%d,%d,%d,%d,%d,%d,%s,%d,%d,%d,%d),';
var
  I,J,Idx,iCount,SIndex,iBind,iRecord: Integer;
  nStrong,nQuality,nCount: Integer;
  snith1, snith2, snith3, initsmith: Integer;
  psld: PTServerListData;
  strGiftItem,strAction: string;
  UserID:Int64;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      iCount := 0;
      for I := 0 to TIWAdvWebGrid1.TotalRows - 1 do
      begin
        SIndex := 0;
        UserID := StrToInt64(TIWAdvWebGrid1.Cells[1,I]);
        psld := GetServerListData(TIWAdvWebGrid1.Cells[3,I]);
        if psld <> nil then
        begin
          SIndex := psld.Index;
        end;
        nStrong := StrToInt(TIWAdvWebGrid1.Cells[5,I]);
        nQuality := StrToInt(TIWAdvWebGrid1.Cells[6,I]);

        initsmith :=  StrToInt(TIWAdvWebGrid1.Cells[7,I]);
        snith1 :=  StrToInt(TIWAdvWebGrid1.Cells[8,I]);
        snith2 :=  StrToInt(TIWAdvWebGrid1.Cells[9,I]);
        snith3 :=  StrToInt(TIWAdvWebGrid1.Cells[10,I]);
        nCount := StrToInt(TIWAdvWebGrid1.Cells[11,I]);
        Idx := FStdItemList.IndexOf(TIWAdvWebGrid1.Cells[4,I]);
        iBind := 0;
        if TIWAdvWebGrid1.Cells[12,I] = sBind[1] then iBind := 1;
        if Idx>0 then
        begin
          strAction := TIWAdvWebGrid1.Cells[3,I]+'/'+TIWAdvWebGrid1.Cells[4,I]+'/'+TIWAdvWebGrid1.Cells[5,I]+'/'+TIWAdvWebGrid1.Cells[6,I]+'/'+TIWAdvWebGrid1.Cells[7,I]+'/'+TIWAdvWebGrid1.Cells[8,I]+'/'+TIWAdvWebGrid1.Cells[9,I]+'/'+TIWAdvWebGrid1.Cells[10,I]+'/'+TIWAdvWebGrid1.Cells[11,I]+'/'+TIWAdvWebGrid1.Cells[12,I]+'/'+TIWAdvWebGrid1.Cells[13,I];
          strGiftItem := '';
          if TIWAdvWebGrid1.Cells[13,I] = sStack[1] then
          begin
            if not IWActivityMode.Checked then
              strGiftItem := strGiftItem+Format(sqlGiftBagValues,[UserID,Idx,iBind,nStrong,nQuality,nCount,SIndex,QuerySQLStr('后台补发C')]) //QuerySQLStr(TIWAdvWebGrid1.Cells[14,I])
            else
              strGiftItem := strGiftItem+Format(sqlGiftBagValuesEx,[UserID,Idx,iBind,nStrong,nQuality,nCount,SIndex,QuerySQLStr('后台补发C'),snith1, snith2, snith3, initsmith]);  //QuerySQLStr(TIWAdvWebGrid1.Cells[14,I])
          end
          else begin
            for J := 0 to nCount - 1 do
            begin
              if not IWActivityMode.Checked then
               strGiftItem := strGiftItem+Format(sqlGiftBagValues,[UserID,Idx,iBind,nStrong,nQuality,1,SIndex,QuerySQLStr('后台补发D')])  //QuerySQLStr(TIWAdvWebGrid1.Cells[14,I])
              else
               strGiftItem := strGiftItem+Format(sqlGiftBagValuesEx,[UserID,Idx,iBind,nStrong,nQuality,1,SIndex,QuerySQLStr('后台补发D'),snith1, snith2, snith3, initsmith]); //QuerySQLStr(TIWAdvWebGrid1.Cells[14,I])
            end;
          end;
          if strGiftItem <> '' then
          begin
            with UserSession.quActivityItem do
            begin
              System.Delete(strGiftItem,Length(strGiftItem),1);
              if not IWActivityMode.Checked then
                SQL.Text := sqlGiftBag+strGiftItem
              else
                SQL.Text := sqlGiftBagEx+strGiftItem;
              iRecord := ExecSQL;
              if iRecord > 0 then
              begin
                UserSession.AddHTOperateLog(0,TIWAdvWebGrid1.Cells[2,I],strAction,TIWAdvWebGrid1.Cells[14,I]);
              end;
              Inc(iCount,iRecord);
              Close;
            end;
          end;
        end;
      end;
      WebApplication.ShowMessage(Format('完成，操作插入了%d条记录',[iCount]));
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

procedure TIWfrmActivityItemGS.N1Click(Sender: TObject);
begin
  if TIWAdvWebGrid1.RadioSelection > -1 then
  begin
    TIWAdvWebGrid1.DeleteRows(TIWAdvWebGrid1.RadioSelection,1);
    TIWAdvWebGrid1.RowCount := TIWAdvWebGrid1.TotalRows;
  end;
end;

procedure TIWfrmActivityItemGS.N2Click(Sender: TObject);
begin
  inherited;
  TIWAdvWebGrid1.ClearCells;
  TIWAdvWebGrid1.RowCount := 0;
  TIWAdvWebGrid1.TotalRows := 0;
end;

initialization
  RegisterClass(TIWfrmActivityItemGS);
end.
