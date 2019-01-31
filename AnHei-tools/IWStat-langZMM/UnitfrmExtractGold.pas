unit UnitfrmExtractGold;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWWebGrid, IWAdvWebGrid, IWVCLBaseContainer, IWContainer,
  IWHTMLContainer, IWHTML40Container, IWRegion, IWCompEdit, IWCompButton,
  IWTMSCal, IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls,
  IWCompCheckbox;

const
  curTitle = 91;//'Ôª±¦ÌáÈ¡';

type
  TIWfrmExtractGold = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWedtAccount: TIWEdit;
    IWLabel2: TIWLabel;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton1: TIWButton;
    IWSpidkBox: TIWCheckBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure TIWAdvWebGrid1ColumnHeaderClick(Sender: TObject;
      ColumnIndex: Integer);
    procedure IWButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryExtractGold(samdb,spid,sAccount:string;MinDate,MaxDate: TDate);
  end;

var
  IWfrmExtractGold: TIWfrmExtractGold;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmExtractGold.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date;
  pEDate.Date := Date;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWLabel2.Caption := Langtostr(283);
  IWBtnBuild.Caption := Langtostr(14);
  IWButton1.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(505);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(506);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(507);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(366);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(508);
end;

procedure TIWfrmExtractGold.IWBtnBuildClick(Sender: TObject);
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
    if IWedtAccount.Text <> '' then
    begin
      if not IWSpidkBox.Checked then
      begin
        if Pos('_'+psld.spID,IWedtAccount.Text) = 0 then
        begin
          IWedtAccount.Text := IWedtAccount.Text + '_'+psld.spID;
        end;
      end;
    end;
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    UserSession.quWebGrid.SQLConnection := UserSession.SQLConnectionSession;
    try
      QueryExtractGold(psld^.Amdb,psld^.spID,IWedtAccount.Text,pSDate.Date,pEDate.Date);
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

procedure TIWfrmExtractGold.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'ExtractGold' + DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmExtractGold.QueryExtractGold(samdb,spid,sAccount: string; MinDate,
  MaxDate: TDate);
const
  sqlExtractGold = 'SELECT b.account,a.consume,a.remain,a.srvid,a.charname,a.recdate FROM %s.amorder a,globaluser b WHERE a.userid=b.userid AND right(b.account,4)= "_%s" and a.recdate >="%s" AND a.recdate<"%s" %s';
  sqlAccount = ' AND account=%s';
var
  strSQL: string;
  I,iCount,iTotal: Integer;
begin
  with UserSession.quWebGrid,TIWAdvWebGrid1 do
  begin
    iCount := 0; iTotal := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    strSQL := '';
    if sAccount <> '' then
    begin
      strSQL := Format(sqlAccount,[QuerySQLStr(sAccount)]);
    end;
    SQL.Text := Format(sqlExtractGold,[samdb,spid,DateToStr(MinDate),FormatDateTime('YYYY-MM-DD 23:59:59',MaxDate),strSQL]);
    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      for I := 1 to Columns.Count - 1 do
      begin
        if I=2 then Inc(iTotal,FieldList.Fields[I-1].AsInteger);
        case I of
          1,5:cells[I,iCount] := Utf8ToString(FieldList.Fields[I-1].AsAnsiString);
          4:
          begin
            cells[I,iCount] := GetServerListName(spid,FieldList.Fields[I-1].AsInteger);
          end
          else begin
            cells[I,iCount] := FieldList.Fields[I-1].AsString;
          end;
        end;
      end;
      Inc(iCount);
      Next;
    end;
    TotalRows := iCount;
    Close;
    Columns[2].FooterText := Format(langtostr(504),[iTotal]);
  end;
end;

procedure TIWfrmExtractGold.TIWAdvWebGrid1ColumnHeaderClick(Sender: TObject;
  ColumnIndex: Integer);
begin
//  inherited;

end;

initialization
  RegisterClass(TIWfrmExtractGold);

end.
