unit UnitARPU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWTMSCal,
  IWAdvChart, IWWebGrid, IWAdvWebGrid, IWCompCheckbox;

type
  TIWfrmARPU = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWLabel4: TIWLabel;
    IWComboBox1: TIWComboBox;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton3: TIWButton;
    IWAmdbMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
    procedure LoadComboBoxList;
  public
    procedure QueryARPU(samdb,spID: string;SDateTime,EDateTime: TDateTime;ServerIndex,nRange: Integer;dRate: Double);
  end;

var
  IWfrmARPU: TIWfrmARPU;

const
  PeriodTypeStr: array[0..2] of Integer = (328,329,330);

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmARPU.IWAppFormCreate(Sender: TObject);
var
  pServerListData: PTServerListData;
begin
  inherited;
  pServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  pSDate.Date := GetFirstOpenTime(pServerListData^.spID);
  pEDate.Date := Now;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbARPU]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbARPU]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbARPU])]);
  LoadComboBoxList;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel4.Caption := Langtostr(327);
  IWBtnBuild.Caption := Langtostr(171);
  IWButton3.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(244);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(331);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(332);
end;

procedure TIWfrmARPU.LoadComboBoxList;
var
  I: Integer;
begin
  IWComboBox1.Items.Clear;
  for I := Low(PeriodTypeStr) to High(PeriodTypeStr) do
  begin
    IWComboBox1.Items.Add(Langtostr(PeriodTypeStr[I]));
  end;
  IWComboBox1.ItemIndex := 0;
end;

procedure TIWfrmARPU.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      QueryARPU(psld^.Amdb,psld^.spID,pSDate.Date,pEDate.Date,psld^.Index,IWComboBox1.ItemIndex,psld^.CurrencyRate);
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

procedure TIWfrmARPU.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'ARPU' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmARPU.QueryARPU(samdb,spID: string;SDateTime, EDateTime: TDateTime; ServerIndex,nRange: Integer;dRate: Double);
const
  sqlARPU = 'SELECT orderdate,SUM(money),COUNT(DISTINCT account) as iCount FROM %s.payorder WHERE type in (1,3) AND orderdate>="%s" AND orderdate<="%s 23:59:59" AND yunying="_%s" ';
  sqlARPU2 = 'SELECT orderdate,SUM(money),COUNT(DISTINCT account) as iCount FROM %s.payorder WHERE type in (1,3) AND orderdate>="%s" AND orderdate<="%s 23:59:59" AND yunying="_%s" ';
var
  iCount: Integer;
  dValue: Double;
  sGroupBy,sServerIndex,FormatShowDate: string;
begin
  sServerIndex := '';  iCount := 0;
  TIWAdvWebGrid1.ClearCells;
  if ServerIndex <> 0 then
  begin
    sServerIndex := Format(' AND serverid in (%s)', [GetJoinServerIndex(ServerIndex)]);
  end;
  FormatShowDate := 'YY-MM-DD';
  case nRange of
    0:
    begin
      sGroupBy := ' GROUP BY Year(orderdate),Month(orderdate)';
      FormatShowDate := 'YYÄêMM';
    end;
    1: sGroupBy := ' GROUP BY YearWeek(orderdate)';
    2: sGroupBy := ' GROUP BY Date(orderdate)';
  end;
  with UserSession.quPay,TIWAdvChart1.Chart do
  begin
    Series[0].ClearPoints;
    Series[0].ValueFormat := objINI.RMBFormat;
    if IWAmdbMode.Checked then
     SQL.Text := Format(sqlARPU2,[samdb,FormatDateTime('YYYYMM',SDateTime),DateToStr(SDateTime),DateToStr(EDateTime),spID])+sServerIndex+sGroupBy+' ORDER BY orderdate'
    else
     SQL.Text := Format(sqlARPU,[samdb,DateToStr(SDateTime),DateToStr(EDateTime),spID])+sServerIndex+sGroupBy+' ORDER BY orderdate';
    Open;
    while not Eof do
    begin
      TIWAdvWebGrid1.RowCount := iCount + 1;
      dValue := DivZero(Fields[1].AsFloat,10)*dRate;
      if (nRange = 1) then
      begin
        Series[0].AddSinglePoint(ChangeZero(dValue/Fields[2].AsInteger),IntToStr(iCount+1)+langtostr(329));
        TIWAdvWebGrid1.cells[1,iCount] := IntToStr(iCount+1)+langtostr(329);
        TIWAdvWebGrid1.cells[2,iCount] := floattostr(ChangeZero(dValue/Fields[2].AsInteger));
        TIWAdvWebGrid1.cells[3,iCount] := inttostr(Fields[2].AsInteger);
      end
      else begin
        Series[0].AddSinglePoint(ChangeZero(dValue/Fields[2].AsInteger),FormatDateTime(FormatShowDate,Fields[0].AsDateTime));
        TIWAdvWebGrid1.cells[1,iCount] := FormatDateTime(FormatShowDate,Fields[0].AsDateTime);
        TIWAdvWebGrid1.cells[2,iCount] := floattostr(ChangeZero(dValue/Fields[2].AsInteger));
        TIWAdvWebGrid1.cells[3,iCount] := inttostr(Fields[2].AsInteger);
      end;
      Inc(iCount);
      Next;
    end;

    Range.RangeFrom := 0;
    Range.RangeTo := iCount-1;
  end;
  if iCount * objINI.AutoWidth < objINI.DefaultWidth then
    TIWAdvChart1.Width := objINI.DefaultWidth
  else
    TIWAdvChart1.Width := iCount * objINI.AutoWidth;
  if TIWAdvChart1.Width > 15000 then
  begin
    TIWAdvChart1.Width := 15000;
  end;
  TIWAdvChart1.Visible := True;
end;

end.
