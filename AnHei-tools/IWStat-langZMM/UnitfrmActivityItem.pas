unit UnitfrmActivityItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWWebGrid, IWAdvWebGrid, IWCompEdit,
  IWCompButton, IWCompListbox, IWExchangeBar, IWCompRectangle,
  IWTMSCtrls, IWCompCheckbox;

const
  curTitle = 90;//'活动物品';

type
  TIWfrmActivityItem = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    IWBtnBuild: TIWButton;
    IWLabel2: TIWLabel;
    IWedtAccount: TIWEdit;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel1: TIWLabel;
    IWBtnDel: TIWButton;
    IWLabel3: TIWLabel;
    IWedtRole: TIWEdit;
    IWSpidkBox: TIWCheckBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnDelClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryActivityItem(ServerIndex: Integer;sAccount,sRole,spid: string);
  end;

var
  IWfrmActivityItem: TIWfrmActivityItem;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmActivityItem }

procedure TIWfrmActivityItem.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel2.Caption := Langtostr(283);
  IWLabel3.Caption := Langtostr(291);
  IWLabel1.Caption := Langtostr(499);
  IWBtnDel.Caption := Langtostr(500);
  IWBtnBuild.Caption := Langtostr(14);
  IWSpidkBox.Caption := Langtostr(320);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(501);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(378);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(403);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(405);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(496);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(423);
  TIWAdvWebGrid1.Columns[8].Title:= Langtostr(502);
  TIWAdvWebGrid1.Columns[9].Title:= Langtostr(503);
  TIWAdvWebGrid1.Columns[10].Title:= Langtostr(495);
end;

procedure TIWfrmActivityItem.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if (IWedtAccount.Text = '') and (IWedtRole.Text = '') then
  begin
    WebApplication.ShowMessage(Langtostr(497));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
    try
      QueryActivityItem(psld.Index,IWedtAccount.Text,IWedtRole.Text,psld.spID);
      TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(194),[Langtostr(curTitle),TIWAdvWebGrid1.TotalRows]);
    finally
      UserSession.SQLConnectionSession.Close;
      UserSession.SQLConnectionRole.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmActivityItem.IWBtnDelClick(Sender: TObject);
const
  sqlDelAccountItem = 'DELETE FROM useritem WHERE id IN (%s)';
  sqlDelRoleItem = 'DELETE FROM useritem WHERE id IN (%s)';
var
  I,iCount: Integer;
  sAValue,sRValue: string;
begin
  inherited;
  sAValue := ''; sRValue := ''; iCount := 0;
  for I := 0 to TIWAdvWebGrid1.TotalRows - 1 do
  begin
    if (TIWAdvWebGrid1.RowSelect[I]) then
    begin
      if TIWAdvWebGrid1.Cells[10,I] = Langtostr(256) then
      begin
        sAValue := sAValue + TIWAdvWebGrid1.Cells[1,I] + ',';
      end
      else begin
        sRValue := sRValue + TIWAdvWebGrid1.Cells[1,I] + ',';
      end;
    end;
  end;
  if Length(sAValue) > 0 then
  begin
    Delete(sAValue,Length(sAValue),1);
    with UserSession.quActivityItem do
    begin
      SQL.Text := Format(sqlDelAccountItem,[sAValue]);
      Inc(iCount,ExecSQL);
      Close;
    end;
  end;
  if Length(sRValue) > 0 then
  begin
    Delete(sRValue,Length(sRValue),1);
    with UserSession.quActivityRItem do
    begin
      SQL.Text := Format(sqlDelRoleItem,[sRValue]);
      Inc(iCount,ExecSQL);
      Close;
    end;
  end;
  WebApplication.ShowMessage(Format(Langtostr(498),[iCount]));
  IWBtnBuild.OnClick(self);
  TIWAdvWebGrid1.ClearRowSelect;
end;

procedure TIWfrmActivityItem.QueryActivityItem(ServerIndex: Integer;
  sAccount,sRole,spid: string);
const
  sqlActivityItem = 'SELECT a.id,b.account as accountname,actorid as actorname,a.itemid,a.strong,a.quality,a.itemcount,a.bind,a.memo FROM useritem a INNER JOIN globaluser b ON a.accountid=b.userid WHERE a.serverindex IN (0,%d) AND b.account in (%s)';
  sqlActors = 'SELECT a.id,b.accountname,b.actorname,a.itemid,a.strong,a.quality,a.itemcount,a.bind,a.memo FROM useritem a INNER JOIN actors b ON a.actorid=b.actorid WHERE b.accountname in (%s)';
  sqlActorsRole = 'SELECT a.id,b.accountname,b.actorname,a.itemid,a.strong,a.quality,a.itemcount,a.bind,a.memo FROM useritem a INNER JOIN actors b ON a.actorid=b.actorid WHERE b.actorname in (%s)';
