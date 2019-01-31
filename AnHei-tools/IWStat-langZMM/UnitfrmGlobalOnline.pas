unit UnitfrmGlobalOnline;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, IWCompButton, IWTMSCal,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompEdit;

const
  curTitle = 26;//'最高在线';

type
  TIWfrmGlobalOnline = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryGlobalOnline(curDateTime: TDateTime);
  end;

var
  IWfrmGlobalOnline: TIWfrmGlobalOnline;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmGlobalOnline.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(188);
  IWBtnBuild.Caption := Langtostr(171);
end;

procedure TIWfrmGlobalOnline.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryGlobalOnline(pSDate.Date);
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

procedure TIWfrmGlobalOnline.QueryGlobalOnline(curDateTime: TDateTime);
const
  sqlOnlineCount = 'SELECT serverindex,MAX(onlinecount) AS onlinecount FROM log_onlinecount_%s WHERE serverindex>0 GROUP BY serverindex ORDER BY onlinecount DESC';
  sqlTotalCount = 'SELECT MAX(onlinecount) AS onlinecount FROM log_onlinecount_%s WHERE serverindex=0';
var
  iCount,TotalCount,iTotal: Integer;
  XValue,spid: string;
  ServerListData: PTServerListData;
begin
  with UserSession.quGlobalOnline,TIWAdvChart1.Chart do
  begin
    SQL.Text := Format(sqlTotalCount,[FormatDateTime('yyyymmdd', curDateTime)]);
    Open;
    iTotal := FieldByName('onlinecount').AsInteger;
    Close;
    Series[0].ClearPoints;
    iCount := 0; TotalCount := 0;
    SQL.Text := Format(sqlOnlineCount,[FormatDateTime('yyyymmdd', curDateTime)]);
    Open;
    try
      spid := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]).spID;
      while not Eof do
      begin
        XValue := GetServerListName(spid,FieldByName('serverindex').AsInteger);
        ServerListData := GetServerListData(spid,FieldByName('serverindex').AsInteger);
        if ServerListData <> nil then
        begin
          if (ServerListData.spID = spid) then
          begin
            Inc(TotalCount,FieldByName('onlinecount').AsInteger);
            Inc(iCount);
            Series[0].AddSinglePoint(ChangeZero(FieldByName('onlinecount').AsInteger),XValue);
          end;
        end;
        Next;
      end;
    finally
      Close;
    end;
    Range.RangeFrom := 0;
    Range.RangeTo := iCount-1;
  end;
  TIWAdvChart1.Chart.Title.Text := Format(Langtostr(curTitle)+'(%d/%d)',[iTotal,TotalCount]);
  TIWAdvChart1.Height := 80+iCount * objINI.AutoHeigth;
  TIWAdvChart1.Visible := True;
end;

initialization
  RegisterClass(TIWfrmGlobalOnline);

end.
