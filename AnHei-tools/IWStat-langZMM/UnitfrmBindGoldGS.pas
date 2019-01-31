unit UnitfrmBindGoldGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWCompEdit, IWCompMemo,
  IWCompRectangle, IWTMSCtrls, IWTMSCheckList, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, IWTMSEdit,
  IWCompListbox, IWExchangeBar, IWCompCheckbox, IWExtCtrls;

const
  curTitle = '礼券管理';

type
  TIWfrmBindGoldGS = class(TIWFormBasic)
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel2: TIWLabel;
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWRegion3: TIWRegion;
    IWLabel1: TIWLabel;
    IWbtnAddBindGold: TIWButton;
    TIWAdvSedtBindGold: TTIWAdvSpinEdit;
    IWLabel3: TIWLabel;
    IWedtRole: TIWEdit;
    IWTimerResult: TIWTimer;
    IWCheckBox1: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWbtnAddBindGoldClick(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
  private
    spID: string;
    SuccessCount,FailCount: Integer;
  public
    procedure SendGSMessage(const MessageID: Integer);
  end;

var
  IWfrmBindGoldGS: TIWfrmBindGoldGS;

implementation

uses ServerController, ConfigINI, GSProto, GSManageServer;

{$R *.dfm}

procedure TIWfrmBindGoldGS.IWAppFormCreate(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  inherited;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWbtnAddBindGold.Confirmation := '是否确认执行？？';
  ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  IWRegion6.Visible := False;
  spID := ServerListData.spID;
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
  IWLabel2.Caption := Format('共有服务器(%d)',[TIWclbServers.Items.Count]);
end;

procedure TIWfrmBindGoldGS.IWbtnAddBindGoldClick(Sender: TObject);
begin
  inherited;
  if IWbtnAddBindGold.DoSubmitValidation then
  begin
    SendGSMessage(MSS_ADD_PLAYER_RESULTPOINT);
  end;
end;

procedure TIWfrmBindGoldGS.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmBindGoldGS.IWTimerResultTimer(Sender: TObject);
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

procedure TIWfrmBindGoldGS.SendGSMessage(const MessageID: Integer);
var
  I,Idx,SID,iCount: Integer;
  m_Server: TGSConnection;
begin
  case MessageID of
    MSS_ADD_PLAYER_RESULTPOINT:
    begin
      if (IWedtRole.Text = '') then
      begin
        WebApplication.ShowMessage('角色名称不能为空，请重新输入');
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
                MSS_ADD_PLAYER_RESULTPOINT:
                begin
                  m_Server.SendPlayerResultPoint(SID,TIWAdvSedtBindGold.Value,IWedtRole.Text);
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
  RegisterClass(TIWfrmBindGoldGS);

end.
