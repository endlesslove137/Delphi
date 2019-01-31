unit UnitfrmUserLogin;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWControl,
  IWTMSImgCtrls, IWCompButton, IWCompEdit, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompLabel, Controls, Forms, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, MSXML,
  Windows, ActiveX, IWBaseComponent, IWBaseHTMLComponent, IWBaseHTML40Component,
  IWExtCtrls, IWCompListbox;

type
  TIWfrmUserLogin = class(TIWAppForm)
    IWRegion1: TIWRegion;
    IWLabelTitle: TIWLabel;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWEditUser: TIWEdit;
    IWEditPassword: TIWEdit;
    IWButtonLogin: TIWButton;
    IWlabVersion: TIWLabel;
    TIWFadeImage1: TTIWFadeImage;
    IWLabel1: TIWLabel;
    IWlabErrorTip: TIWLabel;
    IWRegion2: TIWRegion;
    IWTimer1: TIWTimer;
    IWLabel4: TIWLabel;
    IWComboBox1: TIWComboBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButtonLoginClick(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWTimer1AsyncTimer(Sender: TObject; EventParams: TStringList);
  private
    xmlDoc : IXMLDOMDocument;
    xmlNode: IXMLDomNode;
    procedure LoadLangType;
  public
    procedure CreatePopXML;
  end;

implementation

uses ServerController, ConfigINI, md5, UnitIWfrmMain, IWLang;

{$R *.dfm}

procedure TIWfrmUserLogin.CreatePopXML;
var
  Element : IXMLDOMElement;
begin
  xmlDoc.appendChild(xmlDoc.createProcessingInstruction('xml', 'version="1.0" encoding="GB2312"'));
  xmlDoc.appendChild(xmlDoc.createComment('PopList 说明'+ #13 +
                                          '     1位 在线统计' + #13 +
                                          '     2位 国家人口统计' + #13 +
                                          '     3位 职业统计' + #13 +
                                          '     4位 等级统计' + #13 +
                                          '     5位 职业等级统计' + #13 +
                                          '     6位 登陆统计' + #13 +
                                          '     7位 用户数统计' + #13 +
                                          '     8位 帐号流失统计' + #13 +
                                          '     9位 消费统计' + #13 +
                                          '     10位 充值统计' + #13 +
                                          '     11位 商城排行统计' + #13 +
                                          '     12位 消费排行统计' + #13 +
                                          '     13位 充值排行统计'));
  xmlNode := xmlDoc.appendChild(xmlDoc.createElement('UserPopList'));
  Element := xmlNode.appendChild(xmlDoc.createElement('User')) as IXMLDOMElement;
  Element.setAttribute('Name','admin');
  Element.setAttribute('Password',MD5EncryptString('123456'));
  Element.setAttribute('PopList','1111111111111');
  Element.setAttribute('sp','wyi');
  xmlDoc.save(AppPathEx+UserPopFile);
end;

procedure TIWfrmUserLogin.IWAppFormCreate(Sender: TObject);
begin
  CoInitialize(nil);
  xmlDoc := CoDOMDocument.Create();
  if FileExists(AppPathEx+UserPopFile) then
  begin
    if xmlDoc.load(AppPathEx+UserPopFile) then
    begin
      xmlNode := xmlDoc.documentElement;
    end;
  end
  else
  begin
    CreatePopXML;
  end;
  Title := objINI.sAppTitle + ' - 请登陆';
  IWLabelTitle.Caption := objINI.sAppTitle;
  IWlabVersion.Caption := 'V' + GetVersionEx;
  LoadLangType;

  IWTimer1.Enabled := False;
  IWTimer1.Enabled := True;
end;

procedure TIWfrmUserLogin.IWAppFormDestroy(Sender: TObject);
begin
  xmlDoc := nil;
  CoUninitialize;
 // ALangs.Free;
end;

procedure TIWfrmUserLogin.LoadLangType;
var
  I: Integer;
begin
  IWComboBox1.Items.Clear;
  for i:= 0 to AuthLangList.count -1 do
  begin
    IWComboBox1.Items.Add(AuthLangList.Strings[i]);
  end;
  IWComboBox1.ItemIndex := objINI.LangType;
end;

procedure TIWfrmUserLogin.IWButtonLoginClick(Sender: TObject);
var
  I: Integer;
  userNode: IXMLDomNode;
  psld: PTServerListData;
//  AUserName, AUserIP: string;
begin

  userNode := xmlDoc.selectSingleNode(format('//*[@Name=''%s'']',[IWEditUser.Text]));
  if userNode <> nil then
  begin
    if MD5EncryptString(AnsiString(IWEditPassword.Text)) = AnsiString(userNode.attributes.getNamedItem('Password').text) then
    begin
      UserSession.UserName := userNode.attributes.getNamedItem('Name').text;
      UserSession.UserPopList := userNode.attributes.getNamedItem('PopList').text;
      UserSession.UserSpid := userNode.attributes.getNamedItem('sp').text;

      UserSession.iLangNum:= IWComboBox1.ItemIndex;
      UserSession.LoadLangFile(IWComboBox1.ItemIndex);

      for I := 0 to ServerList.Count - 1 do
      begin
        psld := PTServerListData(ServerList.Objects[I]);
        if ((psld^.Index = 0) and (Pos(psld.spID,UserSession.UserSpid)<>0)) or ((UserSession.UserSpid = 'ALL') or (UserSession.UserName = AdminUser)) then
        begin
          UserSession.pServerName := ServerList.Strings[I];
          break;
        end;
      end;
     (*
      for n := 0 to AuthUserIPList.Count - 1 do
      begin
        AUserName := Copy(AuthUserIPList.Strings[n], 1,  Pos('|', AuthUserIPList.Strings[n]) - 1);
        AUserIP := Copy(AuthUserIPList.Strings[n], Pos('|', AuthUserIPList.Strings[n]) + 1, Length(AuthUserIPList.Strings[n]));
        if (AUserName = UserSession.UserName) and (AUserSession.IP <> AUserIP) then
        begin
          IWlabErrorTip.Caption := '当前账号访问限制，请联系管理员';
          Exit;
        end;
      end;  *)

      if UserSession.pServerName <> '' then
      begin
        WebApplication.ShowMessage('登录成功');
        Move(TIWfrmMain).Show;
      end
      else
      begin
        IWlabErrorTip.Caption := '账号权限设置错误请联系管理员';
      end;
    end
    else
    begin
      IWlabErrorTip.Caption := '密码错误，请重新输入';
    end;
  end
  else
  begin
    IWlabErrorTip.Caption := '用户名不存在，请重新输入';
  end;
end;

procedure TIWfrmUserLogin.IWTimer1AsyncTimer(Sender: TObject;
  EventParams: TStringList);
begin
  IWTimer1.Enabled := False;
  IWRegion1.Left := Trunc((Width/2)-(IWRegion1.Width/2));
  IWRegion1.Top := Trunc((Height/2)-(IWRegion1.Height/2));
end;

initialization
  TIWfrmUserLogin.SetAsMainForm;

end.
