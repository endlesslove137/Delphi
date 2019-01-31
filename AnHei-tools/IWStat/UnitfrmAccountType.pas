unit UnitfrmAccountType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, IWCompButton, IWTMSCal,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompEdit;

const
  TypeChartColor : array [0..1] of Integer = (clRed, clGreen);
  curTitle = 40;//'新老账号统计';

type
  TIWfrmAccountType = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    TIWAdvChart1: TTIWAdvChart;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryAccountType(SelectDate,sAccounts,sHostName,OpenTime: string);
  end;

var
  IWfrmAccountType: TIWfrmAccountType;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmAccountType }

procedure TIWfrmAccountType.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel1.Caption := Langtostr(188);
  IWBtnBuild.Caption := Langtostr(171);

end;

procedure TIWfrmAccountType.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
  if (psld.OpenTime = '') or (StrToDateTime(psld.OpenTime)>Now) then
  begin
    Exit;
  end;
  try
    try
      QueryAccountType(DateToStr(pSDate.Date),psld.AccountDB,psld.SessionHostName,psld.OpenTime);
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

procedure TIWfrmAccountType.QueryAccountType(SelectDate,sAccounts,sHostName,OpenTime: string);
const
  sqlAccount = 'SELECT DISTINCT(accountname) FROM actors WHERE createtime>="%s" and createtime<="%s"';
  sqlGlobalUser = 'SELECT createtime FROM globaluser WHERE account in (%s)';
var
  iNewCount,iOldCount,iField: Integer;
  sAccount: string;
  procedure GetAccountCount(account: string);
  var
    sCreateTime: string;
  begin
    with UserSession.quSCommon do
    begin
      System.Delete(account,Length(account),1);
      SQL.Text := Format(sqlGlobalUser,[account]);
      Open;
      try
        while not Eof do
        begin
          sCreateTime := Fields[0].AsString;
          if (sCreateTime='') or (StrToDateTime(sCreateTime) < StrToDateTime(OpenTime)) then
          begin
            Inc(iOldCount);
          end
          else begin
            Inc(iNewCount);
          end;
          Next;
        end;
      finally
        Close;
      end;
    end;
  end;
begin
  iNewCount := 0; iOldCount := 0;
  UserSession.ConnectionSessionMysql(sAccounts,sHostName);
  try
    with UserSession.quAccountType do
    begin
      SQL.Text := Format(sqlAccount,[SelectDate+' 00:00:00',SelectDate+' 23:59:59']);
      Open;
      try
        sAccount := '';  iField := 0;
        while not Eof do
        begin
          sAccount := sAccount + QuotedStr(Fields[0].AsString) + ',';
          Inc(iField);
          if iField = 200 then
          begin
            iField := 0;
            GetAccountCount(sAccount);
            sAccount := '';
          end;
          Next;
        end;
        if iField > 0 then
        begin
          GetAccountCount(sAccount);
        end;
      finally
        Close;
      end;
    end;
  finally
    UserSession.SQLConnectionSession.Close;
  end;
  with TIWAdvChart1,Chart do
  begin
    Series[0].ClearPoints;
    Series[0].AddSinglePoint(iNewCount,TypeChartColor[0], Langtostr(305) + IntToStr(iNewCount) + ' ');
    Series[0].AddSinglePoint(iOldCount,TypeChartColor[1], Langtostr(306) + IntToStr(iOldCount) + ' ');
    Title.Text := Langtostr(curTitle) + '('+IntToStr(iNewCount+iOldCount)+')';
    Visible := True;
  end;
end;

initialization
  RegisterClass(TIWfrmAccountType);

end.
