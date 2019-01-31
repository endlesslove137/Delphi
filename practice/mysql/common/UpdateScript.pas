unit UpdateScript;

interface

uses
  Windows, SysUtils, Classes, Lua, FuncUtil;

type
  TUpdateScript = class
  protected
    m_Lua: Lua_State;       
    procedure OpenBaseLibs();
    procedure RunInitialize();
    procedure RunFinalize();      
    procedure LuaCheck(Err: Integer);
  protected
    procedure RegisteFunctions();virtual;
  public
    destructor Destroy();override;

    procedure SetScriptText(const sText: string);
    procedure RunScriptFromFile(const sFileName: string);
  end;
              
procedure LuaCheck(L: Lua_State; const Err: Integer);
function GetTableIndexString(L: lua_State; IndexStartFromOne: Integer): string;
function GetFieldString(L: lua_State; fieldName: PChar): string;
function GetFieldInteger(L: lua_State; fieldName: PChar): Integer;
function GetFieldPointer(L: lua_State; fieldName: PChar): Pointer;
function GetFieldTable(L: lua_State; fieldName: PChar): Boolean;

(*  script  function   *)

function lc_SetControlBounds(L: Lua_State): Integer;cdecl;
function lc_GetControlParent(L: Lua_State): Integer;cdecl;
function lc_SetControlParent(L: Lua_State): Integer;cdecl;
function lc_Exit(L: Lua_State): Integer;cdecl;
function lc_RunShellCommand(L: Lua_State): Integer;cdecl;
function lc_GetProperty(L: Lua_State): Integer;cdecl;
function lc_SetProperty(L: Lua_State): Integer;cdecl;
function lc_HexToInt(L: Lua_State): Integer;cdecl;
function lc_MsgBox(L: Lua_State): Integer;cdecl;
function lc_CreateObject(L: Lua_State): Integer;cdecl;
function lc_FreeObject(L: Lua_State): Integer;cdecl;
function lc_GetFileSize(L: Lua_State): Integer;cdecl;
function lc_ShowDialogModal(L: Lua_State): Integer;cdecl;
function lc_EndDialogModal(L: Lua_State): Integer;cdecl;

const
  SystemFnTable : array [0..14] of luaL_reg =
  (
    ( name: 'SetControlBounds'; func: lc_SetControlBounds ),
    ( name: 'GetControlParent'; func: lc_GetControlParent ),
    ( name: 'SetControlParent'; func: lc_SetControlParent ),
    ( name: 'Exit'; func: lc_Exit ),
    ( name: 'RunShellCommand'; func: lc_RunShellCommand ),
    ( name: 'GetProperty'; func: lc_GetProperty ),
    ( name: 'SetProperty'; func: lc_SetProperty ),
    ( name: 'HexToInt'; func: lc_HexToInt ),
    ( name: 'MsgBox'; func: lc_MsgBox ),
    ( name: 'CreateObject'; func: lc_CreateObject ),
    ( name: 'FreeObject'; func: lc_FreeObject ),
    ( name: 'GetFileSize'; func: lc_GetFileSize ),
    ( name: 'ShowDialogModal'; func: lc_ShowDialogModal ),   
    ( name: 'EndDialogModal'; func: lc_EndDialogModal ),
    ( name: nil; func: nil )
  );

implementation

uses RTLConsts, Forms, Variants, StdCtrls, ExtCtrls, Controls, TypInfo,
  ShellAPI, Spin, Gauges;

procedure LuaCheck(L: Lua_State; const Err: Integer);
var
  S: string;
