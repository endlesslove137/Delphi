unit UnitfrmFunctionGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWCompMemo, IWCompRectangle,
  IWTMSCtrls, IWCompEdit, IWTMSCheckList, GSManageServer, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, IWCompListbox,
  IWExchangeBar, IWCompCheckbox, IWTMSEdit, IWExtCtrls;

const
  curTitle = '脚本管理';
    
type
  TIWfrmFunctionGS = class(TIWFormBasic)
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel2: TIWLabel;
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWRegion3: TIWRegion;
    IWbtnReloadFunction: TIWButton;
    IWTimerResult: TIWTimer;
    IWbtnReloadLoginScript: TIWButton;
    IWbtnReloadRobotnpc: TIWButton;
    IWButton1: TIWButton;
    IWButton2: TIWButton;
    IWMemoMonName: TIWMemo;
    IWCheckBox1: TIWCheckBox;
    IWLabel8: TIWLabel;
    IWButton5: TIWButton;
    IWReLoadConfig: TIWEdit;
    IWcBoxCommand: TIWComboBox;
    IWLabel9: TIWLabel;
    IWButton6: TIWButton;
    IWReFreshcorss: TIWButton;
    IWSetCommonSrvid: TIWButton;
    IWLabel1: TIWLabel;
    IWGetCommonSrvid: TIWButton;
    TIWCommonSrvid: TTIWAdvSpinEdit;
    IWButton3: TIWButton;
    IWButton4: TIWButton;
    IWButton7: TIWButton;
    IWLabel3: TIWLabel;
    TIWAdvSpinEdit1: TTIWAdvSpinEdit;
    IWButton8: TIWButton;
    TIWGradientLabel1: TTIWGradientLabel;
    IWButton9: TIWButton;
    procedure IWbtnReloadFunctionClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWbtnReloadLoginScriptClick(Sender: TObject);
    procedure IWbtnReloadRobotnpcClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
    procedure IWButton5Click(Sender: TObject);
    procedure IWButton6Click(Sender: TObject);
    procedure IWReFreshcorssClick(Sender: TObject);
    procedure IWSetCommonSrvidClick(Sender: TObject);
    procedure IWGetCommonSrvidClick(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
    procedure IWButton4Click(Sender: TObject);
    procedure IWButton7Click(Sender: TObject);
    procedure IWButton8Click(Sender: TObject);
    procedure IWButton9Click(Sender: TObject);
  private
    spid: string;
    SuccessCount,FailCount: Integer;
    ComType: Boolean;
    bTpye : Byte;
  public
    procedure SendGSMessage(const MessageID: Integer);
  end;

var
  IWfrmFunctionGS: TIWfrmFunctionGS;

implementation

uses ConfigINI, ServerController, GSProto;

{$R *.dfm}

{ TIWfrmFunctionGS }

procedure TIWfrmFunctionGS.IWAppFormCreate(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  inherited;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
  ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  spid := ServerListData^.spID;
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

  IWcBoxCommand.Items.AddStrings(CommonList);
  IWcBoxCommand.Items.Insert(0,'未选择');
  IWcBoxCommand.ItemIndex := 0;

  SuccessCount := 0; FailCount := 0; ComType:= False; bTpye := 0;
  IWLabel2.Caption := Format('共有服务器(%d)',[TIWclbServers.Items.Count]);
end;

procedure TIWfrmFunctionGS.IWbtnReloadFunctionClick(Sender: TObject);
begin
  SendGSMessage(MSS_RELOAD_FUNCTION);
end;

procedure TIWfrmFunctionGS.IWbtnReloadLoginScriptClick(Sender: TObject);
begin
  SendGSMessage(MSS_RELOAD_LOGIN_SCRIPT);
end;

procedure TIWfrmFunctionGS.IWbtnReloadRobotnpcClick(Sender: TObject);
begin
  SendGSMessage(MSS_RELOAD_ROBOTNPC);
end;

procedure TIWfrmFunctionGS.IWButton1Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_RELOAD_ABUSEINFORMATION);
end;

procedure TIWfrmFunctionGS.IWButton2Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_RELOAD_MONSTER_SCRIPT);
end;

procedure TIWfrmFunctionGS.IWButton3Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_SET_RELOADLANG);
end;

procedure TIWfrmFunctionGS.IWButton4Click(Sender: TObject);
begin
  inherited;
  bTpye := 1;
  SendGSMessage(MSS_SET_CROSSBATTLE);
end;

procedure TIWfrmFunctionGS.IWReFreshcorssClick(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_SET_REFRESHCORSS);
end;

