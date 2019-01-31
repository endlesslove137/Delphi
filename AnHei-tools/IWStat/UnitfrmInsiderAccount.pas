unit UnitfrmInsiderAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWWebGrid,
  IWAdvWebGrid, IWCompMemo, IWTMSPopup, Menus, IWCompCheckbox;

type
  TIWfrmInsiderAccount = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    IWBtnBuild: TIWButton;
    IWButton1: TIWButton;
    IWLabel2: TIWLabel;
    IWedtAccount: TIWEdit;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    IWEdtMAccount: TIWEdit;
    IWMemo1: TIWMemo;
    IWButton5: TIWButton;
    IWButton6: TIWButton;
    IWLabel4: TIWLabel;
    PopupMenu1: TPopupMenu;
    H1: TMenuItem;
    H2: TMenuItem;
    L1: TMenuItem;
    TIWPopupMenuButton1: TTIWPopupMenuButton;
    IWSpidkBox: TIWCheckBox;
    IWRegion3: TIWRegion;
    IWMemoAccount: TIWMemo;
    IWButton2: TIWButton;
    IWButton3: TIWButton;
    IWLabel5: TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWButton6Click(Sender: TObject);
    procedure IWButton5Click(Sender: TObject);
    procedure H1Click(Sender: TObject);
    procedure H2Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
  private
    bState: Byte;
    spID: string;
    sAccountName, sRemarks: string;
  public
    procedure QueryInsiderAccount(sAccount, sgstatic: string);
    function PostDBData(sAaccount,sRemark: string): Boolean;
    function DeleteDBData(sAccount: string): Boolean;
    procedure ShowDataCount;
    function AddCheckRepeat(sAccount: string): Boolean;
  end;

var
  IWfrmInsiderAccount: TIWfrmInsiderAccount;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

{ TIWfrmInsiderAccount }

function TIWfrmInsiderAccount.AddCheckRepeat(sAccount: string): Boolean;
var
  psld: PTServerListData;
begin
  Result := False;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.quInsiderAccount.SQL.Text := Format('SELECT COUNT(1) FROM %s.insideraccount WHERE account=%s',[psld.GstaticDB,QuerySQLStr(sAccount)]);
    UserSession.quInsiderAccount.Open;
    Result := UserSession.quInsiderAccount.Fields[0].AsInteger > 0;
    UserSession.quInsiderAccount.Close;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

function TIWfrmInsiderAccount.DeleteDBData(sAccount: string): Boolean;
var
  psld: PTServerListData;
begin
  Result := False;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.quInsiderAccount.SQL.Text := Format('DELETE FROM %s.insideraccount WHERE account=%s',[psld.GstaticDB,QuerySQLStr(sAccount)]);
    UserSession.quInsiderAccount.ExecSQL;
    UserSession.quInsiderAccount.Close;
    Result := True;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmInsiderAccount.H1Click(Sender: TObject);
begin
  inherited;
  bState := 1;
  IWRegion3.Visible := True;
  IWMemoAccount.Text := '';
end;

procedure TIWfrmInsiderAccount.H2Click(Sender: TObject);
begin
  inherited;
  if DeleteDBData(TIWAdvWebGrid1.Cells[1,TIWAdvWebGrid1.RadioSelection]) then
  begin
    TIWAdvWebGrid1.DeleteRows(TIWAdvWebGrid1.RadioSelection,1);
    TIWAdvWebGrid1.RowCount := TIWAdvWebGrid1.TotalRows;
    ShowDataCount;
  end;
end;

procedure TIWfrmInsiderAccount.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbInsiderAccount]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbInsiderAccount]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbInsiderAccount])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  bState := 0;
  sAccountName := '';
  sRemarks := '';
end;

procedure TIWfrmInsiderAccount.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      if not IWSpidkBox.Checked then
      begin
        if (IWedtAccount.Text <> '') and (Pos('_'+psld^.spID,IWedtAccount.Text) = 0) then
        begin
          IWedtAccount.Text := IWedtAccount.Text + '_' + psld^.spID;
        end;
      end;
      spID := psld^.spID;
      QueryInsiderAccount(IWedtAccount.Text, psld^.GstaticDB);
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

procedure TIWfrmInsiderAccount.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := Langtostr(StatToolButtonStr[tbInsiderAccount]) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmInsiderAccount.IWButton2Click(Sender: TObject);
var
 i: Integer;
