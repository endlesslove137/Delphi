unit UnitfrmExpRateGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompMemo, IWCompRectangle, IWTMSCtrls,
  IWCompEdit, IWTMSCheckList, IWBaseComponent, IWBaseHTMLComponent,
  IWBaseHTML40Component, GSManageServer, IWTMSEdit, IWCompButton,
  IWCompListbox, IWExchangeBar, IWCompCheckbox, IWWebGrid, IWAdvWebGrid,
  IWTMSCal, IWExtCtrls;

const
  curTitle ='经验倍率管理';
  
type
  TIWfrmExpRateGS = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWRegion3: TIWRegion;
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWTimerResult: TIWTimer;
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel2: TIWLabel;
    IWCheckBox1: TIWCheckBox;
    IWRegion7: TIWRegion;
    IWCheckMode: TIWCheckBox;
    pETime: TTIWAdvTimeEdit;
    pEDate: TTIWDateSelector;
    IWLabel4: TIWLabel;
    TIWAdvSedtTime: TTIWAdvSpinEdit;
    IWLabel3: TIWLabel;
    IWButton1: TIWButton;
    TIWAdvsedtExpRate: TTIWAdvSpinEdit;
    IWLabel1: TIWLabel;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure TIWAdvWebGrid1ButtonClick(Sender: TObject; RowIndex,
      ColumnIndex: Integer);
    procedure IWTimerResultTimer(Sender: TObject);
  private
    spid: string;
    SuccessCount,FailCount, nServerIndex: Integer;
  public
    procedure SendGSMessage(const MessageID: Integer);
    procedure LoadExpRateFile;

    procedure SetControlEnabled(OnOff: Boolean);
    procedure SendGSDelExpRate(ServerIndex,Index: Integer);
  end;

var
  IWfrmExpRateGS: TIWfrmExpRateGS;

implementation

uses ConfigINI, ServerController, GSProto, EDcode, DateUtils, AIWRobot;

{$R *.dfm}


procedure TIWfrmExpRateGS.LoadExpRateFile;
var
  I, Idx, iCount: Integer;
  sMessage, strdat, strdate: string;
  parr: PTAutoRunRecord;
begin
  TIWAdvWebGrid1.ClearCells;
  iCount := 0;
  TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;

  for i := ARobots.FileAutoList.Count - 1 downto 0 do
  begin
    parr := PTAutoRunRecord(ARobots.FileAutoList.Items[i]);
    if parr <> nil then
    begin
      if parr^.NumType in [3, 4] then
      begin
        Idx      := parr^.ServerIdx;
        sMessage := parr^.sdata;
        strdat   := RobotTypestr(parr^.NumType);
        strdate  := FormatDateTime('YYYY-MM-DD hh:mm:ss',parr^.dNextRun);
        if ((nServerIndex = 0) and (parr^.spid = spID)) or ((Idx = nServerIndex) and (parr^.spid = spID)) then
        begin
          TIWAdvWebGrid1.RowCount := TIWAdvWebGrid1.RowCount + 1;
          TIWAdvWebGrid1.Cells[1, iCount] := GetServerListName(spID, Idx);
          TIWAdvWebGrid1.Cells[2, iCount] := sMessage;
          TIWAdvWebGrid1.Cells[3, iCount] := strdat;
          TIWAdvWebGrid1.Cells[4, iCount] := strdate;
          Inc(iCount);
        end;
      end;
    end;
  end;
  TIWAdvWebGrid1.TotalRows := iCount;

  TIWAdvWebGrid1.Controller.Caption := Format('&nbsp&nbsp&nbsp共有%d条公告',[TIWAdvWebGrid1.RowCount]);
end;

