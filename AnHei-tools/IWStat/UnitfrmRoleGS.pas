unit UnitfrmRoleGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompEdit, IWTMSCheckList, IWCompMemo,
  IWCompRectangle, IWTMSCtrls, IWBaseComponent, IWBaseHTMLComponent,
  IWBaseHTML40Component, IWCompButton, GSManageServer, IWTMSEdit,
  IWCompListbox, IWExchangeBar, IWCompCheckbox, IWWebGrid, IWAdvWebGrid,
  IWExtCtrls;

const
  curTitle = 113;//'角色状态管理';

type
  PTRoleData = ^TRoleData;
  TRoleData = record
    idx: Integer;
    charid: DWORD;
    account: string;
    charname: string;
    createtime: string;
    updatetime: string;
    charstate: Int64;
  end;

  TIWfrmRoleGS = class(TIWFormBasic)
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWRegion2: TIWRegion;
    IWRegion3: TIWRegion;
    IWTimerResult: TIWTimer;
    IWLabel1: TIWLabel;
    IWedtRoleName: TIWEdit;
    IWButton1: TIWButton;
    IWButton2: TIWButton;
    IWLabel2: TIWLabel;
    TIWAdvsedtShutupMinute: TTIWAdvSpinEdit;
    IWButton3: TIWButton;
    IWButton4: TIWButton;
    IWLabel3: TIWLabel;
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel4: TIWLabel;
    IWCheckBox1: TIWCheckBox;
    IWLabel5: TIWLabel;
    IWedtAccountName: TIWEdit;
    IWButton5: TIWButton;
    IWButton6: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWbtQuery: TIWButton;
    IWButton7: TIWButton;
    IWButton8: TIWButton;
    IWButton9: TIWButton;
    IWSpidkBox: TIWCheckBox;
    IWCheckBox2: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
    procedure IWButton4Click(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWButton5Click(Sender: TObject);
    procedure IWButton6Click(Sender: TObject);
    procedure IWbtQueryClick(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWButton7Click(Sender: TObject);
    procedure IWButton8Click(Sender: TObject);
    procedure IWButton9Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
  private
    spid: string;
    SuccessCount,FailCount: Integer;
    RoleDataList: TList;
    procedure ClearRoleDataList;
  public
    procedure SendGSMessage(const MessageID: Integer);
    procedure QueryRole(Account,Role: string;ServerID: Integer);
    procedure SetWebGridData;
    procedure BatchExecSQL(sqlType: Integer);
  end;

var
  IWfrmRoleGS: TIWfrmRoleGS;

implementation

uses ServerController, ConfigINI, GSProto;

{$R *.dfm}

procedure TIWfrmRoleGS.IWAppFormCreate(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  inherited;
  RoleDataList := TList.Create;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
  ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  spid :=  ServerListData^.spID;
  IWRegion6.Visible := False;
  if ServerListData.Index = 0 then
  begin
    IWRegion6.Visible := True;
    LoadGSServers(TIWclbServers,ServerListData.spID, False);
  end
  else
  begin
    TIWclbServers.Items.AddObject(Trim(UserSession.pServerName),TObject(ServerListData.Index));
    TIWclbServers.Selected[0] := True;
  end;
  SuccessCount := 0; FailCount := 0;  
  IWLabel4.Caption := Format(Langtostr(540),[TIWclbServers.Items.Count]);
  IWCheckBox1.Caption := Langtostr(547);
  IWCheckBox2.Caption := Langtostr(662);
  IWLabel5.Caption := Langtostr(558);
  IWLabel1.Caption := Langtostr(548);
  IWLabel2.Caption := Langtostr(559);
  IWLabel3.Caption := Langtostr(560);

  IWButton5.Caption := Langtostr(561);
  IWButton6.Caption := Langtostr(562);
  IWSpidkBox.Caption := Langtostr(320);
  IWButton1.Caption := Langtostr(563);
  IWButton2.Caption := Langtostr(564);
  IWButton3.Caption := Langtostr(565);
  IWButton4.Caption := Langtostr(566);
  IWbtQuery.Caption := Langtostr(14);
  IWButton7.Caption := Langtostr(567);
  IWButton8.Caption := Langtostr(568);
  IWButton9.Caption := Langtostr(569);

  TIWGradientLabel5.Text := Langtostr(550);
  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(396);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(366);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(189);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(386);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(258);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(190);
end;

procedure TIWfrmRoleGS.IWAppFormDestroy(Sender: TObject);
begin
  ClearRoleDataList;
  RoleDataList.Free;
end;

procedure TIWfrmRoleGS.BatchExecSQL(sqlType: Integer);
const
  sqlDelete = 'update actors set status=0 where actorid in (%s)';
  sqlDisabled = 'update actors set status=1 where actorid in (%s)';
  sqlRecover = 'update actors set status=2 where actorid in (%s)';
var
  I,iCount: Integer;
  strSQL: string;
  function ExecSQL(sSQL: string): Integer;
  begin
    with UserSession.quRole do
    begin
      SQL.Text := sSQL;
      Result := UserSession.quRole.ExecSQL;
      Close;
    end;
  end;
begin
  strSQL := '';
  try
    for I := 0 to TIWAdvWebGrid1.RowCount - 1 do
    begin
      if (TIWAdvWebGrid1.RowSelect[I]) then
      begin
        if Trim(TIWAdvWebGrid1.Cells[1,I]) <> '' then
        begin
          strSQL := strSQL + GetCellName(TIWAdvWebGrid1.Cells[1,I]) + ',';
        end;
      end;
    end;
    iCount := 0;
    if Length(strSQL) > 0 then
    begin
      Delete(strSQL,Length(strSQL),1);
      case sqlType of
        1:iCount := ExecSQL(Format(sqlDelete,[strSQL]));
        2:iCount := ExecSQL(Format(sqlDisabled,[strSQL]));
        3:iCount := ExecSQL(Format(sqlRecover,[strSQL]));
      end;
      WebApplication.ShowMessage(Format(Langtostr(551),[iCount]));
      if iCount > 0 then
      begin
        IWbtQuery.OnClick(self);
      end;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmRoleGS.ClearRoleDataList;
var
  I: Integer;
begin
  for I := 0 to RoleDataList.Count - 1 do
  begin
    System.Dispose(PTRoleData(RoleDataList[I]));
  end;
  RoleDataList.Clear;
end;

procedure TIWfrmRoleGS.IWbtQueryClick(Sender: TObject);
var
  psld: PTServerListData;
  I,Idx: Integer;
begin
  if (Trim(IWedtAccountName.Text)='') and (Trim(IWedtRoleName.Text)='') then
  begin
    WebApplication.ShowMessage(Langtostr(552));
    Exit;
  end;
  try
    ClearRoleDataList; //在查询前 清除已有的列表信息防止错误发生
    for I := 0 to TIWclbServers.Items.Count - 1 do
    begin
      if TIWclbServers.Selected[I] then
      begin
        Idx := Integer(TIWclbServers.Items.Objects[I]);
        if Idx > 0 then
        begin
          psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(TIWclbServers.Items[i]))]);
          UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
          if IWedtAccountName.Text <> '' then
          begin
             if not IWSpidkBox.Checked then
             begin
                if Pos(psld.spID,IWedtAccountName.Text) = 0 then
                IWedtAccountName.Text := IWedtAccountName.Text+'_'+psld.spID;
             end;
          end;
          try
            QueryRole( IWedtAccountName.Text, IWedtRoleName.Text, psld.ServerID);
          finally
            UserSession.SQLConnectionRole.Close;
          end;
        end;
      end;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmRoleGS.IWButton1Click(Sender: TObject);
