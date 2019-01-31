unit UnitfrmS1Engine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompMemo, IWCompRectangle, IWTMSCtrls,
  IWCompEdit, IWTMSCheckList, IWBaseComponent, IWBaseHTMLComponent,
  IWBaseHTML40Component, GSManageServer, IWTMSEdit, IWCompButton,
  IWCompListbox, IWExchangeBar, IWCompCheckbox, IWExtCtrls;

const
  curTitle =132;//'引擎设置A';

type
  TIWfrmS1Engine = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWRegion3: TIWRegion;
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWTimerResult: TIWTimer;
    IWButton1: TIWButton;
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel2: TIWLabel;
    IWCheckBox1: TIWCheckBox;
    IWButton2: TIWButton;
    IWLabel5: TIWLabel;
    TIWChatLevel: TTIWAdvSpinEdit;
    IWLabel1: TIWLabel;
    IWComboBox2: TIWComboBox;
    IWLabel3: TIWLabel;
    TIWQuicksoft: TTIWAdvSpinEdit;
    IWLabel4: TIWLabel;
    IWComboBox1: TIWComboBox;
    IWLabel6: TIWLabel;
    IWedtGuildName: TIWEdit;
    IWLabel7: TIWLabel;
    IWButton3: TIWButton;
    IWButton4: TIWButton;
    IWComboBox3: TIWComboBox;
    IWLabel9: TIWLabel;
    TIWAdvSpinEdit1: TTIWAdvSpinEdit;
    IWLabel10: TIWLabel;
    IWButton5: TIWButton;
    IWedtUserName: TIWEdit;
    IWComboBox4: TIWComboBox;
    IWLabel11: TIWLabel;
    IWLabel12: TIWLabel;
    IWButton6: TIWButton;
    IWLabel13: TIWLabel;
    IWItemGuid: TIWEdit;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
    procedure IWButton4Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
    procedure IWButton6Click(Sender: TObject);
    procedure IWButton5Click(Sender: TObject);
  private
    spid: string;
    SuccessCount,FailCount: Integer;
    procedure LoadQuicType;
    procedure LoadChatType;
    procedure LoadGoldType;
    procedure LoadItmeType;
  public
    procedure SendGSMessage(const MessageID: Integer);
  end;

var
  IWfrmS1Engine: TIWfrmS1Engine;

const
  QuicTypeStr : array[0..5] of Integer = (337, 611, 612, 613, 524, 614);
  ChatTypeStr : array[0..8] of Integer = (337, 615, 616, 617, 618, 619, 620, 621, 622);
  GoldTypeStr : array[0..3] of Integer = (337, 339, 340, 341);
  ItmeTypeStr : array[0..7] of Integer = (337, 623, 624, 625, 626, 627, 493, 628);

implementation

uses ConfigINI, ServerController, GSProto, EDcode;

{$R *.dfm}

procedure TIWfrmS1Engine.IWAppFormCreate(Sender: TObject);
var
  psld: PTServerListData;
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  spid := psld^.spID;
  IWRegion6.Visible := False;
  if psld.Index = 0 then
  begin
    IWRegion6.Visible := True;
    LoadGSServers(TIWclbServers,psld.spID, False);
  end
  else
  begin
    TIWclbServers.Items.AddObject(Trim(UserSession.pServerName),TObject(psld.Index));
    TIWclbServers.Selected[0] := True;
  end;

  LoadQuicType;
  LoadChatType;
  LoadGoldType;
  LoadItmeType;
  TIWGradientLabel5.Text := Langtostr(550);
  IWCheckBox1.Caption := Langtostr(547);

  IWLabel4.Caption := Langtostr(645);
  IWLabel3.Caption := Langtostr(646);
  IWLabel1.Caption := Langtostr(647);
  IWLabel5.Caption := Langtostr(648);
  IWLabel6.Caption := Langtostr(663);

  IWLabel7.Caption := Langtostr(649);
  IWLabel13.Caption := Langtostr(650);
  IWLabel11.Caption := Langtostr(651);
  IWLabel12.Caption := Langtostr(652);
  IWLabel9.Caption := Langtostr(334);
  IWLabel10.Caption := Langtostr(653);

  IWButton2.Caption := Langtostr(654);
  IWButton4.Caption := Langtostr(655);
  IWButton1.Caption := Langtostr(636);
  IWButton3.Caption := Langtostr(656);
  IWButton6.Caption := Langtostr(657);
  IWButton5.Caption := Langtostr(658);

  SuccessCount := 0; FailCount := 0;
  IWLabel2.Caption := Format(Langtostr(540),[TIWclbServers.Items.Count]);
