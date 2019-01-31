unit UnitfrmIWStatList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, ZGSManageServer, IWCompMemo,
  IWBaseComponent, IWBaseHTMLComponent, IWBaseHTML40Component,
  IWCompRectangle, IWTMSCtrls, IWCompEdit, IWTMSCheckList, IWWebGrid,
  IWCompListbox, IWExchangeBar, IWCompCheckbox, IWExtCtrls;

const
  curTitle = '后台管理中心';

type
  TIWfrmIWStatList = class(TIWFormBasic)
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
    IWBtnLoadAll: TIWButton;
    IWCheckBox1: TIWCheckBox;
    IWMemoNPC: TIWMemo;
    IWLabel4: TIWLabel;
    IWbtnReloadNPC: TIWButton;
    IWComboBox1: TIWComboBox;
    IWLabel2: TIWLabel;
    IWcBoxCommand: TIWComboBox;
    IWLabel9: TIWLabel;
    IWReFreshcorss: TIWButton;
    IWbtnReloadFunction: TIWButton;
    IWButton1: TIWButton;
    IWButton5: TIWButton;
    IWReLoadConfig: TIWEdit;
    IWLabel8: TIWLabel;
    procedure IWBtnLoadAllClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
    procedure IWbtnReloadNPCClick(Sender: TObject);
    procedure IWbtnReloadFunctionClick(Sender: TObject);
    procedure IWReFreshcorssClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWButton5Click(Sender: TObject);
  private
    spid: string;
    SuccessCount,FailCount: Integer;
  public
    procedure SendGSMessage(const MessageID: Integer);
  end;
procedure LoadIWServers(CheckListBox: TTIWCheckListBox; IsDisplay: Boolean = True);
var
  IWfrmIWStatList: TIWfrmIWStatList;

implementation

uses ServerController, ConfigINI, GSProto, Share;

{$R *.dfm}

procedure LoadIWServers(CheckListBox: TTIWCheckListBox; IsDisplay: Boolean = True);
var
  I,iCount: Integer;
  GSConnection: TZGSConnection;
begin
  iCount := ZGSMServer.FConnectionList.Count;
  CheckListBox.Items.Clear;

  for I := 0 to iCount - 1 do
  begin
    GSConnection := TZGSConnection(ZGSMServer.FConnectionList[I]);
    CheckListBox.Items.AddObject(IntToStr(GSConnection.ServerIndex) + '|' + GSConnection.ServerName + ' |' + GSConnection.spid, TObject(i));
    CheckListBox.Selected[CheckListBox.Items.Count-1] := IsDisplay;
  end;
    {
  for I := 0 to iCount-1 do
  begin
    GSConnection := TZGSConnection(FGSMServer.FConnectionList[I]);
    TIWAdvWebGrid1.Cells[1,I] := GSConnection.ServerName;
    TIWAdvWebGrid1.Cells[2,I] := GSConnection.spid;
    TIWAdvWebGrid1.Cells[3,I] := Format('%s:%d',[GSConnection.RemoteAddress,GSConnection.RemotePort]);
    TIWAdvWebGrid1.Cells[4,I] := IntToStr(GSConnection.ServerIndex);
  end;    }
 // TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;&nbsp;&nbsp;共 %d 个已连接引擎 &nbsp;&nbsp;',[iCount]);
end;


procedure TIWfrmIWStatList.IWAppFormCreate(Sender: TObject);
var
  psld: PTServerListData;
begin
  inherited;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
  psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  spid := psld^.spID;

  LoadIWServers(TIWclbServers, False);

  IWcBoxCommand.Items.AddStrings(CommonList);
  IWcBoxCommand.Items.Insert(0,'未选择');
  IWcBoxCommand.ItemIndex := 0;

  SuccessCount := 0; FailCount := 0;
  IWLabel3.Caption := Format('共有服务器(%d)',[TIWclbServers.Items.Count]);
end;

procedure TIWfrmIWStatList.IWBtnLoadAllClick(Sender: TObject);
begin
  SendGSMessage(SM_RELOADDATALL);