begin
  SendGSMessage(MSS_KICKPLAY);
end;

procedure TIWfrmRoleGS.IWButton2Click(Sender: TObject);
begin
  SendGSMessage(MSS_QUERYPLAYONLINE);
end;

procedure TIWfrmRoleGS.IWButton3Click(Sender: TObject);
begin
  SendGSMessage(MSS_SHUTUP);
end;

procedure TIWfrmRoleGS.IWButton4Click(Sender: TObject);
begin
  SendGSMessage(MSS_RELEASESHUTUP);
end;

procedure TIWfrmRoleGS.IWButton5Click(Sender: TObject);
begin
  SendGSMessage(MSS_KICKUSER);
end;

procedure TIWfrmRoleGS.IWButton6Click(Sender: TObject);
begin
  SendGSMessage(MSS_QUERYUSERONLINE);
end;

procedure TIWfrmRoleGS.IWButton7Click(Sender: TObject);
begin
  inherited;
  BatchExecSQL(1);
end;

procedure TIWfrmRoleGS.IWButton8Click(Sender: TObject);
begin
  inherited;
  BatchExecSQL(2);
end;

procedure TIWfrmRoleGS.IWButton9Click(Sender: TObject);
begin
  inherited;
  BatchExecSQL(3);
end;

procedure TIWfrmRoleGS.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmRoleGS.IWTimerResultTimer(Sender: TObject);
var
  StrResult: string;
  procedure AddLog(str: string);
  begin
    if str[1] = '0' then
    begin
      IWMemoSuccessLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),Copy(str,2,Length(str)-1)]));
      Inc(SuccessCount);
    end
    else begin
      IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),Copy(str,2,Length(str)-1)]));
      Inc(FailCount);
    end;
  end;
