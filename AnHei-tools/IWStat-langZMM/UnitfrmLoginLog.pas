unit UnitfrmLoginLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompEdit, IWCompListbox, IWCompButton, IWTMSCal,
  IWWebGrid, IWAdvWebGrid, Menus, IWTMSPopup,
  DateUtils, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = 83;//'µÇÂ½ÈÕÖ¾';

type
  PTLoginLogData = ^TLoginLogData;
  TLoginLogData = record
    sName: string;
    sAccount : string;
    sIP: string;
    iServerIndex: Integer;
    sLoginTime: string;
  end;

  TIWfrmLoginLog = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel3: TIWLabel;
    DTStart: TTIWDateSelector;
    IWLabel4: TIWLabel;
    DTEnd: TTIWDateSelector;
    IWbtTrace: TIWButton;
    CBType: TIWComboBox;
    EditHumName: TIWEdit;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    TIWPopupMenuButton1: TTIWPopupMenuButton;
    PopupMenu1: TPopupMenu;
    H1: TMenuItem;
    L1: TMenuItem;
    procedure H1Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure IWbtTraceClick(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    LoginLogList: TStrings;
    procedure ClearLoginLogData;
  public
    procedure QueryLoginLog(spid: string;ServerIndex: Integer;sHumName: string; DateStart, DateEnd: TDateTime);
  end;

var
  IWfrmLoginLog: TIWfrmLoginLog;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmLoginLog.ClearLoginLogData;
var
  I: Integer;
begin
  for I := 0 to LoginLogList.Count - 1 do
  begin
    System.DisPose(PTLoginLogData(LoginLogList.Objects[I]));
  end;
  LoginLogList.Clear;
end;

procedure TIWfrmLoginLog.H1Click(Sender: TObject);
var
  iRow: Integer;
  sHumName: string;
begin
  iRow := TIWAdvWebGrid1.RowOffset+TIWAdvWebGrid1.RadioSelection;
  if iRow <> -1 then
  begin
    sHumName := GetCellName(TIWAdvWebGrid1.Cells[3,iRow]);
    ShowLoginLog(1,sHumName,DTStart.Date,DTEnd.Date);
  end;
end;

procedure TIWfrmLoginLog.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  DTStart.Date := Date();
  DTEnd.Date := Date();
  LoginLogList := TStringList.Create;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  CBType.Items.Clear;
  CBType.Items.Delimiter := ',';
  CBType.Items.DelimitedText := Langtostr(460);
  if PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]).Index = 0 then
  begin
    CBType.Items.Delimiter := ',';
    CBType.Items.DelimitedText := Langtostr(461);
  end;
  CBType.ItemIndex := 0;
  IWRegion1.Visible := True;

  IWLabel3.Caption := Langtostr(150);
  IWLabel4.Caption := Langtostr(151);
  IWbtTrace.Caption := Langtostr(14);
  TIWPopupMenuButton1.Caption := Langtostr(447);

  H1.Caption := Langtostr(463);
  L1.Caption := Langtostr(448);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(464);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(465);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(257);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(189);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(466);
end;

procedure TIWfrmLoginLog.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
  ClearLoginLogData;
  LoginLogList.Free;
end;

procedure TIWfrmLoginLog.IWbtTraceClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if DayOf(DTEnd.Date)-DayOf(DTStart.Date) >= 7 then
  begin
    WebApplication.ShowMessage(Langtostr(436));
    Exit;
  end;
  if EditHumName.Text = '' then
  begin
    WebApplication.ShowMessage(Langtostr(462));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    if psld.Index <> 0 then
    begin
      if psld.OpenTime = '' then
      begin
        Exit;
      end;
      if DTStart.Date < StrToDateTime(psld.OpenTime) then
      begin
        DTStart.Date := StrToDateTime(psld.OpenTime);
      end;
      if DTEnd.Date < StrToDateTime(psld.OpenTime) then
      begin
        DTEnd.Date := StrToDateTime(psld.OpenTime);
      end;
    end;
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    TIWAdvWebGrid1.RadioSelection := -1;
    TIWAdvWebGrid1.RowOffset := 0;
    try
      QueryLoginLog(psld.spID,psld.Index,EditHumName.Text, DTStart.Date, DTEnd.Date );
    finally
      UserSession.SQLConnectionLog.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmLoginLog.L1Click(Sender: TObject);
