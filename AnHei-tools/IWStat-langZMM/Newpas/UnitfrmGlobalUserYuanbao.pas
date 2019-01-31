unit UnitfrmGlobalUserYuanbao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompEdit, IWTMSCheckList, IWCompMemo,
  IWCompRectangle, IWTMSCtrls, IWBaseComponent, IWBaseHTMLComponent,
  IWBaseHTML40Component, IWCompButton, GSManageServer, IWTMSEdit,
  IWCompListbox, IWExchangeBar, IWCompCheckbox, IWWebGrid, IWAdvWebGrid;

const
  curTitle = '平台元宝追踪';

type
  TGameGoldTypen = (ftNone, ftType1, ftType2);

  PTUserDataX = ^TUserDataX;
  TUserDataX = record
    idx: Integer;
    account: string;
    charname: string;
    consumeyb: Integer;
    drawybcount: Integer;
    nonbindyuanbao: Integer;
  end;

  TIWfrmGlobalUserYuanbao = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWRegion3: TIWRegion;
    IWLabel2: TIWLabel;
    TIWAdvsedtGameGold: TTIWAdvSpinEdit;
    IWRegion6: TIWRegion;
    TIWclbServers: TTIWCheckListBox;
    IWLabel4: TIWLabel;
    IWCheckBox1: TIWCheckBox;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWbtQuery: TIWButton;
    IWLabel1: TIWLabel;
    IWComboBox1: TIWComboBox;
    IWButton3: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
    procedure IWbtQueryClick(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    spid: string;
    UserDataList: TList;
    procedure ClearUserDataList;
    procedure LoadGameGoldType;
  public
    procedure QueryUserData(GValue, GType, ServerID: Integer);
    procedure SetWebGridData;
  end;

var
  IWfrmGlobalUserYuanbao: TIWfrmGlobalUserYuanbao;

const
  GameGoldTypeStr  : array[TGameGoldTypen] of string = ('--请选择--','消费与提取','当前与提取');

implementation

uses ServerController, ConfigINI, GSProto;

{$R *.dfm}

procedure TIWfrmGlobalUserYuanbao.IWAppFormCreate(Sender: TObject);
var
  psld: PTServerListData;
begin
  inherited;
  UserDataList := TList.Create;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;

  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  spid :=  psld^.spID;
  IWRegion6.Visible := False;
  if psld.Index = 0 then
  begin
    IWRegion6.Visible := True;
    LoadGSServers(TIWclbServers,psld.spID, False);
  end
  else
  begin
    TIWclbServers.Items.AddObject(Trim(UserSession.pServerName),TObject(psld.Index));
    TIWclbServers.Selected[0] := True;
  end;
  IWLabel4.Caption := Format('共有服务器(%d)',[TIWclbServers.Items.Count]);
  LoadGameGoldType;
end;

procedure TIWfrmGlobalUserYuanbao.IWAppFormDestroy(Sender: TObject);
begin
  ClearUserDataList;
  UserDataList.Free;
end;

procedure TIWfrmGlobalUserYuanbao.ClearUserDataList;
var
  I: Integer;
begin
  for I := 0 to UserDataList.Count - 1 do
  begin
    System.Dispose(PTUserDataX(UserDataList[I]));
  end;
  UserDataList.Clear;
end;

procedure TIWfrmGlobalUserYuanbao.LoadGameGoldType;
var
  cstr: string;
begin
  IWComboBox1.Items.Clear;
  for cstr in GameGoldTypeStr do
  begin
    IWComboBox1.Items.Add(cstr);
  end;
  IWComboBox1.ItemIndex := 0;
end;

procedure TIWfrmGlobalUserYuanbao.IWbtQueryClick(Sender: TObject);
var
  psld: PTServerListData;
  I,Idx: Integer;
begin
  if IWComboBox1.ItemIndex = 0 then
  begin
    WebApplication.ShowMessage('未选择查询类型，请选择..');
    Exit;
  end;
  if TIWAdvsedtGameGold.Value <= 0 then
  begin
    WebApplication.ShowMessage('元宝数量必须大于0，请输入..');
    Exit;
  end;
  try
    ClearUserDataList; //在查询前 清除已有的列表信息防止错误发生
    for I := 0 to TIWclbServers.Items.Count - 1 do
    begin
      if TIWclbServers.Selected[I] then
      begin
        Idx := Integer(TIWclbServers.Items.Objects[I]);
        if Idx > 0 then
        begin
          psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(TIWclbServers.Items[i]))]);
          UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
          try
            QueryUserData(TIWAdvsedtGameGold.Value, IWComboBox1.ItemIndex, psld.ServerID);
          finally
            UserSession.SQLConnectionRole.Close;
          end;
        end;
      end;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmGlobalUserYuanbao.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'GlobalUserYuanbao' + DateToStr(Now) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmGlobalUserYuanbao.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWclbServers.Items.Count do
    TIWclbServers.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmGlobalUserYuanbao.QueryUserData(GValue, GType, ServerID: Integer);