procedure TIWfrmExpRateGS.IWAppFormCreate(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  inherited;
  pEDate.Date := Now();
  pETime.Time := StrToTime('00:00:00');

  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
  ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  spid := ServerListData^.spID;
  nServerIndex := ServerListData^.Index;

  TIWAdvWebGrid1.RowCount := 0;
  TIWAdvWebGrid1.TotalRows := 0;

  LoadExpRateFile;

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

procedure TIWfrmExpRateGS.IWButton1Click(Sender: TObject);
begin
  SendGSMessage(MSS_SET_EXPRATE);
end;

procedure TIWfrmExpRateGS.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmExpRateGS.IWTimerResultTimer(Sender: TObject);
const
  SuccessStr: array [0 .. 1] of string = ('成功', '失败');
  ResultStr = '%d<%s> %s';
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
  function GetGSMessage(AppID: string): string;
  var
    Idx, IsSuccess,iServerIndex: Integer;
    ServerName: string;
    pDefMsg: PTDefaultMessage;
    parr: PTAutoRunRecord;
  begin
    Result := '';
    EnterCriticalSection(FPrintMsgLock);
    try
      IsSuccess := 1;
      Idx := GetSessionDMessage(AppID);
      if Idx <> -1 then
      begin
        pDefMsg := PTDefaultMessage(GSMsgList.Objects[Idx]);
        iServerIndex := StrToInt(Copy(GSMsgList.Strings[Idx],1,Pos('|',GSMsgList.Strings[Idx])-1));
        ServerName := GetServerListNameEx(iServerIndex);
        if pDefMsg <> nil then
        begin
          if pDefMsg^.Tag > 1 then pDefMsg^.Tag := 1;
          case pDefMsg^.Ident of
            //返回设置经验倍率结果(tag为0表示成功，param为实际设置的倍率，可能不同于请求设置的倍率)
            MCS_SET_EXPRATE_RET:
            begin
              if pDefMsg^.Tag = 0 then
              begin
                IsSuccess := 0;
                if pDefMsg^.Param <= 1 then
                  ARobots.DeleteEx2(iServerIndex, 4)
                else
                begin
                  New(parr);
                  ZeroMemory(parr, sizeof(parr^));
                  parr.spid := spid;
                  parr.ServerIdx:= iServerIndex;
                  parr.MsgType := TIWAdvsedtExpRate.Value;
                  parr.sdata := '经验倍率为: ' + inttostr(TIWAdvsedtExpRate.Value) +
                                '倍 持续: ' + IntToStr(TIWAdvSedtTime.Value) + '分钟';
                  parr.NumType := 4;
                  parr.dNextRun := IncMinute(pEDate.Date + Time, TIWAdvSedtTime.Value);
                  parr.RunTick := TIWAdvSedtTime.Value;
                  ARobots.add(parr);
                  IWServerController.SetRobotMessage(spid, iServerIndex, TIWAdvsedtExpRate.Value, 4, TIWAdvSedtTime.Value, parr.sdata, parr.dNextRun);
                end;
              end;
              Result := Format(ResultStr,[IsSuccess,ServerName,'设置经验倍率' + SuccessStr[pDefMsg^.Tag] +'，经验倍率为：' + IntToStr(pDefMsg^.Param)]);
            end;
          end;
          if Idx < GSMsgList.Count then
          begin
            System.Dispose(pDefMsg);
            GSMsgList.Delete(Idx);
          end;
        end;
      end;
    finally
      LeaveCriticalSection(FPrintMsgLock);
    end;
  end;
begin
  inherited;
  StrResult := GetGSMessage(WebApplication.AppID);
  if StrResult <> '' then
  begin
    AddLog(StrResult);
    while StrResult <> '' do
    begin
      StrResult := GetGSMessage(WebApplication.AppID);
      if StrResult <> '' then
      AddLog(StrResult);
    end;
  end
  else
  begin
    if (SuccessCount > 1) or (FailCount > 1) then
    begin
      IWMemoSuccessLog.Lines.Add(Format('[%s] 操作完成成功(%d)失败(%d)',[DateTimeToStr(Now),SuccessCount,FailCount]));
    end;
    SuccessCount := 0;
    FailCount := 0;
    IWTimerResult.Enabled := False;
    SetControlEnabled(True);

    LoadExpRateFile;
  end;
end;

procedure TIWfrmExpRateGS.SendGSDelExpRate(ServerIndex,Index: Integer);
var
  SID: Integer;
  m_Server: TGSConnection;
begin
  m_Server := FGSMServer.GetServerByIndex(spID,ServerIndex);
  if m_Server <> nil then
  begin
    SID := SessionIDList.IndexOf(WebApplication.AppID);
    m_Server.SendSetExpRate(SID, 1, 0);
  end
  else
    IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),'获取<'+GetServerListName(spID,ServerIndex)+'>失败']));
end;