end;

procedure TIWfrmS1Engine.LoadQuicType;
var
  I: Integer;
begin
  IWComboBox1.Items.Clear;
  for I := Low(QuicTypeStr) to High(QuicTypeStr) do
  begin
    IWComboBox1.Items.Add(Langtostr(QuicTypeStr[I]));
  end;
  IWComboBox1.ItemIndex := 0;
end;

procedure TIWfrmS1Engine.LoadChatType;
var
  I: Integer;
begin
  IWComboBox2.Items.Clear;
  for I := Low(ChatTypeStr) to High(ChatTypeStr) do
  begin
    IWComboBox2.Items.Add(Langtostr(ChatTypeStr[I]));
  end;
  IWComboBox2.ItemIndex := 0;
end;

procedure TIWfrmS1Engine.LoadGoldType;
var
  I: Integer;
begin
  IWComboBox3.Items.Clear;
  for I := Low(ItmeTypeStr) to High(ItmeTypeStr) do
  begin
    IWComboBox3.Items.Add(Langtostr(ItmeTypeStr[I]));
  end;
  IWComboBox3.ItemIndex := 0;
end;

procedure TIWfrmS1Engine.LoadItmeType;
var
  I: Integer;
begin
  IWComboBox4.Items.Clear;
  for I := Low(GoldTypeStr) to High(GoldTypeStr) do
  begin
    IWComboBox4.Items.Add(Langtostr(GoldTypeStr[I]));
  end;
  IWComboBox4.ItemIndex := 0;
end;

procedure TIWfrmS1Engine.IWButton1Click(Sender: TObject);
begin
  if IWComboBox2.ItemIndex <= 0 then
  begin
    WebApplication.ShowMessage(Langtostr(629));
    Exit;
  end;
  SendGSMessage(MSS_SET_CHATLEVEL);
end;

procedure TIWfrmS1Engine.IWButton2Click(Sender: TObject);
begin
  if IWComboBox1.ItemIndex <= 0 then
  begin
    WebApplication.ShowMessage(Langtostr(630));
    Exit;
  end;
  SendGSMessage(MSS_SET_QUICKSOFT);
end;

procedure TIWfrmS1Engine.IWButton3Click(Sender: TObject);
begin
  if IWedtGuildName.Text = '' then
  begin
    WebApplication.ShowMessage(Langtostr(631));
    Exit;
  end;
  SendGSMessage(MSS_SET_DELGUILD);
end;

procedure TIWfrmS1Engine.IWButton4Click(Sender: TObject);
begin
  ShowIllegalInfo(Date + StrToTime('00:00:00'), Date + StrToTime('23:59:59'));
end;

procedure TIWfrmS1Engine.IWButton5Click(Sender: TObject);
begin
  if IWedtUserName.Text = '' then
  begin
    WebApplication.ShowMessage(Langtostr(632));
    Exit;
  end;
  if IWComboBox4.ItemIndex <= 0 then
  begin
    WebApplication.ShowMessage(Langtostr(630));
    Exit;
  end;
  if TIWAdvSpinEdit1.Value <= 0 then
  begin
    WebApplication.ShowMessage(Langtostr(633));
    Exit;
  end;
  SendGSMessage(MSS_SET_REMOVEMONEY);
end;

