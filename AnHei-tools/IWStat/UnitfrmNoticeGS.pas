unit UnitfrmNoticeGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompMemo, IWCompRectangle, IWTMSCtrls,
  IWCompEdit, IWCompButton, IWTMSCheckList, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, GSManageServer,
  IWCompListbox, IWExchangeBar, IWTMSEdit, IWCompCheckbox, IWWebGrid,
  IWAdvWebGrid, IWTMSCal, IWExtCtrls;

const
  curTitle = 114;//'公告管理';

type
  TIWfrmNoticeGS = class(TIWFormBasic)
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
    IWButton1: TIWButton;
    IWButton3: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWRegion8: TIWRegion;
    IWMemoNotice: TIWMemo;
    IWLabel3: TIWLabel;
    IWButton2: TIWButton;
    IWButton5: TIWButton;
    IWButton7: TIWButton;
    TIWCLBoxMsgType: TTIWCheckListBox;
    IWLabel1: TIWLabel;
    IWButton4: TIWButton;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWCheckMode: TIWCheckBox;
    IWRegion9: TIWRegion;
    IWButton6: TIWButton;
    IWButton8: TIWButton;
    IWLabel5: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWLabel4: TIWLabel;
    TIWNoticeTime: TTIWAdvSpinEdit;
    IWLabel6: TIWLabel;
    IWButton9: TIWButton;
    IWCheckBox2: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWTimerResultTimer(Sender: TObject);
    procedure TIWAdvWebGrid1ButtonClick(Sender: TObject; RowIndex,
      ColumnIndex: Integer);
    procedure IWButton5Click(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
    procedure IWButton7Click(Sender: TObject);
    procedure IWButton4Click(Sender: TObject);
    procedure IWButton8Click(Sender: TObject);
    procedure IWButton6Click(Sender: TObject);
    procedure IWButton9Click(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWCheckBox2Click(Sender: TObject);
  private
    SuccessCount, FailCount, nServerIndex: Integer;
    spID: string;
  public
    procedure SendGSMessage(const MessageID: Integer);
    procedure LoadMsgType;
    function GetMsgTypeValue: Integer;
    procedure LoadNoticeFile;

    procedure SetControlEnabled(OnOff: Boolean);
    procedure SendGSDelNotice(ServerIndex,Index: Integer;sMessage: string);
  end;

var
  IWfrmNoticeGS: TIWfrmNoticeGS;

implementation

uses ConfigINI, ServerController, GSProto, EDcode, AIWRobot;

{$R *.dfm}

function TIWfrmNoticeGS.GetMsgTypeValue: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to TIWCLBoxMsgType.Items.Count - 1 do
  begin
    if TIWCLBoxMsgType.Selected[I] then
    begin
      Result := Result + Integer(TIWCLBoxMsgType.Items.Objects[I]);
    end;
  end;
end;

procedure TIWfrmNoticeGS.IWAppFormCreate(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('00:00:00');

  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
  ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
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

  IWLabel2.Caption := Format(Langtostr(540),[TIWclbServers.Items.Count]);
  spID := ServerListData^.spID;
  nServerIndex := ServerListData^.Index;
  TIWAdvWebGrid1.RowCount := 0;
  TIWAdvWebGrid1.TotalRows := 0;

  LoadNoticeFile;
  LoadMsgType;

  IWCheckBox1.Caption := Langtostr(547);
  IWCheckBox2.Caption := Langtostr(547);
  IWCheckMode.Caption := Langtostr(596);
  IWButton7.Caption := Langtostr(589);

  IWButton1.Caption := Langtostr(575);
  IWButton4.Caption := Langtostr(590);
  IWButton9.Caption := Langtostr(577);
  IWButton3.Caption := Langtostr(591);

  IWButton6.Caption := Langtostr(168);
  IWButton8.Caption := Langtostr(169);
  IWButton2.Caption := Langtostr(168);
  IWButton5.Caption := Langtostr(169);

  IWLabel1.Caption := Langtostr(592);
  IWLabel3.Caption := Langtostr(593);
  IWLabel4.Caption := Langtostr(594);
  IWLabel6.Caption := Langtostr(560);
  IWLabel5.Caption := Langtostr(595);


  TIWGradientLabel5.Text := Langtostr(550);
  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(189);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(597);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(598);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(190);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(599);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(600);
  TIWAdvWebGrid1.Columns[6].ButtonText := Langtostr(500);
end;

procedure TIWfrmNoticeGS.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
  ARobots.ClearRobot; //此处释放
end;

procedure TIWfrmNoticeGS.IWButton1Click(Sender: TObject);
begin
  IWRegion8.Visible := True;
  IWMemoNotice.Text := '';
end;

procedure TIWfrmNoticeGS.IWButton2Click(Sender: TObject);
begin
  IWRegion8.Visible := False;
  SendGSMessage(MSS_ADDNOTICE);
end;

procedure TIWfrmNoticeGS.IWButton3Click(Sender: TObject);
begin
  SendGSMessage(MSS_RELOADNOTICE);
end;

procedure TIWfrmNoticeGS.IWButton4Click(Sender: TObject);
begin
   IWRegion9.Visible := True;
end;

procedure TIWfrmNoticeGS.IWButton5Click(Sender: TObject);
begin
  inherited;
  IWRegion8.Visible := False;
end;

procedure TIWfrmNoticeGS.IWButton6Click(Sender: TObject);
var
  i: Integer;
  parr: PTAutoRunRecord;
  psld: PTServerListData;
begin
  inherited;
   IWRegion9.Visible := False;
   SetControlEnabled(False);
   for I := TIWAdvWebGrid1.TotalRows - 1 downto 0 do
   begin
     if (TIWAdvWebGrid1.RowSelect[I]) then
     begin
        psld := GetServerListData(TIWAdvWebGrid1.Cells[1,I]);
        if psld <> nil then
        begin
          parr := ARobots.Find(TIWAdvWebGrid1.Cells[2,I], psld^.spid, psld^.Index);
          if parr <> nil then
          begin
             if parr^.NumType = 1 then
             begin
               WebApplication.ShowMessage(Langtostr(570));
               SetControlEnabled(True);
               Exit;
             end;
             parr^.NumType:= 2;
             parr^.dNextRun := pEDate.Date + pETime.Time;
             IWServerController.SetRobotMessage(parr^.spid,parr^.ServerIdx, parr^.MsgType,parr^.NumType, parr^.RunTick, parr^.sdata, parr^.dNextRun);
             IWMemoSuccessLog.Lines.Add(Format(Langtostr(571), [DateTimeToStr(Now)]));
          end;
        end;
     end;
   end;
   TIWAdvWebGrid1.ClearRowSelect;
   IWTimerResult.Enabled := False;
   IWTimerResult.Enabled := True;
end;

procedure TIWfrmNoticeGS.IWButton7Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := not TIWclbServers.Selected[I];
end;

procedure TIWfrmNoticeGS.IWButton8Click(Sender: TObject);
begin
  inherited;
  IWRegion9.Visible := False
end;

procedure TIWfrmNoticeGS.IWButton9Click(Sender: TObject);
begin
  inherited;
  ARobots.ClearRobot; //此处释放
  SendGSMessage(MSS_GET_NOTICESTR);
end;

procedure TIWfrmNoticeGS.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmNoticeGS.IWCheckBox2Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWAdvWebGrid1.TotalRows do
    TIWAdvWebGrid1.RowSelect[I] := IWCheckBox2.Checked;
end;

procedure TIWfrmNoticeGS.IWTimerResultTimer(Sender: TObject);
const
  SuccessStr: array [0 .. 1] of Integer = (572,573);
  ResultStr = '%d<%s> %s';
var
  StrResult: string;
  procedure AddLog(str: string);
  begin
    if str[1] = '0' then
    begin
      IWMemoSuccessLog.Lines.Add(Format(GSLogInfo, [DateTimeToStr(Now),
        Copy(str, 2, Length(str) - 1)]));
      Inc(SuccessCount);
    end
    else
    begin
      IWMemoFailLog.Lines.Add(Format(GSLogInfo, [DateTimeToStr(Now),
        Copy(str, 2, Length(str) - 1)]));
      Inc(FailCount);
    end;
  end;
  function GetGSMessage(AppID: string): string;
  var
    Idx, IsSuccess,iServerIndex: Integer;
    ServerName,sData,sStr: string;
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
        sStr := GSMsgList.Strings[Idx];
        iServerIndex := StrToInt(Copy(sStr,1,Pos('|',sStr)-1));
        sData := Copy(sStr,Pos('|',sStr)+1,Length(sStr));
        ServerName := GetServerListNameEx(iServerIndex);
        if pDefMsg <> nil then
        begin
          if pDefMsg^.Tag > 1 then pDefMsg^.Tag := 1;
          case pDefMsg^.Ident of
            //返回刷新公告结果(tag为0表示成功,否则表示失败，当失败时数据段为编码后的错误描述字符串)
            MCS_RELOADNOTICE_RET:
            begin
              if pDefMsg^.Tag = 0 then IsSuccess := 0;
              Result := Format(ResultStr,[IsSuccess,ServerName,Langtostr(574) + Langtostr(SuccessStr[pDefMsg^.Tag])]);
            end;
            //返回添加公告结果(tag为0表示成功)
            MCS_ADDNOTICE_RET:
            begin
              if pDefMsg^.Tag = 0 then  IsSuccess := 0;

              New(parr);
              ZeroMemory(parr, sizeof(parr^));
              parr.spid := spid;
              parr.ServerIdx:= Idx;
              parr.MsgType := GetMsgTypeValue;
              parr.sdata := TrimRight(IWMemoNotice.Lines.Text);
              parr.NumType := 0;
              parr.dNextRun := pSDate.Date + pSTime.Time;
              parr.RunTick := TIWNoticeTime.Value;
              ARobots.add(parr);

              Result := Format(ResultStr,[IsSuccess,ServerName,Langtostr(575) + Langtostr(SuccessStr[pDefMsg^.Tag])]);
            end;
            //返回删除公告结果(tag为0表示成功，1表示不存在此公告内容)
            MCS_DELNOTICE_RET:
            begin
              if pDefMsg^.Tag = 0 then
              begin
                IsSuccess := 0;
              end;
              Result := Format(ResultStr,[IsSuccess,ServerName,Langtostr(576) + Langtostr(SuccessStr[pDefMsg^.Tag])]);
            end;
            MCS_RETURN_NOTICESTR:
            begin
              if pDefMsg^.Tag = 0 then IsSuccess := 0;

              New(parr);
              ZeroMemory(parr, sizeof(parr^));
              parr.spid := spid;
              parr.ServerIdx:= iServerIndex;
              parr.MsgType := pDefMsg^.Series;
              parr.sdata := sData;
              parr.NumType := 0;
              parr.dNextRun := Now;
              parr.RunTick := pDefMsg^.Param;
              ARobots.add(parr);

              Result := Format(ResultStr,[IsSuccess,ServerName,Langtostr(577) + Langtostr(SuccessStr[pDefMsg^.Tag])]);
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
      IWMemoSuccessLog.Lines.Add(Format(langtostr(541), [DateTimeToStr(Now), SuccessCount, FailCount]));
    end;
    SuccessCount := 0;
    FailCount := 0;
    IWTimerResult.Enabled := False;
    SetControlEnabled(True);
    LoadNoticeFile;
  end;
end;

procedure TIWfrmNoticeGS.LoadMsgType;
begin
  TIWCLBoxMsgType.Items.Clear;
  TIWCLBoxMsgType.Items.AddObject(Langtostr(578), TObject(1));
  TIWCLBoxMsgType.Items.AddObject(Langtostr(579), TObject(2));
  TIWCLBoxMsgType.Items.AddObject(Langtostr(580), TObject(4));
  TIWCLBoxMsgType.Items.AddObject(Langtostr(581), TObject(8));
  TIWCLBoxMsgType.Items.AddObject(Langtostr(582), TObject(16));
  TIWCLBoxMsgType.Items.AddObject(Langtostr(583), TObject(32));
  TIWCLBoxMsgType.Items.AddObject(Langtostr(584), TObject(64));
  TIWCLBoxMsgType.Items.AddObject(Langtostr(585), TObject(128));
end;

procedure TIWfrmNoticeGS.LoadNoticeFile;
var
  I, Idx, iCount: Integer;
  sMessage, msgstr, strdat, strdate: string;
  parr: PTAutoRunRecord;
begin
  TIWAdvWebGrid1.ClearCells;
  iCount := 0;
  TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;

  for I := 0 to ARobots.FileAutoList.Count - 1 do
  begin
    parr := PTAutoRunRecord(ARobots.FileAutoList.Items[i]);
    if parr <> nil then
    begin
      if parr^.NumType in [0..2] then
      begin
        Idx      := parr^.ServerIdx;
        sMessage := parr^.sdata;
        msgstr   := MsgTypestr(parr^.MsgType);
        strdat   := RobotTypestr(parr^.NumType);
        strdate  := FormatDateTime('YYYY-MM-DD hh:mm:ss',parr^.dNextRun);
        if ((nServerIndex = 0) and (parr^.spid = spID)) or ((Idx = nServerIndex) and (parr^.spid = spID)) then
        begin
          TIWAdvWebGrid1.TotalRows := TIWAdvWebGrid1.RowCount + iCount;
          TIWAdvWebGrid1.Cells[1, iCount] := GetServerListName(spID, Idx);
          TIWAdvWebGrid1.Cells[2, iCount] := sMessage;
          TIWAdvWebGrid1.Cells[3, iCount] := msgstr;
          TIWAdvWebGrid1.Cells[4, iCount] := strdat;
          TIWAdvWebGrid1.Cells[5, iCount] := strdate;
          Inc(iCount);
        end;
      end;
    end;
  end;
  TIWAdvWebGrid1.TotalRows := iCount;

  TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(586),[TIWAdvWebGrid1.TotalRows]);
end;

procedure TIWfrmNoticeGS.SendGSDelNotice(ServerIndex,Index: Integer;
  sMessage: string);
var
  SID: Integer;
  m_Server: TGSConnection;
begin
  m_Server := FGSMServer.GetServerByIndex(spID,ServerIndex);
  if m_Server <> nil then
  begin
    SID := SessionIDList.IndexOf(WebApplication.AppID);
    m_Server.SendDelNotice(SID,sMessage);
  end
  else
    IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),Langtostr(543)+GetServerListName(spID,ServerIndex)+Langtostr(544)]));
