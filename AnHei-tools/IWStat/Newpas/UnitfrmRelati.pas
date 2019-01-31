unit UnitfrmRelati;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = 79;//'社交关系';

type
  TIWfrmRelati = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    IWBtnBuild: TIWButton;
    IWedtUserID: TIWEdit;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel2: TIWLabel;
    IWedtUserName: TIWEdit;
    IWLabel3: TIWLabel;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
  public
    procedure QueryRelati(suserid, susername: string);
  end;

var
  IWfrmRelati: TIWfrmRelati;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmRelati }

procedure TIWfrmRelati.IWAppFormCreate(Sender: TObject);
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
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(422);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(423);
end;

procedure TIWfrmRelati.IWBtnBuildClick(Sender: TObject);
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
      QueryRelati(IWedtUserID.Text, IWedtUserName.Text);
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

procedure TIWfrmRelati.QueryRelati(suserid,susername: string);
const
  sqluserrelati = 'SELECT b.actorid, b.actorname, a.nactorid, a.ntype, COUNT(1) AS iCount FROM friends a LEFT JOIN actors b ON a.nactorid = b.actorid WHERE a.nactorid > 0 %s GROUP BY ntype';

  sqluserid   = ' and b.actorid =%s ';
  sqlusername = ' and b.actorname =%s ';
var
  iCount, acount: Integer;
  sWhere: string;
begin
   iCount := 0; acount := 0; sWhere := '';
   TIWAdvWebGrid1.ClearCells;

   if suserid <> '' then
   begin
      sWhere := Format(sqluserid,[suserid]);
   end;

   if susername <> '' then
   begin
     sWhere := sWhere + Format(sqlusername,[QuerySQLStr(susername)]);
   end;

   with UserSession.quUserInfo, TIWAdvWebGrid1 do
   begin
     SQL.Text := Format(sqluserrelati,[sWhere]);
     Open;
     while not Eof do
     begin
       RowCount := iCount + 1;
       cells[1,iCount] := IntToStr(FieldByName('actorid').AsInteger);
       cells[2,iCount] := Utf8ToString(FieldList.FieldByName('actorname').AsAnsiString);
       cells[3,iCount] := IntToStr(FieldByName('ntype').AsInteger);
       cells[4,iCount] := IntToStr(FieldByName('iCount').AsInteger);
       acount:= acount + FieldByName('iCount').AsInteger;
       Inc(iCount);
       Next;
     end;
     Close;
   end;
   with TIWAdvWebGrid1 do
   begin
     TotalRows := iCount;
     Columns[1].FooterText := Langtostr(420);
     Columns[2].FooterText := '';
     Columns[3].FooterText := '';
     Columns[4].FooterText := IntToStr(acount) + Langtostr(421);
     TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(194),[Langtostr(curTitle),TIWAdvWebGrid1.TotalRows]);
   end;
end;

initialization
  RegisterClass(TIWfrmRelati);

end.
