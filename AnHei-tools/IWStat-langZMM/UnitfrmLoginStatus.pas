unit UnitfrmLoginStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWWebGrid,
  IWAdvWebGrid, IWTMSCal;

type
  TLoginStatus = (lsRegAccountCount,lsLoadFlashComplete,lsConnectLGateway,lsConnectLGatewayComplete,lsLGatewayDisconnect,
                  lsSendLoginAsk,lsLoginSucceed,lsLoginFail,lsSendSelectServer,
                  lsSServerSucceed,lsSServerFail,lsConnectRGateway, lsConnectRGatewayComplete,
                  lsRGatewayFail,lsRGatewayDisconnect,lsSendSelectRole,lsServerRoleList,
                  lsStartCreateRole,lsSendCreateRole,lsCreateRoleSucceed,lslsCreateRoleFail,
                  lsSendSRoleGame,lsSRoleGameSucceed,lsSRoleGameFail,lsGameGateway,
                  lsGameGatewaySucceed,lsGameGatewayFail,lsGameGatewayDisconnect,lsCreateSucceed,
                  lsCloseGamePage,lsGamelogin,ls5MinStatus,ls10MinStatus,ls15MinStatus,ls20MinStatus,
                  ls25MinStatus,ls30MinStatus,ls35MinStatus,ls40MinStatus,ls45MinStatus,ls50MinStatus,
                  ls55MinStatus,ls60MinStatus);
const
  TLoginStatusStr: array[TLoginStatus] of string =
                 (//'注册账号数','加载flash完成','连接登录网关','连接登录网关成功','登录网关连接被迫断开',
                   '195','196','197','198','199',
                  //'发送登录请求','登录成功','登录失败','发送选择服务器',
                  '200','201','202','203',
                  // '选择服务器成功','选择服务器失败','连接角色网关','连接角色网关成功',
                  '204','205','206','207',
                  // '连接角色网关失败','角色网关连接被迫断开','发送选择角色','服务器返回角色列表',
                  '208','209','210','211',
                  // '开始创建角色','发送创建角色','创建角色成功','创建角色失败',
                  '212','213','214','215',
                  // '发送选择角色开始游戏','选择角色开始游戏成功','选择角色开始游戏失败','连接游戏网关',
                  '216','217','218','219',
                  //'连接游戏网关成功','连接游戏网关失败','游戏网关被迫关闭连接','主角创建成功',
                  '220','221','222','223',
                  //'关闭游戏页面','点击下载登陆器','5分钟状态','10分钟状态','15分钟状态','20分钟状态',
                  '224','225','226','227','228','229',
                  //'25分钟状态','30分钟状态','35分钟状态','40分钟状态','45分钟状态','50分钟状态',
                  '230','231','232','233','234','235',
                  //'55分钟状态','60分钟状态'
                  '236','237');
type

  TIWfrmLoginStatus = class(TIWFormBasic)
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWRegionQueryTop: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryLoginStatus(spid, sgstatic: string;ServerIndex: Integer;curDate: TDate);
  end;

var
  IWfrmLoginStatus: TIWfrmLoginStatus;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmLoginStatus.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbLoginStatus]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbLoginStatus]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbLoginStatus])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(188);
  IWBtnBuild.Caption := Langtostr(14);

  TIWAdvWebGrid1.Columns[1].Title := Langtostr(189);
  TIWAdvWebGrid1.Columns[2].Title := Langtostr(190);
  TIWAdvWebGrid1.Columns[3].Title := Langtostr(191);
  TIWAdvWebGrid1.Columns[4].Title := Langtostr(192);
  TIWAdvWebGrid1.Columns[5].Title := Langtostr(193);
end;

procedure TIWfrmLoginStatus.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    UserSession.ConnectionSessionMysql(psld.AccountDB,psld.SessionHostName);
    try
      QueryLoginStatus(psld.spID, psld.GstaticDB,psld.Index,pSDate.Date);
      TIWAdvWebGrid1.Controller.Caption := Format(Langtostr(194),[Langtostr(StatToolButtonStr[tbLoginStatus]),TIWAdvWebGrid1.TotalRows]);
    finally
      UserSession.SQLConnectionLog.Close;
      UserSession.SQLConnectionSession.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmLoginStatus.QueryLoginStatus(spid, sgstatic: string;ServerIndex: Integer;curDate: TDate);