procedure TIWfrmExpRateGS.SendGSMessage(const MessageID: Integer);
var
  I,Idx,SID,iCount: Integer;
  m_Server: TGSConnection;
  BoOpenSend: Boolean;
  parr: PTAutoRunRecord;
begin
  case MessageID of
    MSS_SET_EXPRATE:
    begin
      if TIWAdvsedtExpRate.Value <= 0 then
      begin
        WebApplication.ShowMessage('经验倍率要大于0，请重新输入');
        Exit;
      end;
    end;
  end;
  iCount := 0;
  SetControlEnabled(False);
  try
    for I := 0 to TIWclbServers.Items.Count - 1 do
    begin
      if TIWclbServers.Selected[I] then
      begin
        BoOpenSend:= True;
        Idx := Integer(TIWclbServers.Items.Objects[I]);
        if Idx > 0 then
        begin
          m_Server := FGSMServer.GetServerByIndex(spid,Idx);
          if m_Server <> nil then
          begin
            SID := SessionIDList.IndexOf(WebApplication.AppID);
            if SID <> -1 then
            begin
              if IWCheckMode.Checked then  //加入定时列表
              begin
                SetControlEnabled(False);

                New(parr);
                ZeroMemory(parr, sizeof(parr^));
                parr.spid := spid;
                parr.ServerIdx:= Idx;
                parr.MsgType := TIWAdvsedtExpRate.Value;
                parr.sdata := '经验倍率为: ' + inttostr(TIWAdvsedtExpRate.Value) +
                              '倍 持续: ' + IntToStr(TIWAdvSedtTime.Value) + '分钟';
                parr.NumType := 3;
                parr.dNextRun := pEDate.Date + pETime.Time;
                parr.RunTick := TIWAdvSedtTime.Value;
                ARobots.add(parr);
                IWServerController.SetRobotMessage(spid, Idx, TIWAdvsedtExpRate.Value, 3, TIWAdvSedtTime.Value, parr.sdata, pEDate.Date + pETime.Time);
                IWTimerResult.Enabled := False;
                IWTimerResult.Enabled := True;
                BoOpenSend:= False;
              end;
              if BoOpenSend then
              case MessageID of
                MSS_SET_EXPRATE:
                begin
                  m_Server.SendSetExpRate(SID,TIWAdvsedtExpRate.Value,TIWAdvSedtTime.Value);
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

procedure TIWfrmExpRateGS.SetControlEnabled(OnOff: Boolean);
begin
  TIWclbServers.ReadOnly := not OnOff;
  IWButton1.Enabled := OnOff;
  TIWAdvWebGrid1.Enabled := OnOff;
end;

procedure TIWfrmExpRateGS.TIWAdvWebGrid1ButtonClick(Sender: TObject; RowIndex,
  ColumnIndex: Integer);
var
  i: Integer;
  psld: PTServerListData;
begin
  inherited;
  case ColumnIndex of
    5: //删除
    begin
      SetControlEnabled(False);
      for I := TIWAdvWebGrid1.TotalRows - 1 downto 0 do
      begin
        if (TIWAdvWebGrid1.RowSelect[I]) then
        begin
          psld := GetServerListData(TIWAdvWebGrid1.Cells[1,I]);
          if psld <> nil then
          begin
            if TIWAdvWebGrid1.Cells[3,I] = RobotTypestr(4) then
               SendGSDelExpRate(psld^.Index,I)
            else begin
              ARobots.DeleteEx(TIWAdvWebGrid1.Cells[2,I], psld^.Index, StrToDateTime(TIWAdvWebGrid1.Cells[4,I]));
              IWServerController.SetRobotMessage(spid, psld^.Index, TIWAdvsedtExpRate.Value, 100, TIWAdvSedtTime.Value, TIWAdvWebGrid1.Cells[2,I], StrToDateTime(TIWAdvWebGrid1.Cells[4,I]));
              IWMemoSuccessLog.Lines.Add(Format('[%s] 删除经验倍率列表成功！', [DateTimeToStr(Now)]));
            end;
          end
          else
          begin
            IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),'获取'+GetServerListName(spID,psld^.Index)+'错误']));
          end;
        end;
      end;
      TIWAdvWebGrid1.ClearRowSelect;
      IWTimerResult.Enabled := False;
      IWTimerResult.Enabled := True;
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmExpRateGS);

end.
