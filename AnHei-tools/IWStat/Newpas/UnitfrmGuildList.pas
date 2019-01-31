unit UnitfrmGuildList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = 80;//'行会信息';
  yyTypeStr: array[0..3] of integer = (424,425,426,427);

type
  TIWfrmGuildList = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton3: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
  public
    procedure QueryGuildlist(ServerIndex: Integer);
  end;

var
  IWfrmGuildList: TIWfrmGuildList;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmGuildList }

procedure TIWfrmGuildList.IWAppFormCreate(Sender: TObject);
var
  psld: PTServerListData;
begin
  inherited;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWButton3.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(428);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(429);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(430);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(431);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(432);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(433);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(434);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(435);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(258);
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);

    UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
    try
      QueryGuildlist(psld.Index);
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


procedure TIWfrmGuildList.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'GuildList' + DateToStr(Now) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmGuildList.QueryGuildlist(ServerIndex: Integer);
const
  sqlguildlist = 'SELECT guildid,guildname,foundname,level,nbidcoin,qqgroupid,yytpye,yygroupid,inmemo,outmemo,createtime FROM guildlist WHERE serverindex =%d  GROUP BY serverindex,guildid';
var
  iCount: Integer;
begin
   iCount := 0;
   TIWAdvWebGrid1.ClearCells;

   with UserSession.quUserInfo, TIWAdvWebGrid1 do
   begin
     SQL.Text := Format(sqlguildlist,[ServerIndex]);
     Open;
     while not Eof do
     begin
       RowCount := iCount + 1;
       cells[1,iCount] := IntToStr(FieldByName('guildid').AsInteger);
       cells[2,iCount] := Utf8ToString(FieldList.FieldByName('guildname').AsAnsiString);
       cells[3,iCount] := Utf8ToString(FieldList.FieldByName('foundname').AsAnsiString);
       cells[4,iCount] := IntToStr(FieldByName('level').AsInteger);
       cells[5,iCount] := IntToStr(FieldByName('nbidcoin').AsInteger);
       cells[6,iCount] := Utf8ToString(FieldByName('qqgroupid').AsAnsiString);
       cells[7,iCount] := Langtostr(yyTypeStr[FieldByName('yytpye').AsInteger]) + Utf8ToString(FieldByName('yygroupid').AsAnsiString);
       cells[8,iCount] := Utf8ToString(FieldList.FieldByName('inmemo').AsAnsiString);
       cells[9,iCount] := Utf8ToString(FieldList.FieldByName('outmemo').AsAnsiString);
       cells[10,iCount] := DateTimeToStr(FieldList.FieldByName('createtime').AsDateTime);
       Inc(iCount);
       Next;
     end;
     Close;
   end;
end;

initialization
  RegisterClass(TIWfrmGuildList);

end.
