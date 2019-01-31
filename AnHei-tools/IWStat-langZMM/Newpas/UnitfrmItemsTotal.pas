unit UnitfrmItemsTotal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = 98;//'物品查询统计';
  sItemsType : array [0..6] of Integer = (490,491,530,492,531,532,533);

type
  TIWfrmItemsTotal = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    IWBtnBuild: TIWButton;
    IWedtItems: TIWEdit;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel2: TIWLabel;
    IWComboBoxType: TIWComboBox;
    IWButton3: TIWButton;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure TIWAdvWebGrid1ColumnHeaderClick(Sender: TObject;
      ColumnIndex: Integer);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
  public
    procedure QueryItemsName(sItems: string);
  end;

var
  IWfrmItemsTotal: TIWfrmItemsTotal;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmItemsTotal }

procedure TIWfrmItemsTotal.IWAppFormCreate(Sender: TObject);
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
  IWLabel2.Caption := Langtostr(166);

  IWBtnBuild.Caption := Langtostr(14);
  IWButton3.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(378);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(402);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(403);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(423);
end;

procedure TIWfrmItemsTotal.IWBtnBuildClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  if  (IWedtItems.Text = '') then
  begin
    WebApplication.ShowMessage(Langtostr(534));
    Exit;
  end;
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);

    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      QueryItemsName(IWedtItems.Text);
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

procedure TIWfrmItemsTotal.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'ItemsTotal' + DateToStr(Now) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmItemsTotal.QueryItemsName(sItems: string);
const
  sqlbag = 'SELECT b.accountname, b.actorname,a.itemidquastrong,(a.itemcountflag & 0xFF) as itemcountflag FROM actorbagitem a LEFT JOIN actors b ON a.actorid=b.actorid  WHERE %s';
  sqlequip = 'SELECT b.accountname, b.actorname,a.itemidquastrong,(a.itemcountflag & 0xFF) as itemcountflag FROM actorequipitem a LEFT JOIN actors b ON a.actorid=b.actorid  WHERE %s';
  sqlpet = 'SELECT b.accountname, b.actorname,a.itemidquastrong,(a.itemcountflag & 0xFF) as itemcountflag FROM actorpetitem a LEFT JOIN actors b ON a.actorid=b.actorid  WHERE %s';
  sqlstorage = 'SELECT b.accountname, b.actorname,a.itemidquastrong,(a.itemcountflag & 0xFF) as itemcountflag FROM actordepotitem a LEFT JOIN actors b ON a.actorid=b.actorid  WHERE %s';
  sqldmkjitem = 'SELECT b.accountname, b.actorname,a.itemidquastrong,(a.itemcountflag & 0xFF) as itemcountflag FROM actordmkjitem a LEFT JOIN actors b ON a.actorid=b.actorid  WHERE %s';
  sqlguild = 'SELECT b.accountname, b.actorname,a.itemidquastrong,(a.itemcountflag & 0xFF) as itemcountflag FROM actorguild a LEFT JOIN actors b ON a.actorid=b.actorid  WHERE %s';

  sqlGroup = 'SELECT accountname, actorname,a.itemidquastrong,sum(itemcountflag) as iCount FROM(%s) a GROUP BY itemidquastrong, accountname,actorname';
  sqlItems = ' itemIdQuaStrong & 0xFFFF in (%s) ';
  sqlUnionALL = ' UNION ALL ';
var
  I,Idx,iCount, acount: Integer;
  ItemsList: TStringList;
  sItemID,sWhere, ssqlall: string;
  procedure BuildSQLData(sSQL: string);
  begin
    with UserSession.quItems,TIWAdvWebGrid1 do
    begin
      SQL.Text := sSQL;
      Open;
      while not Eof do
      begin
      //  TotalRows := RowCount+iCount;
        RowCount := iCount + 1;
        cells[1,iCount] := Utf8ToString(FieldList.FieldByName('accountname').AsAnsiString);
        cells[2,iCount] := Utf8ToString(FieldList.FieldByName('actorname').AsAnsiString);
        cells[3,iCount] := IntToStr(LoWord(FieldByName('itemIdQuaStrong').AsInteger));
        cells[4,iCount] := OnGetStdItemName(LoWord(FieldByName('itemIdQuaStrong').AsInteger));
        cells[5,iCount] := IntToStr(FieldByName('iCount').AsInteger);
        acount:= acount + FieldByName('iCount').AsInteger;
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
    if sItemID = ''  then Exit;
    iCount := 0; acount:= 0; sWhere := ''; ssqlall := '';
    TIWAdvWebGrid1.ClearCells;

    if sItemID <> '' then
    begin
      sWhere := sWhere + Format(sqlItems,[sItemID]);
    end;
    if (IWComboBoxType.ItemIndex = 0) then //所有
    begin
      ssqlall := Format(sqlbag,[sWhere]) + sqlUnionALL + Format(sqlequip,[sWhere]) + sqlUnionALL +
                 Format(sqlpet,[sWhere]) + sqlUnionALL + Format(sqlstorage,[sWhere]) + sqlUnionALL +
                 Format(sqldmkjitem,[sWhere]);
      BuildSQLData(Format(sqlGroup,[ssqlall]));
    end;
    if  (IWComboBoxType.ItemIndex = 1) then //包裹
    begin
      BuildSQLData(Format(sqlbag,[sWhere]));
    end;
    if  (IWComboBoxType.ItemIndex = 2) then //装备
    begin
      BuildSQLData(Format(sqlequip,[sWhere]));
    end;
    if  (IWComboBoxType.ItemIndex = 3) then //英雄身上
    begin
      BuildSQLData(Format(sqlpet,[sWhere]));
    end;
    if  (IWComboBoxType.ItemIndex = 4) then //仓库
    begin
      BuildSQLData(Format(sqlstorage,[sWhere]));
    end;
    if (IWComboBoxType.ItemIndex = 5) then //寻宝
    begin
      BuildSQLData(Format(sqldmkjitem,[sWhere]));
    end;
   { if  (IWComboBoxType.ItemIndex = 6) then //行会仓库
    begin
      BuildSQLData(Format(sqlguild,[sWhere]));
    end;
    if  (IWComboBoxType.ItemIndex = 7) then //系统邮件  暂无
    begin
      BuildSQLData(Format(sqldmkjitem,[sWhere]));
    end; }
    with TIWAdvWebGrid1 do
    begin
      TotalRows := iCount;
      Columns[1].FooterText := langtostr(420);
      Columns[2].FooterText := '';
      Columns[3].FooterText := '';
      Columns[4].FooterText := '';
      Columns[5].FooterText := IntToStr(acount) + langtostr(421);
      TIWAdvWebGrid1.Controller.Caption := Format(langtostr(494),[curTitle,TIWAdvWebGrid1.TotalRows]);
    end;
  finally
    ItemsList.Free;
  end;
end;

procedure TIWfrmItemsTotal.TIWAdvWebGrid1ColumnHeaderClick(Sender: TObject;
  ColumnIndex: Integer);
begin
  inherited;
  //
end;

initialization
  RegisterClass(TIWfrmItemsTotal);

end.
