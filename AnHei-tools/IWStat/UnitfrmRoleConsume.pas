unit UnitfrmRoleConsume;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWAdvToolButton,
  IWCompLabel, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWWebGrid, IWAdvWebGrid, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompEdit, IWCompButton, IWTMSCal, DateUtils,

  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = 81;//'½ÇÉ«Ïû·Ñ';

type
  TIWfrmRoleConsume = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWButton1: TIWButton;
    IWLabel2: TIWLabel;
    IWedtAccount: TIWEdit;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel3: TIWLabel;
    IWcboxType: TIWComboBox;
    IWLabel4: TIWLabel;
    pEDate: TTIWDateSelector;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure TIWAdvWebGrid1ColumnHeaderClick(Sender: TObject;
      ColumnIndex: Integer);
  private
    { Private declarations }
    procedure LoadGoldsType;
  public
    procedure QueryRoleConsume(spid: string;ServerIndex: Integer;Account, sgstatic: string;MinDateTime,MaxDateTime: TDate);
  end;

var
  IWfrmRoleConsume: TIWfrmRoleConsume;

const
  GoldTypeStr : array[0..1] of Integer = (340,341);

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmRoleConsume.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date;
  pEDate.Date := Date();
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  LoadGoldsType;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel2.Caption := Langtostr(326);
  IWBtnBuild.Caption := Langtostr(14);
  IWButton1.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(366);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(189);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(437);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(358);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(438);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(263);
  TIWAdvWebGrid1.Columns[8].Title:= Langtostr(324);
end;
procedure TIWfrmRoleConsume.LoadGoldsType;
var
  cstr: Integer;
begin
  IWcboxType.Items.Clear;
  for cstr in GoldTypeStr do
  begin
    IWcboxType.Items.Add(Langtostr(cstr));
  end;
  IWcboxType.ItemIndex := 0;
end;

procedure TIWfrmRoleConsume.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if DayOf(pEDate.Date)-DayOf(pSDate.Date) >= 7 then
  begin
    WebApplication.ShowMessage(Langtostr(436));
    Exit;
  end;

  if pSDate.Date > pEDate.Date then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;

  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      UserSession.quWebGrid.SQLConnection := UserSession.SQLConnectionLog;
      QueryRoleConsume(psld^.spID,psld^.Index,IWedtAccount.Text, psld^.GstaticDB,pSDate.Date, pEDate.Date);
      TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(194),[Langtostr(curTitle),TIWAdvWebGrid1.TotalRows]);
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

procedure TIWfrmRoleConsume.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'RoleConsume' + DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmRoleConsume.QueryRoleConsume(spid: string;ServerIndex: Integer;
  Account,sgstatic: string; MinDateTime,MaxDateTime: TDate);
const
  sqlRoleConsume = 'SELECT account,charname,serverindex,consumedescr,consumecount,paymentcount*-1,reser1,logdate FROM %s WHERE moneytype=%d AND paymentcount<=0 AND %s';
  tTableName = 'log_consume_%s';
  tServerID = ' serverindex=%d AND ';
  taccount = ' account=%s AND ';
  sqlUnionALL  = ' UNION ALL ';
var
  I,iCount: Integer;
  sSQL,sWhere,sTableName: string;
begin
  sWhere := '';
  if ServerIndex <> 0 then sWhere := Format(tServerID,[ServerIndex]);
  if Account <> '' then
  begin
    sWhere := sWhere + Format(taccount,[QuerySQLStr(Account)]);
  end
  else begin
    sWhere := sWhere + ' account not in (SELECT account FROM '+sgstatic+'.insideraccount) AND ';
  end;
  if sWhere <> '' then
  begin
    Delete(sWhere,Length(sWhere)-4,4);
  end;

  while DateOf(MinDateTime)<=DateOf(MaxDateTime) do
  begin
     sTableName := Format(tTableName,[FormatDateTime('YYYYMMDD',MinDateTime)]);
     sSQL := sSQL + Format(sqlRoleConsume,[sTableName,IWcboxType.ItemIndex+2,sWhere])+ sqlUnionALL;
     MinDateTime := IncDay(MinDateTime,1);
  end;

  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    with UserSession.quWebGrid,TIWAdvWebGrid1 do
    begin
      TIWAdvWebGrid1.Columns[6].Title := Langtostr(322);
      if IWcboxType.ItemIndex = 1 then
      begin
        TIWAdvWebGrid1.Columns[6].Title := Langtostr(321);
      end;
      iCount := 0;
      ClearCells;
      RowCount := objINI.MaxPageCount;
      SQL.Text := sSQL;
      Open;
      while not Eof do
      begin
        TotalRows := RowCount+iCount;
        for I := 1 to Columns.Count - 1 do
        begin
          if I = 3 then
            cells[I,iCount] := GetServerListName(spid,FieldList.Fields[I-1].AsInteger)
          else
            cells[I,iCount] := Utf8ToString(FieldList.Fields[I-1].AsAnsiString);
        end;
        Inc(iCount);
        Next;
      end;
      TotalRows := iCount;
      Close;
    end;
  end;
end;

procedure TIWfrmRoleConsume.TIWAdvWebGrid1ColumnHeaderClick(Sender: TObject;
  ColumnIndex: Integer);
begin
//  inherited;
end;

initialization
  RegisterClass(TIWfrmRoleConsume);

end.