procedure TIWfrmS1Engine.IWButton6Click(Sender: TObject);
begin
  if IWedtUserName.Text = '' then
  begin
    WebApplication.ShowMessage(Langtostr(632));
    Exit;
  end;
  if IWComboBox3.ItemIndex <= 0 then
  begin
    WebApplication.ShowMessage(Langtostr(630));
    Exit;
  end;
  if IWItemGuid.Text = '' then
  begin
    WebApplication.ShowMessage(Langtostr(634));
    Exit;
  end;
  SendGSMessage(MSS_SET_REMOVEITEM);
end;

procedure TIWfrmS1Engine.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmS1Engine.IWTimerResultTimer(Sender: TObject);
const
  SuccessStr: array [0 .. 1] of Integer = (572, 573);
  ResultStr = '%d<%s> %s';
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
  function GetGSMessage(AppID: string): string;
  var
    Idx, IsSuccess,iServerIndex: Integer;
    ServerName: string;
    pDefMsg: PTDefaultMessage;
  begin
    Result := '';
    EnterCriticalSection(FPrintMsgLock);
    try
      IsSuccess := 1;
      Idx := GetSessionDMessage(AppID);
      if Idx <> -1 then
      begin
        pDefMsg := PTDefaultMessage(GSMsgList.Objects[Idx]);
       // iServerIndex := StrToInt(GSMsgList.Strings[Idx]);
        iServerIndex := StrToInt(Copy(GSMsgList.Strings[Idx],1,Pos('|',GSMsgList.Strings[Idx])-1));
        ServerName := GetServerListNameEx(iServerIndex);
        if pDefMsg <> nil then
        begin
          if pDefMsg^.Tag > 1 then pDefMsg^.Tag := 1;
          case pDefMsg^.Ident of
             //返回外挂的设置  (tag为0表示成功，1表示设置失败)
             MCS_RETURN_QUICKSOFT_RET:
             begin
               if pDefMsg^.Tag = 0 then IsSuccess := 0;
               Result := Format(ResultStr,[IsSuccess,ServerName,Langtostr(635) + Langtostr(SuccessStr[pDefMsg^.Tag])]);
             end;
             //设置聊天等级 (tag为0表示成功，1表示设置失败)
             MCS_RETURN_CHATLEVEL_RET:
             begin
               if pDefMsg^.Tag = 0 then IsSuccess := 0;
               Result := Format(ResultStr,[IsSuccess,ServerName,Langtostr(636)+ Langtostr(SuccessStr[pDefMsg^.Tag])]);
             end;
             //返回后台删除行会 (tag为0表示成功，1表示设置失败)
             MCS_RETURN_DELGUILD_RET:
             begin
               if pDefMsg^.Tag = 0 then IsSuccess := 0;
               Result := Format(ResultStr,[IsSuccess,ServerName,Langtostr(637) + Langtostr(SuccessStr[pDefMsg^.Tag])]);
             end;
             //返回删除玩家物品结果 (tag为0表示成功，1表示设置失败)
             MCS_RETURN_REMOVEITEM:
             begin
               if pDefMsg^.Tag = 0 then IsSuccess := 0;
               Result := Format(ResultStr,[IsSuccess,ServerName,Langtostr(638) + Langtostr(SuccessStr[pDefMsg^.Tag])]);
             end;
             //返回删除玩家金钱结果 (tag为0表示成功，1表示设置失败)
             MCS_RETURN_REMOVEMONEY:
             begin
               if pDefMsg^.Tag = 0 then IsSuccess := 0;
               Result := Format(ResultStr,[IsSuccess,ServerName,Langtostr(639) + Langtostr(SuccessStr[pDefMsg^.Tag])]);
             end;
          end;
          if Idx < GSMsgList.Count then
          begin
            System.Dispose(pDefMsg);
            GSMsgList.Delete(Idx);
          end;
        end;
      end;
    finally
      LeaveCriticalSection(FPrintMsgLock);
    end;
  end;
begin
  inherited;
  StrResult := GetGSMessage(WebApplication.AppID);
  if StrResult <> '' then
  begin
    AddLog(StrResult);
    while StrResult <> '' do
    begin
      StrResult := GetGSMessage(WebApplication.AppID);
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

