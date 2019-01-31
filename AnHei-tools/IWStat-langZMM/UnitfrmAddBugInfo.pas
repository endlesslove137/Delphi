unit UnitfrmAddBugInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWHTMLEdit,
  ImgList, IWImageList,
  IWWebGrid, IWAdvWebGrid, Classes;

const
  curTitle = 479;//'新增Bug信息';
  UpLoadDir = 'files\UploadFiles\';

type
  TIWfrmAddBugInfo = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel2: TIWLabel;
    IWCbBugType: TIWComboBox;
    IWLabel3: TIWLabel;
    IWEditTitle: TIWEdit;
    IWLabel4: TIWLabel;
    IWCbState: TIWComboBox;
    IWBtnOK: TIWButton;
    IWRegion3: TIWRegion;
    IWRegion5: TIWRegion;
    TIWHTMLEdit: TTIWHTMLEdit;
    IWRegion6: TIWRegion;
    IWButton1: TIWButton;
    IWLabel1: TIWLabel;
    IWImageList1: TIWImageList;
    TIWAdvWebGridAttachment: TTIWAdvWebGrid;
    IWFile1: TIWFile;
    procedure IWAppFormCreate(Sender: TObject);
    procedure TIWAdvWebGridAttachmentButtonClick(Sender: TObject; RowIndex,
      ColumnIndex: Integer);
    procedure IWButton1Click(Sender: TObject);
    procedure IWBtnOKClick(Sender: TObject);
  private
    iBugID: Integer;
    procedure LoadBugInfoState;
  public
    IsAdd: Boolean;
    procedure GetBugInfo(BugID: Integer);
    procedure AddAttachment(iImageIdx,iAttachment: Integer;sFileName,sPath: string);
    function DeleteAttachmentID(iID: Integer): Boolean;
    procedure LoadAttachmentList(sgstatic:string);
    function SaveAttachmentList: Boolean;
  end;

var
  IWfrmAddBugInfo: TIWfrmAddBugInfo;

implementation

uses ServerController, ConfigINI, UnitfrmBugInfo;

{$R *.dfm}

procedure TIWfrmAddBugInfo.AddAttachment(iImageIdx, iAttachment: Integer; sFileName,
  sPath: string);
begin
  with TIWAdvWebGridAttachment do
  begin
    RowCount := RowCount+1;
    TotalRows := RowCount;
    Cells[0,RowCount-1] := IntToStr(iImageIdx);
    Cells[1,RowCount-1] := sFileName;
    Cells[2,RowCount-1] := sPath;
    Cells[3,RowCount-1] := IntToStr(iAttachment);
  end;
end;

function TIWfrmAddBugInfo.DeleteAttachmentID(iID: Integer): Boolean;
var
  psld: PTServerListData;
begin
  Result := false;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      with UserSession.quBugInfo do
      begin
        SQL.Text := Format('DELETE FROM '+ psld.GstaticDB+ '.bugattachment WHERE attachmentid=%d',[iID]);
        Result := UserSession.quBugInfo.ExecSQL>0;
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

procedure TIWfrmAddBugInfo.GetBugInfo(BugID: Integer);
const
  sqlBugInfo = 'SELECT a.*,b.typename FROM %s.buginfo a LEFT JOIN %s.bugtype b ON a.bugtype=typeid WHERE bugid=%d';
var
  psld: PTServerListData;
begin
  iBugID := BugID;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      with UserSession.quBugInfo do
      begin
        SQL.Text := Format(sqlBugInfo,[psld.GstaticDB,psld.GstaticDB,iBugID]);
        Open;
        IWEditTitle.Text := Utf8ToString(FieldByName('title').AsAnsiString);
        IWCbBugType.ItemIndex := IWCbBugType.Items.IndexOf(Utf8ToString(FieldByName('typename').AsAnsiString));
        IWCbState.ItemIndex := IWCbState.Items.IndexOfObject(TObject(FieldByName('state').AsInteger));
        TIWHTMLEdit.Lines.Text := Utf8ToString(FieldByName('html').AsAnsiString);
        Close;
      end;
      LoadAttachmentList(psld.GstaticDB);
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

