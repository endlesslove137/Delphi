unit UnitfrmHunShiInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = 78;//'»êÊ¯ÐÅÏ¢';
  sItemsType : array [0..1] of Integer = (411, 412);

type
  TIWfrmHunShiInfo = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    IWBtnBuild: TIWButton;
    IWedtUserID: TIWEdit;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel2: TIWLabel;
    IWedtUserName: TIWEdit;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
  public
    procedure QueryHunShiInfo(suserid, susername: string);
  end;

var
  IWfrmHunShiInfo: TIWfrmHunShiInfo;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmHunShiInfo }

procedure TIWfrmHunShiInfo.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(396);
  IWLabel2.Caption := Langtostr(378);
  IWBtnBuild.Caption := Langtostr(14);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(396);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(378);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(413);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(414);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(415);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(416);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(417);
  TIWAdvWebGrid1.Columns[8].Title:= Langtostr(418);
  TIWAdvWebGrid1.Columns[9].Title:= Langtostr(419);
end;

procedure TIWfrmHunShiInfo.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if (IWedtUserID.Text = '') and (IWedtUserName.Text = '') then
  begin
    WebApplication.ShowMessage(Langtostr(410));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);

    UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
    try
      QueryHunShiInfo(IWedtUserID.Text, IWedtUserName.Text);
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

procedure TIWfrmHunShiInfo.QueryHunShiInfo(suserid,susername: string);
const
  sqluserhero = 'SELECT b.actorid, b.actorname, a.type, a.param, a.param1, a.param2, a.param3 FROM diamond a LEFT JOIN actors b ON a.actorid = b.actorid  WHERE a.actorid > 0 %s';

  sqluserid   = ' and b.actorid =%s ';
  sqlusername = ' and b.actorname =%s ';
var
  iCount : Integer;
  sWhere: string;
  procedure BuildSQLData(sSQL: string);
  begin
    with UserSession.quUserInfo, TIWAdvWebGrid1 do
    begin
      SQL.Text := sSQL;
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := IntToStr(FieldByName('actorid').AsInteger);
        cells[2,iCount] := Utf8ToString(FieldList.FieldByName('actorname').AsAnsiString);
        cells[3,iCount] := Langtostr(sItemsType[FieldList.FieldByName('type').AsInteger]);
        cells[4,iCount] := ItemTypeStr(FieldByName('param').AsInteger);
        cells[5,iCount] := OnGetStdItemName(HiWord(FieldByName('param1').AsInteger) and $7FFF);
        cells[6,iCount] := OnGetStdItemName(LoWord(FieldByName('param1').AsInteger)and $7FFF);
        cells[7,iCount] := OnGetStdItemName(HiWord(FieldByName('param2').AsInteger) and $7FFF);
        cells[8,iCount] := OnGetStdItemName(LoWord(FieldByName('param2').AsInteger)and $7FFF);
        cells[9,iCount] := OnGetStdItemName(HiWord(FieldByName('param3').AsInteger) and $7FFF);
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;
begin
   iCount := 0; sWhere := '';
   TIWAdvWebGrid1.ClearCells;

   if suserid <> '' then
   begin
      sWhere := Format(sqluserid,[suserid]);
   end;

   if susername <> '' then
   begin
     sWhere := sWhere + Format(sqlusername,[QuerySQLStr(susername)]);
   end;

   BuildSQLData(Format(sqluserhero,[sWhere]));
end;

initialization
  RegisterClass(TIWfrmHunShiInfo);

end.
