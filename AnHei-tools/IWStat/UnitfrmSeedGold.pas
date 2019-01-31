unit UnitfrmSeedGold;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWAdvChart,
  IWTMSEdit, IWTMSCal;

const
  SeedGoldColor : array [0..3] of Integer = (clRed, clGreen, clYellow, clBlue);

type
  TIWfrmSeedGold = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    TIWAdvChart1: TTIWAdvChart;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QuerySeedGold(slog: string; ServerIndex: Integer;dRate: Double;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmSeedGold: TIWfrmSeedGold;

implementation

uses ConfigINI, ServerController, Share;

{$R *.dfm}

procedure TIWfrmSeedGold.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(StatToolButtonStr[tbSeedGold]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbSeedGold]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbSeedGold])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
end;

procedure TIWfrmSeedGold.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date + pSTime.Time > pEDate.Date + pETime.Time then
  begin
    WebApplication.ShowMessage('起始日期应大于或等于结束日期，请重新选择');
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB, psld.LogHostName);
    try
      QuerySeedGold(psld.LogDB, psld.Index, psld.CurrencyRate,pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
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

procedure TIWfrmSeedGold.QuerySeedGold(slog: string; ServerIndex: Integer;dRate: Double; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlSeedGold = 'SELECT para1*-1 as SeedGold,SUM(para1*-1) AS TotalGold FROM log_common_%s WHERE logid=142 AND serverindex=%d AND logdate>="%s" AND logdate<="%s" GROUP BY para1';
  sqlGroup = 'SELECT SeedGold,SUM(TotalGold) AS TotalGold FROM (%s) tmpGold GROUP BY SeedGold';
  sqlUnionALL = ' UNION ALL ';
var
  I: Integer;
  sSQL: string;
  dValue,dTotal: Double;
begin
  while MinDateTime<=MaxDateTime do
  begin
    if UserSession.IsCheckTable(slog,Format('log_common_%s',[FormatDateTime('YYYYMMDD',MinDateTime)])) then
    begin
      sSQL := sSQL+ Format(sqlSeedGold,[FormatDateTime('YYYYMMDD',MinDateTime),ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)])+sqlUnionALL;
    end;
    MinDateTime := MinDateTime+1;
  end;
  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    I := 0; dTotal := 0;
    with UserSession.quSeedGold,TIWAdvChart1.Chart do
    begin
      Series[0].ClearPoints;
      SQL.Text := Format(sqlGroup,[sSQL]);
      Open;
      try
        while not Eof do
        begin
          if I > High(SeedGoldColor) then break;
          dValue := DivZero(FieldByName('TotalGold').AsInteger,10)*dRate;
          dTotal := dTotal+ dValue;
          Series[0].AddSinglePoint(dValue,SeedGoldColor[I],Format('%d (%.1f)',[FieldByName('SeedGold').AsInteger div 10,dValue]));
          Inc(I);
          Next;
        end;
        Title.Text := Format(Langtostr(StatToolButtonStr[tbSeedGold])+'('+objINI.RMBFormat+')',[dTotal]);
      finally
        Close;
      end;
    end;
  end;
  TIWAdvChart1.Visible := True;
end;

end.
