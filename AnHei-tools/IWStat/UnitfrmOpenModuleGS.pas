unit UnitfrmOpenModuleGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWTMSCheckList,
  IWBaseComponent, IWBaseHTMLComponent, IWBaseHTML40Component,
  IWCompMemo, IWCompCheckbox, IWExtCtrls;

type
  TIWfrmOpenModuleGS = class(TIWFormBasic)
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWTimerResult: TIWTimer;
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel2: TIWLabel;
    IWCheckBox1: TIWCheckBox;
    IWRegion2: TIWRegion;
    IWbtnOpenGamble: TIWButton;
    IWbtnCloseGamble: TIWButton;
    IWButton1: TIWButton;
    IWButton2: TIWButton;
    IWButton3: TIWButton;
    IWButton4: TIWButton;
    IWButton5: TIWButton;
    IWButton6: TIWButton;
    IWButton7: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWbtnCloseGambleClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
    procedure IWbtnOpenGambleClick(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
    procedure IWButton4Click(Sender: TObject);
    procedure IWButton5Click(Sender: TObject);
    procedure IWButton6Click(Sender: TObject);
    procedure IWButton7Click(Sender: TObject);
  private
    spid: string;
    SuccessCount,FailCount: Integer;
    SetNameTpye, SetUserback : Byte;
  public
    procedure SendGSMessage(const MessageID: Integer);
  end;

var
  IWfrmOpenModuleGS: TIWfrmOpenModuleGS;

implementation

uses GSManageServer, ServerController, GSProto, ConfigINI;

{$R *.dfm}

procedure TIWfrmOpenModuleGS.IWAppFormCreate(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  inherited;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbOpenModuleGS]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbOpenModuleGS]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbOpenModuleGS])]);
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
  SuccessCount := 0; FailCount := 0;  SetNameTpye:= 0;  SetUserback := 0;
  IWLabel2.Caption := Format('共有服务器(%d)',[TIWclbServers.Items.Count]);
end;

procedure TIWfrmOpenModuleGS.IWbtnCloseGambleClick(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_CLOSE_GAMBLE);
end;

procedure TIWfrmOpenModuleGS.IWbtnOpenGambleClick(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_OPEN_GAMBLE);
end;

procedure TIWfrmOpenModuleGS.IWButton1Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_OPEN_COMMONSERVER);
end;

procedure TIWfrmOpenModuleGS.IWButton2Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_CLOSE_COMMONSERVER);
end;

procedure TIWfrmOpenModuleGS.IWButton3Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_RESET_GAMBLE);
end;

procedure TIWfrmOpenModuleGS.IWButton4Click(Sender: TObject);
begin
  inherited;
  SetNameTpye:= 1;
  SendGSMessage(MSS_SET_CHANGENAME);
end;

procedure TIWfrmOpenModuleGS.IWButton5Click(Sender: TObject);
begin
  inherited;
  SetNameTpye:= 0; //关闭
  SendGSMessage(MSS_SET_CHANGENAME);
end;

procedure TIWfrmOpenModuleGS.IWButton6Click(Sender: TObject);
begin
  inherited;
  SetUserback:= 1;
  SendGSMessage(MSS_SET_OLDPLAYERBACK);
end;

procedure TIWfrmOpenModuleGS.IWButton7Click(Sender: TObject);
begin
  inherited;
  SetUserback:= 0;
  SendGSMessage(MSS_SET_OLDPLAYERBACK);
end;

procedure TIWfrmOpenModuleGS.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmOpenModuleGS.IWTimerResultTimer(Sender: TObject);
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

procedure TIWfrmOpenModuleGS.SendGSMessage(const MessageID: Integer);
var
  I,Idx,SID,iCount: Integer;
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
                MSS_OPEN_GAMBLE:
                begin
                  m_Server.SendOpenGamble(SID,True);
                end;
                MSS_CLOSE_GAMBLE:
                begin
                  m_Server.SendOpenGamble(SID,False);
                end;
                MSS_OPEN_COMMONSERVER:
                begin
                  m_Server.SendOpenCommonServer(SID,True);
                end;
                MSS_CLOSE_COMMONSERVER:
                begin
                  m_Server.SendOpenCommonServer(SID,False);
                end;
                MSS_RESET_GAMBLE:
                begin
                  m_Server.SendSetGamble(SID);
                end;
                MSS_SET_CHANGENAME:
                begin
                  m_Server.SendSetChangeName(SID,SetNameTpye);
                end;
                MSS_SET_OLDPLAYERBACK:
                begin
                  m_Server.SendSetOldPlayerBack(SID,SetUserback);
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

end.
