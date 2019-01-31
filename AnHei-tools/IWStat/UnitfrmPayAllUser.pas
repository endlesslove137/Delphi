unit UnitfrmPayAllUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWAdvToolButton,
  IWCompLabel, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWWebGrid, IWAdvWebGrid, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWCompEdit, IWTMSCal,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls,
  IWCompCheckbox;

const
  curTitle = 94;//'³äÖµ²éÑ¯';

type
  TIWfrmPayAllUser = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel2: TIWLabel;
    IWedtAccount: TIWEdit;
    IWLabel4: TIWLabel;
    IWEdtOrderNo: TIWEdit;
    IWSpidkBox: TIWCheckBox;
    IWButton3: TIWButton;
    IWAmdbMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryPayAllUser(spid,samdb: string;ServerIndex,ServerID: Integer;Account,OrderNo: string;MinDateTime, MaxDateTime: TDateTime);
  end;

var
  IWfrmPayAllUser: TIWfrmPayAllUser;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

{ TIWfrmPayALLUser }

procedure TIWfrmPayAllUser.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date;
  pEDate.Date := Date;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel2.Caption := Langtostr(283);
  IWLabel4.Caption := Langtostr(515);

  IWBtnBuild.Caption := Langtostr(14);
  IWButton3.Caption := Langtostr(182);
  IWSpidkBox.Caption := Langtostr(320);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(516);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(341);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(517);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(189);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(518);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(511);
end;

procedure TIWfrmPayAllUser.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date > pEDate.Date then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
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
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      QueryPayAllUser(psld.spID,psld.Amdb,psld.Index,psld.ServerID,IWedtAccount.Text,IWEdtOrderNo.Text,pSDate.Date,pEDate.Date);
    finally
      UserSession.SQLConnectionSession.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmPayAllUser.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'PayAllUser' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmPayAllUser.QueryPayAllUser(spid,samdb: string;ServerIndex,ServerID: Integer; Account,OrderNo: string;MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlPayAllUser = 'SELECT orderid,account,money,rmb,serverid,paygift,orderdate FROM %s.payorder WHERE yunying="_%s" AND type in (1,3) AND orderdate>="%s" AND orderdate<="%s" %s %s %s ORDER BY orderdate DESC';
  sqlPayAllUser2 = 'SELECT orderid,account,money,rmb,serverid,paygift,orderdate FROM %s.payorder_%s WHERE yunying="_%s" AND type in (1,3) AND orderdate>="%s" AND orderdate<="%s" %s %s %s ORDER BY orderdate DESC';
  FilterServerID = ' AND serverid in (%s) ';
  sqlAccount = ' AND account=%s ';
  sqlOrderNo = ' AND orderid=%s';
var
  I,iCount,TotalMoney: Integer;
  TotalRMB: Double;
  sServerID: string;
begin
  with UserSession.quPayAllUser, TIWAdvWebGrid1 do
  begin
    iCount := 0; TotalRMB := 0; TotalMoney := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    sServerID := Format(FilterServerID,[GetJoinServerIndex(ServerIndex)]);
    if ServerIndex = 0 then
    begin
      sServerID := '';
    end;
    if Account <> '' then
    begin
      Account := Format(sqlAccount,[QuerySQLStr(Account)]);
    end;
    if OrderNo <> '' then
    begin
      OrderNo := Format(sqlOrderNo,[QuerySQLStr(OrderNo)]);
    end;
    if IWAmdbMode.Checked then
     SQL.Text := Format(sqlPayAllUser2,[samdb,FormatDateTime('YYYYMM',MinDateTime),spid,DateToStr(MinDateTime),FormatDateTime('YYYY-MM-DD 23:59:59',MaxDateTime),sServerID,Account,OrderNo])
    else
     SQL.Text := Format(sqlPayAllUser,[samdb,spid,DateToStr(MinDateTime),FormatDateTime('YYYY-MM-DD 23:59:59',MaxDateTime),sServerID,Account,OrderNo]);
    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      for I := 1 to Columns.Count - 1 do
      begin
        case I of
          3:
          begin
            TotalMoney := TotalMoney + Fields[I-1].AsInteger;
            cells[I,iCount] := Fields[I-1].AsString;
          end;
          4:
          begin
            cells[I,iCount] := Format(objINI.RMBFormat,[Fields[I-1].AsFloat]);
            TotalRMB := TotalRMB+Fields[I-1].AsFloat;
            if FieldList.Fields[I-1].AsString = '' then
            begin
              cells[I,iCount] := IntToStr(FieldList.Fields[I-2].AsInteger div 10);
              TotalRMB := TotalRMB+FieldList.Fields[I-2].AsInteger div 10;
            end;
          end;
          5:
          begin
            cells[I,iCount] := GetServerListName(spid,FieldList.Fields[I-1].AsInteger+ServerID);
          end;
          6:
          begin
            cells[I,iCount] := FieldList.Fields[I-1].AsString;
            if FieldList.Fields[I-1].AsString = '' then
            begin
              cells[I,iCount] := Langtostr(513);
            end;
          end
          else begin
            cells[I,iCount] := UTF8ToString(FieldList.Fields[I-1].AsAnsiString);
          end;
        end;
      end;
      Inc(iCount);
      Next;
    end;
    TIWAdvWebGrid1.Columns[2].FooterText := Langtostr(514);
    TIWAdvWebGrid1.Columns[3].FooterText := IntToStr(TotalMoney);
    TIWAdvWebGrid1.Columns[4].FooterText := Format(objINI.RMBFormat,[TotalRMB]);
    TotalRows := iCount;
    Close;
    Controller.Caption := Format(Langtostr(194),[Langtostr(curTitle),iCount]);
  end;
end;

initialization
  RegisterClass(TIWfrmPayAllUser);

end.
