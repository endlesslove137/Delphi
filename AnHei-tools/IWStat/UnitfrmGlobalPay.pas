unit UnitfrmGlobalPay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWTMSCal, IWAdvChart, IWCompListbox,
  IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompEdit, IWCompCheckbox;

const
  curTitle = 45;//'¸÷Çø³äÖµ';

type
  TIWfrmGlobalPay = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWAmdbMode: TIWCheckBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryGlobalPay(samdb,spid: string;ServerID: Integer;dRate: Double;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmGlobalPay: TIWfrmGlobalPay;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmGlobalPay.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  TIWAdvChart1.Chart.Series[0].ValueFormat := objINI.RMBFormat;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWBtnBuild.Caption := Langtostr(171);
end;

procedure TIWfrmGlobalPay.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date > pEDate.Date then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      QueryGlobalPay(psld.Amdb,psld.spID,psld.ServerID,psld.CurrencyRate,pSDate.Date,pEDate.Date+StrToTime('23:59:59'));
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

procedure TIWfrmGlobalPay.QueryGlobalPay(samdb,spid: string;ServerID: Integer;dRate: Double;MinDateTime, MaxDateTime: TDateTime);
const
  sqlGlobalPay = 'SELECT serverid,SUM(rmb) AS TotalMoney FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND orderdate>="%s" AND orderdate<"%s" GROUP BY serverid ORDER BY TotalMoney DESC';
  sqlGlobalPay2 = 'SELECT serverid,SUM(rmb) AS TotalMoney FROM %s.payorder_%s WHERE yunying="_%s" AND type = 3 and state = 1 AND orderdate>="%s" AND orderdate<"%s" GROUP BY serverid ORDER BY TotalMoney DESC';
var
  serverindex: Integer;
  dValue,TotalCount: Double;
  I,Idx,SIndex,curMoney: Integer;
  ServerListData: PTServerListData;
  DataList: TStringList;
begin
  with UserSession.quGlobalPay,TIWAdvChart1.Chart do
  begin
    Series[0].ClearPoints;
    TotalCount := 0;
    if IWAmdbMode.Checked then
     SQL.Text := Format(sqlGlobalPay2,[samdb,FormatDateTime('YYYYMM',MinDateTime),spid,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)])
    else
    SQL.Text := Format(sqlGlobalPay,[samdb,spid,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]);
    Open;
    DataList := TStringList.Create;
    try
      while not Eof do
      begin
        curMoney := FieldByName('TotalMoney').AsInteger;
        serverindex := FieldByName('serverid').AsInteger;
        ServerListData := GetServerListData(serverindex);
        if ServerListData <> nil then
        begin
          if ServerListData.JoinIdx <> 0 then
          begin
            Idx := DataList.IndexOf(IntToStr(ServerListData.JoinIdx));
            SIndex := ServerListData.JoinIdx;
          end
          else begin
            Idx := DataList.IndexOf(IntToStr(serverindex));
            SIndex := serverindex;
          end;
          if Idx = -1 then
            DataList.AddObject(IntToStr(SIndex),TObject(curMoney))
          else
            DataList.Objects[Idx] := TObject(Integer(DataList.Objects[Idx]) + curMoney);
        end;
        Next;
      end;
      for I := 0 to DataList.Count - 1 do
      begin
       // dValue := DivZero(Integer(DataList.Objects[I]),10) * dRate;
        dValue := DivZero(Integer(DataList.Objects[I]),dRate);
        TotalCount := TotalCount + dValue;
        Series[0].AddSinglePoint(dValue,GetServerListName(spid,StrToInt(DataList.Strings[I])));
      end;
      Range.RangeFrom := 0;
      Range.RangeTo := DataList.Count-1;
      TIWAdvChart1.Chart.Title.Text := Format(Langtostr(curTitle)+'('+objINI.RMBFormat+')',[TotalCount]);
      TIWAdvChart1.Height := 80+DataList.Count * objINI.AutoHeigth;
      TIWAdvChart1.Visible := True;
    finally
      DataList.Free;
      Close;
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmGlobalPay);

end.
