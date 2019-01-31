unit UnitfrmRoleInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompEdit, IWCompButton, IWWebGrid, IWAdvWebGrid,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWTMSEdit, IWTMSCal,
  IWCompCheckbox;

const
  curTitle = 76;//'╫ги╚пео╒';

type
  TIWfrmRoleInfo = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWBtnBuild: TIWButton;
    IWLabel3: TIWLabel;
    IWedtAccount: TIWEdit;
    IWLabel4: TIWLabel;
    IWedtRole: TIWEdit;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel2: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWButton1: TIWButton;
    IWLabel5: TIWLabel;
    IWSpidkBox: TIWCheckBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryRoleInfo(sAccount,sRole,SDTime,SETime: string);
  end;

var
  IWfrmRoleInfo: TIWfrmRoleInfo;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

{ TIWfrmRoleInfo }

procedure TIWfrmRoleInfo.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date;
  pSTime.Time := StrToTime('00:00:00');
  pEDate.Date := Date;
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(150);
  IWLabel2.Caption := Langtostr(151);
  IWLabel3.Caption := Langtostr(325);
  IWLabel4.Caption := Langtostr(377);
  IWLabel5.Caption := Langtostr(395);
  IWBtnBuild.Caption := Langtostr(14);
  IWButton1.Caption := Langtostr(182);
  IWSpidkBox.Caption := Langtostr(320);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(378);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(367);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(368);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(263);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(379);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(341);
  TIWAdvWebGrid1.Columns[8].Title:= Langtostr(340);
  TIWAdvWebGrid1.Columns[9].Title:= Langtostr(339);
  TIWAdvWebGrid1.Columns[10].Title:= Langtostr(338);
  TIWAdvWebGrid1.Columns[11].Title:= Langtostr(380);
  TIWAdvWebGrid1.Columns[12].Title:= Langtostr(381);
  TIWAdvWebGrid1.Columns[13].Title:= Langtostr(382);
  TIWAdvWebGrid1.Columns[14].Title:= Langtostr(343);
  TIWAdvWebGrid1.Columns[15].Title:= Langtostr(369);
  TIWAdvWebGrid1.Columns[16].Title:= Langtostr(383);
  TIWAdvWebGrid1.Columns[17].Title:= Langtostr(384);
  TIWAdvWebGrid1.Columns[18].Title:= Langtostr(258);
  TIWAdvWebGrid1.Columns[19].Title:= Langtostr(386);
  TIWAdvWebGrid1.Columns[20].Title:= Langtostr(387);
  TIWAdvWebGrid1.Columns[21].Title:= Langtostr(257);
  TIWAdvWebGrid1.Columns[22].Title:= Langtostr(385);
  TIWAdvWebGrid1.Columns[23].Title:= Langtostr(388);
  TIWAdvWebGrid1.Columns[24].Title:= Langtostr(389);
  TIWAdvWebGrid1.Columns[25].Title:= Langtostr(390);
  TIWAdvWebGrid1.Columns[26].Title:= Langtostr(391);
  TIWAdvWebGrid1.Columns[27].Title:= Langtostr(392);
  TIWAdvWebGrid1.Columns[28].Title:= Langtostr(393);
  TIWAdvWebGrid1.Columns[29].Title:= Langtostr(661);
  TIWAdvWebGrid1.Columns[30].Title:= Langtostr(660);
  TIWAdvWebGrid1.Columns[31].Title:= Langtostr(394);
end;

procedure TIWfrmRoleInfo.IWBtnBuildClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    if (IWedtAccount.Text = '') and (IWedtRole.Text = '') then
    begin
      WebApplication.ShowMessage(Langtostr(375));
      Exit;
    end;
    if IWedtAccount.Text <> '' then
    begin
      if not IWSpidkBox.Checked then
      begin
        if Pos('_'+ServerListData.spID,IWedtAccount.Text) = 0 then
        begin
          IWedtAccount.Text := IWedtAccount.Text + '_'+ServerListData.spID;
        end;
      end;
    end;
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    UserSession.quWebGrid.SQLConnection := UserSession.SQLConnectionRole;
    try
      QueryRoleInfo(IWedtAccount.Text,IWedtRole.Text,DateTimeToStr(pSDate.Date+pSTime.Time),DateTimeToStr(pEDate.Date+pETime.Time));
      TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(194),[Langtostr(curTitle),TIWAdvWebGrid1.TotalRows]);
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

procedure TIWfrmRoleInfo.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'RoleInfo' + DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmRoleInfo.QueryRoleInfo(sAccount, sRole,SDTime,SETime: string);
const
  sqlRoleInfo = 'SELECT accountname,actorname,sex,job,a.level,exp,nonbindyuanbao,bindyuanbao,nonbindcoin,'+
                'bindcoin,pkvalue,zhanhunvalue,achievepoint,honourval,circle,circlesoul,energy,a.createtime,updatetime,'+
                'baggridcount,INET_NTOA(lastloginip),nridelevel,mountexp,ntakeonrideid,FROM_UNIXTIME(1262275200 + rideexpiredtime),'+
                'viplevel,FROM_UNIXTIME(1262275200 + vipdurtime), depotlockpwd, depotcoin, depotyb, b.guildname FROM actors a LEFT JOIN guildlist b ON a.guildid=b.guildid WHERE '+
                'a.createtime>="%s" AND a.createtime<="%s" AND ';
  sqlAccount = ' a.accountname=%s AND ';
  sqlRole = ' a.actorname=%s AND ';
  sASex: array[0..1] of Integer = (372,373);
var
  I,iCount: Integer;
  sSQL: string;
begin
  with UserSession.quWebGrid,TIWAdvWebGrid1 do
  begin
    iCount := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    sSQL := Format(sqlRoleInfo,[SDTime,SETime]);
    if sAccount <> '' then
    begin
      sSQL := sSQL + Format(sqlAccount,[QuerySQLStr(sAccount)]);
    end;
    if sRole <> '' then
    begin
      sSQL := sSQL + Format(sqlRole,[QuerySQLStr(sRole)]);
    end;
    System.Delete(sSQL,Length(sSQL)-4,4);
    SQL.Text := sSQL;
    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      for I := 1 to Columns.Count - 1 do
      begin
        case I of
          1,2,28,31: cells[I,iCount] := Utf8ToString(Fields[I-1].AsAnsiString);
          3: cells[I,iCount] := Langtostr(sASex[Fields[I-1].AsInteger]);
          4: cells[I,iCount] := Langtostr(sRoleJob[Fields[I-1].AsInteger]);
        else
          begin
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
  RegisterClass(TIWfrmRoleInfo);

end.
