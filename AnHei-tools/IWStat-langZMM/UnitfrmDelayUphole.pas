unit UnitfrmDelayUphole;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWBaseComponent, IWBaseHTMLComponent,
  IWBaseHTML40Component, IWCompMemo, IWCompRectangle, IWTMSCtrls,
  IWCompEdit, IWCompButton, IWTMSCheckList, GSManageServer, IWTMSEdit,
  IWCompListbox, IWExchangeBar, IWCompCheckbox, IWTMSCal, IWExtCtrls;

const
  curTitle = '倒计时管理';
    
type
  TIWfrmDelayUphole = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWRegion3: TIWRegion;
    IWbtnReloadNPC: TIWButton;
    IWLabel1: TIWLabel;
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWTimerResult: TIWTimer;
    IWButton1: TIWButton;
    TIWAdvsedtDelay: TTIWAdvSpinEdit;
    IWedtPass: TIWEdit;
    IWlabPass: TIWLabel;
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel2: TIWLabel;
    IWCheckBox1: TIWCheckBox;
    IWLabel3: TIWLabel;
    IWButton2: TIWButton;
    IWLabel4: TIWLabel;
    TIWAdvSpinEdit2: TTIWAdvSpinEdit;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWbtnReloadNPCClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
  private
    spid: string;
    SuccessCount,FailCount: Integer;
  public
    procedure SendGSMessage(const MessageID: Integer);
  end;

var
  IWfrmDelayUphole: TIWfrmDelayUphole;

implementation

uses ConfigINI, ServerController, GSProto;

{$R *.dfm}

procedure TIWfrmDelayUphole.IWAppFormCreate(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  inherited;

  pSDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');

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
  IWLabel2.Caption := Format('共有服务器(%d)',[TIWclbServers.Items.Count]);
end;

procedure TIWfrmDelayUphole.IWbtnReloadNPCClick(Sender: TObject);
begin
  SendGSMessage(MSS_DELAY_UPHOLE);
end;

procedure TIWfrmDelayUphole.IWButton1Click(Sender: TObject);
begin
  SendGSMessage(MSS_CANLCE_UPHOLE);
end;

procedure TIWfrmDelayUphole.IWButton2Click(Sender: TObject);
begin
  SendGSMessage(MSS_DELAY_COMBINE);
end;

procedure TIWfrmDelayUphole.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;


procedure TIWfrmDelayUphole.IWTimerResultTimer(Sender: TObject);
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

procedure TIWfrmDelayUphole.SendGSMessage(const MessageID: Integer);
var
  I,Idx,SID,iCount: Integer;
  m_Server: TGSConnection;
begin
  case MessageID of
    MSS_DELAY_UPHOLE:
    begin
      if TIWAdvsedtDelay.Value <= 0 then
      begin
        WebApplication.ShowMessage('倒计时要大于0，请重新输入');
        Exit;
      end;
      if IWedtPass.Text <> objINI.DelayUpholePass then
      begin
        WebApplication.ShowMessage('倒计时密码错误，请重新输入');
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
                MSS_DELAY_UPHOLE:
                begin
                  m_Server.SendDelayUphole(SID,TIWAdvsedtDelay.Value);
                end;
                MSS_CANLCE_UPHOLE:
                begin
                  m_Server.SendCancelUphole(SID);
                end;
                MSS_DELAY_COMBINE:
                begin
                  m_Server.SendDelayComBine(SID,TIWAdvSpinEdit2.Value, FormatDateTime('YYYY-MM-DD hh:mm:ss',pSDate.Date + pSTime.Time));
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
  RegisterClass(TIWfrmDelayUphole);


end.
