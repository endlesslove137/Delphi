unit UnitfrmBasicConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel, ActiveX,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompEdit, IWTMSEdit, IWCompButton,
  IWCompRectangle, IWTMSCtrls, IWTMSMenus, IWWebGrid,
  IWCompCheckbox, IWCompListbox, IWExchangeBar;

const
  curTitle = '程序设置';

type
  THandleType = ( htAdd, htModif);
  
  TIWfrmBasicConfig = class(TIWFormBasic)
    IWLabel4: TIWLabel;
    IWLabel5: TIWLabel;
    TIWStaticMenu1: TTIWStaticMenu;
    IWbtnAdd: TIWButton;
    IWbtnDel: TIWButton;
    IWbtnModif: TIWButton;
    IWRegion2: TIWRegion;
    IWedtServerName: TIWEdit;
    IWedtSessionHostName: TIWEdit;
    IWedtLogHostName: TIWEdit;
    IWLabel1: TIWLabel;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWbtnOK: TIWButton;
    IWbtnCancel: TIWButton;
    IWlabTServerID: TIWLabel;
    TIWAdvSedtServerID: TTIWAdvSpinEdit;
    IWLabel6: TIWLabel;
    IWedtRate: TIWEdit;
    IWlabPassKey: TIWLabel;
    IWedtPassKey: TIWEdit;
    IWLabel12: TIWLabel;
    IWedtBonusKey: TIWEdit;
    IWlabAppTitle: TIWLabel;
    IWedtAppTitle: TIWEdit;
    IWlabTipText: TIWLabel;
    IWedtTipText: TIWEdit;
    TIWGradientLabel1: TTIWGradientLabel;
    IWlabMaxLevel: TIWLabel;
    TIWAdvSedtMaxLevel: TTIWAdvSpinEdit;
    IWlabRMBFormat: TIWLabel;
    IWedtRMBFormat: TIWEdit;
    IWlabServerList: TIWLabel;
    IWEdtServerList: TIWEdit;
    IWlabShopList: TIWLabel;
    IWedtShopList: TIWEdit;
    IWlabItemList: TIWLabel;
    IWedtItemList: TIWEdit;
    IWlabBonusHttp: TIWLabel;
    IWedtBonusHttp: TIWEdit;
    IWlabLogIdent: TIWLabel;
    IWedtLogIdent: TIWEdit;
    IWLabTaskList: TIWLabel;
    IWedtTaskList: TIWEdit;
    TIWGradientLabel3: TTIWGradientLabel;
    TIWGradientLabel2: TTIWGradientLabel;
    IWlabMaxPageCount: TIWLabel;
    TIWAdvSedtMaxPageCount: TTIWAdvSpinEdit;
    IWlabAutoWidth: TIWLabel;
    TIWAdvSedtAutoWidth: TTIWAdvSpinEdit;
    IWlabAutoHeigth: TIWLabel;
    TIWAdvSedtAutoHeigth: TTIWAdvSpinEdit;
    IWlabDefaultWidth: TIWLabel;
    TIWAdvSedtDefaultWidth: TTIWAdvSpinEdit;
    TIWGradientLabel5: TTIWGradientLabel;
    IWcbLossStat: TIWCheckBox;
    TIWGradientLabel8: TTIWGradientLabel;
    IWlabLossBuildTime: TIWLabel;
    IWedtLossBuildTime: TIWEdit;
    IWlabLossSpid: TIWLabel;
    IWedtLossspid: TIWEdit;
    IWLabel10: TIWLabel;
    TIWGradientLabel4: TTIWGradientLabel;
    TIWGradientLabel6: TTIWGradientLabel;
    IWLabel7: TIWLabel;
    TIWAdvsedtSafetyPassPort: TTIWAdvSpinEdit;
    IWLabel8: TIWLabel;
    TIWAdvsedtEngineConnectPort: TTIWAdvSpinEdit;
    IWcbSafetyPassStart: TIWCheckBox;
    IWcbEngineConnectStart: TIWCheckBox;
    IWLabel9: TIWLabel;
    IWedtDelayUpholePass: TIWEdit;
    TIWGradientLabel7: TTIWGradientLabel;
    IWLabel11: TIWLabel;
    IWedtAcrossPass: TIWEdit;
    IWLabel13: TIWLabel;
    IWCBoxHTType: TIWComboBox;
    IWlabDataSpid: TIWLabel;
    IWedtDataSpid: TIWEdit;
    IWBtnServerList: TIWButton;
    IWBtnShop: TIWButton;
    IWBtnLogIdent: TIWButton;
    IWButton2: TIWButton;
    IWBtnTask: TIWButton;
    IWBtnItem: TIWButton;
    IWButton1: TIWButton;
    IWBtnMonthlyDataDispose: TIWButton;
    IWButton3: TIWButton;
    IWlabCommand: TIWLabel;
    IWedtCommand: TIWEdit;
    procedure IWButton1Click(Sender: TObject);
    procedure TIWStaticMenu1Click(Sender: TObject; ItemIdx: Integer);
    procedure IWbtnAddClick(Sender: TObject);
    procedure IWbtnCancelClick(Sender: TObject);
    procedure IWbtnOKClick(Sender: TObject);
    procedure IWbtnDelClick(Sender: TObject);
    procedure IWbtnModifClick(Sender: TObject);
    procedure IWcbSafetyPassStartClick(Sender: TObject);
    procedure IWcbEngineConnectStartClick(Sender: TObject);
    procedure IWcbLossStatClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnServerListClick(Sender: TObject);
    procedure IWBtnShopClick(Sender: TObject);
    procedure IWBtnItemClick(Sender: TObject);
    procedure IWBtnTaskClick(Sender: TObject);
    procedure IWBtnLogIdentClick(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
    procedure IWBtnMonthlyDataDisposeClick(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
    curHandleType: THandleType;
  public
    { Public declarations }
    procedure ReadINIConfig;
    procedure SaveINIConifg;
  end;

var
  IWfrmBasicConfig: TIWfrmBasicConfig;

implementation

uses ServerController, ConfigINI, ServerINI, uDataDispose, AIWRobot;

{$R *.dfm}

procedure TIWfrmBasicConfig.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  CoInitialize(nil);
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + UserSession.pServerName + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  ReadINIConfig;
end;

procedure TIWfrmBasicConfig.IWbtnAddClick(Sender: TObject);
begin
  inherited;
  IWRegion2.Visible := True;
  curHandleType := htAdd;
  IWedtServerName.Text := '';
  IWedtSessionHostName.Text := '';
  IWedtLogHostName.Text := '';
  TIWAdvSedtServerID.Value := 0;
  IWedtServerName.Enabled := True;
  CoUninitialize;
end;

procedure TIWfrmBasicConfig.IWbtnCancelClick(Sender: TObject);
begin
  inherited;
  IWRegion2.Visible := False;
end;

procedure TIWfrmBasicConfig.IWbtnDelClick(Sender: TObject);
var
  Idx: Integer;
begin
  inherited;
  if TIWStaticMenu1.SelectedIndex > -1 then
  begin
    Idx := objServerINI.SectionList.IndexOf(IWedtServerName.Text);
    if Idx > -1 then
    begin
      objServerINI.SectionList.Delete(Idx);    
      System.Dispose(PTServerListData(ServerList.Objects[Idx]));
      ServerList.Delete(Idx);
      TIWStaticMenu1.Items.Delete(TIWStaticMenu1.SelectedIndex);
      objServerINI.FConfigINI.EraseSection(IWedtServerName.Text);
    end;
  end;
end;

procedure TIWfrmBasicConfig.IWBtnItemClick(Sender: TObject);
begin
  inherited;
  LoadStdItems;
  WebApplication.ShowMessage((Sender as TIWButton).Caption+'完成');
end;

procedure TIWfrmBasicConfig.IWBtnLogIdentClick(Sender: TObject);
begin
  inherited;
  LoadLogIdent;
  WebApplication.ShowMessage((Sender as TIWButton).Caption+'完成');
end;

procedure TIWfrmBasicConfig.IWbtnModifClick(Sender: TObject);
begin
  if TIWStaticMenu1.SelectedIndex > -1 then
  begin
    IWRegion2.Visible := True;
    IWedtServerName.Enabled := False;
    curHandleType := htModif;
  end;
end;

procedure TIWfrmBasicConfig.IWBtnMonthlyDataDisposeClick(Sender: TObject);
begin
  inherited;
  if IWBtnMonthlyDataDispose.DoSubmitValidation then
  begin
    if DataDispose.IsRunMonthlyData then
    begin
      WebApplication.ShowMessage('每月自动执行数据处理，正在进行中...');
    end
    else begin
      DataDispose.ExecMonthlyData;
    end;
  end;
end;

procedure TIWfrmBasicConfig.IWbtnOKClick(Sender: TObject);
var
  Idx: Integer;
  psld: PTServerListData;
  procedure WriteServerINI;
  begin
    objServerINI.FConfigINI.WriteString(IWedtServerName.Text,IWLabel2.Caption,IWedtSessionHostName.Text);
    objServerINI.FConfigINI.WriteString(IWedtServerName.Text,IWLabel3.Caption,IWedtLogHostName.Text);
    objServerINI.FConfigINI.WriteInteger(IWedtServerName.Text,IWlabTServerID.Caption,TIWAdvSedtServerID.Value);
    objServerINI.FConfigINI.WriteFloat(IWedtServerName.Text,IWLabel6.Caption,StrToFloat(IWedtRate.Text));
    objServerINI.FConfigINI.WriteString(IWedtServerName.Text,IWlabPassKey.Caption,IWedtPassKey.Text);
    objServerINI.FConfigINI.WriteString(IWedtServerName.Text,IWLabel12.Caption,IWedtBonusKey.Text);
  end;
begin
  case curHandleType of
    htAdd:
    begin
      if objServerINI.SectionList.IndexOf(IWedtServerName.Text) = -1 then
      begin
        New(psld);
        psld.Index := 0;
        psld.LogHostName := IWedtLogHostName.Text;
        psld.SessionHostName := IWedtSessionHostName.Text;
        psld.ServerID := TIWAdvSedtServerID.Value;
        ServerList.AddObject(IWedtServerName.Text,TObject(psld));
        TIWStaticMenu1.Items.Add.Caption := IWedtServerName.Text;
        WriteServerINI;
      end
      else
      begin
        WebApplication.ShowMessage('服务器名称重复，请重新输入');
      end;
      IWRegion2.Visible := False;
    end;
    htModif:
    begin
      Idx := ServerList.IndexOf(IWedtServerName.Text);
      if Idx > -1 then
      begin
        psld := PTServerListData(ServerList.Objects[Idx]);
        psld.LogHostName := IWedtLogHostName.Text;
        psld.SessionHostName := IWedtSessionHostName.Text;
        psld.ServerID := TIWAdvSedtServerID.Value;
        psld.PassKey := IWedtPassKey.Text;
        if IWedtBonusKey.Text <> psld.BonusKey then
        begin
          psld.BonusKey := IWedtBonusKey.Text;
          WriteServerINI;
        end;
      end;
      IWRegion2.Visible := False;
    end;
  end;
  LoadServerList;
end;

procedure TIWfrmBasicConfig.IWBtnServerListClick(Sender: TObject);
begin
  inherited;
  LoadServerList;
  WebApplication.ShowMessage((Sender as TIWButton).Caption+'完成');
end;

procedure TIWfrmBasicConfig.IWBtnShopClick(Sender: TObject);
begin
  inherited;
  LoadShopList;
  WebApplication.ShowMessage((Sender as TIWButton).Caption+'完成');
end;

procedure TIWfrmBasicConfig.IWBtnTaskClick(Sender: TObject);
begin
  inherited;
  LoadTasks;
  WebApplication.ShowMessage((Sender as TIWButton).Caption+'完成');
end;

procedure TIWfrmBasicConfig.IWButton1Click(Sender: TObject);
begin
  SaveINIConifg;
end;

procedure TIWfrmBasicConfig.IWButton2Click(Sender: TObject);
begin
  inherited;
  LoadServerList;
  LoadShopList;
  LoadStdItems;
  LoadTasks;
  LoadLogIdent;
  WebApplication.ShowMessage((Sender as TIWButton).Caption+'完成');
end;

procedure TIWfrmBasicConfig.IWButton3Click(Sender: TObject);
begin
  inherited;
  ARobots.ReLoadRobotFile;
  WebApplication.ShowMessage((Sender as TIWButton).Caption+'完成');
end;

procedure TIWfrmBasicConfig.IWcbEngineConnectStartClick(Sender: TObject);
begin
  inherited;
  objINI.EngineConnectPort := TIWAdvsedtEngineConnectPort.Value;
  objINI.EngineConnectStart := IWcbEngineConnectStart.Checked;
  FGSMServer.BindPort := objINI.EngineConnectPort;
  if IWcbEngineConnectStart.Checked then
  begin
    FGSMServer.Start();
  end
  else
  begin
    FGSMServer.Stop();
  end;
end;

procedure TIWfrmBasicConfig.IWcbLossStatClick(Sender: TObject);
begin
  inherited;
  objINI.OpenLossStat := IWcbLossStat.Checked;
end;

procedure TIWfrmBasicConfig.IWcbSafetyPassStartClick(Sender: TObject);
begin
  inherited;
  objINI.SafetyPassPort := TIWAdvsedtSafetyPassPort.Value;
  objINI.SafetyPassStart := IWcbSafetyPassStart.Checked;
  SafetyPassHttpServer.DefaultPort := objINI.SafetyPassPort;
  SafetyPassHttpServer.Active := objINI.SafetyPassStart;
end;

procedure TIWfrmBasicConfig.ReadINIConfig;
var
  I: Integer;
begin
  objINI.ReadINI;
  IWedtAppTitle.Text := objINI.sAppTitle;
  IWedtTipText.Text := objINI.curTipText;
  IWEdtServerList.Text := objINI.ServerListXML;
  TIWAdvSedtMaxLevel.Value := objINI.MaxLevel;
  TIWAdvSedtAutoWidth.Value := objINI.AutoWidth;
  TIWAdvSedtAutoHeigth.Value := objINI.AutoHeigth;
  TIWAdvSedtDefaultWidth.Value := objINI.DefaultWidth;
  TIWAdvSedtMaxPageCount.Value := objINI.MaxPageCount;
  IWedtShopList.Text := objINI.ShopListXML;
  IWedtItemList.Text := objINI.ItemListXML;
  IWedtTaskList.Text := objINI.TaskListXML;
  IWedtLogIdent.Text := objINI.LogIdentFile;
  IWedtCommand.Text := objINI.CommandFile;
  IWedtBonusHttp.Text := objINI.CallBonusHttp;
  IWedtRMBFormat.Text := objINI.RMBFormat;
  IWedtLossBuildTime.Text := objINI.LossBuildTime;
  IWcbLossStat.Checked := objINI.OpenLossStat;
  IWedtLossspid.Text := objINI.LossSpid;

  TIWAdvsedtEngineConnectPort.Value := objINI.EngineConnectPort;
  TIWAdvsedtSafetyPassPort.Value := objINI.SafetyPassPort;
  IWcbSafetyPassStart.Checked := objINI.SafetyPassStart;
  IWcbEngineConnectStart.Checked := objINI.EngineConnectStart;
  IWedtDelayUpholePass.Text := objINI.DelayUpholePass;

  IWedtAcrossPass.Text := objINI.AcrossPass;
  IWedtDataSpid.Text := objINI.DataDisposeSpid;

  for I := 0 to objServerINI.SectionList.Count - 1 do
  begin
    TIWStaticMenu1.Items.Add.Caption := objServerINI.SectionList.Strings[I];
  end;
  for I := Integer(Low(THTTypeStr)) to Integer(High(THTTypeStr)) do
  begin
    IWCBoxHTType.Items.Add(THTTypeStr[THTType(I)]);
  end;
  IWCBoxHTType.ItemIndex := objINI.HTType;
end;

procedure TIWfrmBasicConfig.SaveINIConifg;
begin
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabAppTitle.Text,IWedtAppTitle.Text);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabTipText.Text,IWedtTipText.Text);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabServerList.Text,IWEdtServerList.Text);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabShopList.Text,IWEdtShopList.Text);
  objINI.WriteIntegerINI(TIWGradientLabel1.Caption,IWlabTServerID.Text,TIWAdvSedtServerID.Value);
  objINI.WriteIntegerINI(TIWGradientLabel1.Caption,IWlabMaxLevel.Text,TIWAdvSedtMaxLevel.Value);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabRMBFormat.Text,IWEdtRMBFormat.Text);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabLossBuildTime.Text,IWEdtLossBuildTime.Text);
  objINI.WriteBooleanINI(TIWGradientLabel1.Caption,IWcbLossStat.Caption,IWcbLossStat.Checked);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabLossSpid.Caption,IWedtLossspid.Text);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabItemList.Text,IWedtItemList.Text);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabTaskList.Text,IWedtTaskList.Text);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabLogIdent.Text,IWedtLogIdent.Text);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabCommand.Text,IWedtCommand.Text);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabBonusHttp.Text,IWedtBonusHttp.Text);
  objINI.WriteStringINI(TIWGradientLabel1.Caption,IWlabDataSpid.Text,IWedtDataSpid.Text);
  objINI.WriteIntegerINI(TIWGradientLabel1.Caption,IWLabel13.Caption,IWCBoxHTType.ItemIndex);

  objINI.WriteIntegerINI(TIWGradientLabel2.Caption,IWlabAutoWidth.Text,TIWAdvSedtAutoWidth.Value);
  objINI.WriteIntegerINI(TIWGradientLabel2.Caption,IWlabAutoHeigth.Text,TIWAdvSedtAutoHeigth.Value);
  objINI.WriteIntegerINI(TIWGradientLabel2.Caption,IWlabDefaultWidth.Text,TIWAdvSedtDefaultWidth.Value);

  objINI.WriteIntegerINI(TIWGradientLabel3.Caption,IWlabMaxPageCount.Text,TIWAdvSedtMaxPageCount.Value);

  objINI.WriteIntegerINI(TIWGradientLabel4.Caption,IWLabel7.Caption,TIWAdvsedtSafetyPassPort.Value);
  objINI.WriteBooleanINI(TIWGradientLabel4.Caption,IWcbSafetyPassStart.Caption,IWcbSafetyPassStart.Checked);

  objINI.WriteStringINI(TIWGradientLabel7.Caption,IWLabel11.Caption,IWedtAcrossPass.Text);
  
  objINI.ReadINI;
