unit UnitfrmPayDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWAdvToolButton,
  IWCompLabel, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWWebGrid, IWAdvWebGrid, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWTMSCal, IWCompListbox,
  IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompEdit, IWCompCheckbox;

const
  curTitle = 92;//'³äÖµÃ÷Ï¸';

type
  TIWfrmPayDetail = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWButton1: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWAmdbMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryPayDetail(samdb,spid: string;sMinDate,sMaxDate: string);
  end;

var
  IWfrmPayDetail: TIWfrmPayDetail;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmPayDetail }

procedure TIWfrmPayDetail.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date;
  pEDate.Date := Date;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel2.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);

  IWBtnBuild.Caption := Langtostr(14);
  IWButton1.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(501);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(509);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(256);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(510);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(189);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(511);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(190);
  TIWAdvWebGrid1.Columns[8].Title:= Langtostr(512);
end;

procedure TIWfrmPayDetail.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    UserSession.quWebGrid.SQLConnection := UserSession.SQLConnectionSession;
    try
      QueryPayDetail(psld.Amdb,psld.spID,DateToStr(pSDate.Date),DateToStr(pEDate.Date));
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

procedure TIWfrmPayDetail.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'PayDetail'+DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmPayDetail.QueryPayDetail(samdb,spid: string;sMinDate,sMaxDate: string);
const
  sqlPayDetail = 'SELECT id,orderid,account,money,serverid,orderdate,state,yunying FROM %s.payorder WHERE yunying="_%s" AND type in (1,3) AND orderdate>="%s" AND orderdate<="%s" ORDER BY orderdate';
  sqlPayDetail2 = 'SELECT id,orderid,account,money,serverid,orderdate,state,yunying FROM %s.payorder_%s WHERE yunying="_%s" AND type in (1,3) AND orderdate>="%s" AND orderdate<="%s" ORDER BY orderdate';
var
  I,iCount: Integer;
begin
  with UserSession.quWebGrid,TIWAdvWebGrid1 do
  begin
    iCount := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    if IWAmdbMode.Checked then
      SQL.Text := Format(sqlPayDetail2,[samdb,FormatDateTime('YYYYMM',pSDate.Date),spid,sMinDate,sMaxDate+' 23:59:59'])
    else
    SQL.Text := Format(sqlPayDetail,[samdb,spid,sMinDate,sMaxDate+' 23:59:59']);

    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      for I := 1 to Columns.Count - 1 do
      begin
        cells[I,iCount] := Utf8ToString(FieldList.Fields[I-1].AsAnsiString);
      end;
      Inc(iCount);
      Next;
    end;
    TotalRows := iCount;
    Close;
  end;
end;

initialization
  RegisterClass(TIWfrmPayDetail);

end.