begin
  if bState = 1 then
  begin
     for I := 0 to IWMemoAccount.Lines.Count - 1 do
     begin
        sAccountName := ParameterStrValue(IWMemoAccount.Lines.Strings[I]);

        if not IWSpidkBox.Checked then
        begin
          if Pos('_'+spID,sAccountName) = 0 then
          begin
           sAccountName := sAccountName + '_'+spID;
          end;
        end;

        if AddCheckRepeat(sAccountName) then
        begin
          WebApplication.ShowMessage(sAccountName+'账号已存在');
          Exit;
        end;
        sRemarks := ParameterStrValueEx(IWMemoAccount.Lines.Strings[I]);
        if PostDBData(sAccountName,sRemarks) then
        begin
          TIWAdvWebGrid1.RowCount := TIWAdvWebGrid1.RowCount + 1;
          TIWAdvWebGrid1.TotalRows := TIWAdvWebGrid1.RowCount;
          TIWAdvWebGrid1.Cells[1,TIWAdvWebGrid1.RowCount-1] := sAccountName;
          TIWAdvWebGrid1.Cells[2,TIWAdvWebGrid1.RowCount-1] := sRemarks;
          ShowDataCount;
          //bState := 0;
          IWRegion3.Visible := False;
        end;
     end;
  end;
end;

procedure TIWfrmInsiderAccount.IWButton3Click(Sender: TObject);
begin
  inherited;
  IWRegion3.Visible := False;
end;

procedure TIWfrmInsiderAccount.IWButton5Click(Sender: TObject);
begin
  inherited;
  if PostDBData(IWEdtMAccount.Text,IWMemo1.Text) then
  begin
    if bState = 2 then
    begin
      TIWAdvWebGrid1.Cells[1,TIWAdvWebGrid1.RadioSelection] := IWEdtMAccount.Text;
      TIWAdvWebGrid1.Cells[2,TIWAdvWebGrid1.RadioSelection] := IWMemo1.Text;
    end;
    bState := 0;
    IWRegion2.Visible := False;
  end;
end;

procedure TIWfrmInsiderAccount.IWButton6Click(Sender: TObject);
begin
  inherited;
  IWRegion2.Visible := False;
end;

procedure TIWfrmInsiderAccount.L1Click(Sender: TObject);
begin
  inherited;
  if TIWAdvWebGrid1.RadioSelection >=0 then
  begin
    bState := 2;
    IWEdtMAccount.Text :=  TIWAdvWebGrid1.Cells[1,TIWAdvWebGrid1.RadioSelection];
    IWEdtMAccount.Enabled := False;
    IWMemo1.Text := TIWAdvWebGrid1.Cells[2,TIWAdvWebGrid1.RadioSelection];
    IWRegion2.Visible := True;
  end;
end;

function TIWfrmInsiderAccount.PostDBData(sAaccount,sRemark: string): Boolean;
const
  sqlAdd = 'INSERT INTO %s.insideraccount VALUES (%s,%s)';
  sqlUpdate = 'UPDATE %s.insideraccount SET remark=%s WHERE account=%s';
var
  sSQL: string;
  psld: PTServerListData;
begin
  Result := False;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    case bState of
      1:
      begin
        sSQL := Format(sqlAdd,[psld.GstaticDB,QuerySQLStr(sAaccount),QuerySQLStr(sRemark)]);
      end;
      2:
      begin
        sSQL := Format(sqlUpdate,[psld.GstaticDB,QuerySQLStr(sRemark),QuerySQLStr(sAaccount)]);
      end;
    end;
    UserSession.quInsiderAccount.SQL.Text := sSQL;
    UserSession.quInsiderAccount.ExecSQL;
    UserSession.quInsiderAccount.Close;
    Result := True;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmInsiderAccount.QueryInsiderAccount(sAccount, sgstatic: string);
const
  sqlInsiderAccount = 'SELECT * FROM %s.insideraccount ';
  sqlAccount = ' account=%s';
var
  I,iCount: Integer;
  sSQL: string;
begin
  sSQL := '';
  if sAccount <> '' then
  begin
    sSQL := Format(sqlAccount,[QuerySQLStr(sAccount)]);
  end;
  if sSQL <> '' then
  begin
    sSQL := ' WHERE '+sSQL;
  end;
  with UserSession.quInsiderAccount,TIWAdvWebGrid1 do
  begin
    iCount := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    SQL.Text := Format(sqlInsiderAccount,[sgstatic]) +sSQL;
    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      for I := 1 to Columns.Count - 1 do
      begin
        cells[I,iCount] := Utf8TOString(Fields[I-1].AsAnsiString);
      end;
      Inc(iCount);
      Next;
    end;
    RowCount := iCount;
    TotalRows := iCount;
    Close;
  end;
  ShowDataCount;
end;

procedure TIWfrmInsiderAccount.ShowDataCount;
begin
  TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>%s</b> 共 %d 个记录',[Langtostr(StatToolButtonStr[tbInsiderAccount]),TIWAdvWebGrid1.TotalRows]);
end;

end.
