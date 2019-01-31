unit UnitfrmCountry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer,IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, IWCompButton, IWCompEdit, IWTMSEdit, IWControl,
  IWTMSCal, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompLabel,
  AdvChart, IWAdvToolButton, IWTMSImgCtrls, IWCompListbox,
  IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  CountryChartColor : array [0..2] of Integer = (clRed, clGreen, clYellow);

type
  TIWfrmCountry = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    TIWAdvChart1: TTIWAdvChart;
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    DataList: TStrings;
  public
    procedure QueryCountry(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmCountry: TIWfrmCountry;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmCountry.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  DataList := TStringList.Create;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(StatToolButtonStr[tbCountry]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbCountry]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbCountry])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
end;

procedure TIWfrmCountry.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
  DataList.Free;
end;

procedure TIWfrmCountry.IWBtnBuildClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  if pSDate.Date + pSTime.Time > pEDate.Date + pETime.Time then
  begin
    WebApplication.ShowMessage('起始日期应大于或等于结束日期，请重新选择');
    Exit;
  end;
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      QueryCountry(ServerListData.Index,pSDate.Date + pSTime.Time,pEDate.Date + pETime.Time);
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

procedure TIWfrmCountry.QueryCountry(ServerIndex: Integer;MinDateTime, MaxDateTime: TDateTime);
const
  sqlCountryCount = 'SELECT zy,COUNT(1) AS iCount FROM actors WHERE updatetime>= "%s" AND updatetime<="%s" GROUP BY zy';
  sCountry : array [0..2] of string = ('无忌', '逍遥', '日月');
var
  I,iValue: Integer;
begin
  with UserSession.quCountryCount,TIWAdvChart1.Chart do
  begin
    SQL.Text := Format(sqlCountryCount,[DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]);
    Open;
    Series[0].ClearPoints;
    try
      while not Eof do
      begin
        I := FieldByName('zy').AsInteger-1;
        iValue := FieldByName('iCount').AsInteger;
        if (I>=0) and (I<=High(sCountry)) then
        begin
          Series[0].AddSinglePoint(iValue,CountryChartColor[I],sCountry[I]+ ' ' + IntToStr(iValue) + ' ');
        end;
        Next;
      end;
    finally
      Close;
    end;
    TIWAdvChart1.Visible := True;
  end;
end;

initialization
  RegisterClass(TIWfrmCountry);

end.