begin
  inherited;
  StrResult := GSResultStr(WebApplication.AppID, spid);
  if StrResult <> '' then
  begin
    AddLog(StrResult);
    while StrResult <> '' do
    begin
      StrResult := GSResultStr(WebApplication.AppID, spid);
      if StrResult <> '' then AddLog(StrResult);
    end;
  end
  else
  begin
    if (SuccessCount > 1) or (FailCount > 1) then
    begin
      IWMemoSuccessLog.Lines.Add(Format(Langtostr(541),[DateTimeToStr(Now),SuccessCount,FailCount]));
    end;
    SuccessCount := 0; FailCount := 0;
    IWTimerResult.Enabled := False;
  end;
end;

procedure TIWfrmRoleGS.SendGSMessage(const MessageID: Integer);
var
  I,Idx,SID,iCount: Integer;
  m_Server: TGSConnection;
begin
  case MessageID of
    MSS_KICKUSER,MSS_QUERYUSERONLINE:
    begin
      if (IWedtAccountName.Text = '') then
      begin
        WebApplication.ShowMessage(Langtostr(553));
        Exit;
      end;
      if not IWSpidkBox.Checked then
      begin
        if Pos(spID,IWedtAccountName.Text) = 0 then
        begin
          IWedtAccountName.Text := IWedtAccountName.Text + '_' + spID;
        end;
      end;
    end;
    MSS_KICKPLAY,MSS_QUERYPLAYONLINE,MSS_RELEASESHUTUP:
    begin
      if (IWedtRoleName.Text = '') then
      begin
        WebApplication.ShowMessage(Langtostr(542));
        Exit;
      end;
    end;
    MSS_SHUTUP:
    begin
      if (IWedtRoleName.Text = '') then
      begin
        WebApplication.ShowMessage(Langtostr(542));
        Exit;
      end;
      if TIWAdvsedtShutupMinute.Value = 0 then
      begin
        WebApplication.ShowMessage(Langtostr(554));
        Exit;
      end;
    end;
  end;
  iCount := 0;
  try
    for I := 0 to TIWclbServers.Items.Count - 1 do
    begin
      if TIWclbServers.Selected[I] then
      begin
        Idx := Integer(TIWclbServers.Items.Objects[I]);
        if Idx > 0 then
        begin
          m_Server := FGSMServer.GetServerByIndex(spid,Idx);
          if m_Server <> nil then
          begin
            SID := SessionIDList.IndexOf(WebApplication.AppID);
            if SID <> -1 then
            begin
              case MessageID of
                MSS_KICKUSER:
                begin
                  m_Server.SendKickUser(SID,IWedtAccountName.Text);
                end;
                MSS_QUERYUSERONLINE:
                begin
                  m_Server.SendQueryUserOnline(SID,IWedtAccountName.Text);
                end;
                MSS_KICKPLAY:
                begin
                  m_Server.SendKickPlayer(SID,IWedtRoleName.Text);
                end;
                MSS_QUERYPLAYONLINE:
                begin
                  m_Server.SendQueryPlayerOnline(SID,IWedtRoleName.Text);
                end;
                MSS_SHUTUP:
                begin
                  m_Server.SendShutup(SID,TIWAdvsedtShutupMinute.Value,IWedtRoleName.Text);
                end;
                MSS_RELEASESHUTUP:
                begin
                  m_Server.SendReleaseShutup(SID,IWedtRoleName.Text);
                end;
              end;
              IWTimerResult.Enabled := False;
              IWTimerResult.Enabled := True;
            end;
          end
          else begin
            Inc(iCount);
            IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),Langtostr(543)+TIWclbServers.Items.Strings[I]+Langtostr(544)]));
          end;
        end;
      end;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
  if iCount > 1 then
  begin
    IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),Langtostr(545)+IntToStr(iCount)+Langtostr(546)]));
  end;
