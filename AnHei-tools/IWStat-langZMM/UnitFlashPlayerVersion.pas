unit UnitFlashPlayerVersion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWTMSCal,
  IWAdvChart;

const
  VersionChartColor : array [0..15] of Integer = (clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clLtGray, clGreen, clBlack, clMaroon, clOlive, clNavy, clPurple, clTeal, clGray, clSilver);

type
  TIWfrmFlashPlayerVersion = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    TIWAdvChart1: TTIWAdvChart;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryFlashPlayerVersion(sgstatic,sDate: string);
  end;

var
  IWfrmFlashPlayerVersion: TIWfrmFlashPlayerVersion;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmFlashPlayerVersion }

procedure TIWfrmFlashPlayerVersion.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbFlashPlayerVersion]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbFlashPlayerVersion]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbFlashPlayerVersion])]);
end;

procedure TIWfrmFlashPlayerVersion.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryFlashPlayerVersion(psld.GstaticDB,DateToStr(pSDate.Date));
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

procedure TIWfrmFlashPlayerVersion.QueryFlashPlayerVersion(sgstatic,sDate: string);
var
  I,VersionColor: Integer;
begin
  with UserSession.quInsiderAccount,TIWAdvChart1.Chart do
  begin
    SQL.Text := Format('SELECT SUBSTRING_INDEX(ver,",",2) as  ver,SUM(`count`) as iCount FROM %s.fpversion WHERE rptdate="%s" GROUP BY SUBSTRING_INDEX(ver,",",2) ORDER BY iCount DESC',[sgstatic,sDate]);
    Open;  I := 0;
    Series[0].ClearPoints;
    while not Eof do
    begin
      if I <= High(VersionChartColor) then
      begin
        VersionColor := VersionChartColor[I];
      end
      else begin
        Randomize;
        VersionColor := RGB(Random(255),Random(255),Random(255));
      end;
      Series[0].AddSinglePoint(Fields[1].AsInteger,VersionColor,Fields[0].AsString + '°æ±¾ ' + IntToStr(Fields[1].AsInteger));
      Inc(I);
      Next;
    end;
    Close;
  end;
  TIWAdvChart1.Visible := True;
end;

end.
