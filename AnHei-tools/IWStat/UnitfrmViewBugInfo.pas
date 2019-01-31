unit UnitfrmViewBugInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWHTMLEdit,
  IWWebGrid, IWAdvWebGrid, ImgList,
  IWImageList, IWCompMemo;

const
  curTitle = 659;//'查看Bug信息';
  
type
  TIWfrmViewBugInfo = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel3: TIWLabel;
    IWLabTitle: TIWLabel;
    IWLabel2: TIWLabel;
    IWLabel4: TIWLabel;
    IWLabType: TIWLabel;
    IWLabState: TIWLabel;
    TIWAdvWebGridReply: TTIWAdvWebGrid;
    IWRegion5: TIWRegion;
    IWRegion6: TIWRegion;
    IWImageList1: TIWImageList;
    IWButton1: TIWButton;
    TIWHTMLEdit: TTIWHTMLEdit;
    TIWAdvWebGridAttachment: TTIWAdvWebGrid;
    IWRegion3: TIWRegion;
    IWRegionReply: TIWRegion;
    TIWGradientLabel1: TTIWGradientLabel;
    IWLabel1: TIWLabel;
    IWMemoReply: TIWMemo;
    IWButton2: TIWButton;
    IWButton3: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure TIWAdvWebGridAttachmentButtonClick(Sender: TObject; RowIndex,
      ColumnIndex: Integer);
    procedure IWButton3Click(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
  private
    iBugID: Integer;
  public
    procedure ViewBugInfo(BugID: Integer);
    procedure LoadAttachmentList(sgstatic:string);
    procedure AddAttachment(iImageIdx,iAttachment: Integer;sFileName,sPath: string);
    procedure AddReply(sTime,sName,sContent: string);
    function InsertReply(sTime,sName,sContent: string): Boolean;
    procedure LoadReply(sgstatic:string);
  end;

var
  IWfrmViewBugInfo: TIWfrmViewBugInfo;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmViewBugInfo.AddAttachment(iImageIdx, iAttachment: Integer;
  sFileName, sPath: string);
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

procedure TIWfrmViewBugInfo.AddReply(sTime,sName, sContent: string);
begin
  TIWAdvWebGridReply.Visible := True;
  with TIWAdvWebGridReply do
  begin
    RowCount := RowCount+1;
    TotalRows := RowCount;
    Cells[2,RowCount-1] := sTime;
    Cells[3,RowCount-1] := sName;
    Cells[4,RowCount-1] := sContent;
    Controller.Caption := Format('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共有 %d 人回复',[TotalRows]);
  end;
  TIWAdvWebGridReply.Height := (TIWAdvWebGridReply.TotalRows*24)+47;
end;

function TIWfrmViewBugInfo.InsertReply(sTime, sName, sContent: string): Boolean;
const
  sqlInsert = 'INSERT INTO %s.bugreply(bugid,name,content,replytime) VALUES (%d,%s,%s,"%s")';
var
  psld: PTServerListData;
begin
  Result:= False;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      with UserSession.quBugInfo do
      begin
        SQL.Text := Format(sqlInsert,[psld.GstaticDB,iBugID,QuerySQLStr(sName),QuerySQLStr(sContent),sTime]);
        Result := ExecSQL > 0;
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

procedure TIWfrmViewBugInfo.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
end;

procedure TIWfrmViewBugInfo.IWButton1Click(Sender: TObject);
begin
  inherited;
  IWMemoReply.Lines.Text := '';
  IWRegionReply.Visible := True;
end;

procedure TIWfrmViewBugInfo.IWButton2Click(Sender: TObject);
var
  sTime: string;
begin
  inherited;
  if IWMemoReply.Lines.Text = '' then Exit;
  sTime := DateTimeToStr(Now);
  if InsertReply(sTime,UserSession.UserName,IWMemoReply.Lines.Text) then
  begin
    AddReply(sTime,UserSession.UserName,IWMemoReply.Lines.Text);
    IWRegionReply.Visible := False;
  end
  else begin
    WebApplication.ShowMessage('回复失败');  
  end;
end;

procedure TIWfrmViewBugInfo.IWButton3Click(Sender: TObject);
begin
  inherited;
  IWRegionReply.Visible := False;
end;

procedure TIWfrmViewBugInfo.LoadAttachmentList(sgstatic:string);
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

procedure TIWfrmViewBugInfo.LoadReply(sgstatic:string);
const
  sqlReply = 'SELECT * FROM %s.bugreply WHERE bugid=%d';
begin
  with UserSession.quBugInfo do
  begin
    SQL.Text := Format(sqlReply,[sgstatic,iBugID]);
    Open;
    while not Eof do
    begin
      AddReply(FieldByName('replytime').AsString,Utf8ToString(FieldByName('name').AsAnsiString),Utf8ToString(FieldByName('content').AsAnsiString));
      Next;
    end;
    Close;
  end;
end;

procedure TIWfrmViewBugInfo.TIWAdvWebGridAttachmentButtonClick(Sender: TObject;
  RowIndex, ColumnIndex: Integer);
var
  sPath: string;
begin
  inherited;
  sPath := StringReplace(TIWAdvWebGridAttachment.Cells[2,RowIndex],'/','\',[rfReplaceAll]);
  WebApplication.SendFile(AppPathEx+sPath,True,'',TIWAdvWebGridAttachment.Cells[1,RowIndex]);
end;

procedure TIWfrmViewBugInfo.ViewBugInfo(BugID: Integer);
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
        SQL.Text := Format('SELECT a.*,b.typename FROM '+psld.GstaticDB+ '.buginfo a LEFT JOIN '+ psld.GstaticDB +'.bugtype b ON a.bugtype=b.typeid WHERE bugid=%d',[BugID]);
        Open;
        IWLabTitle.Caption := Utf8ToString(FieldByName('title').AsAnsiString);
        IWLabType.Caption := Utf8ToString(FieldByName('typename').AsAnsiString);
        IWLabState.Caption := Langtostr(TBugInfoStateStr[FieldByName('state').AsInteger]);
        TIWHTMLEdit.Lines.Text := Utf8ToString(FieldByName('html').AsAnsiString);
        Close;
      end;
      LoadAttachmentList(psld.GstaticDB);
      LoadReply(psld.GstaticDB);
    finally
      UserSession.SQLConnectionLog.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
  IWRegion3.Visible := (TIWAdvWebGridAttachment.TotalRows > 0) and (TIWAdvWebGridReply.TotalRows > 0);
  TIWAdvWebGridAttachment.Visible := TIWAdvWebGridAttachment.TotalRows > 0;
  TIWAdvWebGridReply.Visible := TIWAdvWebGridReply.TotalRows > 0;
end;

end.
