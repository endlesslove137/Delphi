unit UnitfrmBugInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWTMSCal,
  IWWebGrid, IWAdvWebGrid, IWTMSEdit;

type
  TIWfrmBugInfo = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    TIWAdvWebGridBug: TTIWAdvWebGrid;
    IWRegionQueryTop: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWButton1: TIWButton;
    IWLabel2: TIWLabel;
    IWedtAccount: TIWEdit;
    IWButton2: TIWButton;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    pETime: TTIWAdvTimeEdit;
    IWcbType: TIWComboBox;
    IWLabel4: TIWLabel;
    IWLabel5: TIWLabel;
    IWEditTitle: TIWEdit;
    IWLabel6: TIWLabel;
    IWcbState: TIWComboBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure TIWAdvWebGridBugLinkClick(Sender: TObject; RowIndex,
      ColumnIndex: Integer);
    procedure TIWAdvWebGridBugButtonClick(Sender: TObject; RowIndex,
      ColumnIndex: Integer);
    procedure IWButton2Click(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
  private
    procedure LoadBugInfoState;
    procedure LoadBugInfoType;
  public
    function BuildSQL(sgstatic:string): string;
    procedure QueryBugInfo;
    procedure DeleteBugInfo(BugID: Integer);
  end;

var
  IWfrmBugInfo: TIWfrmBugInfo;

implementation

uses ConfigINI, ServerController, UnitfrmAddBugInfo, UnitfrmViewBugInfo;

{$R *.dfm}

function TIWfrmBugInfo.BuildSQL(sgstatic:string): string;
const
  sqlBugInfo = 'SELECT a.*,b.typename,(SELECT COUNT(1) FROM %s.bugreply WHERE bugid=a.bugid) AS replycount FROM %s.buginfo a LEFT JOIN %s.bugtype b ON a.bugtype=b.typeid WHERE createtime>="%s" and createtime<="%s" ';
begin
  Result := Format(sqlBugInfo,[sgstatic,sgstatic,sgstatic,DateTimeToStr(pSDate.Date+pSTime.Time),DateTimeToStr(pEDate.Date+pETime.Time)]);
  if IWEditTitle.Text <> '' then
  begin
    Result := Result + ' and title like "%'+QuerySQLStr(IWEditTitle.Text)+'%" and html like "%'+QuerySQLStr(IWEditTitle.Text)+'%"';
  end;
  if IWedtAccount.Text <> '' then
  begin
    Result := Result + Format(' and publish=%s',[QuerySQLStr(IWedtAccount.Text)]);
  end;
  if IWcbType.ItemIndex > 0 then
  begin
    Result := Result + Format(' and bugtype=%d',[Integer(IWcbType.Items.Objects[IWcbType.ItemIndex])]);
  end;
  if IWcbState.ItemIndex > 0 then
  begin
    Result := Result + Format(' and state=%d',[Integer(IWcbState.Items.Objects[IWcbState.ItemIndex])]);
  end;
  Result := Result + ' ORDER BY a.createTime DESC';
end;

procedure TIWfrmBugInfo.DeleteBugInfo(BugID: Integer);
const
  sqlDelReply = 'DELETE FROM %s.bugreply WHERE bugid=%d';
  sqlAttachment = 'SELECT * FROM %s.bugattachment WHERE bugid=%d';
  sqlDelAttachment = 'DELETE FROM %s.bugattachment WHERE bugid=%d';
  sqlDelBugInfo = 'DELETE FROM %s.buginfo WHERE bugid=%d';
var
  sPath: string;
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      with UserSession.quBugInfo do
      begin
        SQL.Text := Format(sqlDelReply,[psld.GstaticDB,BugID]);
        ExecSQL;
        Close;
        SQL.Text := Format(sqlAttachment,[psld.GstaticDB,BugID]);
        Open;
        while not Eof do
        begin
          sPath := AppPathEx+FieldByName('attachment').AsString;
          if FileExists(sPath) then
          begin
            DeleteFile(sPath);
          end;
          Next;
        end;
        Close;
        SQL.Text := Format(sqlDelAttachment,[psld.GstaticDB,BugID]);
        ExecSQL;
        Close;
        SQL.Text := Format(sqlDelBugInfo,[psld.GstaticDB,BugID]);
        ExecSQL;
        Close;
      end;
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

procedure TIWfrmBugInfo.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := StrToDate('2011-07-01');
  pEDate.Date := Date;
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(LangToStr(StatToolButtonStr[tbBugInfo]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + LangToStr(StatToolButtonStr[tbBugInfo]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),LangToStr(StatToolButtonStr[tbBugInfo])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  LoadBugInfoState;
  LoadBugInfoType;
  IWcbType.Items.InsertObject(0,LangToStr(337),TObject(-1));
  IWcbType.ItemIndex := 0;

  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel5.Caption := Langtostr(470);
  IWLabel4.Caption := Langtostr(471);
  IWLabel2.Caption := Langtostr(472);
  IWLabel6.Caption := Langtostr(473);
  IWBtnBuild.Caption := Langtostr(14);
  IWButton1.Caption := Langtostr(182);
  IWButton2.Caption := Langtostr(474);

  TIWAdvWebGridBug.Columns[1].Title:= Langtostr(475);
  TIWAdvWebGridBug.Columns[2].Title:= Langtostr(476);
  TIWAdvWebGridBug.Columns[3].Title:= Langtostr(258);
  TIWAdvWebGridBug.Columns[4].Title:= Langtostr(477);
  TIWAdvWebGridBug.Columns[5].Title:= Langtostr(190);
  TIWAdvWebGridBug.Columns[6].Title:= Langtostr(478);
end;

procedure TIWfrmBugInfo.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryBugInfo;
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

procedure TIWfrmBugInfo.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'BugInfo' + DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGridBug.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmBugInfo.IWButton2Click(Sender: TObject);
begin
  inherited;
  Move(TIWfrmAddBugInfo).Show;
end;

procedure TIWfrmBugInfo.LoadBugInfoState;
var
  I: Integer;
begin
  IWcbState.Items.AddObject(LangToStr(337),TObject(-1));

  for I := Low(TBugInfoStateStr) to High(TBugInfoStateStr) do
  begin
    IWcbState.Items.Add(Langtostr(TBugInfoStateStr[I]));
  end;
  IWcbState.ItemIndex := 1;
end;

procedure TIWfrmBugInfo.LoadBugInfoType;
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      BugTypeList.Clear;
      with UserSession.quBugInfo do
      begin
        SQL.Text := 'SELECT * FROM '+psld.GstaticDB+'.bugtype';
        Open;
        while not Eof do
        begin
          BugTypeList.AddObject(Utf8ToString(Fields[1].AsAnsiString),TObject(Fields[0].AsInteger));
          Next;
        end;
        Close;
      end;
      IWcbType.Items.Clear;
      IWcbType.Items.AddStrings(BugTypeList);
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

procedure TIWfrmBugInfo.QueryBugInfo;
var
  iCount: Integer;
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    TIWAdvWebGridBug.Columns[7].Visible := UserSession.UserName = AdminUser;
    with UserSession.quBugInfo,TIWAdvWebGridBug do
    begin
      iCount := 0;
      ClearCells;
      RowCount := objINI.MaxPageCount;
      SQL.Text := BuildSQL(psld.GstaticDB);
      Open;
      while not Eof do
      begin
        TotalRows := RowCount+iCount;
        cells[0,iCount] := IntToStr(FieldByName('bugid').AsInteger);
        cells[1,iCount] := Utf8ToString(FieldByName('typename').AsAnsiString);
        cells[2,iCount] := Utf8ToString(FieldByName('title').AsAnsiString);
        cells[3,iCount] := FieldByName('createtime').AsString;
        cells[4,iCount] := Utf8ToString(FieldByName('publish').AsAnsiString);
        cells[5,iCount] := Langtostr(TBugInfoStateStr[FieldByName('state').AsInteger]);
        cells[6,iCount] := IntToStr(FieldByName('replycount').AsInteger);
        Inc(iCount);
        Next;
      end;
      TotalRows := iCount;
      Close;
      Controller.Caption := Format('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>%s</b>£º¹² %d ¸ö¼ÇÂ¼',[Langtostr(StatToolButtonStr[tbBugInfo]),TotalRows]);
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmBugInfo.TIWAdvWebGridBugButtonClick(Sender: TObject; RowIndex,
  ColumnIndex: Integer);
var
  BugID: Integer;
begin
  inherited;
  BugID := StrToInt(TIWAdvWebGridBug.Cells[0,RowIndex]);
  case ColumnIndex of
    7: //±à¼­
    begin
      if (TIWAdvWebGridBug.Cells[4,RowIndex] = UserSession.UserName) or
         (UserSession.UserName = AdminUser) then
      begin
        with Move(TIWfrmAddBugInfo,False) as TIWfrmAddBugInfo do
        begin
          IsAdd := False;
          GetBugInfo(BugID);
          Show;
        end;
      end
      else begin
        WebApplication.ShowMessage(LangToStr(467));
      end;
    end;
    8: //É¾³ý
    begin
      DeleteBugInfo(BugID);
      IWBtnBuild.OnClick(self);
    end;
  end;
end;

procedure TIWfrmBugInfo.TIWAdvWebGridBugLinkClick(Sender: TObject; RowIndex,
  ColumnIndex: Integer);
var
  iBugID: Integer;
begin
  inherited;
  case ColumnIndex of
    2:
    begin
      iBugID := StrToInt(TIWAdvWebGridBug.Cells[0,RowIndex]);
      with Move(TIWfrmViewBugInfo,False) as TIWfrmViewBugInfo do
      begin
        ViewBugInfo(iBugID);
        Show;
      end;
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmBugInfo);

end.