const
  //sqlUserQuery  CONVERT(consumeyb + (-drawybcount),SIGNED) CONVERT( 字段 + (要加减的数字) AS SIGNED ) 有字符 和无字符的解决方法
  sqlUserQuery = 'select serverindex,accountname,actorname,consumeyb,drawybcount,nonbindyuanbao,CONVERT(consumeyb + (-drawybcount),SIGNED) from actors where CONVERT(consumeyb + (-drawybcount),SIGNED) > %d';
  sqlUserQuery2 = 'select serverindex,accountname,actorname,consumeyb,drawybcount,nonbindyuanbao from actors where nonbindyuanbao - drawybcount > %d';
var
  sSQL: string;
  pudx: PTUserDataX;
begin
  if GType = 2 then
     sSQL := Format(sqlUserQuery2, [GValue])
  else
     sSQL := Format(sqlUserQuery, [GValue]);

  with UserSession.quRole do
  begin
    SQL.Text := sSQL;
    Open;
    try
      while not Eof do
      begin
        New(pudx);
        pudx.idx := FieldByName('serverindex').AsInteger;
        pudx.account := Utf8ToString(FieldByName('accountname').AsAnsiString);
        pudx.charname := Utf8ToString(FieldByName('actorname').AsAnsiString);
        pudx.consumeyb := FieldByName('consumeyb').AsInteger;
        pudx.drawybcount := FieldByName('drawybcount').AsInteger;
        pudx.nonbindyuanbao := FieldByName('nonbindyuanbao').AsInteger;
        UserDataList.Add(pudx);
        Next;
      end;
    finally
      Close;
    end;
  end;
  SetWebGridData;
  TIWAdvWebGrid1.Controller.Caption := Format('&nbsp;&nbsp;&nbsp;&nbsp;共 %d 个记录 &nbsp;&nbsp;',[UserDataList.Count]);
end;

procedure TIWfrmGlobalUserYuanbao.SetWebGridData;
var
  I: Integer;
  pudx: PTUserDataX;
begin
  TIWAdvWebGrid1.ClearRowSelect;
  TIWAdvWebGrid1.ClearCells;
  TIWAdvWebGrid1.RowCount := objINI.MaxPageCount;
  if TIWAdvWebGrid1.TotalRows < objINI.MaxPageCount then
  begin
    TIWAdvWebGrid1.RowCount := UserDataList.Count;
  end;
  TIWAdvWebGrid1.TotalRows := UserDataList.Count;
  for I := 0 to UserDataList.Count - 1 do
  begin
    pudx := PTUserDataX(UserDataList[I]);
    TIWAdvWebGrid1.Cells[1,I] := GetServerListName(spid,pudx.idx);
    TIWAdvWebGrid1.Cells[2,I] := pudx.account;
    TIWAdvWebGrid1.Cells[3,I] := pudx.charname;
    TIWAdvWebGrid1.Cells[4,I] := IntToStr(pudx.consumeyb);
    TIWAdvWebGrid1.Cells[5,I] := IntToStr(pudx.drawybcount);
    TIWAdvWebGrid1.Cells[6,I] := IntToStr(pudx.nonbindyuanbao);
  end;
end;

initialization
  RegisterClass(TIWfrmGlobalUserYuanbao);

end.
