unit UnitLangPackage;

interface

uses
  Windows, SysUtils, Classes, Dialogs, COMLangPackLib, MSXML, UnitLPConnect, lua;

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

  TLuaLanguagePackage = class
  private
    FStrings: array of UTF8String;
    FLanguage: String;
    procedure SetLanguage(const Value: String);
    function GetText(Id: Integer): UTF8String;
    procedure SetText(Id: Integer; const Value: UTF8String);
    function GetCapacity: Integer;
  public
    //从数据库加载所有文本
    procedure LoadFromDB(const DBName: String);
    //将语言包对象注册到LUA脚本中
    procedure RegisteToScript(L: lua_State);
    
    property Language: String read FLanguage write SetLanguage;
    property Text[Id: Integer]: UTF8String read GetText write SetText; default;
    property Capacity: Integer read GetCapacity;
  end;



var
  LanguagePackage: TLanguagePackage;
  
implementation

type
  TLangPackLoaderCallBack = class(TInterfacedObject, ILangPackLoaderCallBack)
  private                 
    FPackage: TLuaLanguagePackage;
  protected
    { ILangPackLoaderCallBack }
    function OnAddCategory(nCategoryId: Integer; const sName: WideString): HResult; stdcall;
    function OnAddText(nTextId: Integer; const sText: WideString): HResult; stdcall;
  public
    constructor Create(APackage: TLuaLanguagePackage);
  end;

(*
  脚本中获取语言文本的处理函数
*)
function LuaGetLangText(L: lua_State): Integer; cdecl;
var
  ptr: ^Pointer;
  Package: TLuaLanguagePackage;
  nIdx: Integer;
begin
  ptr := lua_touserdata(L, 1);
  Package := ptr^;
  nIdx := lua_tointeger(L, 2);
  lua_pushinteger( L, nIdx );
//  lua_pushstring(L, PChar(Package[nIdx]));
  Result := 1;
end;

{ TCustomLanguagePackage }

function TLuaLanguagePackage.GetCapacity: Integer;
begin
  Result := Length(FStrings);
end;

function TLuaLanguagePackage.GetText(Id: Integer): UTF8String;
begin
  if Id < Length(FStrings) then
    Result := FStrings[Id]
  else Result := '';
end;

procedure TLuaLanguagePackage.LoadFromDB(const DBName: String);
var
  Loader: ILangPackLoader;
  CallBack: ILangPackLoaderCallBack;
begin
  CallBack := TLangPackLoaderCallBack.Create(Self);
  try
    Loader := CreateLocalLangPackLoader();   
    Loader.openDatabase(DBName);
    Loader.loadText(CallBack);
    Loader := nil;
  finally
    CallBack := nil;
  end;
end;

procedure TLuaLanguagePackage.RegisteToScript(L: lua_State);
var
  ptr: ^Pointer;
begin
  //创建脚本对象
  ptr := lua_newuserdata(L, sizeof(ptr));
  ptr^ := Self;
  //创建元方法表
  lua_createtable(L, 0, 1);
  //设置get方法
  lua_pushcclosure(L, @LuaGetLangText, 0);
  lua_setfield(L, -2, '__index');
  //设置原方法
  lua_setmetatable(L, -2); 
  //设置Lang表
  lua_setglobal(L, 'Lang');
end;

procedure TLuaLanguagePackage.SetLanguage(const Value: String);
begin
  if FLanguage <> value then
  begin
    FLanguage := Value;
  end;
end;

procedure TLuaLanguagePackage.SetText(Id: Integer;
  const Value: UTF8String);
begin
  if Id >= Length(FStrings) then
  begin
    SetLength(FStrings, (Id + 2048) and (not 2047));
  end;
  FStrings[Id] := Value;
end;

{ TLangPackLoaderCallBack }

constructor TLangPackLoaderCallBack.Create;
begin
  Inherited Create();
  FPackage := APackage; 
end;

function TLangPackLoaderCallBack.OnAddCategory(nCategoryId: Integer;
  const sName: WideString): HResult;
begin
  Result := S_OK;
end;

function TLangPackLoaderCallBack.OnAddText(nTextId: Integer;
  const sText: WideString): HResult;
begin
  FPackage.Text[nTextId] := UTF8Encode(sText);
  Result := S_OK;
end;

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