procedure TIWfrmAddBugInfo.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IsAdd := True;
  IWCbBugType.Items.AddStrings(BugTypeList);
  IWCbBugType.ItemIndex := 0;
  LoadBugInfoState;
  TIWHTMLEdit.Lines.Text := '';

  IWLabel3.Caption := Langtostr(470);
  IWLabel2.Caption := Langtostr(472);
  IWLabel4.Caption := Langtostr(473);

  IWBtnOK.Caption := Langtostr(484);

  TIWAdvWebGridAttachment.Columns[1].Title:= Langtostr(485);
  TIWAdvWebGridAttachment.Columns[2].Title:= Langtostr(486);
  TIWAdvWebGridAttachment.Columns[3].Title:= Langtostr(190);
  TIWAdvWebGridAttachment.Columns[4].Title:= Langtostr(487);
end;

procedure TIWfrmAddBugInfo.IWBtnOKClick(Sender: TObject);
const
  sqlAdd = 'INSERT INTO %s.buginfo(bugtype,title,html,createtime,publish,state) VALUES (%d,%s,:p1,"%s","%s",%d)';
  sqlUpdate = 'UPDATE %s.buginfo SET bugtype=%d,title=%s,html=:p1,state=%d WHERE bugid=%d';
var
  TypeID,StateID: Integer;
  psld: PTServerListData;
begin
  if Length(TIWHTMLEdit.Lines.Text) > 20000 then
  begin
    WebApplication.ShowMessage(Langtostr(480));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      with UserSession.quBugInfo do
      begin
        TypeID := Integer(IWCbBugType.Items.Objects[IWCbBugType.ItemIndex]);
        StateID := Integer(IWCbState.Items.Objects[IWCbState.ItemIndex]);
        if IsAdd then
        begin
          SQL.Text := Format(sqlAdd,[psld.GstaticDB,TypeID,QuerySQLStr(IWEditTitle.Text),DateTimeToStr(Now),QuerySQLStr(UserSession.UserName),0]);
        end
        else begin
          SQL.Text := Format(sqlUpdate,[psld.GstaticDB,TypeID,QuerySQLStr(IWEditTitle.Text),StateID,iBugID]);
        end;
        ParamByName('P1').AsString := TIWHTMLEdit.Lines.Text;
        ExecSQL;
        Close;
        if IsAdd then
        begin
          SQL.Text := 'select @@IDENTITY';
          Open;
          iBugID := Fields[0].AsInteger;
          Close;
        end;
        SaveAttachmentList;
        with (Move(TIWfrmBugInfo) as TIWfrmBugInfo) do
        begin
          IWBtnBuild.OnClick(self);
          Show;
        end;
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

function UrlEncode(const ASrc: string): string;
const
  UnsafeChars = '*#%<>+ []';  {do not localize}
var
  i: Integer;