procedure TIWfrmS1Engine.SendGSMessage(const MessageID: Integer);
var
  I,Idx,SID,iCount, ctype: Integer;
  m_Server: TGSConnection;
begin
  case MessageID of
    MSS_SET_QUICKSOFT:
    begin
      if IWComboBox1.ItemIndex in [1..3] then
      begin
        if TIWQuicksoft.Value <= 0 then
        begin
          WebApplication.ShowMessage(Langtostr(640));
          Exit;
        end;
      end;

      if IWComboBox1.ItemIndex = 1 then
      begin
        if TIWQuicksoft.Value > 50 then
        begin
          WebApplication.ShowMessage(Langtostr(641));
          Exit;
        end;
      end;
      if IWComboBox1.ItemIndex = 3 then
      begin
        if TIWQuicksoft.Value > 100 then
        begin
          WebApplication.ShowMessage(Langtostr(642));
          Exit;
        end;
      end;
      if IWComboBox1.ItemIndex = 5 then
      begin
        if TIWQuicksoft.Value > 1 then
        begin
          WebApplication.ShowMessage(Langtostr(643));
          Exit;
        end;
      end;
    end;
    MSS_SET_CHATLEVEL:
    begin
      if TIWChatLevel.Value <= 0 then
      begin
        WebApplication.ShowMessage(Langtostr(644));
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
                MSS_SET_QUICKSOFT:
                begin
                  m_Server.SendSetQuicksoft(SID,IWComboBox1.ItemIndex, TIWQuicksoft.Value);
                  UserSession.AddHTOperateLog(4{设置加速外挂},'参数值：'+IntToStr(TIWQuicksoft.Value),'服务器ID: '+ inttostr(Idx) +' 控制类型：'+ Langtostr(QuicTypeStr[IWComboBox1.ItemIndex]),'引擎设置A');
                end;
                MSS_SET_CHATLEVEL:
                begin
                  case IWComboBox2.ItemIndex of
                      6: ctype := 6;
                      7: ctype := 10;
                      8: ctype := 100;
                  else
                     ctype := IWComboBox2.ItemIndex - 1;
                  end;

                  m_Server.SendChatLevel(SID, ctype, TIWChatLevel.Value);
                  UserSession.AddHTOperateLog(5{设置聊天等级},'最小等级：'+IntToStr(TIWChatLevel.Value),'服务器ID: '+ inttostr(Idx) +' 频道类型：'+ Langtostr(ChatTypeStr[IWComboBox2.ItemIndex]),'引擎设置A');
                end;
                MSS_SET_DELGUILD:
                begin
                   m_Server.SendSetDelGuild(SID, IWedtGuildName.Text);
                   UserSession.AddHTOperateLog(6{删除行会},'','行会名称：'+ IWedtGuildName.Text,'引擎设置A');
                end;
                MSS_SET_REMOVEITEM:
                begin
                   m_Server.SendSetReMoveItem(SID, IWComboBox3.ItemIndex, IWedtUserName.Text, IWItemGuid.Text);
                   UserSession.AddHTOperateLog(7{删除装备},IWedtUserName.Text, '服务器ID: '+ inttostr(Idx) + ' 装备位置：'+ Langtostr(ItmeTypeStr[IWComboBox3.ItemIndex]) + 'Guid：'+ IWItemGuid.Text,'引擎设置A');
                end;
                MSS_SET_REMOVEMONEY:
                begin
                   m_Server.SendSetReMoveMoney(SID, IWComboBox4.ItemIndex, IWedtUserName.Text, IntToStr(TIWAdvSpinEdit1.Value));
                  UserSession.AddHTOperateLog(8{删除货币},IWedtUserName.Text, '服务器ID: '+ inttostr(Idx) + ' 货币类型：'+ Langtostr(GoldTypeStr[IWComboBox4.ItemIndex]) + '数量：'+ IntToStr(TIWAdvSpinEdit1.Value),'引擎设置A');
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

initialization
  RegisterClass(TIWfrmS1Engine);

end.
