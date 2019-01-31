unit UnitfrmItemTrace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompEdit, IWCompListbox, IWCompButton, IWTMSCal,
  IWWebGrid, IWAdvWebGrid, Menus, IWTMSPopup, DateUtils,
  IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompCheckbox;

const
  curTitle = 88;//'物品追踪';

type
  TIWfrmItemTrace = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel3: TIWLabel;
    DTStart: TTIWDateSelector;
    IWLabel4: TIWLabel;
    DTEnd: TTIWDateSelector;
    IWbtTrace: TIWButton;
    IWRegion3: TIWRegion;
    IWLabel1: TIWLabel;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    PopupMenu1: TPopupMenu;
    L1: TMenuItem;
    T1: TMenuItem;
    TIWPopupMenuButton1: TTIWPopupMenuButton;
    EditItemId: TTIWAdvEdit;
    IWLogMode: TIWCheckBox;
    procedure T1Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure IWbtTraceClick(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    ItemTraceList: TStrings;
    procedure ClearItemTraceListData;
  public
    procedure QueryItemLog(ServerIndex: Integer; ItemId: string; DateStart, DateEnd: TDateTime);
    procedure QueryItemLogEx(ispid, ServerIndex: Integer; ItemId: string; DateStart, DateEnd: TDateTime);
    procedure SetWebGridData;
  end;

var
  IWfrmItemTrace: TIWfrmItemTrace;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmItemTrace.ClearItemTraceListData;
var
  I: Integer;
begin
  for I := 0 to ItemTraceList.Count - 1 do
  begin
    System.DisPose(PTLogRecord(ItemTraceList.Objects[I]));
  end;
  ItemTraceList.Clear;
end;

procedure TIWfrmItemTrace.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  DTStart.Date := Date();
  DTEnd.Date := Date();
  ItemTraceList := TStringList.Create;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel1.Caption := Langtostr(488);
  IWLabel3.Caption := Langtostr(150);
  IWLabel4.Caption := Langtostr(151);
  IWLogMode.Caption := Langtostr(183);
  IWbtTrace.Caption := Langtostr(14);

  TIWPopupMenuButton1.Caption := Langtostr(447);

  L1.Caption := Langtostr(448);
  T1.Caption := Langtostr(450);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(439);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(457);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(402);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(455);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(456);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(403);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(404);
  TIWAdvWebGrid1.Columns[8].Title:= Langtostr(459);
  TIWAdvWebGrid1.Columns[9].Title:= Langtostr(458);
end;

procedure TIWfrmItemTrace.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
  ClearItemTraceListData;
  ItemTraceList.Free;
end;

procedure TIWfrmItemTrace.IWbtTraceClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if Trim(EditItemId.Text) = '' then
  begin
    WebApplication.ShowMessage(Langtostr(483));
    Exit;
  end;
  if DayOf(DTEnd.Date)-DayOf(DTStart.Date) >= 7 then
  begin
    WebApplication.ShowMessage(Langtostr(436));
    Exit;
  end;
  try
    TIWAdvWebGrid1.RadioSelection := -1;
    TIWAdvWebGrid1.RowOffset := 0;
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
    if not IWLogMode.Checked then
    begin
      UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
      try
        QueryItemLog(psld.Index, EditItemId.Text, DTStart.Date, DTEnd.Date);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //新模式
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        QueryItemLogEx(psld.Ispid, psld.Index, EditItemId.Text, DTStart.Date, DTEnd.Date);
      finally
        UserSession.SQLConnectionLocalLog.Close;
      end;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmItemTrace.L1Click(Sender: TObject);
var
  iRow: Integer;
  sHumName: string;
begin
  iRow := TIWAdvWebGrid1.RowOffset+TIWAdvWebGrid1.RadioSelection;
  if iRow <> -1 then
  begin
    sHumName := GetCellName(TIWAdvWebGrid1.Cells[1,iRow]);
    ShowHumlog(sHumName,GetCellName(TIWAdvWebGrid1.Cells[6,iRow]),DTStart.Date,DTEnd.Date);
  end;
end;

procedure TIWfrmItemTrace.QueryItemLog(ServerIndex: Integer; ItemId: string; DateStart,
  DateEnd: TDateTime);
const
  sQueryFormat =
  'select Logid,Account,Para0,Para1,Para2,LongStr0,LongStr1,LongStr2,logdate '
  + 'from log_common_%s where serverindex=%d AND LongStr1="%s" order by logdate';
var
  sDate: string;
  pRec: PTLogRecord;
begin
  ClearItemTraceListData;
  if DateEnd > Now then DateEnd := Now;
  while DateStart <= DateEnd do
  begin
    sDate := DateToStr(DateStart);
    sDate := FormatDateTime('yyyymmdd', DateStart);
    with UserSession.quItemTrace do
    begin
      SQL.Text := Format(sQueryFormat,[sDate,ServerIndex, ItemId]);
      Open;
      try
        First;
        while not Eof do
        begin
          New(pRec);
          pRec.nIdent := Fields[0].AsInteger;
          pRec.sSender := Utf8ToString(Fields[1].AsAnsiString);
          pRec.nType := Fields[2].AsInteger;
          pRec.nChange := Fields[3].AsInteger;
          pRec.nCount := Fields[4].AsInteger;
          pRec.sRemark := Utf8ToString(Fields[5].AsAnsiString);
          pRec.sObjId := Fields[6].AsString;
          pRec.sObjName := Utf8ToString(Fields[7].AsAnsiString);
          pRec.sDate := Fields[8].AsString;
          ItemTraceList.AddObject('',TObject(pRec));
          Next;
        end;
      finally
        Close;
      end;
    end;
    DateStart := DateStart + 1;
  end;
  TIWAdvWebGrid1.TotalRows := ItemTraceList.Count;
  if ItemTraceList.Count < objINI.MaxPageCount then
  begin
    TIWAdvWebGrid1.RowCount := ItemTraceList.Count;
  end
  else
  begin
    TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;
  end;
  SetWebGridData;
  TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共 %d 个记录&nbsp;&nbsp;',[ItemTraceList.Count]);
end;

procedure TIWfrmItemTrace.QueryItemLogEx(ispid, ServerIndex: Integer; ItemId: string; DateStart,
  DateEnd: TDateTime);
const
  sQueryFormat =
  'select Logid,Account,Para0,Para1,Para2,LongStr0,LongStr1,LongStr2,logdate from log_common_%d_%d_%s where serverindex=%d AND LongStr1= "%s" order by logdate';
var
  sDate: string;
  pRec: PTLogRecord;
begin
  ClearItemTraceListData;
  if DateEnd > Now then DateEnd := Now;
  while DateStart <= DateEnd do
  begin
    sDate := DateToStr(DateStart);
    sDate := FormatDateTime('yyyymmdd', DateStart);
    with UserSession.quItemTraceEx do
    begin
      SQL.Text := Format(sQueryFormat,[ispid, ServerIndex, sDate,ServerIndex, ItemId]);
      Open;
      try
        First;
        while not Eof do
        begin
          New(pRec);
          pRec.nIdent := Fields[0].AsInteger;
          pRec.sSender := Utf8ToString(Fields[1].AsAnsiString);
          pRec.nType := Fields[2].AsInteger;
          pRec.nChange := Fields[3].AsInteger;
          pRec.nCount := Fields[4].AsInteger;
          pRec.sRemark := Utf8ToString(Fields[5].AsAnsiString);
          pRec.sObjId := Fields[6].AsString;
          pRec.sObjName := Utf8ToString(Fields[7].AsAnsiString);
          pRec.sDate := Fields[8].AsString;
          ItemTraceList.AddObject('',TObject(pRec));
          Next;
        end;
      finally
        Close;
      end;
    end;
    DateStart := DateStart + 1;
  end;
  TIWAdvWebGrid1.TotalRows := ItemTraceList.Count;
  if ItemTraceList.Count < objINI.MaxPageCount then
  begin
    TIWAdvWebGrid1.RowCount := ItemTraceList.Count;
  end
  else
  begin
    TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;
  end;
  SetWebGridData;
  TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共 %d 个记录&nbsp;&nbsp;',[ItemTraceList.Count]);
end;

procedure TIWfrmItemTrace.SetWebGridData;
var
  I: Integer;
  pLogRec: PTLogRecord;
  sFontColor: string;
begin
  for I := 0 to ItemTraceList.Count - 1 do
  begin
    pLogRec := PTLogRecord(ItemTraceList.Objects[I]);
    sFontColor := '%s';
    TIWAdvWebGrid1.Cells[1,I] := Format(sFontColor,[pLogRec^.sSender]);
    TIWAdvWebGrid1.Cells[2,I] := Format(sFontColor,[GetLogIdentStr(pLogRec^.nIdent)]);
    TIWAdvWebGrid1.Cells[3,I] := Format(sFontColor,[IntToStr(pLogRec^.nType)]);
    TIWAdvWebGrid1.Cells[4,I] := Format(sFontColor,[IntToStr(pLogRec^.nChange)]);
    TIWAdvWebGrid1.Cells[5,I] := Format(sFontColor,[IntToStr(pLogRec^.nCount)]);
    TIWAdvWebGrid1.Cells[6,I] := Format(sFontColor,[pLogRec^.sObjName]);
    TIWAdvWebGrid1.Cells[7,I] := Format(sFontColor,[pLogRec^.sObjId]);
    TIWAdvWebGrid1.Cells[8,I] := Format(sFontColor,[pLogRec^.sRemark]);
    TIWAdvWebGrid1.Cells[9,I] := Format(sFontColor,[pLogRec^.sDate]);
  end;
end;

procedure TIWfrmItemTrace.T1Click(Sender: TObject);
var
  iRow: Integer;
  sHumName: string;
begin
  iRow := TIWAdvWebGrid1.RowOffset+TIWAdvWebGrid1.RadioSelection;
  if iRow <> -1 then
  begin
    sHumName := GetCellName(TIWAdvWebGrid1.Cells[1,iRow]);
    ShowLoginLog(0,sHumName,DTStart.Date,DTEnd.Date);
  end;
end;

initialization
  RegisterClass(TIWfrmItemTrace);

end.
