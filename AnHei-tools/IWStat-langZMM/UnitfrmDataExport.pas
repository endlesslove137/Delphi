unit UnitfrmDataExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWTMSEdit,
  IWCompCheckbox;

type
  TIWfrmDataExport = class(TIWFormBasic)
    IWButton6: TIWButton;
    IWLabel3: TIWLabel;
    IWedtAccount: TIWEdit;
    IWLabel4: TIWLabel;
    IWedtRole: TIWEdit;
    IWLabel1: TIWLabel;
    TIWAdvSedtIndex: TTIWAdvSpinEdit;
    IWSpidkBox: TIWCheckBox;
    procedure IWButton6Click(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IWfrmDataExport: TIWfrmDataExport;

implementation

uses ServerController,{ AAServiceXML,} ConfigINI, Share;

{$R *.dfm}

procedure TIWfrmDataExport.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbDataExport]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbDataExport]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbDataExport])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True; 
end;

procedure TIWfrmDataExport.IWButton6Click(Sender: TObject);
(*
const
  sqlRole = 'SELECT accountid,actorid FROM actors WHERE actorname=%s';
  sqlDelete = 'DELETE FROM globaluser WHERE account=%s';
var
  charid,accountid: Integer;
  strSQL: string;
  ServerListData: PTServerListData;
  ServersData: PTAAServersData;  *)
begin
 (* if IsAcrossRun then
  begin
    WebApplication.ShowMessage('正在导入跨服战数据请稍等后再执行本操作');
    Exit;
  end;
  strSQL := 'INSERT INTO globaluser (userid,account,passwd,identity,createtime,updatetime,updateip,offlinetime)'+
            'SELECT %d,"%s",md5("123456"),identity,Now(),Now(),0,0 FROM globaluser LIMIT 1';
  ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  if (IWedtAccount.Text<>'') and (IWedtRole.Text <> '') then
  begin
    if not IWSpidkBox.Checked then
    begin
      if Pos('_'+ServerListData.spID,IWedtAccount.Text) = 0 then
      begin
        IWedtAccount.Text := IWedtAccount.Text + '_'+ServerListData.spID;
      end;
    end;

    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      with UserSession.quRole do
      begin
        SQL.Text := Format(sqlRole,[QuerySQLStr(IWedtRole.Text)]);
        Open;
        accountid := Fields[0].AsInteger;
        charid := Fields[1].AsInteger;
        Close;
      end;
    finally
      UserSession.SQLConnectionRole.Close;
    end;
    New(ServersData);
    try
      FillChar(ServersData^,sizeof(ServersData^),0);
      ServersData.Index := TIWAdvSedtIndex.Value;
      ServersData.DBServer := '61.144.23.107';
      ServersData.DBUser := 'wymaster';
      ServersData.DataBase := UM_DATA_ACTOR;
      ServersData.DBPass := '$$$newpassword2009!!!';
      ServersData.DBPort := 33306;
      if IWServerController.ImportDBData(charid,ServerListData,ServersData) then
      begin
        with UserSession.SQLConnectionTest do
        begin
          Connected := False;
          Params.Clear;
          Params.Append('HostName='+ServersData.DBServer);
          Params.Append('Database=' + ServerListData.LogDB);
          Params.Append('User_Name='+ServersData.DBUser);
          Params.Append('Password='+string(ServersData.DBPass));
          Params.Append('ServerCharset=utf8');
          Params.Append('Server Port='+IntToStr(ServersData.DBPort));
          Connected := True;
        end;
        try
          UserSession.quTest.SQL.Text := Format(sqlDelete,[QuerySQLStr(IWedtAccount.Text)]);
          UserSession.quTest.ExecSQL;
          UserSession.quTest.Close;
          UserSession.quTest.SQL.Text := Format(strSQL,[accountid,IWedtAccount.Text]);
          UserSession.quTest.ExecSQL;
          UserSession.quTest.Close;
        finally
          UserSession.SQLConnectionTest.Close;
        end;
        WebApplication.ShowMessage('导入角色('+IWedtRole.Text+')到内网成功');
      end
      else begin
        WebApplication.ShowMessage('导入角色('+IWedtRole.Text+')到内网失败');
      end;
    finally
      System.Dispose(ServersData);
    end;
  end;   *)
end;

initialization
  RegisterClass(TIWfrmDataExport);


end.
