unit UnitLangPackage;

interface

uses
  Windows, SysUtils, Classes, Dialogs, COMLangPackLib, MSXML, UnitLPConnect;

type
  TLangPackEventCallBack = class;

  TLanguagePackage = class
  private
    FCategoryList: array [0..1023] of Boolean;

    LangPackClient: ILangPackClient;
    FConnectForm: TfrmLPConnect;
    FClientCallBack: TLangPackEventCallBack;
    FOnClientConnected: TNotifyEvent;
    FOnClientDisconnected: TNotifyEvent;
    function ReadConfig(): Boolean;
    procedure SetIdText(const nId: Integer; const sText: WideString);
    procedure FetchText(FCategoryId: Integer);
  public
    BShowID: boolean;
    LanguageName: string;
    TextList: array of WideString;
    constructor Create;
    destructor Destroy; override;

    procedure Initialize;
    function GetLangText(FCategoryId,Id: Integer): WideString;
    function AddLangText(FCategoryId: Integer;const Value: WideString): Integer;
    procedure ReplaceLangText(FCategoryId,Id: Integer;const Value: WideString);
    procedure GetLanguageNames(StrLanguageNames: TStrings);
    property OnClientConnected: TNotifyEvent read FOnClientConnected write FOnClientConnected;
    property OnClientDisonnected: TNotifyEvent read FOnClientDisconnected write FOnClientDisconnected;
  end;

  TLangPackEventCallBack = class(TInterfacedObject, ILangPackClientCallBack)
  private
    FLanguagePackage: TLanguagePackage;
  protected
    function OnConnected: HResult; stdcall;
    function OnDisconnected: HResult; stdcall;
  end;

var
  LanguagePackage: TLanguagePackage;
  
implementation

{ TCustomLanguagePackage }

constructor TLanguagePackage.Create;
begin
  inherited;                                    
  FClientCallBack := TLangPackEventCallBack.Create();
  FClientCallBack.FLanguagePackage := Self;
  BShowID := false;
  LangPackClient := CreateLocalLangPackClient();
  LangPackClient.eventCallBack := FClientCallBack;
  if ReadConfig then
  begin
    LangPackClient.startClient();
  end;
end;

destructor TLanguagePackage.Destroy;
begin
  FConnectForm.Free;
  FClientCallBack := nil;
  LangPackClient := nil;
  inherited;
end;

procedure TLanguagePackage.FetchText(FCategoryId: Integer);
var
  Doc: IXMLDOMDocument;
  Nodes: IXMLDOMNodeList;
  Node: IXMLDOMNode;
  I, nId: Integer;
begin
  Doc := LangPackClient.fetchText(FCategoryId) as IXMLDOMDocument;
  if Doc <> nil then
  begin
    Nodes := Doc.documentElement.selectNodes('text');
    for I := 0 to Nodes.length - 1 do
    begin
      Node := Nodes.item[i];
      nId := StrToInt(Node.selectSingleNode('id').Text);
      SetIdText(nId, Node.selectSingleNode('content').text);
    end;
  end;
end;

function TLanguagePackage.GetLangText(FCategoryId,Id: Integer): WideString;
begin
  if Id <= 0 then
  begin
    Result := '';
    exit;
  end;
  

  if not FCategoryList[FCategoryId] then
  begin
    FetchText(FCategoryId);
    FCategoryList[FCategoryId] := True;
  end;
  Result := '';
  if (Id >= 0) and (Id < Length(TextList)) then
  begin
    if BShowID then
        Result := TextList[Id] + Format('[id=%d]', [Id])
    else
        Result := TextList[Id];
  end;

end;

procedure TLanguagePackage.GetLanguageNames(StrLanguageNames: TStrings);
var
  Doc: IXMLDOMDocument;
  Nodes: IXMLDOMNodeList;
  I: Integer;
begin
  Doc := LangPackClient.fetchLanguages() as IXMLDOMDocument;
  if Doc <> nil then
  begin
    StrLanguageNames.Clear();
    Nodes := Doc.documentElement.selectNodes('lang');
    for I := 0 to Nodes.length- 1 do
    begin
      StrLanguageNames.Add(Nodes.item[I].text);
    end;
  end;  

end;

procedure TLanguagePackage.Initialize;
begin
  if not LangPackClient.connected() then
  begin
    FConnectForm := TfrmLPConnect.Create(nil);
    FConnectForm.LPClient := LangPackClient;
    FConnectForm.WaitFor();
  end;

  if LanguageName = '' then
    LanguageName := 'zh-CN';

  LangPackClient.languageName := LanguageName;

end;

function TLanguagePackage.ReadConfig: Boolean;
var
  Doc: IXMLDOMDocument;
  Element: IXMLDOMElement;
begin
  Result := False;
  Doc := CoDOMDocument.Create;
  Doc.load(ExtractFilePath(ParamStr(0)) + '\LPClient.xml');
  if Doc.parseError.errorCode <> 0 then
    Raise Exception.Create('读取LPClient.xml文件错误：' + Doc.parseError.reason);
  //服务器地址和端口配置
  Element := Doc.documentElement.selectSingleNode('Server') as IXMLDOMElement;
  if Element <> nil then
  begin
    LangPackClient.setServerHost(
      Element.getAttribute('host'),
      Element.getAttribute('port'));
    Result := True;
  end;
end;

procedure TLanguagePackage.ReplaceLangText(FCategoryId,Id: Integer; const Value: WideString);
begin
  if BShowID then
  begin
    ShowMessage('对不起 你现在在调试模式下不可以替换语言包');
    Exit;
  end;

  if (Value='') OR (Id <=0) then
  begin
    Exit;
  end;
  if not FCategoryList[FCategoryId] then
  begin
    FetchText(FCategoryId);
    FCategoryList[FCategoryId] := True;
  end;
  if GetLangText(FCategoryId,Id) <> Value then
  begin
    LangPackClient.replaceCategoryText(FCategoryId,Id,Value);
    SetIdText(Id, Value);
  end;
end;

procedure TLanguagePackage.SetIdText(const nId: Integer;
  const sText: WideString);
const
  Algin = $1000;
begin
  if nId >= Length(TextList) then
  begin
    SetLength(TextList, (nId + 1 + (Algin - 1)) and (not (Algin - 1)));
  end;
  TextList[nId] := sText;
end;

function TLanguagePackage.AddLangText(FCategoryId: Integer;const Value: WideString): Integer;
begin

  if Trim(Value)='' then
  begin
    Result := 0;
    exit;
  end;
  if not FCategoryList[FCategoryId] then
  begin
    FetchText(FCategoryId);
    FCategoryList[FCategoryId] := True;
  end;
  Result := LangPackClient.addCategoryText(FCategoryId,Value);
  if Result > 0 then
  begin
    SetIdText(Result, Value);
  end;
end;

{ TLangPackEventCallBack }

function TLangPackEventCallBack.OnConnected: HResult;
begin
  if Assigned(FLanguagePackage.FOnClientConnected) then
    FLanguagePackage.FOnClientConnected(Self);
  Result := S_OK;
end;

function TLangPackEventCallBack.OnDisconnected: HResult;
begin
  if Assigned(FLanguagePackage.FOnClientDisconnected) then
    FLanguagePackage.FOnClientDisconnected(Self);
  Result := S_OK;
end;

end.
