unit UnitfrmAcrossRank;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWWebGrid,
  IWAdvWebGrid;

const
  curTitle = '跨服排行统计';

type
  TIWfrmAcrossRank = class(TIWFormBasic)
    IWRegionQueryTop: TIWRegion;
    IWBtnBuild: TIWButton;
    IWLabel3: TIWLabel;
    IWcBoxDate: TIWComboBox;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure LoadAwardtime;
    procedure QueryAcrossRank(AcrossTime, sgstatic: string);
  end;

var
  IWfrmAcrossRank: TIWfrmAcrossRank;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmAcrossRank.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  LoadAwardtime;
end;

procedure TIWfrmAcrossRank.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryAcrossRank(IWcBoxDate.Text, psld.GstaticDB);
      TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;<b>%s</b>：共 %d 个记录',[curTitle,TIWAdvWebGrid1.TotalRows]);
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

procedure TIWfrmAcrossRank.LoadAwardtime;
const
  sqlAcrossDate = 'SELECT DISTINCT(date(awardtime)) AS awardtime FROM %s.acrossaward ORDER BY awardtime DESC LIMIT %d';
var
  psld: PTServerListData;
begin
  psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
  try
    with UserSession.quAcross do
    begin
      SQL.Text := Format(sqlAcrossDate,[psld.GstaticDB,53]);
      Open;
      while not Eof do
      begin
        IWcBoxDate.Items.Add(Fields[0].AsString);
        Next;
      end;
      Close;
    end;
  finally
    UserSession.SQLConnectionLog.Close;
  end;
  if IWcBoxDate.Items.Count > 0 then
  begin
    IWcBoxDate.ItemIndex := 0;
  end;
end;

procedure TIWfrmAcrossRank.QueryAcrossRank(AcrossTime, sgstatic: string);
const
  sqlAcrossAward = 'SELECT * FROM %s.acrossaward WHERE date(awardtime)="%s"';
var
  I,iCount: Integer;
  function GetCountryName(iCountry: Integer): string;
  const
    sCountry : array [1..3] of string = ('魏国', '蜀国', '吴国');
  begin
    Result := IntToStr(iCountry);
    if (iCountry >= Low(sCountry)) AND (iCountry <= High(sCountry)) then
    begin
      Result := sCountry[iCountry];
    end;
  end;
begin
  with UserSession.quAcross,TIWAdvWebGrid1 do
  begin
    iCount := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    SQL.Text := Format(sqlAcrossAward,[sgstatic,AcrossTime]);
    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      for I := 1 to Columns.Count - 1 do
      begin
        if I = 2 then
          cells[I,iCount] := GetCountryName(Fields[I].AsInteger)
        else
          cells[I,iCount] := Fields[I].AsString;
      end;
      Inc(iCount);
      Next;
    end;
    TotalRows := iCount;
    Close;
  end;
end;

initialization
  RegisterClass(TIWfrmAcrossRank);

end.
