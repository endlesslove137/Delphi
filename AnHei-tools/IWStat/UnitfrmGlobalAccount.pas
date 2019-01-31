unit UnitfrmGlobalAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWAdvChart,
  IWTMSEdit, IWTMSCal, AdvChart, DateUtils, IWWebGrid, IWAdvWebGrid;

type
  TIWfrmGlobalAccount = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWLabel4: TIWLabel;
    IWComboBox1: TIWComboBox;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton3: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTicksType;
  public
    procedure QueryGlobalAccount(MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmGlobalAccount: TIWfrmGlobalAccount;

const
  TickTypeStr : array[0..6] of Integer = (173,174,175,176,177,178,179);

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmGlobalAccount.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(StatToolButtonStr[tbGlobalAccount]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbGlobalAccount]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbGlobalAccount])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  LoadTicksType;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel4.Caption := Langtostr(170);
  IWBtnBuild.Caption := Langtostr(171);
  IWButton3.Caption := Langtostr(182);

  TIWAdvChart1.Chart.Title.Text := Langtostr(StatToolButtonStr[tbGlobalAccount]);
  TIWAdvWebGrid1.Columns[1].Title := Langtostr(244);
  TIWAdvWebGrid1.Columns[2].Title := Langtostr(195);
end;

procedure TIWfrmGlobalAccount.LoadTicksType;
var
  cstr: Integer;
begin
  IWComboBox1.Items.Clear;
  for cstr in TickTypeStr do
  begin
    IWComboBox1.Items.Add(Langtostr(cstr));
  end;
  IWComboBox1.ItemIndex := 0;
end;

procedure TIWfrmGlobalAccount.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172){'起始日期应小于或等于结束日期，请重新选择'});
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      QueryGlobalAccount(pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
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

procedure TIWfrmGlobalAccount.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'GlobalAccount' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmGlobalAccount.QueryGlobalAccount(MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlGlobalAccount = 'SELECT COUNT(account) as iCount,createtime FROM globaluser WHERE createtime>"%s" AND createtime<="%s"';
var
  XFormat: string;
  sqlMaxTime: TDateTime;
  iCount, iAutoWidth,iTotalCount: Integer;
  function IncChartDateTime(tmpDateTime: TDateTime): TDateTime;
  begin
    Result := tmpDateTime;
    iAutoWidth := objINI.AutoWidth;
    case IWComboBox1.ItemIndex of
      0:begin
          XFormat := 'MM-DD HH';
          Result := IncHour(tmpDateTime,1);
        end;
      1:begin
          XFormat := 'MM-DD HH';
          Result := IncHour(tmpDateTime,2);
        end;
      2:begin
          XFormat := 'MM-DD HH';
          Result := IncHour(tmpDateTime,4);
        end;
      3:begin
          iAutoWidth := objINI.AutoWidth-10;
          XFormat := 'MM-DD';
          Result := IncDay(tmpDateTime,1);
        end;
      4:begin
          iAutoWidth := objINI.AutoWidth-10;
          XFormat := 'MM-DD';
          Result := IncWeek(tmpDateTime,1);
        end;
      5:begin //月
          iAutoWidth := objINI.AutoWidth-10;
          XFormat := 'YYYY-MM';
          Result := IncMonth(tmpDateTime,1);
        end;
      6:begin
          XFormat := 'DD HH:MM';
          Result := IncMinute(tmpDateTime,30);
        end;
      7:begin
          XFormat := 'DD HH:MM';
          Result := IncMinute(tmpDateTime,20);
        end;
      8:begin
          XFormat := 'DD HH:MM';
          Result := IncMinute(tmpDateTime,10);
        end;
    end;
  end;
begin
  iCount := 0; iTotalCount := 0;
  TIWAdvWebGrid1.ClearCells;
  with TIWAdvChart1.Chart do
  begin
    Series[0].ClearPoints;
    while MinDateTime<=MaxDateTime do
    begin
      sqlMaxTime := IncChartDateTime(MinDateTime);
      with UserSession.quGlobalAccount do
      begin
        SQL.Text := Format(sqlGlobalAccount,[DateTimeToStr(MinDateTime),DateTimeToStr(sqlMaxTime)]);
        Open;
        if FieldByName('createtime').AsString = '' then
        begin
          Series[0].AddSinglePoint(-1,FormatDateTime(XFormat,MinDateTime));
        end
        else
        begin
          Inc(iTotalCount, FieldByName('iCount').AsInteger);
          Series[0].AddSinglePoint(FieldByName('iCount').AsInteger,
                    FormatDateTime(XFormat,FieldByName('createtime').AsDateTime));
        end;
        with TIWAdvWebGrid1 do
        begin
          while not Eof do
          begin
            RowCount := iCount + 1;
            cells[1,iCount] := FormatDateTime(XFormat,FieldByName('createtime').AsDateTime);
            cells[2,iCount] := inttostr(FieldByName('iCount').AsInteger);
            Next;
          end;
        end;
        Close;
        Inc(iCount);
      end;
      if sqlMaxTime > Now() then break; 
      MinDateTime := sqlMaxTime;
    end;
    Range.RangeFrom := 0;
    Range.RangeTo := iCount-1;
    Title.Text := Format(Langtostr(StatToolButtonStr[tbGlobalAccount])+'(%d)',[iTotalCount]);
    Series[0].Autorange := arEnabledZeroBased;
  end;
  if iCount * iAutoWidth < objINI.DefaultWidth then
    TIWAdvChart1.Width := objINI.DefaultWidth
  else
    TIWAdvChart1.Width := iCount * iAutoWidth;
  TIWAdvChart1.Visible := True;


end;

initialization
  RegisterClass(TIWfrmGlobalAccount);
  
end.
