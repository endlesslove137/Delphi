unit UnitEvaluate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWTMSCal;

const
// curTitle = 78;//'评价系统';
  curTitleStr = '评价系统';
  sItemsType : array [0..1] of Integer = (411, 412);

type
  TEvaluateFrm = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    twdvwbgrdmessage: TTIWAdvWebGrid;
    iwlbl1: TIWLabel;
    twdtslctrSDate: TTIWDateSelector;
    iwlbl2: TIWLabel;
    twdtslctrEDate: TTIWDateSelector;
    cbbCvalue: TIWComboBox;
    iwlblCvalue: TIWLabel;
    iwlblCType: TIWLabel;
    cbbCType: TIWComboBox;
    twdvwbgrdPersent: TTIWAdvWebGrid;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure twdvwbgrdmessageButtonClick(Sender: TObject; RowIndex,
      ColumnIndex: Integer);
    procedure cbbCTypeChange(Sender: TObject);
  private
  public
    procedure QueryEvaluateInfo(spID: string;MinDateTime, MaxDateTime: TDateTime);
  end;

var
  EvaluateFrm: TEvaluateFrm;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmHunShiInfo }

procedure TEvaluateFrm.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(curTitleStr);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitleStr;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitleStr]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  iwlbl1.Caption := Langtostr(150);
  iwlbl2.Caption := Langtostr(151);

  twdtslctrSDate.date := now()-7;
  twdtslctrEDate.date := now();


  IWBtnBuild.Caption := Langtostr(14);

  twdvwbgrdmessage.Columns[1].Title:= Langtostr(396); //角色ID
  twdvwbgrdmessage.Columns[2].Title:= '留言'; //角色ID

  twdvwbgrdPersent.Columns[1].Title:= '评价条目';
  twdvwbgrdPersent.Columns[2].Title:= '程度';
  twdvwbgrdPersent.Columns[3].Title:= '比率';
end;

procedure TEvaluateFrm.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
  sTemp: string;
begin
  if (cbbCType.ItemIndex < 0) or (cbbCvalue.ItemIndex < 0) then
  begin
    WebApplication.ShowMessage(Langtostr(666));
    Exit;
  end;
  if twdtslctrSDate.Date > twdtslctrEDate.Date then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  try
    sTemp := trim(UserSession.pServerName);
    psld := GetServerListData(sTemp);
    webapplication.ShowMessage( GetJoinServerIndex(psld.Index));
    UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
    try
      QueryEvaluateInfo(psld.spID, twdtslctrSDate.Date, twdtslctrEDate.Date);
    finally
      UserSession.SQLConnectionRole.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TEvaluateFrm.cbbCTypeChange(Sender: TObject);
begin
  inherited;
  case cbbCType.ItemIndex of
   0:
   begin
     cbbCvalue.Items.Clear;
     cbbCvalue.Items.AddStrings(FubenList);
   end;
   1:
   begin
     cbbCvalue.Items.Clear;
     cbbCvalue.Items.AddStrings(ActivityList);
   end;
   2:
   begin
     cbbCvalue.Items.Clear;
     cbbCvalue.Items.AddStrings(TaskList);
    end;
  end;
end;

procedure TEvaluateFrm.QueryEvaluateInfo(spID: string;MinDateTime, MaxDateTime: TDateTime);
const
  sqluserhero = 'SELECT b.actorid, b.actorname, a.type, a.param, a.param1, a.param2, a.param3 FROM diamond a LEFT JOIN actors b ON a.actorid = b.actorid  WHERE a.actorid > 0 %s';

  sqluserid   = ' and b.actorid =%s ';
  sqlusername = ' and b.actorname =%s ';
var
  iCount, ctype, cvalue, i : Integer;
  sWhere, sTemp: string;
  startDate,endDate :string;
  procedure BuildMessageSQLData();
  const
   SqlMessage = 'select actorid,content from  systemcomment where addtime >="%s" and addtime<="%s" and ctype =%d and cvalue =%d ORDER BY addtime';
  begin
    twdvwbgrdmessage.ClearCells;
    with UserSession.quUserInfo, twdvwbgrdmessage do
    begin
      iCount := 0;
      RowCount := 0;
      sTemp := format(SqlMessage, [startDate, endDate, ctype, cvalue]);
      SQL.Text := sTemp;
      webapplication.showmessage(sTemp);
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := IntToStr(FieldByName('actorid').AsInteger);
        cells[2,iCount] := Utf8ToString(FieldList.FieldByName('content').AsAnsiString);
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;

  procedure BuildPersentSQLData();
  const
   SqlMessage = 'select actorid,content from  systemcomment where addtime >="%s" and addtime<="%s" and ctype =%d and cvalue =%d ORDER BY addtime';
  begin
    twdvwbgrdmessage.ClearCells;
    with UserSession.quUserInfo, twdvwbgrdmessage do
    begin
      iCount := 0;
      RowCount := 0;
      sTemp := format(SqlMessage, [startDate, endDate, ctype, cvalue]);
      SQL.Text := sTemp;
      webapplication.showmessage(sTemp);
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := IntToStr(FieldByName('actorid').AsInteger);
        cells[2,iCount] := Utf8ToString(FieldList.FieldByName('content').AsAnsiString);
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;
begin
   startDate := formatdatetime('YYYY-MM-DD',twdtslctrSDate.Date);
   endDate := formatdatetime('YYYY-MM-DD',twdtslctrEDate.Date);
   ctype := cbbCType.ItemIndex + 1;
   i := cbbCvalue.ItemIndex;
   case ctype of
    1:cvalue := pfuben(FubenList.Objects[i]).ID;
    2:cvalue := pActivity(FubenList.Objects[i]).ID;
    3:cvalue := pTTask(FubenList.Objects[i]).nTaskID;
   end;
   BuildMessageSQLData();
end;

procedure TEvaluateFrm.twdvwbgrdmessageButtonClick(Sender: TObject; RowIndex,
  ColumnIndex: Integer);
begin
  inherited;
  webapplication.ShowMessage(inttostr(RowIndex) + ' : ' + inttostr(ColumnIndex));
end;

initialization
  RegisterClass(TEvaluateFrm);

end.