var
  iRow: Integer;
  sHumName: string;
begin
  iRow := TIWAdvWebGrid1.RowOffset+TIWAdvWebGrid1.RadioSelection;
  if iRow <> -1 then
  begin
    sHumName := GetCellName(TIWAdvWebGrid1.Cells[1,iRow]);
    if sHumName = EditHumName.Text then Exit;
    ShowHumlog(sHumName,'',DTStart.Date,DTEnd.Date);
  end;
end;

procedure TIWfrmLoginLog.QueryLoginLog(spid: string;ServerIndex: Integer;sHumName: string; DateStart,
  DateEnd: TDateTime);
const
  sQueryFormatName =
  'select logindescr,account,loginip,serverindex,logdate '
  + 'from log_login_%s where logid = 7 and logindescr=%s order by logdate';
  sQueryFormatIP =
  'select logindescr,account,loginip,serverindex,logdate '
  + 'from log_login_%s where logid = 7 and  loginip="%s" order by logdate';
  sQueryFormatACC =
  'select logindescr,account,loginip,serverindex,logdate '
  + 'from log_login_%s where logid = 7 and  account=%s order by logdate';
var
  I,iCount,Index: Integer;
  sDate: string;
  LoginLogData: PTLoginLogData;
begin
  iCount := 0;
  ClearLoginLogData;
  if DateEnd > Now then DateEnd := Now;
  while DateStart <= DateEnd do
  begin
    sDate := DateToStr(DateStart);
    sDate := FormatDateTime('yyyymmdd', DateStart);
    with UserSession.quLoginLog do
    begin
      Index := CBType.ItemIndex;
      if CBType.Items.Count = 2 then Inc(Index);
      case Index of
        0:SQL.Text := Format(sQueryFormatName,[sDate, QuerySQLStr(sHumName)]);
        1:SQL.Text := Format(sQueryFormatACC,[sDate, QuerySQLStr(sHumName)]);
        2:SQL.Text := Format(sQueryFormatIP,[sDate, sHumName]);
      end;
      Open;
      try
        First;
        while not Eof do
        begin
          Inc(iCount);
          New(LoginLogData);
          LoginLogData.sName := Utf8ToString(Fields[0].AsAnsiString);
          LoginLogData.sAccount := Utf8ToString(Fields[1].AsAnsiString);
          LoginLogData.sIP := Fields[2].AsString;
          LoginLogData.iServerIndex := Fields[3].AsInteger;
          LoginLogData.sLoginTime := DateTimeToStr(Fields[4].AsDateTime);
          LoginLogList.AddObject(IntToStr(iCount),TObject(LoginLogData));
          Next;
        end;
      finally
        Close;
      end;
    end;
    DateStart := DateStart + 1;
  end;
  with TIWAdvWebGrid1 do
  begin
    TotalRows := LoginLogList.Count;
    if LoginLogList.Count < objINI.MaxPageCount then
    begin
      RowCount := LoginLogList.Count;
    end
    else
    begin
      RowCount := objINI.MaxPageCount;
    end;
    for I := 0 to iCount - 1 do
    begin
      LoginLogData := PTLoginLogData(LoginLogList.Objects[I]);
      Cells[1,I] := LoginLogData.sName;
      Cells[2,I] := LoginLogData.sAccount;
      Cells[3,I] := LoginLogData.sIP;
      Cells[4,I] := GetServerListName(spid,LoginLogData.iServerIndex);
      Cells[5,I] := LoginLogData.sLoginTime;
    end;
    Controller.Caption := Format(Langtostr(453),[LoginLogList.Count]);
  end;
end;

initialization
  RegisterClass(TIWfrmLoginLog);

end.
