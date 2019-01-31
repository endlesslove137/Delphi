unit UnitfrmHeroInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = 77;//'Ó¢ÐÛÐÅÏ¢';

type
  TIWfrmHeroInfo = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    IWBtnBuild: TIWButton;
    IWedtUserID: TIWEdit;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    TIWAdvWebGrid2: TTIWAdvWebGrid;
    IWLabel2: TIWLabel;
    IWedtUserName: TIWEdit;
    TIWAdvWebGrid3: TTIWAdvWebGrid;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
  public
    procedure QueryHeroInfo(suserid, susername: string);
  end;

var
  IWfrmHeroInfo: TIWfrmHeroInfo;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmHeroInfo }

procedure TIWfrmHeroInfo.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(396);
  IWLabel2.Caption := Langtostr(366);
  IWBtnBuild.Caption := Langtostr(14);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(396);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(378);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(397);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(398);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(399);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(400);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(401);

  TIWAdvWebGrid3.Columns[1].Title:= Langtostr(402);
  TIWAdvWebGrid3.Columns[2].Title:= Langtostr(403);
  TIWAdvWebGrid3.Columns[3].Title:= Langtostr(404);
  TIWAdvWebGrid3.Columns[4].Title:= Langtostr(405);

  TIWAdvWebGrid2.Columns[1].Title:= Langtostr(406);
  TIWAdvWebGrid2.Columns[2].Title:= Langtostr(407);
  TIWAdvWebGrid2.Columns[3].Title:= Langtostr(408);
  TIWAdvWebGrid2.Columns[4].Title:= Langtostr(409);
end;

procedure TIWfrmHeroInfo.IWBtnBuildClick(Sender: TObject);
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
      QueryHeroInfo(IWedtUserID.Text, IWedtUserName.Text);
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

procedure TIWfrmHeroInfo.QueryHeroInfo(suserid,susername: string);
const
  sqluserhero = 'SELECT b.actorid, b.actorname, a.name, a.level, a.circle, a.vocation FROM actorpets a LEFT JOIN actors b ON a.actorid = b.actorid  WHERE a.actorid > 0 %s';
  sqlheroskill= 'SELECT actorid, petid,skillid,reserver, skillexp FROM petskills WHERE actorid = %d GROUP BY petid, skillid';
  sqlheroitem = 'SELECT actorid, itemidquastrong,CAST(itemguid as char(255)) as itemguid,(itemcountflag & 0xFF) as itemcountflag FROM actorpetitem WHERE actorid = %d ';

  sqluserid   = ' and b.actorid =%s ';
  sqlusername = ' and b.actorname =%s ';
var
  iCount, iCount2, iCount3, iuserid: Integer;
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
        cells[3,iCount] := Utf8ToString(FieldList.FieldByName('name').AsAnsiString);
        cells[4,iCount] := IntToStr(FieldByName('level').AsInteger);
        cells[5,iCount] := IntToStr(FieldByName('circle').AsInteger);
        cells[6,iCount] := Langtostr(sRoleJob[FieldByName('vocation').AsInteger]);
        iuserid := FieldByName('actorid').AsInteger;
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;
  procedure BuildSQLSkillData(sSQL: string);
  begin
    with UserSession.quUserInfo, TIWAdvWebGrid2 do
    begin
      SQL.Text := sSQL;
      Open;
      while not Eof do
      begin
        RowCount := iCount2 + 1;
        cells[1,iCount2] := IntToStr(FieldByName('petid').AsInteger);
        cells[2,iCount2] := IntToStr(FieldByName('skillid').AsInteger);
        cells[3,iCount2] := IntToStr(FieldByName('reserver').AsInteger);
        cells[4,iCount2] := IntToStr(FieldByName('skillexp').AsInteger);
        Inc(iCount2);
        Next;
      end;
      Close;
    end;
  end;
  procedure BuildSQLItemData(sSQL: string);
  begin
    with UserSession.quUserInfo, TIWAdvWebGrid3 do
    begin
      SQL.Text := sSQL;
      Open;
      while not Eof do
      begin
        RowCount := iCount3 + 1;
        cells[1,iCount3] := IntToStr(LoWord(FieldByName('itemIdQuaStrong').AsInteger));
        cells[2,iCount3] := OnGetStdItemName(LoWord(FieldByName('itemIdQuaStrong').AsInteger));
        cells[3,iCount3] := FieldList.FieldByName('itemguid').AsString;
        cells[4,iCount3] := IntToStr(Hi(HiWord(FieldByName('itemIdQuaStrong').AsInteger)));
        Inc(iCount3);
        Next;
      end;
      Close;
    end;
  end;
begin
   iCount := 0; iCount2 := 0; iCount3 := 0;
   iuserid := 0;sWhere := '';
   TIWAdvWebGrid1.ClearCells;
   TIWAdvWebGrid2.ClearCells;
   TIWAdvWebGrid3.ClearCells;
   if suserid <> '' then
   begin
      sWhere := Format(sqluserid,[suserid]);
   end;

   if susername <> '' then
   begin
     sWhere := sWhere + Format(sqlusername,[QuerySQLStr(susername)]);
   end;

   BuildSQLData(Format(sqluserhero,[sWhere]));
   BuildSQLItemData(Format(sqlheroitem,[iuserid]));
   BuildSQLSkillData(Format(sqlheroskill,[iuserid]));
end;

initialization
  RegisterClass(TIWfrmHeroInfo);

end.
