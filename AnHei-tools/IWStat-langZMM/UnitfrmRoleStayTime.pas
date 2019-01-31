unit UnitfrmRoleStayTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IWTMSImgCtrls, IWAdvToolButton,
  IWCompLabel, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWWebGrid, IWAdvWebGrid, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWCompEdit, IWTMSEdit, IWTMSCal,
  UnitfrmBasic, IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = 35;//'账号停留时间';

type
  TIWfrmRoleStayTime = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton1: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryRoleStayTime(MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmRoleStayTime: TIWfrmRoleStayTime;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmRoleStayTime }

procedure TIWfrmRoleStayTime.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWBtnBuild.Caption := Langtostr(171);
  IWButton1.Caption := Langtostr(182);
  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(257);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(258);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(259);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(260);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(261);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(262);
end;

procedure TIWfrmRoleStayTime.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage(Langtostr(172){'起始日期应小于或等于结束日期，请重新选择'});;
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      QueryRoleStayTime(pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
      TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(194),[Langtostr(curTitle),TIWAdvWebGrid1.TotalRows]);
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

procedure TIWfrmRoleStayTime.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'RoleStayTime'+DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmRoleStayTime.QueryRoleStayTime(MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlRoleStayTime = 'SELECT account,INET_NTOA(updateip),createtime,updatetime,offlinetime,fcmonline,totalonline FROM globaluser WHERE createtime>="%s" AND createtime<="%s" AND updatetime<>createtime ORDER BY totalonline DESC';
var
  I,iCount: Integer;
begin
  with UserSession.quRoleStayTime,TIWAdvWebGrid1 do
  begin
    iCount := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    SQL.Text := Format(sqlRoleStayTime,[DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]);
    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      for I := 1 to Columns.Count - 1 do
      begin
        case I of
          1:
          begin
            cells[I,iCount] := Utf8ToString(Fields[I-1].AsAnsiString);
          end;
          6,7:
          begin
            cells[I,iCount] := SecondToTime(Fields[I-1].AsInteger);
          end
          else begin
            cells[I,iCount] := Fields[I-1].AsString;
          end;
        end;
      end;
      Inc(iCount);
      Next;
    end;
    TotalRows := iCount;
    Close;
  end;
end;

initialization
  RegisterClass(TIWfrmRoleStayTime);
  
end.
