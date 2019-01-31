unit UnitfrmItems;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompCheckbox;

const
  curTitle = 89;//'ŒÔ∆∑≤È—Ø';
  sItemsType : array [0..3] of Integer = (490,491,492,493);

type
  TIWfrmItems = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    IWBtnBuild: TIWButton;
    IWedtItems: TIWEdit;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWedtAccount: TIWEdit;
    IWLabel4: TIWLabel;
    IWedtRole: TIWEdit;
    IWComboBoxType: TIWComboBox;
    IWSpidkBox: TIWCheckBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
  public
    procedure QueryItemsName(sItems,sAccount,sRoleName: string);
  end;

var
  IWfrmItems: TIWfrmItems;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmItems }

procedure TIWfrmItems.IWAppFormCreate(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWComboBoxType.Items.Add(Langtostr(489));
  for I := Low(sItemsType) to High(sItemsType) do
  begin
    IWComboBoxType.Items.Add(Langtostr(sItemsType[I]));
  end;
  IWComboBoxType.ItemIndex := 0;

  IWLabel1.Caption := Langtostr(441);
  IWLabel3.Caption := Langtostr(283);
  IWLabel4.Caption := Langtostr(291);
  IWLabel2.Caption := Langtostr(166);
  IWSpidkBox.Caption := Langtostr(320);
  IWBtnBuild.Caption := Langtostr(14);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(378);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(403);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(495);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(404);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(423);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(496);
  TIWAdvWebGrid1.Columns[8].Title:= Langtostr(405);
  TIWAdvWebGrid1.Columns[9].Title:= Langtostr(415);
  TIWAdvWebGrid1.Columns[10].Title:= Langtostr(416);
  TIWAdvWebGrid1.Columns[11].Title:= Langtostr(416);
end;

procedure TIWfrmItems.IWBtnBuildClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  if (IWedtAccount.Text='') and (IWedtRole.Text='') and (IWedtItems.Text='') then
  begin
    WebApplication.ShowMessage(Langtostr(410));
    Exit;
  end;
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    if IWedtAccount.Text <> '' then
    begin
      if not IWSpidkBox.Checked then
      begin
        if Pos('_'+ServerListData.spID,IWedtAccount.Text) = 0 then
        begin
          IWedtAccount.Text := IWedtAccount.Text + '_'+ServerListData.spID;
        end;
      end;
    end;
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      QueryItemsName(IWedtItems.Text,IWedtAccount.Text,IWedtRole.Text);
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

procedure TIWfrmItems.QueryItemsName(sItems,sAccount,sRoleName: string);
const
  sqlbag = 'SELECT b.accountname,b.actorname,a.itemcountflag,CAST(a.itemguid as char(255)) as itemguid,a.itemidquastrong,0 AS itemtype,iteminlayhole FROM actorbagitem a LEFT JOIN actors b ON a.actorid=b.actorid WHERE a.actorid>0 %s';
  sqlequip = 'SELECT b.accountname,b.actorname,a.itemcountflag,CAST(a.itemguid as char(255)) as itemguid,a.itemidquastrong,1 AS itemtype,iteminlayhole FROM actorequipitem a LEFT JOIN actors b ON a.actorid=b.actorid WHERE a.actorid>0 %s';
  sqlstorage = 'SELECT b.accountname,b.actorname,a.itemcountflag,CAST(a.itemguid as char(255)) as itemguid,a.itemidquastrong,2 AS itemtype,iteminlayhole FROM actordepotitem a LEFT JOIN actors b ON a.actorid=b.actorid WHERE a.actorid>0 %s';
  sqldmkjitem = 'SELECT b.accountname,b.actorname,a.itemcountflag,CAST(a.itemguid as char(255)) as itemguid,a.itemidquastrong,3 AS itemtype,iteminlayhole FROM actordmkjitem a LEFT JOIN actors b ON a.actorid=b.actorid WHERE a.actorid>0 %s';
  sqlItems = ' AND itemIdQuaStrong & 0xFFFF in (%s) ';
  sqlAccount = ' AND b.accountname=%s ';
  sqlRole = ' AND b.actorname=%s ';
var
  I,Idx,iCount: Integer;
  ItemsList: TStringList;
  sItemID,sWhere: string;
  procedure BuildSQLData(sSQL: string);
  begin
    with UserSession.quItems,TIWAdvWebGrid1 do
    begin
      SQL.Text := sSQL;
      Open;
      while not Eof do
      begin
        TotalRows := RowCount+iCount;
        cells[1,iCount] := Utf8ToString(FieldList.FieldByName('accountname').AsAnsiString);
        cells[2,iCount] := Utf8ToString(FieldList.FieldByName('actorname').AsAnsiString);
        cells[3,iCount] := OnGetStdItemName(LoWord(FieldByName('itemIdQuaStrong').AsInteger));
        cells[4,iCount] := Langtostr(sItemsType[FieldByName('itemtype').AsInteger]);
        cells[5,iCount] := FieldList.FieldByName('itemguid').AsString;
        cells[6,iCount] := IntToStr(Lo(FieldByName('itemcountflag').AsInteger));
        cells[7,iCount] := IntToStr(Lo(HiWord(FieldByName('itemIdQuaStrong').AsInteger)));
        cells[8,iCount] := IntToStr(Hi(HiWord(FieldByName('itemIdQuaStrong').AsInteger)));
        if HiWord(FieldByName('itemcountflag').AsInteger) <> 0 then
        begin
          cells[9,iCount] := OnGetStdItemName(HiWord(FieldByName('itemcountflag').AsInteger) and $7FFF);
        end;
        if LoWord(FieldByName('iteminlayhole').AsInteger) <> 0 then
        begin
          cells[10,iCount] := OnGetStdItemName(LoWord(FieldByName('iteminlayhole').AsInteger) and $7FFF);
        end;
        if HiWord(FieldByName('iteminlayhole').AsInteger) <> 0 then
        begin
          cells[11,iCount] := OnGetStdItemName(HiWord(FieldByName('iteminlayhole').AsInteger) and $7FFF);
        end;
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;
begin
  ItemsList := TStringList.Create;
  try
    ItemsList.DelimitedText := sItems;
    ItemsList.Delimiter := ',';
    sItemID := '';
    for I := 0 to ItemsList.Count - 1 do
    begin
      Idx := FStdItemList.IndexOf(ItemsList.Strings[I]);
      if Idx>-1 then
      begin
        sItemID := sItemID + IntToStr(Idx)+ ',';
      end;
    end;
    if Length(sItemID) > 0 then
    begin
      Delete(sItemID,Length(sItemID),1);
    end;
    if (sItemID='') and (sAccount='') and (sRoleName='') then Exit;
    iCount := 0; sWhere := '';
    TIWAdvWebGrid1.ClearCells;
    TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;
    if sAccount <> '' then
    begin
      sWhere := Format(sqlAccount,[QuerySQLStr(sAccount)]);
    end;
    if sRoleName <> '' then
    begin
      sWhere := sWhere + Format(sqlRole,[QuerySQLStr(sRoleName)]);
    end;
    if sItemID <> '' then
    begin
      sWhere := sWhere + Format(sqlItems,[sItemID]);
    end;
    if (IWComboBoxType.ItemIndex = 0) or (IWComboBoxType.ItemIndex = 1) then
    begin
      BuildSQLData(Format(sqlbag,[sWhere]));
    end;
    if (IWComboBoxType.ItemIndex = 0) or (IWComboBoxType.ItemIndex = 2) then
    begin
      BuildSQLData(Format(sqlequip,[sWhere]));
    end;
    if (IWComboBoxType.ItemIndex = 0) or (IWComboBoxType.ItemIndex = 3) then
    begin
      BuildSQLData(Format(sqlstorage,[sWhere]));
    end;
    if (IWComboBoxType.ItemIndex = 0) or (IWComboBoxType.ItemIndex = 4) then
    begin
      BuildSQLData(Format(sqldmkjitem,[sWhere]));
    end;
    TIWAdvWebGrid1.TotalRows := iCount;
    TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(494),[curTitle,TIWAdvWebGrid1.TotalRows]);
  finally
    ItemsList.Free;
  end;
end;

initialization
  RegisterClass(TIWfrmItems);

end.