procedure TIWfrmFunctionGS.IWSetCommonSrvidClick(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_SET_COMMON_SRVID);
end;

procedure TIWfrmFunctionGS.IWButton5Click(Sender: TObject);
begin
  if IWReLoadConfig.Text = '' then
  begin
    WebApplication.ShowMessage('命令格式不允许为空，请输入..');
    Exit;
  end;
  ComType:= False;
  SendGSMessage(MSS_SET_RELOADCONFIG);
end;

procedure TIWfrmFunctionGS.IWButton6Click(Sender: TObject);
begin
  if IWcBoxCommand.ItemIndex = 0 then
  begin
    WebApplication.ShowMessage('选择需要执行的命令，请选择');
    Exit;
  end;
  ComType:= True;
  SendGSMessage(MSS_SET_RELOADCONFIG);
end;

procedure TIWfrmFunctionGS.IWButton7Click(Sender: TObject);
begin
  inherited;
  bTpye := 0;
  SendGSMessage(MSS_SET_CROSSBATTLE);
end;

procedure TIWfrmFunctionGS.IWButton8Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_SET_CROSSBATTLENUM);
end;

procedure TIWfrmFunctionGS.IWButton9Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_RELOAD_ITMEFUNCTION);
end;

procedure TIWfrmFunctionGS.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmFunctionGS.IWGetCommonSrvidClick(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_GET_COMMON_SRVID);
end;

procedure TIWfrmFunctionGS.IWTimerResultTimer(Sender: TObject);
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
      IWMemoSuccessLog.Lines.Add(Format('[%s] 操作完成成功(%d)失败(%d)',[DateTimeToStr(Now),SuccessCount,FailCount]));
    end;
    SuccessCount := 0; FailCount := 0;
    IWTimerResult.Enabled := False;
  end;
end;

procedure TIWfrmFunctionGS.SendGSMessage(const MessageID: Integer);
var
  I,J,Idx,SID,iCount: Integer;
  m_Server: TGSConnection;
begin
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
                MSS_RELOAD_FUNCTION:
                begin
                  m_Server.SendReloadFunction(SID);
                end;
                MSS_RELOAD_LOGIN_SCRIPT:
                begin
                  m_Server.SendReloadLoginScript(SID);
                end;
                MSS_RELOAD_ROBOTNPC:
                begin
                  m_Server.SendReloadRobotnpc(SID);
                end;
                MSS_RELOAD_ABUSEINFORMATION:
                begin
                  m_Server.SendAbuseInfoRmation(SID);
                end;
                MSS_RELOAD_MONSTER_SCRIPT:
                begin
                  for J := 0 to IWMemoMonName.Lines.Count - 1 do
                  begin
                    m_Server.SendMonsterScript(SID,IWMemoMonName.Lines.Strings[J]);
                  end;
                end;
                MSS_SET_RELOADCONFIG:
                begin
                  if not ComType then
                    m_Server.SendSetReLoadConfig(SID, IWReLoadConfig.Text)
                  else
                    m_Server.SendSetReLoadConfig(SID, IWcBoxCommand.Text)
                end;
                MSS_SET_REFRESHCORSS:
                begin
                   m_Server.SendSetReFreshcorss(SID);
                end;
                MSS_SET_COMMON_SRVID:
                begin
                  m_Server.SendSetCommonSrvid(SID, TIWCommonSrvid.Value);
                end;
                MSS_GET_COMMON_SRVID:
                begin
                  m_Server.SendGetCommonSrvid(SID);
                end;
                MSS_SET_RELOADLANG:
                begin
                  m_Server.SendSetReLoadLang(SID);
                end;
                MSS_SET_CROSSBATTLE:
                begin
                  m_Server.SendSetCrossBattle(SID, bTpye);
                end;
                MSS_SET_CROSSBATTLENUM:
                begin
                  m_Server.SendSetCrossBattleNum(SID, TIWAdvSpinEdit1.Value);
                end;
                MSS_RELOAD_ITMEFUNCTION:
                begin
                  m_Server.SendReLoadItmeFunction(SID);
                end;
              end;
              IWTimerResult.Enabled := False;
              IWTimerResult.Enabled := True;
            end;
          end
          else begin
            Inc(iCount);
            IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),'获取<'+TIWclbServers.Items.Strings[I]+'>失败']));
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
    IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),'共有'+IntToStr(iCount)+'个服务器获取失败']));
  end;    
end;

initialization
  RegisterClass(TIWfrmFunctionGS);
end.
