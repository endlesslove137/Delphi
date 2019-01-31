unit DataConfig;

interface

uses Classes, SysUtils, Lua, Windows, Dialogs;

type
  TDataConfigLoad = function : Boolean of Object;

  PTDataConfigReloadCall=^TDataConfigReloadCall;
  TDataConfigReloadCall = record
    sConfigName: string[57];
    Func: TDataConfigLoad;
  end;
  
  TDataConfig = class
  private
    m_Lua           : Lua_State;
    m_nLastError    : Integer;
    m_sLastFunction : string;
    m_pNextReloadCall: PTDataConfigReloadCall;

    procedure ClearStdItemList;
    procedure ClearTaskList;
  public
    m_ReloadCalls: array [0..1023] of TDataConfigReloadCall;
    m_StdItemList: TStringList;
    m_ShopClass:array[1..50] of TShopClass;
    m_TaskList: TStringList;

    constructor Create();
    destructor Destroy();override;

    function LoadConfigScript(): Boolean;
    function LoadAllConfig(): Boolean;
    procedure SetScript(const s: string);
    procedure CreateLuaEngine();
    procedure AddReloadCall(sConfigName: string; Call: TDataConfigLoad);
    procedure SetupReloadCalls();

    function LoadItemConifg: Boolean;
    function LoadShopConfig: Boolean;
    function LoadTaskConfig: Boolean;

    function OpenGlobalTable(const sTableName: PChar): Boolean;
    function OpenFieldTable(const sTableName: PChar): Boolean;
    procedure CloseTable();
    function EnumTableFirst: Boolean;
    function EnumTableNext: Boolean;
    procedure EndTableEnum;

    function GetFieldInteger(sFieldName: PChar; var IsValid: Boolean): Int64;
    function GetFieldString(sFieldName: PChar; var IsValid: Boolean): string;
    function GetFieldNumber(sFieldName: PChar; var IsValid: Boolean): Double;
  end;

procedure PerProcessLuaScript(sScritpFileName, sPatch: string; ScriptList: TStrings);

var
  DConfig: TDataConfig;
  
implementation

{ TDataConfig }

function LoadUTFFile(const FileName: string): string;
var
  MemStream: TMemoryStream;
  S, HeaderStr:string;
  strTmp: TStringList;
begin
  Result:='';
  if not FileExists(FileName) then Exit;
  MemStream := TMemoryStream.Create;
  try
    MemStream.LoadFromFile(FileName);
    SetLength(HeaderStr, 3);
    MemStream.Read(HeaderStr[1], 3);
    if HeaderStr = #$EF#$BB#$BF then
    begin
      SetLength(S, MemStream.Size - 3);
      MemStream.Read(S[1], MemStream.Size - 3);
      Result := Utf8ToAnsi(S);
    end else
    begin
      strTmp := TStringList.Create;
      try
        strTmp.LoadFromFile(FileName);
        S := strTmp.Text;
      finally
        strTmp.Free;
      end;
      Result := S;
    end;
  finally
    MemStream.Free;
  end;
end;
 

procedure TDataConfig.AddReloadCall(sConfigName: string; Call: TDataConfigLoad);
begin
  m_pNextReloadCall^.sConfigName := sConfigName;
  m_pNextReloadCall^.Func := Call;
  Inc(m_pNextReloadCall);
end;

procedure TDataConfig.ClearStdItemList;
var
  I: Integer;
begin
  for I := 0 to m_StdItemList.Count - 1 do
  begin
    Dispose(PTStdItem(m_StdItemList.Objects[I]));
  end;
end;

procedure TDataConfig.ClearTaskList;
var
  I: Integer;
begin
  for I := 0 to m_TaskList.Count - 1 do
  begin
    Dispose(PTTask(m_TaskList.Objects[I]));
  end;
  m_TaskList.Clear;
end;

procedure TDataConfig.CloseTable;
begin
  if lua_gettop(m_Lua) > 0 then
  begin
    lua_pop(m_Lua, 1);
  end;
end;

constructor TDataConfig.Create;
begin
  m_pNextReloadCall := @m_ReloadCalls[0];
  m_StdItemList := TStringList.Create;
  m_TaskList := TStringList.Create;
  SetupReloadCalls();
end;