end;

procedure TIWfrmBasicConfig.TIWStaticMenu1Click(Sender: TObject;
  ItemIdx: Integer);
begin
  IWedtServerName.Text := TIWStaticMenu1.Items[ItemIdx].Caption;
  IWedtSessionHostName.Text := objServerINI.FConfigINI.ReadString(TIWStaticMenu1.Items[ItemIdx].Caption,IWLabel2.Caption,'');
  IWedtLogHostName.Text := objServerINI.FConfigINI.ReadString(TIWStaticMenu1.Items[ItemIdx].Caption,IWLabel3.Caption,'');
  TIWAdvSedtServerID.Value := objServerINI.FConfigINI.ReadInteger(TIWStaticMenu1.Items[ItemIdx].Caption,IWlabTServerID.Caption,0);
  IWedtRate.Text := FloatToStr(objServerINI.FConfigINI.ReadFloat(TIWStaticMenu1.Items[ItemIdx].Caption,IWLabel6.Caption,1));
  IWedtPassKey.Text := objServerINI.FConfigINI.ReadString(TIWStaticMenu1.Items[ItemIdx].Caption,IWlabPassKey.Caption,'wyi');
  IWedtBonusKey.Text := objServerINI.FConfigINI.ReadString(TIWStaticMenu1.Items[ItemIdx].Caption,IWLabel12.Caption,'wyi');
end;

initialization
  RegisterClass(TIWfrmBasicConfig);

end.
