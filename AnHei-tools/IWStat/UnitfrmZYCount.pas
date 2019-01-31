unit UnitfrmZYCount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWTMSCal,
  IWAdvChart;

type
  TIWfrmZYCount = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    TIWAdvChart2: TTIWAdvChart;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryZyCount(spid: string;ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmZYCount: TIWfrmZYCount;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmZYCount.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date;
  pEDate.Date := Date;
end;

procedure TIWfrmZYCount.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  inherited;
  SetServerListSelect(Langtostr(StatToolButtonStr[btZYCount]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[btZYCount]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[btZYCount])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryZyCount(psld^.spID,psld.Index,pSDate.Date,pEDate.Date);
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

procedure TIWfrmZYCount.QueryZyCount(spid: string;ServerIndex: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlServerIndexZyCount = 'SELECT serverindex,SUM(Para1) as ZyCount FROM log_common_%s WHERE logid=510 %s GROUP BY serverindex';
  sqlServerIndexGroup = 'SELECT serverindex,SUM(ZyCount) as ZyCount FROM (%s) tmp GROUP BY serverindex';
  sqlActivityIndexZyCount = 'SELECT Longstr0,SUM(Para1) as ZyCount FROM log_common_%s WHERE logid=510 %s GROUP BY Longstr0';
  sqlActivityIndexGroup = 'SELECT Longstr0,SUM(ZyCount) as ZyCount FROM (%s) tmp GROUP BY Longstr0';
  sqlUnionall = ' UNION ALL ';
var
  iCount: Integer;
  SIdx,idxSQL,actSQL,sTableName: string;
begin
  SIdx := ''; idxSQL := '';  actSQL := '';
  if ServerIndex <> 0 then
  begin
    SIdx := Format(' AND serverindex=%d ',[serverindex]);
  end;
  while MinDateTime<=MaxDateTime do
  begin
    sTableName := FormatDateTime('YYYYMMDD',MinDateTime);
    idxSQL := idxSQL + Format(sqlServerIndexZyCount,[sTableName,SIdx])+sqlUnionall;
    actSQL := actSQL + Format(sqlActivityIndexZyCount,[sTableName,SIdx])+sqlUnionall;
    MinDateTime := MinDateTime+1;
  end;
  if idxSQL <> '' then
  begin
    System.Delete(idxSQL,Length(idxSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    with UserSession.quCommon,TIWAdvChart1,Chart do
    begin
      Series[0].ClearPoints;
      SQL.Text := Format(sqlServerIndexGroup,[idxSQL]);
      Open;  iCount := 0;
      while not Eof do
      begin
        Series[0].AddSinglePoint(ChangeZero(Fields[1].AsInteger),GetServerListName(spid,Fields[0].AsInteger));
        Inc(iCount);
        Next;
      end;
      Close;
      Range.RangeFrom := 0;
      Range.RangeTo := iCount-1;
      TIWAdvChart1.Height := 80+iCount * objINI.AutoHeigth;
      TIWAdvChart1.Visible := True;
    end;
  end;
  if actSQL <> '' then
  begin
    System.Delete(actSQL,Length(actSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    with UserSession.quCommon,TIWAdvChart2,Chart do
    begin
      Series[0].ClearPoints;
      SQL.Text := Format(sqlActivityIndexGroup,[actSQL]);
      Open; iCount := 0;
      while not Eof do
      begin
        Series[0].AddSinglePoint(ChangeZero(Fields[1].AsInteger),Utf8ToString(Fields[0].AsAnsiString));
        Inc(iCount);
        Next;
      end;
      Close;
      Range.RangeFrom := 0;
      Range.RangeTo := iCount-1;
      TIWAdvChart2.Height := 80+iCount * objINI.AutoHeigth;
      TIWAdvChart2.Visible := True;
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmZYCount);
end.
