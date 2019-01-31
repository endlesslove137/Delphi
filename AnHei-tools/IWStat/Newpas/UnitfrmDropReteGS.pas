unit UnitfrmDropReteGS;

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
  curTitle ='死亡掉落概率';
  
type
  TDropTypen = (ftNone, ftWhiteBag, ftWhiteBody, ftRedBag, ftRedBody);

  TIWfrmDropReteGS = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWRegion3: TIWRegion;
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWTimerResult: TIWTimer;
    IWLabel1: TIWLabel;
    TIWAdvsedtDropRete: TTIWAdvSpinEdit;
    IWButton1: TIWButton;
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel2: TIWLabel;
    IWCheckBox1: TIWCheckBox;
    IWLabel4: TIWLabel;
    IWComboBox1: TIWComboBox;
    IWLabel3: TIWLabel;
    IWLabel5: TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
  private
    spid: string;
    SuccessCount,FailCount: Integer;
    procedure LoadDropType;
  public
    procedure SendGSMessage(const MessageID: Integer);
  end;

var
  IWfrmDropReteGS: TIWfrmDropReteGS;

const
  DropTypeStr  : array[TDropTypen] of string =
                  ('--请选择--','白名背包','白名装备','红名背包','红名装备');

implementation

uses ConfigINI, ServerController, GSProto;

{$R *.dfm}

procedure TIWfrmDropReteGS.IWAppFormCreate(Sender: TObject);
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
  LoadDropType;
  IWLabel2.Caption := Format('共有服务器(%d)',[TIWclbServers.Items.Count]);
end;

procedure TIWfrmDropReteGS.IWButton1Click(Sender: TObject);
begin
  SendGSMessage(MSS_SET_DROPRATE);
end;

procedure TIWfrmDropReteGS.LoadDropType;
var
  cstr: string;
begin
  IWComboBox1.Items.Clear;
  for cstr in DropTypeStr do
  begin
    IWComboBox1.Items.Add(cstr);
  end;
  IWComboBox1.ItemIndex := 0;
end;

procedure TIWfrmDropReteGS.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmDropReteGS.IWTimerResultTimer(Sender: TObject);
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

procedure TIWfrmDropReteGS.SendGSMessage(const MessageID: Integer);
var
  I,Idx,SID,iCount: Integer;
  m_Server: TGSConnection;
begin
  case MessageID of
    MSS_SET_DROPRATE:
    begin
      if (TIWAdvsedtDropRete.Value <= 0) or (TIWAdvsedtDropRete.Value > 1000) then
      begin
        WebApplication.ShowMessage('概率值必须大于0小于1000，请重新输入');
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
                MSS_SET_DROPRATE:
                begin
                  m_Server.SendSetDropRete(SID, IWComboBox1.ItemIndex, TIWAdvsedtDropRete.Value);
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
  RegisterClass(TIWfrmDropReteGS);

end.
