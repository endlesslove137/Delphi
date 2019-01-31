unit UnitfrmOperateLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWTMSCal,
  IWWebGrid, IWAdvWebGrid, ServerController, IWCompCheckbox;

type
  TIWfrmOperateLog = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWLabel2: TIWLabel;
    IWLabel4: TIWLabel;
    IWLabel5: TIWLabel;
    IWComboBox1: TIWComboBox;
    IWedtUserName: TIWEdit;
    IWedtAccount: TIWEdit;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton1: TIWButton;
    IWSpidkBox: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
  private
    procedure LoadOperateType;
  public
    procedure QueryOperateLog(opType: Integer;sUserName,sAccount,sMinTime,sMaxTime, sgstatic: string);
  end;

var
  IWfrmOperateLog: TIWfrmOperateLog;

implementation

uses ConfigINI;

{$R *.dfm}

procedure TIWfrmOperateLog.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbOperateLog]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbOperateLog]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbOperateLog])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  pSDate.Date := Date;
  pEDate.Date := Date;
  LoadOperateType;
end;

procedure TIWfrmOperateLog.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  inherited;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      if IWedtAccount.Text <> '' then
      begin
        if not IWSpidkBox.Checked then
        begin
          if Pos('_'+psld.spID,IWedtAccount.Text) = 0 then
          begin
            IWedtAccount.Text := IWedtAccount.Text + '_'+psld.spID;
          end;
        end;
      end;
      QueryOperateLog(IWComboBox1.ItemIndex,IWedtUserName.Text,IWedtAccount.Text,DateToStr(pSDate.Date),DateToStr(pEDate.Date)+' 23:59:59', psld.GstaticDB);
      TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;<b>%s</b>：共 %d 个记录',[StatToolButtonStr[tbOperateLog],TIWAdvWebGrid1.TotalRows]);
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

procedure TIWfrmOperateLog.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'OperateLog'+DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmOperateLog.LoadOperateType;
var
  cstr: string;
begin
  IWComboBox1.Items.Clear;
  IWComboBox1.Items.Add('未选择');
  for cstr in TOperateTypeStr do
  begin
    IWComboBox1.Items.Add(cstr);
  end;
  IWComboBox1.ItemIndex := 0;
end;

procedure TIWfrmOperateLog.QueryOperateLog(opType: Integer; sUserName, sAccount,
  sMinTime, sMaxTime, sgstatic: string);
const
  sqlOperateLog = 'SELECT * FROM %s.operatelog WHERE logdate>="%s" AND logdate<="%s" ';
var
  I,iCount: Integer;
  strSQL: string;
begin
  strSQL := '';
  if opType <> 0 then
  begin
    strSQL := Format(' AND optype=%d ',[opType-1]);
  end;
  if sUserName <> '' then
  begin
    strSQL := strSQL + Format(' AND username=%s ',[QuerySQLStr(sUserName)]);
  end;
  if sAccount <> '' then
  begin
    strSQL := strSQL + Format(' AND account=%s ',[QuerySQLStr(sAccount)]);
  end;
  with UserSession.quOperateLog,TIWAdvWebGrid1 do
  begin
    iCount := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    SQL.Text := Format(sqlOperateLog,[sgstatic,sMinTime,sMaxTime])+strSQL;
    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      for I := 1 to Columns.Count - 1 do
      begin
        if I = 2 then
        begin
          cells[I,iCount] := TOperateTypeStr[Fields[I-1].AsInteger];
        end
        else begin
          cells[I,iCount] := Utf8ToString(Fields[I-1].AsAnsiString);
        end;
      end;
      Inc(iCount);
      Next;
    end;
    TotalRows := iCount;
    Close;
  end;
end;

initialization
  RegisterClass(TIWfrmOperateLog);
  
end.
