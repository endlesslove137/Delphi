unit UnitfrmCompenGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompMemo, IWCompRectangle, IWTMSCtrls,
  IWCompEdit, IWTMSCheckList, IWBaseComponent, IWBaseHTMLComponent,
  IWBaseHTML40Component, GSManageServer, IWTMSEdit, IWCompButton,
  IWCompListbox, IWExchangeBar, IWCompCheckbox, IWTMSCal, IWExtCtrls;

const
  curTitle ='补偿方案管理';
  
type
  TIWfrmCompenGS = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWRegion3: TIWRegion;
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWTimerResult: TIWTimer;
    IWLabel1: TIWLabel;
    TIWAdvsedtExpRate: TTIWAdvSpinEdit;
    IWButton1: TIWButton;
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    TIWAdvSedtTime: TTIWAdvSpinEdit;
    IWLabel4: TIWLabel;
    IWCheckBox1: TIWCheckBox;
    IWButton2: TIWButton;
    IWLabel5: TIWLabel;
    TIWAdvHundred: TTIWAdvSpinEdit;
    IWButton3: TIWButton;
    IWButton4: TIWButton;
    IWLabel6: TIWLabel;
    IWLabel7: TIWLabel;
    TIWAdvSpinEdit2: TTIWAdvSpinEdit;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel8: TIWLabel;
    TIWAdvSpinEdit1: TTIWAdvSpinEdit;
    IWButton6: TIWButton;
    IWLabel9: TIWLabel;
    pBDate: TTIWDateSelector;
    IWLabel10: TIWLabel;
    IWLabel11: TIWLabel;
    IWLabel12: TIWLabel;
    IWLabel13: TIWLabel;
    IWButton5: TIWButton;
    IWButton7: TIWButton;
    TIWGradientLabel1: TTIWGradientLabel;
    TIWGradientLabel2: TTIWGradientLabel;
    IWBFIdx1: TIWCheckBox;
    IWBFIdx2: TIWCheckBox;
    IWBFIdx3: TIWCheckBox;
    IWBFIdx4: TIWCheckBox;
    IWBFIdx7: TIWCheckBox;
    IWBFIdx5: TIWCheckBox;
    IWBFIdx6: TIWCheckBox;
    IWRegion9: TIWRegion;
    IWButton8: TIWButton;
    IWButton9: TIWButton;
    IWLabel14: TIWLabel;
    IWLabel15: TIWLabel;
    pBTime: TTIWAdvTimeEdit;
    TIWGradientLabel3: TTIWGradientLabel;
    IWLabel16: TIWLabel;
    IWLabel19: TIWLabel;
    IWButton12: TIWButton;
    TIWAdvSpinEdit3: TTIWAdvSpinEdit;
    IWLabel20: TIWLabel;
    pTDate: TTIWDateSelector;
    TIWAdvSpinEdit4: TTIWAdvSpinEdit;
    IWLabel21: TIWLabel;
    pTTime: TTIWAdvTimeEdit;
    IWBFIdx8: TIWCheckBox;
    IWBFIdx9: TIWCheckBox;
    IWBFIdx10: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
    procedure IWButton4Click(Sender: TObject);
    procedure IWButton9Click(Sender: TObject);
    procedure IWButton5Click(Sender: TObject);
    procedure IWButton7Click(Sender: TObject);
    procedure IWButton8Click(Sender: TObject);
    procedure IWButton6Click(Sender: TObject);
    procedure IWButton12Click(Sender: TObject);
  private
    spid: string;
    SuccessCount,FailCount: Integer;
    hunType: byte;
  public
    procedure SendGSMessage(const MessageID: Integer);
  end;

var
  IWfrmCompenGS: TIWfrmCompenGS;

implementation

uses ConfigINI, ServerController, GSProto;

{$R *.dfm}

procedure TIWfrmCompenGS.IWAppFormCreate(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  inherited;
  pSDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  //默认百服活动时间
  pBDate.Date := Now();
  pBTime.Time := StrToTime('00:00:00');

  pTDate.Date := Now();
  pTTime.Time := StrToTime('00:00:00');
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
  SuccessCount := 0; FailCount := 0; hunType := 0;
  IWLabel2.Caption := Format('共有服务器(%d)',[TIWclbServers.Items.Count]);
end;

procedure TIWfrmCompenGS.IWButton12Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_SET_GROUPON);
end;

procedure TIWfrmCompenGS.IWButton1Click(Sender: TObject);
begin
  SendGSMessage(MSS_OPEN_COMPENSATE);
end;

procedure TIWfrmCompenGS.IWButton2Click(Sender: TObject);
begin
  SendGSMessage(MSS_CLOSE_COMPENSATE);
end;

procedure TIWfrmCompenGS.IWButton3Click(Sender: TObject);
begin
  if not IWBFIdx1.Checked and not IWBFIdx2.Checked and not IWBFIdx3.Checked and not IWBFIdx4.Checked and
     not IWBFIdx5.Checked and not IWBFIdx6.Checked and not IWBFIdx7.Checked and not IWBFIdx8.Checked and
     not IWBFIdx9.Checked and not IWBFIdx10.Checked then
  begin
    WebApplication.ShowMessage('至少开启一项活动，请选择');
    Exit;
  end;

  hunType := 1;
  SendGSMessage(MSS_SET_HUNDREDSERVER);
