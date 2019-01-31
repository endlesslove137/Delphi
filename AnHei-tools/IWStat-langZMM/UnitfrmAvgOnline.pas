unit UnitfrmAvgOnline;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWAdvChart, IWTMSCal, IWCompEdit, IWCompButton,
  IWCompListbox, IWTMSImgCtrls, IWControl, IWExchangeBar, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompRectangle,
  IWTMSCtrls, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion;

const
  curTitle = 25;//'平均在线';
    
type
  TIWfrmAvgOnline = class(TIWFormBasic)
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
    procedure QueryAvgOnline(curDateTime: TDateTime);
  end;

var
  IWfrmAvgOnline: TIWfrmAvgOnline;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmAvgOnline.IWAppFormCreate(Sender: TObject);
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

procedure TIWfrmAvgOnline.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryAvgOnline(pSDate.Date);
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

procedure TIWfrmAvgOnline.QueryAvgOnline(curDateTime: TDateTime);
const
  sqlAvgOnline = 'SELECT serverindex,AVG(onlinecount) AS onlinecount FROM log_onlinecount_%s WHERE serverindex>0 GROUP BY serverindex ORDER BY AVG(onlinecount) DESC';
  sqlMaxAvgOnline = 'SELECT AVG(onlinecount) AS onlinecount FROM log_onlinecount_%s WHERE serverindex=0';
var
  iCount,iTotal: Integer;
  XValue,spid: string;
  ServerListData: PTServerListData;  
begin
  with UserSession.quAvgOnline,TIWAdvChart1.Chart do
  begin
    SQL.Text := Format(sqlMaxAvgOnline,[FormatDateTime('yyyymmdd', curDateTime)]);
    Open;
    iTotal := FieldByName('onlinecount').AsInteger;
    Close;
    Series[0].ClearPoints;
    iCount := 0; 
    SQL.Text := Format(sqlAvgOnline,[FormatDateTime('yyyymmdd', curDateTime)]);
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
  TIWAdvChart1.Chart.Title.Text := Format(Langtostr(curTitle)+'(%d)',[iTotal]);
  TIWAdvChart1.Height := 80+iCount * objINI.AutoHeigth;
  TIWAdvChart1.Visible := True;
end;

initialization
  RegisterClass(TIWfrmAvgOnline);

end.
