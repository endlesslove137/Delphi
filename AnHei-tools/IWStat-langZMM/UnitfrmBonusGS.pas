unit UnitfrmBonusGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IWCompMemo, md5,
  IWCompCheckbox;

type
  TIWfrmBonusGS = class(TIWFormBasic)
    IdHTTP1: TIdHTTP;
    IWBtnGrantGold: TIWButton;
    IWRegion2: TIWRegion;
    IWMemoAccount: TIWMemo;
    IWLabel1: TIWLabel;
    IWRegion5: TIWRegion;
    TIWGradientLabel5: TTIWGradientLabel;
    IWMemoSuccessLog: TIWMemo;
    IWMemoFailLog: TIWMemo;
    IWLabel2: TIWLabel;
    IWMemoRemark: TIWMemo;
    IWSpidkBox: TIWCheckBox;
    IWButton1: TIWButton;
    IWedtUserName: TIWEdit;
    IWLabel3: TIWLabel;
    IWLabel4: TIWLabel;
    IWEdit1: TIWEdit;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnGrantGoldClick(Sender: TObject);
    procedure IWButton1AsyncClick(Sender: TObject; EventParams: TStringList);
  private
    function CheckMemoMode: Boolean;
  public
    procedure GrantGold(ServerIndex: Integer; spID,sBonusKey: string);
    procedure QueryAccountName(ServerIndex: Integer; susername: string);
  end;

var
  IWfrmBonusGS: TIWfrmBonusGS;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

function TIWfrmBonusGS.CheckMemoMode: Boolean;
var
  I,iCount: Integer;
begin
  for I := IWMemoAccount.Lines.Count - 1 downto 0 do
  begin
    if IWMemoAccount.Lines.Strings[I] = '' then
    begin
      IWMemoAccount.Lines.Delete(I);
    end;
  end;
  iCount := 0;
  for I := 0 to IWMemoAccount.Lines.Count - 1 do
  begin
    if (ParameterIntValue(IWMemoAccount.Lines.Strings[I]) > 0) and
       (ParameterStrValue(IWMemoAccount.Lines.Strings[I]) <> '') then
    begin
      Inc(iCount);
    end;
  end;
  Result := (iCount <> 0) and (iCount=IWMemoAccount.Lines.Count);
end;

procedure TIWfrmBonusGS.GrantGold(ServerIndex: Integer; spID,sBonusKey: string);
const
  HttpGetParameter = 'opid=%s&account=%s&money=%d&server=S%d';
var
  I,nMoney: Integer;
  sAccount,SerialNO: string;
  ParamList: TStringList;
  sParameter,sSign,sKey: AnsiString;
  StrStream: TStringStream;
  procedure AddOPLog(StrResult,sAccount: string);
  var
    LogDate: string;
  begin
    LogDate := DateTimeToStr(Now)+':';
    if StrResult = 'OK' then
    begin
      IWMemoSuccessLog.Lines.Add(LogDate+'<'+sAccount+'>操作成功');
    end
    else if StrResult = 'UNE' then
    begin
      IWMemoFailLog.Lines.Add(LogDate+'<'+sAccount+'>用户不存在');
    end
    else if StrResult = 'FA' then
    begin
      IWMemoFailLog.Lines.Add(LogDate+'<'+sAccount+'>余额不足');
    end
    else if StrResult = 'DOI' then
    begin
      IWMemoFailLog.Lines.Add(LogDate+'<'+sAccount+'>流水号重复');
    end
    else if StrResult = 'UEE' then
    begin
      IWMemoFailLog.Lines.Add(LogDate+'<'+sAccount+'>其他错误');
    end
    else begin
      IWMemoFailLog.Lines.Add(LogDate+'<'+sAccount+'>'+StrResult);
    end;
  end;
begin
  ParamList := TStringList.Create;
  try
    for I := 0 to IWMemoAccount.Lines.Count - 1 do
    begin
      StrStream := TStringStream.Create('');
      try
        ParamList.Clear;
        sAccount := ParameterStrValue(IWMemoAccount.Lines.Strings[I]);

        if not IWSpidkBox.Checked then
        begin
          if Pos('_'+spID,sAccount) = 0 then
          begin
            sAccount := sAccount + '_'+spID;
          end;
        end;

        nMoney := ParameterIntValue(IWMemoAccount.Lines.Strings[I]);
        SerialNO := BuildSerialNO;
        sKey := AnsiString(Trim(string(DecryptZJHTKey(sBonusKey))));
        sParameter := UTF8Encode(Format(HttpGetParameter,[SerialNO,sAccount,nMoney,ServerIndex]));
        sSign := '&sign='+MD5EncryptString(sParameter+'&key='+sKey);
        sParameter := AnsiString(Format(HttpGetParameter,[SerialNO,UrlEncode(PAnsiChar(Utf8Encode(sAccount))),nMoney,ServerIndex]));
        ParamList.Add(string(sParameter+sSign+'&ram='+AnsiString(Format('%.1f',[nMoney/10]))));
        IdHTTP1.Post(Format(objINI.CallBonusHttp,[spID]),ParamList,StrStream);
        if StrStream.DataString = 'OK' then
        begin
          UserSession.AddHTOperateLog(2,sAccount,IntToStr(nMoney),IWMemoRemark.Text);
        end;
        AddOPLog(StrStream.DataString,sAccount);
      finally
        StrStream.Free;
      end;
    end;
  finally
    ParamList.Free;
  end;
end;

procedure TIWfrmBonusGS.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbBonusGS]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbBonusGS]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName), Langtostr(StatToolButtonStr[tbBonusGS])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
end;

procedure TIWfrmBonusGS.IWBtnGrantGoldClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  try
    if CheckMemoMode then
    begin
      ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
      GrantGold(ServerListData.Index-ServerListData.ServerID,ServerListData.spID,ServerListData.BonusKey);
    end
    else begin
      WebApplication.ShowMessage('格式不正确，请检查');
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmBonusGS.IWButton1AsyncClick(Sender: TObject;
  EventParams: TStringList);
var
  psld: PTServerListData;
begin
  if  IWedtUserName.Text = '' then
  begin
    WebApplication.ShowMessage('角色名称不允许为空, 请输入');
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);

    UserSession.ConnectionRoleMysql(psld.RoleHostName,psld.DataBase);
    try
      QueryAccountName(psld.Index, IWedtUserName.Text);
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

procedure TIWfrmBonusGS.QueryAccountName(ServerIndex: Integer; susername: string);
const
  sqlaccouname = 'SELECT accountname FROM actors WHERE  serverindex = %d and actorname = %s';
begin
   with UserSession.quUserInfo do
   begin
     SQL.Text := Format(sqlaccouname,[ServerIndex, QuerySQLStr(susername)]);
     Open;
     IWEdit1.Text:=  Utf8ToString(FieldList.FieldByName('accountname').AsAnsiString);
     Close;
   end;
end;

initialization
  RegisterClass(TIWfrmBonusGS);

end.
