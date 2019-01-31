unit UnitfrmVaseries;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWWebGrid, IWAdvWebGrid, IWCompEdit, IWCompButton, IWHTML40Container, IWRegion,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

const
  curTitle = '活动卡号查询';
  sVaserType : array [0..1] of string = ('未使用', '已使用');

type
  TIWfrmVaseries = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    IWBtnBuild: TIWButton;
    IWVaseriesSN: TIWEdit;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWComboBoxType: TIWComboBox;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
  public
    procedure QueryVaseriesSN(sdata: string);
  end;

var
  IWfrmVaseries: TIWfrmVaseries;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmVaseries }

procedure TIWfrmVaseries.IWAppFormCreate(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWComboBoxType.Items.Add('请选择');
  for I := Low(sVaserType) to High(sVaserType) do
  begin
    IWComboBoxType.Items.Add(sVaserType[I]);
  end;
  IWComboBoxType.ItemIndex := 0;
end;

procedure TIWfrmVaseries.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if  (IWVaseriesSN.Text = '') then
  begin
    WebApplication.ShowMessage('请输入好号');
    Exit;
  end;

  if IWComboBoxType.ItemIndex <= 0 then
  begin
    WebApplication.ShowMessage('请选择查询类型');
    Exit;
  end;

  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      QueryVaseriesSN(IWVaseriesSN.Text);
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

procedure TIWfrmVaseries.QueryVaseriesSN(sdata: string);
const
  sqlvaser = 'SELECT sn,tp,val,gt FROM vaseries WHERE sn in(%s)';
  sqlvaserlog = 'SELECT sn,tp,val,gt,ut,uid,username FROM vaserieslog WHERE sn in(%s)';
var
  iCount: Integer;
  procedure BuildSQLData(sSQL: string);
  begin
    with UserSession.quVaser,TIWAdvWebGrid1 do
    begin
      SQL.Text := sSQL;
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := UIntToStr(FieldByName('sn').AsLargeInt);
        cells[2,iCount] := IntToStr(FieldByName('tp').AsInteger);
        cells[3,iCount] := IntToStr(FieldByName('val').AsInteger);
        cells[4,iCount] := FormatDateTime('YYYY-MM-DD hh:mm:ss',FieldByName('gt').AsDateTime);
        cells[5,iCount] := '-';
        cells[6,iCount] := '-';
        cells[7,iCount] := '-';
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;
  procedure BuildSQLData2(sSQL: string);
  begin
    with UserSession.quVaser,TIWAdvWebGrid1 do
    begin
      SQL.Text := sSQL;
      Open;
      while not Eof do
      begin
        RowCount := iCount + 1;
        cells[1,iCount] := UIntToStr(FieldByName('sn').AsLargeInt);
        cells[2,iCount] := IntToStr(FieldByName('tp').AsInteger);
        cells[3,iCount] := IntToStr(FieldByName('val').AsInteger);
        cells[4,iCount] := FormatDateTime('YYYY-MM-DD hh:mm:ss',FieldByName('gt').AsDateTime);
        cells[5,iCount] := FormatDateTime('YYYY-MM-DD hh:mm:ss',FieldByName('ut').AsDateTime);
        cells[6,iCount] := IntToStr(FieldByName('uid').AsInteger);
        cells[7,iCount] := Utf8ToString(FieldList.FieldByName('username').AsAnsiString);
        Inc(iCount);
        Next;
      end;
      Close;
    end;
  end;
begin
  iCount := 0;
  TIWAdvWebGrid1.ClearCells;
  if IWComboBoxType.ItemIndex = 1 then
  begin
     BuildSQLData(Format(sqlvaser,[sdata]));
  end;
  if IWComboBoxType.ItemIndex = 2 then
  begin
     BuildSQLData2(Format(sqlvaserlog,[sdata]));
  end;
end;

initialization
  RegisterClass(TIWfrmVaseries);

end.