end;

procedure TIWfrmCompenGS.IWButton4Click(Sender: TObject);
begin
  inherited;
  IWLabel15.Caption := '手动清档: 是否确定要清档？ 清档将会把百服活动中的所有数据清空（排行榜、战力、沙城），请谨慎操作！';
  hunType := 2;
  IWRegion9.Visible := True;
end;

procedure TIWfrmCompenGS.IWButton5Click(Sender: TObject);
begin
  inherited;
  IWLabel15.Caption := '手动关闭: 是否确定要关闭？ 关闭将会把百服活动的入口关闭，可以重新开启百服活动打开入口按钮！';
  hunType := 3;
  IWRegion9.Visible := True;
end;

procedure TIWfrmCompenGS.IWButton6Click(Sender: TObject);
begin
  inherited;
  SendGSMessage(MSS_SET_SURPRISERET);
end;

procedure TIWfrmCompenGS.IWButton7Click(Sender: TObject);
begin
  inherited;
  IWLabel15.Caption := '手动结算: 是否确定要结算？ 结算将会把百服活动的数据进行结算，数据不会再进行统计累计！请谨慎操作！';
  hunType := 4;
  IWRegion9.Visible := True;
end;

procedure TIWfrmCompenGS.IWButton8Click(Sender: TObject);
begin
  inherited;
  IWRegion9.Visible := False;
  SendGSMessage(MSS_SET_HUNDREDSERVER);
end;

procedure TIWfrmCompenGS.IWButton9Click(Sender: TObject);
begin
  inherited;
  IWRegion9.Visible := False
end;

procedure TIWfrmCompenGS.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmCompenGS.IWTimerResultTimer(Sender: TObject);
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

procedure TIWfrmCompenGS.SendGSMessage(const MessageID: Integer);
var
  I,Idx,SID,iCount: Integer;
  m_Server: TGSConnection;
begin
  case MessageID of
    MSS_OPEN_COMPENSATE:
    begin
      if TIWAdvsedtExpRate.Value <= 0 then
      begin
        WebApplication.ShowMessage('补偿ID编号必须大于0，请重新输入');
        Exit;
      end;
    end;
    MSS_SET_HUNDREDSERVER:
    begin
      if TIWAdvHundred.Value <= 0 then
      begin
        WebApplication.ShowMessage('持续开启天数必须大于0，请重新输入');
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
                MSS_OPEN_COMPENSATE:
                begin
                  m_Server.SendSetOpenCompen(SID,TIWAdvsedtExpRate.Value,TIWAdvSedtTime.Value);
                end;
                MSS_CLOSE_COMPENSATE:
                begin
                   m_Server.SendSetCloseompen(SID);
                end;
                MSS_SET_HUNDREDSERVER:
                begin
                  if hunType = 1 then
                  begin
                    m_Server.SendSetHunderd(SID,
                    TIWAdvHundred.Value, hunType, FormatDateTime('YYYY-MM-DD hh:mm:ss',pBDate.Date + pBTime.Time) + #10 +
                    BoolToIntStr(IWBFIdx1.Checked) + BoolToIntStr(IWBFIdx2.Checked) + BoolToIntStr(IWBFIdx3.Checked) +
                    BoolToIntStr(IWBFIdx4.Checked) + BoolToIntStr(IWBFIdx5.Checked) + BoolToIntStr(IWBFIdx6.Checked) +
                    BoolToIntStr(IWBFIdx7.Checked) + BoolToIntStr(IWBFIdx8.Checked) + BoolToIntStr(IWBFIdx9.Checked) +
                    BoolToIntStr(IWBFIdx10.Checked))
                  end else m_Server.SendSetHunderd(SID, 0, hunType, '');
                end;
                MSS_SET_SURPRISERET:
                begin
                   m_Server.SendSetSurpRiseret(SID,TIWAdvSpinEdit2.Value,TIWAdvSpinEdit1.Value, FormatDateTime('YYYY-MM-DD hh:mm:ss',pSDate.Date + pSTime.Time));
                   UserSession.AddHTOperateLog(3,'持续(时)：'+IntToStr(TIWAdvSpinEdit2.Value),'服务器ID: '+ inttostr(Idx) + '回馈ID：'+IntToStr(TIWAdvSpinEdit1.Value),'开启时间：'+FormatDateTime('YYYY-MM-DD hh:mm:ss',pSDate.Date + pSTime.Time));
                end;
                MSS_SET_GROUPON:
                begin
                   m_Server.SendSetGroupon(SID,TIWAdvSpinEdit4.Value,TIWAdvSpinEdit3.Value, FormatDateTime('YYYY-MM-DD hh:mm:ss',pTDate.Date + pTTime.Time));
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
  RegisterClass(TIWfrmCompenGS);

end.