end;

procedure TIWfrmNoticeGS.SendGSMessage(const MessageID: Integer);
var
  I,Idx,SID: Integer;
  m_Server: TGSConnection;
  BoOpenSend: Boolean;
  parr: PTAutoRunRecord;
begin
  case MessageID of
    MSS_ADDNOTICE:
      begin
         if (IWMemoNotice.Text = '') then
         begin
           WebApplication.ShowMessage(Langtostr(587));
           Exit;
         end;
         if GetMsgTypeValue = 0 then
         begin
           WebApplication.ShowMessage(Langtostr(588));
           Exit;
         end;
      end;
  end;
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

          m_Server := FGSMServer.GetServerByIndex(spID,Idx);
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
                parr.MsgType := GetMsgTypeValue;
                parr.sdata := TrimRight(IWMemoNotice.Lines.Text);
                parr.NumType := 1;
                parr.dNextRun := pSDate.Date + pSTime.Time;
                parr.RunTick := TIWNoticeTime.Value;
                ARobots.add(parr);
                IWServerController.SetRobotMessage(parr^.spid, parr^.ServerIdx, parr^.MsgType, parr^.NumType, parr^.RunTick, parr^.sdata, parr^.dNextRun);
                IWTimerResult.Enabled := False;
                IWTimerResult.Enabled := True;
                BoOpenSend:= False;
              end;

              if BoOpenSend then
              case MessageID of
                MSS_ADDNOTICE:
                  begin
                    m_Server.SendAddNotice(SID, GetMsgTypeValue, TIWNoticeTime.Value, TrimRight(IWMemoNotice.Lines.Text));
                  end;
                MSS_DELNOTICE:
                  begin
                    m_Server.SendDelNotice(SID, Trim(IWMemoNotice.Lines.Text));
                  end;
                MSS_RELOADNOTICE:
                  begin
                    m_Server.SendReloadNotice(SID);
                  end;
                MSS_GET_NOTICESTR:
                  begin
                    m_Server.SendGetNoticeStr(SID);
                  end;
              end;
            end;
          end
          else begin
            Inc(FailCount);
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
  IWTimerResult.Enabled := False;
  IWTimerResult.Enabled := True;