begin
  if Err <> 0 then
  begin
    s := lua_tostring( L, -1 );
    lua_pop(L, 1);
    Raise Exception.Create('Script Error:' + #13#10 + S);
  end;
end;


function GetTableIndexString(L: lua_State; IndexStartFromOne: Integer): string;
begin
  lua_pushinteger( L, IndexStartFromOne );
  lua_rawget( L, -2 );
  Result := lua_tostring( L, -1 );
  lua_pop( L, 1 );
end;

function GetFieldString(L: lua_State; fieldName: PChar): string;
begin
  lua_getfield(L, -1, fieldName );
  Result := lua_tostring( L, -1 );
  lua_pop( L, 1 );
end;

function GetFieldInteger(L: lua_State; fieldName: PChar): Integer;
begin
  lua_getfield(L, -1, fieldName );
  Result := lua_tointeger( L, -1 );
  lua_pop( L, 1 );
end;

function GetFieldPointer(L: lua_State; fieldName: PChar): Pointer;
begin
  lua_getfield(L, -1, fieldName );
  Result := lua_touserdata( L, -1 );
  lua_pop( L, 1 );
end;

function GetFieldTable(L: lua_State; fieldName: PChar): Boolean;
begin
  lua_getfield(L, -1, fieldName );
  Result := lua_istable( L, -1 );
  if not Result then lua_pop( L, 1 );
end;

type
  PCallLuaMethodData = ^TCallLuaMethodData;
  TCallLuaMethodData = record
    Instance: TObject;
    lua: Lua_State;
    pFnName: PChar;
  end;       

procedure PropertyNotFound(const Name: string);
begin
  raise EPropertyError.CreateResFmt(@SUnknownProperty, [Name]);
end;

procedure _LMethodeCalll(pMethodData: PCallLuaMethodData);
begin
  lua_getglobal( pMethodData^.lua, pMethodData^.pFnName );
  lua_pushlightuserdata( pMethodData^.lua, pMethodData^.Instance );
  LuaCheck(pMethodData^.lua, lua_pcall( pMethodData^.lua, 1, 0, 0 ));
end;

procedure _SetLMethodProc(Instance: TObject; PropInfo: PPropInfo;
  L: Lua_State; const LFn: PChar);overload;
var
  m: TMethod;
  pData: PCallLuaMethodData;
begin
  GetMem( pData, sizeof(pData^) + Length(LFn) + 1 );
  RegisterExpectedMemoryLeak(pData);

  pData^.Instance := Instance;
  pData^.lua := L;
  pData^.pFnName := PChar(Integer(pData) + Sizeof(pData^));
  StrCopy(pData^.pFnName, LFn);

  m.Code := @_LMethodeCalll;
  m.Data := pData;
  SetMethodProp( Instance, PropInfo, m );
end;

procedure _SetLMethodProc(Instance: TObject; const PropName: string;
  L: Lua_State; const LFn: PChar);overload;
var
  PropInfo: PPropInfo;
begin
  PropInfo := GetPropInfo(Instance, PropName);
  if PropInfo = nil then
    PropertyNotFound(PropName);
  _SetLMethodProc( Instance, PropInfo, L, LFn );
end;

function DeepFindControl(WinCtrl: TWinControl; const sName: string): TControl;
var
  I: Integer;
  ChildCtrl: TControl;
begin
  Result := nil;
  for I := 0 to WinCtrl.ControlCount - 1 do
  begin
    ChildCtrl := WinCtrl.Controls[I];
    if CompareText(ChildCtrl.Name, sName) = 0 then
    begin
      Result := ChildCtrl;
      break;
    end;
    if ChildCtrl is TWinControl then
    begin
      Result := DeepFindControl(TWinControl(ChildCtrl), sName);
      if Result <> nil then
        break;
    end;
  end;
end;

function lc_SetControlBounds(L: Lua_State): Integer;cdecl;
var
  WinCtrl: TWinControl;
  Bounds: TRect;
begin
  WinCtrl := lua_touserdata( L, 1 );
  if lua_istable( L, 2 ) then
  begin
    Bounds.Left := GetFieldInteger( L, 'X' );
    Bounds.Top := GetFieldInteger( L, 'Y' );
    Bounds.Right := GetFieldInteger( L, 'Width' );
    Bounds.Bottom := GetFieldInteger( L, 'Height' );
  end
  else begin
    Bounds.Left := lua_tointeger( L, 2 );
    Bounds.Top := lua_tointeger( L, 3 );
    Bounds.Right := lua_tointeger( L, 4 );
    Bounds.Bottom :=lua_tointeger( L, 5 );
  end;            
  WinCtrl.SetBounds(Bounds.Left, Bounds.Top, Bounds.Right, Bounds.Bottom);
  Result := 0;
end;

function lc_GetControlParent(L: Lua_State): Integer;cdecl;
var
  Child: TObject;
begin
  Child := lua_touserdata( L, 1 );
  if (Child <> nil) and (Child is TWinControl)
  and (TWinControl(Child).Parent <> nil) then
  begin
    lua_pushlightuserdata( L, TWinControl(Child).Parent );
  end
  else lua_pushnil( L );
  Result := 1;
end;

function lc_SetControlParent(L: Lua_State): Integer;cdecl;
var
  Child, Parent: TObject;
begin
  Child := lua_touserdata( L, 1 );
  Parent := lua_touserdata( L, 2 );
  if (Child <> nil) and (Parent <> nil)
  and (Child is TControl) and (Parent is TWinControl) then
  begin
    TControl(Child).Parent := TWinControl(Parent);
    lua_pushboolean( L, True );
  end
  else lua_pushboolean( L, False );
  Result := 1;
end;

function lc_Exit(L: Lua_State): Integer;cdecl;
begin
  ExitProcess(lua_tointeger( L, 1 ));
  Result := 0;
end;

function lc_RunShellCommand(L: Lua_State): Integer;cdecl;
var
  sOperation, sPage: string;
begin
  sOperation := lua_tostring( L, 1 );
  sPage := lua_tostring( L, 2 );
  ShellExecute(0, PCHAR(sOperation), PChar(sPage), nil, nil, SW_SHOW);
  Result := 0;
end;

function lc_GetProperty(L: Lua_State): Integer;cdecl;
var
  Instance: TObject;
  sPropName, S: string;
  pInfo: PPropInfo;
  v: variant;
begin
  Instance := lua_touserdata( L, 1 );
  sPropName := lua_tostring( L, 2 );
                 
  pInfo := GetPropInfo(Instance, sPropName);
  if pInfo = nil then
  begin
    Raise Exception.Create('类型' + Instance.ClassName + '不具备此特性:' + sPropName);
  end;

  case pInfo^.PropType^^.Kind of
    tkInteger, tkChar, tkWChar: lua_pushinteger( L, GetOrdProp(Instance, pInfo) );
    tkClass: lua_pushlightuserdata( L, GetObjectProp(Instance, pInfo) );
    tkEnumeration: lua_pushstring(L, PChar(GetEnumProp(Instance, pInfo)));
    tkSet: lua_pushinteger( L, GetOrdProp(Instance, pInfo));
    tkFloat: lua_pushnumber( L, GetFloatProp(Instance, pInfo));
    tkString, tkLString: lua_pushstring( L, PChar(GetStrProp(Instance, pInfo)));
    tkWString: begin
      S := GetWideStrProp(Instance, pInfo);
      lua_pushstring( L, PChar(S));
    end;
    tkVariant: begin
      v := GetVariantProp(Instance, pInfo);
      S := v;
      lua_pushstring(L, PChar(S));
    end;
    tkInt64: lua_pushnumber( L, GetInt64Prop(Instance, pInfo));
    else Raise Exception.Create('不支持获取此特性:' + Instance.ClassName + '.' + sPropName);
  end;
  Result := 1;
end;

function lc_SetProperty(L: Lua_State): Integer;cdecl;
var
  Instance: TObject;
  sPropName: string;
  pInfo: PPropInfo;
  v: variant;
begin
  Instance := lua_touserdata( L, 1 );
  sPropName := lua_tostring( L, 2 );

  pInfo := GetPropInfo(Instance, sPropName);
  if pInfo = nil then
  begin
    Raise Exception.Create('类型' + Instance.ClassName + '不具备此特性:' + sPropName);
  end;

  case pInfo^.PropType^^.Kind of
    tkInteger, tkChar, tkWChar: SetOrdProp(Instance, pInfo, lua_tointeger(L, 3));
    tkClass: SetObjectProp(Instance, pInfo, TObject(lua_touserdata(L,3)));
    tkEnumeration: SetEnumProp(Instance, pInfo, lua_tostring(L, 3));
    tkSet: SetOrdProp(Instance, pInfo, lua_tointeger(L, 3));
    tkFloat: SetFloatProp(Instance, pInfo, lua_tonumber(L, 3));
    tkMethod: _SetLMethodProc(Instance, pInfo, L, lua_tostring(L, 3));
    tkString, tkLString:SetStrProp(Instance, pInfo, lua_tostring(L, 3));
    tkWString: SetWideStrProp(Instance, pInfo, lua_tostring(L, 3));
    tkVariant: begin
      v := string(lua_tostring(L, 3));
      SetVariantProp(Instance, pInfo, v);
    end;
    tkInt64: SetInt64Prop(Instance, pInfo, lua_tointeger(L, 3));
    else Raise Exception.Create('不支持此设置特性:' + Instance.ClassName + '.' + sPropName);
  end;
  Result := 0;
end;

function lc_HexToInt(L: Lua_State): Integer;cdecl;
var
  s: string;
begin
  s := lua_tostring( L, 1 );
  lua_pushinteger( L, StrToIntDef(s, 0) );
  Result := 1;
end;

function lc_MsgBox(L: Lua_State): Integer;cdecl;
var
  pText, pCaption: PChar;
  uFlag: DWord;
begin
  pText := lua_tostring( L, 1 );
  pCaption := lua_tostring( L, 2 );
  uFlag := lua_tointeger( L, 3 );
  uFlag := MessageBox( 0, pText, pCaption, uFlag or MB_SYSTEMMODAL );
  lua_pushinteger( L, uFlag );
  Result := 1;
end;

function lc_CreateObject(L: Lua_State): Integer;cdecl;
var
  ClassName: string; 
  ClassType: TPersistentClass;
  Instance: TObject;
begin
  ClassName := lua_tostring( L, 1 );
  ClassType := FindClass( ClassName );
  if ClassType <> nil then
  begin
    Instance := ClassType.Create;
    if Instance is TComponent then
    begin
      TComponent(Instance).Create(nil);
    end;
    lua_pushlightuserdata( L, Instance );
  end
  else lua_pushnil( L );
  Result := 1;
end;

function lc_FreeObject(L: Lua_State): Integer;cdecl;
var
  Instance: TObject;
begin
  Instance := lua_touserdata( L, 1 );
  Instance.Free;
  Result := 0;
end;

function lc_GetFileSize(L: Lua_State): Integer;cdecl;
var
  nSize: double;
begin
  nSize := FuncUtil.GetFileSize( lua_tostring( L, 1 ) );
  lua_pushnumber( L, nSize );
  Result := 1;
end;    

function lc_ShowDialogModal(L: Lua_State): Integer;cdecl;
var
  Wnd: TObject;
begin
  Wnd := lua_touserdata( L, 1 );
  if (Wnd <> nil) and (Wnd is TCustomForm) then
  begin
    lua_pushinteger( L, TCustomForm(Wnd).ShowModal() );
  end
  else lua_pushnil( L );
  Result := 1;
end;

function lc_EndDialogModal(L: Lua_State): Integer;cdecl;
var
  Wnd: TObject;
begin
  Wnd := lua_touserdata( L, 1 );
  if (Wnd <> nil) and (Wnd is TCustomForm) and TCustomForm(Wnd).Showing then
  begin
    TCustomForm(Wnd).ModalResult := lua_tointeger( L, 2 );
  end;
  Result := 0;
end;

{ TUpdateScript }

destructor TUpdateScript.Destroy;
begin
  SetScriptText( '' );
  inherited;
end;

procedure TUpdateScript.LuaCheck(Err: Integer);
begin
  UpdateScript.LuaCheck( m_Lua, Err );
end;

procedure TUpdateScript.OpenBaseLibs;
begin
  LuaCheck(lua_cpcall( m_Lua, luaopen_base, nil ));
  LuaCheck(lua_cpcall( m_Lua, luaopen_string, nil ));
  LuaCheck(lua_cpcall( m_Lua, luaopen_math, nil ));
  LuaCheck(lua_cpcall( m_Lua, luaopen_os, nil ));
  LuaCheck(lua_cpcall( m_Lua, luaopen_table, nil ));
  LuaCheck(lua_cpcall( m_Lua, luaopen_io, nil ));
  LuaCheck(lua_cpcall( m_Lua, luaopen_package, nil ));
end;

procedure TUpdateScript.RegisteFunctions;
begin
  luaL_register(m_Lua, 'System', @SystemFnTable[0]);
end;

procedure TUpdateScript.RunFinalize;
begin
  lua_getglobal( m_Lua, 'finalization' );
  if lua_isfunction( m_Lua, -1 ) then
  begin
    LuaCheck(lua_pcall( m_Lua, 0, 0, 0 ));
  end
  else lua_pop( m_Lua, 1 );
end;

procedure TUpdateScript.RunInitialize;
begin
  lua_getglobal( m_Lua, 'initialization' );
  if lua_isfunction( m_Lua, -1 ) then
  begin
    LuaCheck(lua_pcall( m_Lua, 0, 0, 0 ));
  end
  else lua_pop( m_Lua, 1 );
end;

procedure TUpdateScript.RunScriptFromFile(const sFileName: string);
var
  stm: TStream;
  s: string;
begin
  stm := TFileStream.Create(sFileName, fmShareDenyWrite);
  try
    SetLength( s, stm.Size );
    try
      stm.Position := 0;
      stm.Read(s[1], Length(s));
      SetScriptText(s);
    finally
      Setlength( s, 0 );
    end;
  finally
    stm.Free;
  end;
end;

var
  LuaLibOpened : Boolean = False;

procedure TUpdateScript.SetScriptText(const sText: string);
begin
  if not LuaLibOpened then
  begin
    if LoadLuaLib() <= 0 then
    begin
      Raise Exception.CreateFmt('加载模块lua模块失败'#13#10'%d %s',
        [GetLastError(), SysErrorMessage(GetLastError())]);
    end;
    LuaLibOpened := True;
  end;

  if m_Lua <> nil then
  begin
    RunFinalize();
    lua_close( m_Lua );
    m_Lua := nil;
  end;

  if sText = '' then Exit;

  m_Lua := lua_open();
  OpenBaseLibs();
  RegisteFunctions();
  LuaCheck(luaL_loadstring(m_Lua, PChar(sText)));
  LuaCheck(lua_pcall( m_Lua, 0, LUA_MULTRET, 0 ));
  RunInitialize();
end;



initialization
begin
  RegisterClass( TButton );
  RegisterClass( TForm );
  RegisterClass( TPanel );
  RegisterClass( TLabel );
  RegisterClass( TMemo );
  RegisterClass( TEdit );
  RegisterClass( TCheckBox );
  RegisterClass( TRadioButton );
  RegisterClass( TListBox );
  RegisterClass( TComboBox );
  RegisterClass( TRadioGroup );
  RegisterClass( TGroupBox );

  RegisterClass( TTimer );
  RegisterClass( TBevel );
  RegisterClass( TColorBox );
  RegisterClass( TColorListBox );
  RegisterClass( TTrayIcon );

  RegisterClass( TGauge );
  RegisterClass( TSpinEdit );
end;

finalization
begin
  FreeLuaLib();
end;

end.
