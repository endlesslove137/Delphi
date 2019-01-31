unit UnitfrmGMGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWCompMemo,
  IWTMSCheckList, IWBaseComponent, IWBaseHTMLComponent, IWBaseHTML40Component,
  IWCompCheckbox, IWExtCtrls;

type
  TIWfrmGMGS = class(TIWFormBasic)
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel2: TIWLabel;
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWTimerResult: TIWTimer;
    IWCheckBox1: TIWCheckBox;
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    IWedtRole: TIWEdit;
    IWButton1: TIWButton;
    IWMemo1: TIWMemo;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
  private
    spID: string;
    SuccessCount,FailCount: Integer;
  public
    procedure SendGSMessage(const MessageID: Integer);
  end;

var
  IWfrmGMGS: TIWfrmGMGS;

implementation

uses ServerController, ConfigINI, GSProto, GSManageServer;

{$R *.dfm}

procedure TIWfrmGMGS.IWAppFormCreate(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  inherited;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbGMGS]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbGMGS]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbGMGS])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
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
  IWLabel2.Caption := Format(Langtostr(540),[TIWclbServers.Items.Count]);
  IWCheckBox1.Caption := Langtostr(547);
  IWLabel2.Caption := Langtostr(548);
  IWButton1.Caption := Langtostr(549);
  TIWGradientLabel5.Text := Langtostr(550);
end;

procedure TIWfrmGMGS.IWButton1Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_SEND_OFFMSGTOACOTOR);
end;

procedure TIWfrmGMGS.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmGMGS.IWTimerResultTimer(Sender: TObject);
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

procedure TIWfrmGMGS.SendGSMessage(const MessageID: Integer);
var
  I,Idx,SID,iCount: Integer;
  m_Server: TGSConnection;
begin
  case MessageID of
    MSS_SEND_OFFMSGTOACOTOR:
    begin
      if (IWedtRole.Text = '') then
      begin
        WebApplication.ShowMessage(Langtostr(542));
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
                MSS_SEND_OFFMSGTOACOTOR:
                begin
                  m_Server.SendGMOfflineMessage(SID,IWedtRole.Text,IWMemo1.Text);
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

end.
