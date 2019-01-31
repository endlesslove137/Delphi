unit UnitfrmCurOnline;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, IWCompButton, IWCompListbox,
  IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompEdit, DateUtils;

const
  curTitle = 24;//'实时在线';

type
  TIWfrmCurOnline = class(TIWFormBasic)
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryCurOnline;
  end;

var
  IWfrmCurOnline: TIWfrmCurOnline;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmCurOnline.IWAppFormCreate(Sender: TObject);
var
  psld: PTServerListData;
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryCurOnline;
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

procedure TIWfrmCurOnline.QueryCurOnline;
const
  sqlOnlineCount = 'SELECT a.Serverindex,OnlineCount FROM (SELECT Serverindex,max(Logdate)as ldate FROM log_onlinecount_%s group by Serverindex)a LEFT JOIN log_onlinecount_%s b ON a.ldate=b.Logdate AND a.Serverindex=b.Serverindex WHERE a.Serverindex <> 0 and ldate > "%s"';
var
  I,Idx,serverindex,TotalCount: Integer;
  DataList: TStringList;
  spid: string;
begin
  with UserSession.quCurOnline,TIWAdvChart1,Chart do
  begin
    Series[0].ClearPoints;
    SQL.Text := Format(sqlOnlineCount,[FormatDateTime('yyyymmdd', Now),FormatDateTime('yyyymmdd', Now),FormatDateTime('yyyy-mm-dd hh:mm:ss', IncMinute(Now, -20))]);
    Open;
    DataList := TStringList.Create;
    try
      TotalCount := 0;
      spid := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]).spID;
      while Not Eof do
      begin
        serverindex := FieldByName('Serverindex').AsInteger;
        if GetServerIsdisplay(spid,serverindex) then
        begin
          Inc(TotalCount,FieldByName('OnlineCount').AsInteger);
          Idx := DataList.IndexOf(IntToStr(serverindex));
          if Idx = -1 then
            DataList.AddObject(IntToStr(serverindex),TObject(FieldByName('OnlineCount').AsInteger))
          else
            DataList.Objects[Idx] := TObject(Integer(DataList.Objects[Idx]) + FieldByName('OnlineCount').AsInteger);
        end;
        Next;
      end;
      for I := 0 to DataList.Count - 1 do
      begin
        Series[0].AddSinglePoint(ChangeZero(Integer(DataList.Objects[I])),GetServerListName(spid,StrToInt(DataList.Strings[I])));
      end;
      Range.RangeFrom := 0;
      Range.RangeTo := DataList.Count-1;
      TIWAdvChart1.Chart.Title.Text := Format(Langtostr(curTitle)+'(%d)',[TotalCount]);
      TIWAdvChart1.Height := 80+DataList.Count * objINI.AutoHeigth;
      TIWAdvChart1.Visible := True;
    finally
      DataList.Free;
      Close;
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmCurOnline);

end.