procedure TDataConfig.CreateLuaEngine;
begin
  m_Lua := lua.luaL_newstate();// lua_newstate( lua_allocater, nil );
  lua_cpcall( m_Lua, luaopen_base, nil );
  lua_cpcall( m_Lua, luaopen_string, nil );
  lua_cpcall( m_Lua, luaopen_math, nil );
  lua_cpcall( m_Lua, luaopen_table, nil );
end;

destructor TDataConfig.Destroy;
begin
  SetScript('');
  ClearStdItemList;
  m_StdItemList.Free;
  ClearTaskList;
  m_TaskList.Free;
  inherited;
end;

procedure TDataConfig.EndTableEnum;
begin
  lua_pop(m_Lua, 2);  (* remove value and key *)
end;

function TDataConfig.EnumTableFirst: Boolean;
begin
  lua_pushnil(m_Lua);  (* first key *)
  Result := lua_next(m_Lua, -2) <> 0;
end;

function TDataConfig.EnumTableNext: Boolean;
begin
  lua_pop(m_Lua, 1);  (* remove value, reserve key for next iterate *)
  Result := lua_next(m_Lua, -2) <> 0;   
end;

function TDataConfig.GetFieldInteger(sFieldName: PChar;
  var IsValid: Boolean): Int64;
var
  d, d2: Double;
  boInvalidValue: Boolean;
begin                                 
  Result := 0;
  
  if sFieldName <> nil then
  begin
    lua_getfield(m_Lua, -1, sFieldName );
  end;

  boInvalidValue := False;
  if lua_isnumber( m_Lua, -1 ) then
  begin
    d := lua_tonumber( m_Lua, -1 );
    Result := Trunc(d);
    d2 := Result;
    if d2 <> d then
      boInvalidValue := True;
    //不要为IsValid设值
  end
  else boInvalidValue := True;
  
  if boInvalidValue then
  begin
    IsValid := False;    
  end;
  if sFieldName <> nil then
  begin
    lua_pop( m_Lua, 1 );
  end;
end;

function TDataConfig.GetFieldNumber(sFieldName: PChar;
  var IsValid: Boolean): Double;
begin
  if sFieldName <> nil then
  begin
    lua_getfield(m_Lua, -1, sFieldName );
  end;
  
  if lua_isnumber( m_Lua, -1 ) then
  begin
    Result := lua_tonumber( m_Lua, -1 );
    //不要为IsValid设值
  end
  else begin
    Result := 0;
    IsValid := False;
  end;

  if sFieldName <> nil then
  begin
    lua_pop( m_Lua, 1 );
  end;
end;

function TDataConfig.GetFieldString(sFieldName: PChar;
  var IsValid: Boolean): string;
begin
  if sFieldName <> nil then
  begin
    lua_getfield(m_Lua, -1, sFieldName );
  end;

  if lua_isstring( m_Lua, -1 ) then
  begin
    Result := lua_tostring( m_Lua, -1 );
    //不要为IsValid设值
  end
  else begin
    Result := '';
    IsValid := False;    
  end;

  if sFieldName <> nil then
  begin
    lua_pop( m_Lua, 1 );
  end;
end;

function TDataConfig.LoadAllConfig: Boolean;
var
  pLoadCall: PTDataConfigReloadCall;
  nStackTop: Integer;
begin
  Result := False;
  nStackTop := lua_gettop(m_Lua);
  pLoadCall := @m_ReloadCalls[0];
  while pLoadCall <> m_pNextReloadCall do
  begin
    if not pLoadCall^.Func() then
      Exit;
    if nStackTop <> lua_gettop(m_Lua) then
    begin
      ShowMessage('加载“' + pLoadCall^.sConfigName + '”后栈遭到破坏！');
      Exit;
    end;
    Inc(pLoadCall);
  end;
  Result := True;
end;

function TDataConfig.LoadConfigScript: Boolean;
const
  szFileName = '\HTConfig.txt';
var
  SL: TStrings;
