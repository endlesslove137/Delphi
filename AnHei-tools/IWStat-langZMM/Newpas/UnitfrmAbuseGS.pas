unit UnitfrmAbuseGS;

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
  curTitle = 116;//'屏蔽字管理';

type
  TIWfrmAbuseGS = class(TIWFormBasic)
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
    IWbtnAbuse: TIWButton;
    IWLabel4: TIWLabel;
    IWMemoAbuse: TIWMemo;
    IWCheckBox1: TIWCheckBox;
    IWLabel2: TIWLabel;
    IWComboBox1: TIWComboBox;
    IWButton1: TIWButton;
    procedure IWbtnAbuseClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
  private
    spid: string;
    SuccessCount,FailCount, AbuseType: Integer;
    procedure LoadAbuseeType;
  public
    procedure SendGSMessage(const MessageID: Integer);
  end;

var
  IWfrmAbuseGS: TIWfrmAbuseGS;

const
  AbuseTypeStr : array[0..2] of Integer = (337,601,366);

implementation

uses ServerController, ConfigINI, GSProto;

{$R *.dfm}

procedure TIWfrmAbuseGS.IWAppFormCreate(Sender: TObject);
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

  LoadAbuseeType;  //获取选项

  IWCheckBox1.Caption := Langtostr(547);
  IWLabel4.Caption := Langtostr(604);
  IWLabel2.Caption := Langtostr(605);

  IWButton1.Caption := Langtostr(607);
  IWbtnAbuse.Caption := Langtostr(606);

  TIWGradientLabel5.Text := Langtostr(550);

  SuccessCount := 0; FailCount := 0;  AbuseType := 0;
  IWLabel3.Caption := Format(Langtostr(540),[TIWclbServers.Items.Count]);
end;

procedure TIWfrmAbuseGS.IWbtnAbuseClick(Sender: TObject);
begin
  if IWComboBox1.ItemIndex = 0 then
  begin
    WebApplication.ShowMessage(Langtostr(602));
    Exit;
  end;
  if IWMemoAbuse.Lines.Count <= 0 then
  begin
    IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),Langtostr(603)]));
    Exit;
  end;
  AbuseType:= 1; //增加
  SendGSMessage(MSS_ADD_FILTERWORDS);
end;

procedure TIWfrmAbuseGS.IWButton1Click(Sender: TObject);
begin
  if IWComboBox1.ItemIndex = 0 then
  begin
    WebApplication.ShowMessage(Langtostr(602));
    Exit;
  end;
  if IWMemoAbuse.Lines.Count <= 0 then
  begin
    IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),Langtostr(603)]));
    Exit;
  end;
  AbuseType:= 2; //删除
  SendGSMessage(MSS_ADD_FILTERWORDS);
end;

procedure TIWfrmAbuseGS.LoadAbuseeType;
var
  I: Integer;
begin
  IWComboBox1.Items.Clear;
  for I := Low(AbuseTypeStr) to High(AbuseTypeStr) do
  begin
    IWComboBox1.Items.Add(Langtostr(AbuseTypeStr[I]));
  end;
  IWComboBox1.ItemIndex := 0;
end;

procedure TIWfrmAbuseGS.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmAbuseGS.SendGSMessage(const MessageID: Integer);
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
          m_Server := FGSMServer.GetServerByIndex(spID,Idx);
          if m_Server <> nil then
          begin
            SID := SessionIDList.IndexOf(WebApplication.AppID);
            if SID <> -1 then
            begin
              case MessageID of
                MSS_ADD_FILTERWORDS:
                begin
                   for J := 0 to IWMemoAbuse.Lines.Count - 1 do
                   begin
                     if IWComboBox1.ItemIndex > 0 then
                      m_Server.SendSetAbuse(SID,AbuseType,IWComboBox1.ItemIndex, Trim(IWMemoAbuse.Lines.Strings[J]));
                   end;
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

procedure TIWfrmAbuseGS.IWTimerResultTimer(Sender: TObject);
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

initialization
  RegisterClass(TIWfrmAbuseGS);

end.
