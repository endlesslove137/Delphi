unit UnitfrmConsumeYXB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWWebGrid,
  IWAdvWebGrid, IWTMSCal, IWCompCheckbox;

type
  TIWfrmConsumeYXB = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWButton1: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel3: TIWLabel;
    IWedtAccount: TIWEdit;
    IWSpidkBox: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryConsumeYXB(spid,sAccount: string;ConsumDate: TDate);
  end;

var
  IWfrmConsumeYXB: TIWfrmConsumeYXB;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmConsumeYXB.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbConsumeYXB]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbConsumeYXB]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbConsumeYXB])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(188);
  IWLabel3.Caption := Langtostr(325);
  IWBtnBuild.Caption := Langtostr(171);
  IWButton1.Caption := Langtostr(182);
  IWSpidkBox.Caption := Langtostr(320);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(189);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(321);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(322);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(323);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(324);
end;

procedure TIWfrmConsumeYXB.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
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
    try
      QueryConsumeYXB(psld^.spID,IWedtAccount.Text,pSDate.Date);
      TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(194),[Langtostr(StatToolButtonStr[tbConsumeYXB]),TIWAdvWebGrid1.TotalRows]);
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

procedure TIWfrmConsumeYXB.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'ConsumeQuery' + DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmConsumeYXB.QueryConsumeYXB(spid,sAccount: string;ConsumDate: TDate);
const                                                                                                                                                               ///SUM(paymentcount*-1)
  sqlConsume = 'SELECT account,ServerIndex,SUM(CASE moneytype WHEN 3 THEN paymentcount*-1 ELSE 0 END) as Gold,SUM(CASE moneytype WHEN 2 THEN paymentcount*-1 ELSE 0 END) as BindGold,SUM(Gold + BindGold),MAX(logdate) '+'FROM log_consume_%s WHERE logid not in (122,142) AND paymentcount<=0 %s GROUP BY account ORDER BY Gold DESC';
  sqlAccount = ' AND account=%s';
var
  I,iCount: Integer;
begin
  if sAccount <> '' then
  begin
    sAccount := Format(sqlAccount,[QuerySQLStr(sAccount)]);
  end;
  with UserSession.quConsume,TIWAdvWebGrid1 do
  begin
    iCount := 0;
    ClearCells;
    SQL.Text := Format(sqlConsume,[FormatDateTime('YYYYMMDD',ConsumDate),sAccount]);
    Open;
    RowCount := objINI.MaxPageCount;
                                              
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      for I := 1 to Columns.Count - 1 do
      begin
        if I = 2 then
        begin
          cells[I,iCount] := GetServerListName(spid,Fields[I-1].AsInteger);
        end
        else begin
          cells[I,iCount] := Utf8ToString(Fields[I-1].AsAnsiString);
        end;
      end;
      Inc(iCount);
      Next;
    end;
    if iCount < objINI.MaxPageCount then
    begin
      RowCount := iCount;
    end;
    TotalRows := iCount;
    Close;
  end;
end;

initialization
  RegisterClass(TIWfrmConsumeYXB);

end.
