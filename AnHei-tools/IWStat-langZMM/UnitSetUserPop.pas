unit UnitSetUserPop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompButton, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompEdit, IWTMSMenus, IWTMSCheckList, MSXML,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls,
  IWCompCheckbox;

const
  curTitle = '账号设置';

type
  TXMLHandleType = ( xhAdd, xhModif);

  TIWfrmSetUserPop = class(TIWFormBasic)
    IWbtnAdd: TIWButton;
    IWbtnDel: TIWButton;
    IWLabel3: TIWLabel;
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    IWedtUser: TIWEdit;
    IWLabel2: TIWLabel;
    IWedtPassword: TIWEdit;
    IWbtnOK: TIWButton;
    IWbtnCancel: TIWButton;
    IWbtnModif: TIWButton;
    TIWStaticMenu1: TTIWStaticMenu;
    IWLabel4: TIWLabel;
    IWedtSPID: TIWEdit;
    TIWCheckListBox1: TTIWCheckListBox;
    IWCheckBox1: TIWCheckBox;
    procedure IWbtnModifClick(Sender: TObject);
    procedure IWbtnOKClick(Sender: TObject);
    procedure IWbtnCancelClick(Sender: TObject);
    procedure IWbtnDelClick(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure TIWStaticMenu1Click(Sender: TObject; ItemIdx: Integer);
    procedure IWbtnAddClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
  private
    xmlDoc : IXMLDOMDocument;
    xmlNode: IXMLDomNode;
    curXMLHandle: TXMLHandleType;
  public
    userNode: IXMLDomNode;
    { Public declarations }
    function GetUserNameNode(UserName: string): IXMLDomNode;
    function GetUserPopList: string;
    procedure ClearCheckListBox;
  end;

var
  IWfrmSetUserPop: TIWfrmSetUserPop;

implementation

uses ServerController, md5, ConfigINI;

{$R *.dfm}

procedure TIWfrmSetUserPop.ClearCheckListBox;
var
  I: Integer;
begin
  for I := 0 to TIWCheckListBox1.Items.Count - 1 do
  begin
    TIWCheckListBox1.Selected[I] := False;
  end;
end;

function TIWfrmSetUserPop.GetUserNameNode(UserName: string): IXMLDomNode;
begin
  Result := xmlDoc.selectSingleNode(format('//*[@Name=''%s'']',[UserName]));
end;

function TIWfrmSetUserPop.GetUserPopList: string;
var
  I: Integer;
begin
  Result := StringOfChar('0', TIWCheckListBox1.Items.Count);
  for I := 0 to TIWCheckListBox1.Items.Count - 1 do
  begin
    if TIWCheckListBox1.Selected[I] then
      Result[I+1] := '1';
  end;
end;

procedure TIWfrmSetUserPop.IWAppFormCreate(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  TIWCheckListBox1.Items.Clear;
  for I := 0 to Integer(High(TStatToolButton)) do
  begin
    TIWCheckListBox1.Items.Add(Langtostr(StatToolButtonStr[TStatToolButton(I)]));
  end;
  xmlDoc := CoDOMDocument.Create();
  if xmlDoc.load(AppPathEx+UserPopFile) then
  begin
    xmlNode := xmlDoc.documentElement;
    for I := 0 to xmlNode.childNodes.length - 1 do
    begin
      TIWStaticMenu1.Items.Add.Caption := xmlNode.childNodes.item[I].attributes.getNamedItem('Name').text;
    end;
    TIWStaticMenu1.SelectedIndex := 0;
    TIWStaticMenu1.OnClick(self,0);
  end;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
end;

procedure TIWfrmSetUserPop.IWAppFormDestroy(Sender: TObject);
begin
  xmlDoc := nil;
  inherited;
end;

procedure TIWfrmSetUserPop.IWbtnAddClick(Sender: TObject);
begin
  IWRegion2.Visible := True;
  curXMLHandle := xhAdd;
  IWedtUser.Text := '';
  IWedtPassword.Text := '';
//  ClearCheckListBox;
end;

procedure TIWfrmSetUserPop.IWbtnCancelClick(Sender: TObject);
begin
  inherited;
  IWRegion2.Visible := False;
end;

procedure TIWfrmSetUserPop.IWbtnDelClick(Sender: TObject);
begin
  inherited;
  if userNode.attributes.getNamedItem('Name').text = AdminUser then
  begin
    WebApplication.ShowMessage('不能删除高级帐号');
    Exit;
  end;
  TIWStaticMenu1.Items.Delete(TIWStaticMenu1.SelectedIndex);
  userNode.parentNode.removeChild(userNode);
  xmlDoc.save(AppPathEx+UserPopFile);
  TIWStaticMenu1.SelectedIndex := 0;
  TIWStaticMenu1.OnClick(self,0);
end;

procedure TIWfrmSetUserPop.IWbtnModifClick(Sender: TObject);
begin
  inherited;
  IWRegion2.Visible := True;
  curXMLHandle := xhModif;
end;

procedure TIWfrmSetUserPop.IWbtnOKClick(Sender: TObject);
var
  Element : IXMLDOMElement;
begin
  case curXMLHandle of
    xhAdd:
    begin
      TIWStaticMenu1.Items.Add.Caption := IWedtUser.Text;
      userNode := xmlNode.appendChild(xmlDoc.createElement('User'));
      Element := userNode as IXMLDOMElement;
      Element.setAttribute('Name',IWedtUser.Text);
      Element.setAttribute('Password',MD5EncryptString(AnsiString(IWedtPassword.Text)));
      Element.setAttribute('PopList',GetUserPopList);
      Element.setAttribute('sp',IWedtSPID.Text);
      TIWStaticMenu1.SelectedIndex := TIWStaticMenu1.Items.Count-1;
    end;
    xhModif:
    begin
      if (TIWStaticMenu1.Items[TIWStaticMenu1.SelectedIndex].Caption=AdminUser) AND (IWedtUser.Text<>AdminUser) then
      begin
        WebApplication.ShowMessage('不能修改高级帐号名称');
        Exit;
      end;
      Element := userNode as IXMLDOMElement;
      if IWedtUser.Text <> TIWStaticMenu1.Items[TIWStaticMenu1.SelectedIndex].Caption then
      begin
        TIWStaticMenu1.Items[TIWStaticMenu1.SelectedIndex].Caption := IWedtUser.Text;
      end;
      Element.setAttribute('Name',IWedtUser.Text);
      if IWedtPassword.Text <> '' then
      begin
        Element.setAttribute('Password',MD5EncryptString(AnsiString(IWedtPassword.Text)));
      end;
      Element.setAttribute('PopList',GetUserPopList);
      Element.setAttribute('sp',IWedtSPID.Text);
    end;
  end;
  xmlDoc.save(AppPathEx+UserPopFile);
  IWRegion2.Visible := False;
end;

procedure TIWfrmSetUserPop.IWCheckBox1Click(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to TIWCheckListBox1.Items.Count do
    TIWCheckListBox1.Selected[I] := IWCheckBox1.Checked;
end;

procedure TIWfrmSetUserPop.TIWStaticMenu1Click(Sender: TObject;
  ItemIdx: Integer);
var
  I: Integer;
  tmpPopList: string;
begin
  userNode := GetUserNameNode(TIWStaticMenu1.Items[ItemIdx].Caption);
  if userNode <> nil then
  begin
    curXMLHandle := xhModif;
    IWedtUser.Text := userNode.attributes.getNamedItem('Name').text;
    IWedtPassword.Text := '';
    tmpPopList := userNode.attributes.getNamedItem('PopList').text;
    IWedtSPID.Text := userNode.attributes.getNamedItem('sp').text;
    ClearCheckListBox;
    for I := 0 to Length(tmpPopList) - 1 do
    begin
      if I < TIWCheckListBox1.Items.Count then
      begin
        TIWCheckListBox1.Selected[I] :=  tmpPopList[I+1] = '1';
      end;
    end;
  end;
end;

initialization
  RegisterClass(TIWfrmSetUserPop);

end.