end;

procedure TIWfrmRoleGS.QueryRole(Account, Role: string; ServerID: Integer);
const
  sqlRoleQuery = 'select serverindex,actorid,accountname,actorname,updatetime,createtime,status from actors where';
  sqlAccount = ' accountname=%s and ';
  sqlRole = ' actorname=%s and ';
  sqlRoleEx = ' actorname %s and ';
var
  sSQL: string;
  RoleData: PTRoleData;
begin
  sSQL := sqlRoleQuery;
  if Account <> '' then sSQL := sSQL + Format(sqlAccount,[QuerySQLStr(Account)]);
  if Role <> '' then
  begin
   if IWCheckBox2.Checked then
      sSQL := sSQL + Format(sqlRoleEx,['like '+QuerySQLStrEx('%'+Role+'%')])
   else
      sSQL := sSQL + Format(sqlRole,[QuerySQLStr(Role)]);
  end;

  Delete(sSQL,Length(sSQL)-4,5);
  with UserSession.quRole do
  begin
    SQL.Text := sSQL;
    Open;
    try
      while not Eof do
      begin
        New(RoleData);
        RoleData.charid := FieldByName('actorid').AsLargeInt;
        RoleData.account := Utf8ToString(FieldByName('accountname').AsAnsiString);
        RoleData.charname := Utf8ToString(FieldByName('actorname').AsAnsiString);
        RoleData.idx := FieldByName('serverindex').AsInteger;
        RoleData.createtime := FieldByName('createtime').AsString;
        RoleData.updatetime := FieldByName('updatetime').AsString;
        RoleData.charstate := FieldByName('status').AsInteger;
        RoleDataList.Add(RoleData);
        Next;
      end;
    finally
      Close;
    end;
  end;
  SetWebGridData;
  TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(453),[RoleDataList.Count]);
end;

procedure TIWfrmRoleGS.SetWebGridData;
var
  I: Integer;
  sState,sFontColor: string;
  RoleData: PTRoleData;
  function GetRoleState(iState: Integer): string;
  begin
    Result := '';
    case iState of
      0:
      begin
        Result := Langtostr(555);
      end;
      1:
      begin
        Result := Langtostr(556);
      end;
      6:
      begin
        Result := Langtostr(557);
      end;
    end;
  end;
begin
  TIWAdvWebGrid1.ClearRowSelect;
  TIWAdvWebGrid1.ClearCells;
  TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;
  if TIWAdvWebGrid1.TotalRows < objINI.MaxPageCount then
  begin
    TIWAdvWebGrid1.RowCount := RoleDataList.Count;
  end;
  TIWAdvWebGrid1.TotalRows := RoleDataList.Count;
  for I := 0 to RoleDataList.Count - 1 do
  begin
    RoleData := PTRoleData(RoleDataList[I]);
    sState := GetRoleState(RoleData.charstate);
    sFontColor := '%s';
    if (sState = Langtostr(555)) or (sState = Langtostr(556)) then sFontColor := '<FONT color=red>%s</FONT>';
    TIWAdvWebGrid1.Cells[1,I] := Format(sFontColor,[UIntToStr(RoleData.charid)]);
    TIWAdvWebGrid1.Cells[2,I] := Format(sFontColor,[RoleData.charname]);
    TIWAdvWebGrid1.Cells[3,I] := Format(sFontColor,[RoleData.account]);
    TIWAdvWebGrid1.Cells[4,I] := Format(sFontColor,[IntToStr(RoleData.idx)]);
    TIWAdvWebGrid1.Cells[5,I] := Format(sFontColor,[RoleData.updatetime]);
    TIWAdvWebGrid1.Cells[6,I] := Format(sFontColor,[RoleData.createtime]);
    TIWAdvWebGrid1.Cells[7,I] := Format(sFontColor,[sState]);
  end;
end;

initialization
  RegisterClass(TIWfrmRoleGS);

end.