begin
  Result := '';    {Do not Localize}
  for i := 1 to Length(ASrc) do begin
    if (AnsiPos(ASrc[i], UnsafeChars) > 0) or (ASrc[i]< #32) or (ASrc[i] > #127) then begin
      Result := Result + '%' + IntToHex(Ord(ASrc[i]), 2);  {do not localize}
    end else begin
      Result := Result + ASrc[i];
    end;
  end;
end;

procedure TIWfrmAddBugInfo.IWButton1Click(Sender: TObject);
const
  HtmlImg = '<IMG src="%s">';
var
  Icon: TIcon;
  SID: Integer;
  sFileName,sPath,sExt: string;
begin
  inherited;
  if IWFile1.Filename = '' then Exit;
  if LowerCase(ExtractFileExt(IWFile1.Filename)) = '.exe' then
  begin
    WebApplication.ShowMessage(Langtostr(481));
    Exit;
  end;
  if TIWAdvWebGridAttachment.RowCount < 7 then
  begin
    sPath := AppPathEx+UpLoadDir+FormatDateTime('YYMM',Now)+'\'+FormatDateTime('DD',Now)+'\'+UserSession.UserName+'\';
    if not DirectoryExists(sPath) then
    begin
      ForceDirectories(sPath);
    end;
    SID := SessionIDList.IndexOf(WebApplication.AppID);
    sExt := ExtractFileExt(IWFile1.Filename);
    sFileName := IntToStr(SID)+FormatDateTime('_HHMMSS',Now)+sExt;
    IWFile1.SaveToFile(sPath+sFileName);
    sPath := Copy(sPath,Pos('files\',sPath),Length(sPath));
    sPath := StringReplace(sPath,'\','/',[rfReplaceAll]);
    Icon := TIcon.Create;
    Icon.Handle := GetExtSysICon(ExtractFileExt(IWFile1.Filename));
    IWImageList1.AddIcon(Icon);
    AddAttachment(IWImageList1.Count-1,0,sFileName,'/'+sPath+sFileName);
    if (sExt = '.gif') or (sExt = '.jpeg') or (sExt = '.jpg') or (sExt = '.png') then
    begin
      sPath := AppPathEx+UpLoadDir+FormatDateTime('YYMM',Now)+'\'+FormatDateTime('DD',Now)+'\'+UrlEncode(UserSession.UserName)+'\';
      sPath := Copy(sPath,Pos('files\',sPath),Length(sPath));
      sPath := StringReplace(sPath,'\','/',[rfReplaceAll]);
      TIWHTMLEdit.Lines.Add(Format(HtmlImg,[WebApplication.ApplicationURL+'/'+sPath+sFileName]));
    end;
  end
  else begin
    WebApplication.ShowMessage(Langtostr(482));
  end;
end;

procedure TIWfrmAddBugInfo.LoadAttachmentList(sgstatic:string);
const
  sqlAttachment = 'SELECT * FROM %s.bugattachment WHERE bugid=%d';
var
  Icon: TIcon;
  sFileName: string;
begin
  with UserSession.quBugInfo do
  begin
    SQL.Text := Format(sqlAttachment,[sgstatic,iBugID]);
    Open;
    while not Eof do
    begin
      sFileName := Utf8ToString(FieldByName('filename').AsAnsiString);
      Icon := TIcon.Create;
      Icon.Handle := GetExtSysICon(ExtractFileExt(sFileName));
      IWImageList1.AddIcon(Icon);
      AddAttachment(IWImageList1.Count-1,FieldByName('attachmentid').AsInteger,sFileName,Utf8ToString(FieldByName('attachment').AsAnsiString));
      Next;
    end;
    Close;
  end;
end;

procedure TIWfrmAddBugInfo.LoadBugInfoState;
var
  I: Integer;
begin
  for I := Low(TBugInfoStateStr) to High(TBugInfoStateStr) do
  begin
    IWcbState.Items.Add(Langtostr(TBugInfoStateStr[I]));
  end;
  IWcbState.ItemIndex := 0;
end;

function TIWfrmAddBugInfo.SaveAttachmentList: Boolean;
const
  sqlInsert = 'INSERT INTO %s.bugattachment(bugid,filename,attachment) VALUES %s';
  sqlValue = '(%d,%s,%s),';
var
  I: Integer;
  sValue: string;
var
  psld: PTServerListData;
begin
  Result := False;
  if TIWAdvWebGridAttachment.RowCount = 0 then
  begin
    Result := True; Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      with UserSession.quBugInfo do
      begin
        sValue := '';
        for I := 0 to TIWAdvWebGridAttachment.RowCount - 1 do
        begin
          if StrToInt(TIWAdvWebGridAttachment.Cells[3,I]) = 0 then
          begin
            sValue := sValue + Format(sqlValue,[iBugID,QuerySQLStr(TIWAdvWebGridAttachment.Cells[1,I]),QuerySQLStr(TIWAdvWebGridAttachment.Cells[2,I])]);
          end;
        end;
        if sValue <> '' then
        begin
          System.Delete(sValue,Length(sValue),1);
          SQL.Text := Format(sqlInsert,[psld.GstaticDB,sValue]);
          Result := ExecSQL>0;
          Close;
        end;
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

procedure TIWfrmAddBugInfo.TIWAdvWebGridAttachmentButtonClick(Sender: TObject; RowIndex,
  ColumnIndex: Integer);
var
  AttachmentID: Integer;
  sPath: string;
begin
  inherited;
  sPath := StringReplace(TIWAdvWebGridAttachment.Cells[2,RowIndex],'/','\',[rfReplaceAll]);
  sPath := AppPathEx+sPath;
  AttachmentID := StrToInt(TIWAdvWebGridAttachment.Cells[3,RowIndex]);
  if AttachmentID > 0 then
  begin
    if not DeleteAttachmentID(AttachmentID) then
    begin
      WebApplication.ShowMessage(Langtostr(483));
      Exit;
    end;
  end;
  if not FileExists(sPath) or DeleteFile(sPath) then
  begin
    TIWAdvWebGridAttachment.DeleteRows(RowIndex,1);
    TIWAdvWebGridAttachment.RowCount := TIWAdvWebGridAttachment.TotalRows;
  end;
end;

initialization
  RegisterClass(TIWfrmAddBugInfo);

end.
