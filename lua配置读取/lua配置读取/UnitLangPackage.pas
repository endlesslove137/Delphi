unit UnitLangPackage;

interface

uses
  Windows, SysUtils, Classes, ActiveX, COMObj, COMLangPackLib, lua;

type
  TLanguagePackage = class
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

implementation    

type
  TLangPackLoaderCallBack = class(TInterfacedObject, ILangPackLoaderCallBack)
  private                 
    FPackage: TLanguagePackage;
  protected
    { ILangPackLoaderCallBack }
    function OnAddCategory(nCategoryId: Integer; const sName: WideString): HResult; stdcall;
    function OnAddText(nTextId: Integer; const sText: WideString): HResult; stdcall;
  public
    constructor Create(APackage: TLanguagePackage);
  end;

(*
  脚本中获取语言文本的处理函数
*)
function LuaGetLangText(L: lua_State): Integer; cdecl;
var
  ptr: ^Pointer;
  Package: TLanguagePackage;
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

function TLanguagePackage.GetCapacity: Integer;
begin
  Result := Length(FStrings);
end;

function TLanguagePackage.GetText(Id: Integer): UTF8String;
begin
  if Id < Length(FStrings) then
    Result := FStrings[Id]
  else Result := '';
end;

procedure TLanguagePackage.LoadFromDB(const DBName: String);
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

procedure TLanguagePackage.RegisteToScript(L: lua_State);
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

procedure TLanguagePackage.SetLanguage(const Value: String);
begin
  if FLanguage <> value then
  begin
    FLanguage := Value;
  end;
end;

procedure TLanguagePackage.SetText(Id: Integer;
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

end.