begin
  SL := TStringList.Create;
  try
    SL.LoadFromFile(g_sEngineRoot+ szFileName);
    PerProcessLuaScript(g_sEngineRoot+ szFileName, '\', SL);
    SetScript(SL.Text);
    Result := True;
  finally
    SL.Free;
  end;
end;

function TDataConfig.LoadItemConifg: Boolean;
var
  id: Integer;
  pStdItem: PTStdItem;
begin
  Result := True;
  if OpenGlobalTable('StdItems') then
  begin
    if EnumTableFirst() then
    begin
      Result := True;
      repeat
        id := GetFieldInteger('id',Result);
        if GetFieldString('name',Result) <> '' then
        begin
          New(pStdItem);
          FillChar(pStdItem^, sizeof(pStdItem^), 0 );
          pStdItem^.ItemID := id;
          pStdItem^.ItemName := GetFieldString('name',Result);
          pStdItem^.Dup := GetFieldInteger('dup',Result);
          m_StdItemList.AddObject(pStdItem^.ItemName,TObject(pStdItem));
        end;
      until not EnumTableNext();
    end;
    CloseTable();
  end;
end;

function TDataConfig.LoadShopConfig: Boolean;
var
  ShopClass:array[1..50] of TShopClass;
  ClassIdx,ItemIdx: Integer;
begin
  Result := False;
  FillChar(ShopClass, sizeof(ShopClass), 0 );
  if OpenGlobalTable('GameStore') then
  begin
    if EnumTableFirst() then
    begin
      Result := True;
      ClassIdx := Low(ShopClass);
      repeat
        ShopClass[ClassIdx].sName := GetFieldString('name',Result);
        if OpenFieldTable('items') then
        begin
          if EnumTableFirst() then
          begin
            ItemIdx := Low(ShopClass[ClassIdx].ShopItem);
            repeat
              ShopClass[ClassIdx].ShopItem[ItemIdx].nItemId := GetFieldInteger('item',Result);
              if OpenFieldTable('price') then
              begin
                if EnumTableFirst() then
                begin
                  repeat
                    if (GetFieldString('spid',Result) = '*') and (GetFieldInteger('type',Result)=3) then
                    begin
                      ShopClass[ClassIdx].ShopItem[ItemIdx].nPrice := GetFieldInteger('price',Result);
                      EndTableEnum();
                      break;
                    end;
                  until not EnumTableNext();
                end;
                CloseTable();
              end;
              Inc(ItemIdx);
              if not Result or (ItemIdx > High(ShopClass[ClassIdx].ShopItem)) then
              begin
                EndTableEnum();
                break;
              end;
            until not EnumTableNext();
          end;
          CloseTable();
        end;
        Inc(ClassIdx);
        if not Result or (ClassIdx > High(ShopClass)) then
        begin
          EndTableEnum();
          break;
        end;
      until not EnumTableNext();
    end;
    CloseTable();
  end;
  if Result then
  begin
    move(ShopClass,m_ShopClass,sizeof(ShopClass));
  end;
end;

function TDataConfig.LoadTaskConfig: Boolean;
var
  id: Integer;
  pTask: PTTask;
begin
  Result := True;
  if OpenGlobalTable('StdQuest') then
  begin
    if EnumTableFirst() then
    begin
      Result := True;
      repeat
        id := GetFieldInteger('id',Result);
        if GetFieldString('name',Result) <> '' then
        begin
          New(pTask);
          FillChar(pTask^, sizeof(pTask^), 0 );
          pTask^.nTaskID := id;
          pTask^.sTaskName := GetFieldString('name',Result);
          pTask^.bType := GetFieldInteger('type',Result);
          pTask^.nParentID := GetFieldInteger('parentid',Result);
          if OpenFieldTable('conds') then
          begin
            if EnumTableFirst() then
            begin
              repeat
                case GetFieldInteger('type',Result) of
                  0:
                  begin
                    pTask^.bMaxLevel := GetFieldInteger('id',Result);
                    pTask^.bAcceptLevel := GetFieldInteger('count',Result);
                  end;
                  4:
                  begin
                    pTask^.nZyID1 := GetFieldInteger('id',Result);
                    pTask^.nZyID2 := GetFieldInteger('count',Result);
                  end;
                end;
              until not EnumTableNext();
            end;
            CloseTable();
          end;
          m_TaskList.AddObject(pTask^.sTaskName,TObject(pTask));
        end;
      until not EnumTableNext();
    end;
    CloseTable();
  end;
end;

function TDataConfig.OpenFieldTable(const sTableName: PChar): Boolean;
begin
  lua_getfield(m_Lua, -1, sTableName );
  Result := lua_istable( m_Lua, -1 );
  if not Result then
  begin
    lua_pop( m_Lua, 1 );
  end;
end;

function TDataConfig.OpenGlobalTable(const sTableName: PChar): Boolean;
begin
  lua_getglobal(m_Lua, sTableName );
  Result := lua_istable( m_Lua, -1 );
  if not Result then
  begin
    lua_pop( m_Lua, 1 );
  end;
end;

procedure TDataConfig.SetScript(const s: string);
var
  dwOldCW: DWord;
begin
  if m_Lua <> nil then
  begin
    lua_close( m_Lua );
    m_Lua := nil;
  end;
  if s <> '' then
  begin
    CreateLuaEngine();
    m_sLastFunction := '<LOADER>';
    //由于lua-dll中可能引起可被忽略的浮点数异常，所以在加载脚本时应当先忽略异常
    dwOldCW := Get8087CW();
    Set8087CW($133f);
    try
      m_nLastError := luaL_loadstring( m_Lua, PChar(s) );
    finally
      Set8087CW(dwOldCW);
    end;
    lua_pcall( m_Lua, 0, LUA_MULTRET, 0 );
  end;
end;

procedure TDataConfig.SetupReloadCalls;
begin
  AddReloadCall('物品数据库配置',LoadItemConifg);
  AddReloadCall('商城物品配置',LoadShopConfig);
  AddReloadCall('系统任务配置',LoadTaskConfig);
end;

procedure PerProcessLuaScript(sScritpFileName, sPatch: string; ScriptList: TStrings);
const
  sIncludeIdent = '--#include ';
  sFunctions = 'Functions\';
  slanguage = 'language\';
var
  I, nCount, J, nPos: Integer;
  sLine, sFile, sInclude,sPath: string;
  SL, Includeed: TStrings;
  boFound: Boolean;
begin
  Includeed := TStringList.Create;
  SL := TStringList.Create;
  (Includeed as TStringList).Sorted := True;

  nCount := ScriptList.Count;
  I := 0;
  sPath := '';
  while I < nCount do
  begin
    sLine := ScriptList[I];

    if (Length(sLine) > Length(sIncludeIdent)) and (StrLIComp(PChar(sLine), sIncludeIdent, Length(sIncludeIdent)) = 0) then
    begin
      sInclude := '';
      nPos := Pos('"', sLine);
      if nPos > 0 then
      begin
        sLine := Copy(sLine, nPos + 1, Length(sLine) - nPos);
        nPos := Pos('"', sLine);
        if nPos > 0 then
        begin
          sInclude := Copy(sLine, 1, nPos - 1);
        end;
      end;
      
      sFile := sPatch + sInclude;
      boFound := FileExists(  sFile );
      if not boFound then
      begin
        sFile := g_sEngineRoot + sPatch + sInclude;
        boFound := FileExists(  sFile );
      end;
      if not boFound then
      begin
        sFile := sPath + sInclude;
        boFound := FileExists(  sFile );
      end;
      if not boFound then
      begin
        sFile := g_sEngineRoot + '\config\item\' + sInclude;
        boFound := FileExists(  sFile );
      end;
      if not boFound then
      begin
        sFile := g_sEngineRoot + '\config\store\' + sInclude;
        boFound := FileExists(  sFile );
      end;
      if not boFound then
      begin
        sFile := g_sEngineRoot + '\config\quest\' + sInclude;
        boFound := FileExists(  sFile );
      end;
      if boFound then
      begin
        sFile := ExpandFileName( sFile );
        sPath := ExtractFilePath(sFile);
        if Includeed.IndexOf( sFile ) < 0 then
        begin
          Includeed.Add( sFile );
          SL.Text := LoadUTFFile(sFile);
          ScriptList[I] := '';
          for J := 0 to SL.Count - 1 do
          begin
            ScriptList.Insert( I + 1 + J, SL[J] );
          end;
          Inc( nCount, SL.Count );
        end;
      end
      else begin
        ShowMessage( Format('[脚本错误]"%s"包含文件"%s"未找到', [sScritpFileName, sFile]) );
      end;
    end;
    Inc( I );
  end;     
  SL.Free;
  Includeed.Free;
end;

initialization
  LoadLuaLib( 'lua5.1.dll' );

finalization
  FreeLuaLib();
  
end.