const
  sqlLoginStatus = 'SELECT serverindex,status,increment,staticdate '+'FROM %s.loginstatus WHERE staticdate="%s" %s ORDER BY serverindex,status';
  sqlWhere = ' AND serverindex=%d';
  sqlglobaluser = 'SELECT COUNT(1) FROM globaluser WHERE createtime>="%s" and createtime<="%s"';
  sqlinserver = ' AND inserver = %d';
var
  iCount,iValue,iStatus,iRegCount: Integer;
  sServerIndex,sInServer,sFontColor: string;
begin
  sServerIndex := '';   sInServer := '';
  if ServerIndex <> 0 then
  begin
    sServerIndex := Format(sqlWhere,[ServerIndex]);
    sInServer := Format(sqlinserver,[ServerIndex]);
  end;
  with UserSession.quGlobalAccount do
  begin
    SQL.Text := Format(sqlglobaluser,[FormatDateTime('YYYY-MM-DD 00:00:00',curDate),FormatDateTime('YYYY-MM-DD 23:59:59',curDate)])+sInServer;
    Open;
    iRegCount := Fields[0].AsInteger;
    Close;
  end;
  with UserSession.quLoginStatus,TIWAdvWebGrid1 do
  begin
    iCount := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    SQL.Text := Format(sqlLoginStatus,[sgstatic,FormatDateTime('YYYY-MM-DD',curDate),sServerIndex]);
    Open;
    cells[0,0] := '0';
    cells[1,0] := UserSession.pServerName;
    cells[2,0] := Langtostr(StrToInt(TLoginStatusStr[TLoginStatus(0)]));
    cells[3,0] := IntToStr(iRegCount);
    cells[4,0] := '0';
    cells[5,0] := DateToStr(pSDate.Date);
    Inc(iCount);
    while not Eof do
    begin
      sFontColor := '%s';
      TotalRows := RowCount+iCount;
      iStatus := FieldByName('status').AsInteger;
      if TLoginStatus(iStatus) in [lsLGatewayDisconnect,lsLoginFail,lsSServerFail,lsRGatewayFail,lsRGatewayDisconnect,lslsCreateRoleFail,lsSRoleGameFail,lsGameGatewayFail,lsGameGatewayDisconnect] then
      begin
        sFontColor := '<FONT color=red>%s</FONT>';
      end;
      cells[0,iCount] := Format(sFontColor,[FieldByName('status').AsString]);
      cells[1,iCount] := Format(sFontColor,[GetServerListName(spid,Fields[0].AsInteger)]);
      iValue := Fields[1].AsInteger;

      case iValue of
            100: iValue := 29;
            105: iValue := 31;
            110: iValue := 32;
            115: iValue := 33;
            120: iValue := 34;
            125: iValue := 35;
            130: iValue := 36;
            135: iValue := 37;
            140: iValue := 38;
            145: iValue := 39;
            150: iValue := 40;
            155: iValue := 41;
            160: iValue := 42;
      else
      end;

      cells[2,iCount] := Format(sFontColor,[Langtostr(StrToInt(TLoginStatusStr[TLoginStatus(iValue)]))]);
      cells[3,iCount] := Format(sFontColor,[Fields[2].AsString]);
      cells[4,iCount] := '0';
      if iRegCount <> 0 then
        cells[4,iCount] := Format(sFontColor,[Format('%.1f%%',[FieldByName('increment').AsInteger/iRegCount*100])]);
      cells[5,iCount] := Format(sFontColor,[Fields[3].AsString]);
      Inc(iCount);
      Next;
    end;
    TotalRows := iCount;
    Close;
  end;
end;

initialization
  RegisterClass(TIWfrmLoginStatus);
  
end.
