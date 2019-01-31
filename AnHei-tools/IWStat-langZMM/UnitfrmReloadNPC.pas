unit UnitfrmReloadNPC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, GSManageServer, IWCompMemo,
  IWBaseComponent, IWBaseHTMLComponent, IWBaseHTML40Component,
  IWCompRectangle, IWTMSCtrls, IWCompEdit, IWTMSCheckList, IWWebGrid,
  IWCompListbox, IWExchangeBar, IWCompCheckbox, IWExtCtrls;

const
  curTitle = 'NPC管理';
  
type
  TIWfrmReloadNPC = class(TIWFormBasic)
    IWTimerResult: TIWTimer;
    IWRegion2: TIWRegion;
    IWRegion3: TIWRegion;
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel3: TIWLabel;
    IWRegion7: TIWRegion;
    IWbtnReloadNPC: TIWButton;
    IWLabel4: TIWLabel;
    IWMemoNPC: TIWMemo;
    IWCheckBox1: TIWCheckBox;
    procedure IWbtnReloadNPCClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
  private
    spid: string;
    SuccessCount,FailCount: Integer;
  public
    procedure SendGSMessage(const MessageID: Integer);
  end;

var
  IWfrmReloadNPC: TIWfrmReloadNPC;

implementation

uses ServerController, ConfigINI, GSProto;

{$R *.dfm}

procedure TIWfrmReloadNPC.IWAppFormCreate(Sender: TObject);
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
  SuccessCount := 0; FailCount := 0;
  IWLabel3.Caption := Format('共有服务器(%d)',[TIWclbServers.Items.Count]);
end;

procedure TIWfrmReloadNPC.IWbtnReloadNPCClick(Sender: TObject);
begin
  if IWMemoNPC.Lines.Count <= 0 then  //新增防止错误
  begin
    IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),'地图名称不允许为空，请输入地图名称']));
    Exit;
  end;
  SendGSMessage(MSS_RELOADNPC);
end;

procedure TIWfrmReloadNPC.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmReloadNPC.IWTimerResultTimer(Sender: TObject);
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

procedure TIWfrmReloadNPC.SendGSMessage(const MessageID: Integer);
var
  I,J,Idx,SID,iCount: Integer;
  m_Server: TGSConnection;
  strList: TStringList;
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
          m_Server := FGSMServer.GetServerByIndex(spID,Idx);
          if m_Server <> nil then
          begin
            SID := SessionIDList.IndexOf(WebApplication.AppID);
            if SID <> -1 then
            begin
              case MessageID of
                MSS_RELOADNPC:
                begin
                  strList := TStringList.Create;
                  try
                    for J := 0 to IWMemoNPC.Lines.Count - 1 do
                    begin
                      strList.Delimiter := ' ';
                      strList.DelimitedText := Trim(IWMemoNPC.Lines.Strings[J]);
                      if strList.Count > 1 then
                        m_Server.SendReloadNPC(SID,strList.Strings[0],strList.Strings[1]);
                    end;
                  finally
                    strList.Clear;
                  end;
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
  RegisterClass(TIWfrmReloadNPC);

end.