end;

procedure TIWfrmNoticeGS.SetControlEnabled(OnOff: Boolean);
begin
  TIWclbServers.ReadOnly := not OnOff;
  IWMemoNotice.Enabled := OnOff;
  IWButton1.Enabled := OnOff;
  IWButton3.Enabled := OnOff;
  IWButton4.Enabled := OnOff;
  TIWAdvWebGrid1.Enabled := OnOff;
end;

procedure TIWfrmNoticeGS.TIWAdvWebGrid1ButtonClick(Sender: TObject; RowIndex,
  ColumnIndex: Integer);
var
  i: Integer;
  psld: PTServerListData;
begin
  inherited;
  case ColumnIndex of
    6: //删除
    begin
      SetControlEnabled(False);
      for I := TIWAdvWebGrid1.TotalRows - 1 downto 0 do
      begin
        if (TIWAdvWebGrid1.RowSelect[I]) then
        begin
          psld := GetServerListData(TIWAdvWebGrid1.Cells[1,I]);
          if psld <> nil then
          begin
            if TIWAdvWebGrid1.Cells[4,I] = RobotTypestr(0) then
            begin
               SendGSDelNotice(psld^.Index,I, TIWAdvWebGrid1.Cells[2,I]);
            end;
            ARobots.Delete(TIWAdvWebGrid1.Cells[2,I], psld^.Index);
            IWServerController.SetRobotMessage(spID,psld^.Index, 0, 103, 0, TIWAdvWebGrid1.Cells[2,I], Now);
          end
          else
          begin
             IWMemoFailLog.Lines.Add(Format(GSLogInfo,[DateTimeToStr(Now),Langtostr(543)+GetServerListName(spID,psld^.Index)+Langtostr(544)]));
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
  RegisterClass(TIWfrmNoticeGS);

end.