end;


procedure TIWfrmIWStatList.IWbtnReloadFunctionClick(Sender: TObject);
begin
  inherited;
  SendGSMessage(SM_RELOAD_FUNCTION);
end;

procedure TIWfrmIWStatList.IWbtnReloadNPCClick(Sender: TObject);
begin
  if IWMemoNPC.Lines.Count <= 0 then  //新增防止错误
  begin
    IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),'地图名称不允许为空，请输入地图名称']));
    Exit;
  end;
  SendGSMessage(SM_RELOADNPC);
end;

procedure TIWfrmIWStatList.IWButton1Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(SM_RELOADLANG);
end;

procedure TIWfrmIWStatList.IWButton5Click(Sender: TObject);
begin
  inherited;
  if (IWReLoadConfig.Text = '') and (IWcBoxCommand.ItemIndex = 0) then
  begin
    WebApplication.ShowMessage('命令格式不允许为空或您未选择执行命令，请选择..');
    Exit;
  end;
  SendGSMessage(SM_RELOADCONFIG);
end;

procedure TIWfrmIWStatList.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmIWStatList.IWReFreshcorssClick(Sender: TObject);
begin
  inherited;
  SendGSMessage(SM_REFRESHCORSS);
end;

procedure TIWfrmIWStatList.SendGSMessage(const MessageID: Integer);
var
  I,j,Idx,SID,iCount: Integer;
  strList:TStringList;
  m_Server: TZGSConnection;
  sdata,sname,sindx, stitle: string;
begin
  iCount := 0;
  try
    for I := 0 to TIWclbServers.Items.Count - 1 do
    begin
      if TIWclbServers.Selected[I] then
      begin
        Idx := Integer(TIWclbServers.Items.Objects[I]);
        if Idx >= 0 then
        begin
          sdata := TIWclbServers.Items.Strings[Idx];
          sdata := GetValidStr3 (sdata, sindx, ['|']);
          sdata := GetValidStr3 (sdata, stitle, ['|']); //标题无用
          sdata := GetValidStr3 (sdata, sname, ['|']);

          m_Server := ZGSMServer.GetServerByIndex(sname, StrToInt(sindx));
          if m_Server <> nil then
          begin
            SID := SessionIDList.IndexOf(WebApplication.AppID);
            if SID <> -1 then
            begin
              case MessageID of
                SM_RELOADDATALL:
                begin
                  m_Server.SendReLoadDatAll(SID,IWComboBox1.ItemIndex);
                end;
                SM_RELOADNPC:
                begin
                  strList := TStringList.Create;
                  try
                    for J := 0 to IWMemoNPC.Lines.Count - 1 do
                    begin
                      strList.Delimiter := ' ';
                      strList.DelimitedText := Trim(IWMemoNPC.Lines.Strings[J]);
                      if strList.Count > 1 then
                       m_Server.SendReloadNPC(SID, strList.Strings[0] + '/' + strList.Strings[1]);
                    end;
                  finally
                    strList.Clear;
                  end;
                end;
                SM_RELOAD_FUNCTION:
                begin
                   m_Server.SendReloadFunction(SID);
                end;
                SM_REFRESHCORSS:
                begin
                   m_Server.SendSetReFreshcorss(SID);
                end;
                SM_RELOADCONFIG:
                begin
                   if IWReLoadConfig.Text <> '' then
                     m_Server.SendSetReLoadConfig (SID, IWReLoadConfig.Text)
                   else
                     m_Server.SendSetReLoadConfig (SID, IWcBoxCommand.Text);
                end;
                SM_RELOADLANG:
                begin
                   m_Server.SendSetReLoadLang(SID);
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

procedure TIWfrmIWStatList.IWTimerResultTimer(Sender: TObject);
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
  StrResult := GSIWResultStr(WebApplication.AppID);
  if StrResult <> '' then
  begin
    AddLog(StrResult);
    while StrResult <> '' do
    begin
      StrResult := GSIWResultStr(WebApplication.AppID);
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

initialization
  RegisterClass(TIWfrmIWStatList);

end.