var
  strSQL,strTmp: string;
  iCount: Integer;
  function GetGroupCONCAT(strAccount: string): string;
  var
    I: Integer;
    strTmp: string;
    strList: TStringList;
  begin
    Result := '';
    strList := TStringList.Create;
    try
      strList.Delimiter := ',';
      strList.DelimitedText := strAccount;
      for I := 0 to strList.Count - 1 do
      begin
        strTmp := strList.Strings[I];
        if not IWSpidkBox.Checked then
        begin
          if Pos('_'+spID,strTmp) = 0 then
          begin
            strTmp := strTmp + '_'+spID;
          end;
        end;

        Result := Result + QuerySQLStr(strTmp) + ',';
      end;
      if strList.Count > 0 then
      begin
        System.Delete(Result,Length(Result),1);
      end;
    finally
      strList.Free;
    end;
  end;
begin
  iCount := 0;
  if sAccount <> '' then
  begin
    strTmp := GetGroupCONCAT(sAccount);
    strSQL := Format(sqlActivityItem,[ServerIndex,strTmp]);
    with UserSession.quActivityItem,TIWAdvWebGrid1 do
    begin
      TotalRows := iCount;
      ClearCells;
      RowCount := objINI.MaxPageCount;
      SQL.Text := strSQL;
      Open;
      while not Eof do
      begin
        TotalRows := RowCount+iCount;
        cells[1,iCount] := IntToStr(Fields[0].AsInteger);
        cells[2,iCount] := Utf8ToString(Fields[1].AsAnsiString);
        cells[3,iCount] := Utf8ToString(Fields[2].AsAnsiString);
        cells[4,iCount] := OnGetStdItemName(Fields[3].AsInteger);
        cells[5,iCount] := IntToStr(Fields[4].AsInteger);
        cells[6,iCount] := IntToStr(Fields[5].AsInteger);
        cells[7,iCount] := IntToStr(Fields[6].AsInteger);
        cells[8,iCount] := sBind[Fields[7].AsInteger];
        cells[9,iCount] := Utf8ToString(Fields[8].AsAnsiString);
        cells[10,iCount] := Langtostr(256);
        Inc(iCount);
        Next;
      end;
      TotalRows := iCount;
      Close;
    end;
    strSQL := Format(sqlActors,[strTmp]);
    with UserSession.quActivityRItem,TIWAdvWebGrid1 do
    begin
      SQL.Text := strSQL;
      Open;
      while not Eof do
      begin
        TotalRows := RowCount+iCount;
        cells[1,iCount] := IntToStr(Fields[0].AsInteger);
        cells[2,iCount] := Utf8ToString(Fields[1].AsAnsiString);
        cells[3,iCount] := Utf8ToString(Fields[2].AsAnsiString);
        cells[4,iCount] := OnGetStdItemName(Fields[3].AsInteger);
        cells[5,iCount] := IntToStr(Fields[4].AsInteger);
        cells[6,iCount] := IntToStr(Fields[5].AsInteger);
        cells[7,iCount] := IntToStr(Fields[6].AsInteger);
        cells[8,iCount] := sBind[Fields[7].AsInteger];
        cells[9,iCount] := Utf8ToString(Fields[8].AsAnsiString);
        cells[10,iCount] := Langtostr(378);
        Inc(iCount);
        Next;
      end;
      TotalRows := iCount;
      Close;
    end;
  end;
  if sRole <> '' then
  begin
    strSQL := Format(sqlActorsRole,[GetGroupCONCAT(sRole)]);
    with UserSession.quActivityRItem,TIWAdvWebGrid1 do
    begin
      SQL.Text := strSQL;
      Open;
      while not Eof do
      begin
        TotalRows := RowCount+iCount;
        cells[1,iCount] := IntToStr(Fields[0].AsInteger);
        cells[2,iCount] := Utf8ToString(Fields[1].AsAnsiString);
        cells[3,iCount] := Utf8ToString(Fields[2].AsAnsiString);
        cells[4,iCount] := OnGetStdItemName(Fields[3].AsInteger);
        cells[5,iCount] := IntToStr(Fields[4].AsInteger);
        cells[6,iCount] := IntToStr(Fields[5].AsInteger);
        cells[7,iCount] := IntToStr(Fields[6].AsInteger);
        cells[8,iCount] := sBind[Fields[7].AsInteger];
        cells[9,iCount] := Utf8ToString(Fields[8].AsAnsiString);
        cells[10,iCount] := Langtostr(378);
        Inc(iCount);
        Next;
      end;
      TotalRows := iCount;
      Close;
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmActivityItem);
end.
