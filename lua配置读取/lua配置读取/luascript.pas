unit luascript;

interface

uses Windows, SysUtils, Classes, lua, UnitLangPackage;

type
  TBaseLuaScript = class(TObject)
    m_Lua           : Lua_State;
    m_nLastError    : Integer;
    m_sLastErrorDesc: string;
    m_sLastFunction : string;
    m_SourceCodes: TStrings;
    m_TableStacks: TStrings;
    m_nOnErrorFunIndex: Integer;
  private
    procedure CreateLuaEngine();
    function GetAvailableMemorySize: Integer;
  protected
    procedure RaiseLuaError(nErr: Integer);
    function pcall(const nArgs, nResults, nErrorFunc: Integer): Integer;virtual;
    procedure ShowScriptError(sError: string);virtual;
    procedure SetScript(const s: string);
  public
    constructor Create();virtual;
    destructor Destroy();override;
    procedure SetScriptFile(const sFileName: string);
    function OpenGlobalTable(const sTableName: PChar): Boolean;
    function OpenFieldTable(const sTableName: PChar): Boolean;
    function GetFieldNumber(sFieldName: PChar; var IsValid: Boolean): Double;
    function GetFieldInteger(sFieldName: PChar; var IsValid: Boolean): Integer;
    function GetFieldString(sFieldName: PChar; var IsValid: Boolean): string;
    function GetFieldBoolean(sFieldName: PChar; var IsValid: Boolean): Boolean;
    function GetTableLength(): Integer;
    function FeildTableExists(const sTableName: PChar): Boolean;
    function EnumTableFirst(): Boolean;
    function EnumTableNext(): Boolean;
    procedure EndTableEnum();
    procedure CloseTable();
    property MemoeryAvailable: Integer read getAvailableMemorySize;
  end;

procedure PerProcessLuaScript(sScritpFileName, sPatch: string; ScriptList: TStrings);
function OnLuaError(L: lua_State): Integer; cdecl;

var
  Lang: TLanguagePackage;  //语言包全局对象
  iFileCount: Integer;

implementation

var
  g_CallingLuaScript: TBaseLuaScript = nil;

{ TBaseLuaScript }

procedure LoadTextFile(utf8Strings: TStrings; const FileName: string);
var
  fs: TFileStream;
  b1, b2, b3, b4: Byte;
  bigEndian: Boolean;
  P, Start: PWideChar;
  Value: string;
  S: WideString;
  i, Size: Integer;
  w: Word;

  procedure LoadAnsiFile();
  var
    i: Integer;
    tmpStrings: TStrings;
  begin
    tmpStrings := TStringList.Create;
    try
      //utf8Strings可能是有序的，直接 utf8Strings[i] := xxx 赋值会报异常
      tmpStrings.LoadFromStream(fs);
      for i := 0 to tmpStrings.Count - 1 do
      begin
        tmpStrings[i] := AnsiToUtf8(tmpStrings[i]);
      end;
      utf8Strings.AddStrings(tmpStrings);
    finally
      tmpStrings.Free;
    end;
  end;
begin
  {BOMs 文件头:
   00 00 FE FF    = UTF-32, big-endian
   FF FE 00 00    = UTF-32, little-endian 
   EF BB BF       = UTF-8, 
   FE FF          = UTF-16, big-endian
   FF FE          = UTF-16, little-endian }
  if utf8Strings = nil then Exit;

  utf8Strings.Clear;
  fs := TFileStream.Create(FileName, fmOpenRead);
  try
    if fs.Size < 2 then
    begin
      LoadAnsiFile();
      Exit;
    end;

    fs.ReadBuffer(b1, SizeOf(b1));
    fs.ReadBuffer(b2, SizeOf(b2));
    if ((b1 = $FE) and (b2 = $FF)) or ((b1 = $FF) and (b2 = $FE)) then  //Unicode
    begin
      bigEndian := b1 = $FE;
      Size := fs.Size - fs.Position;
      if Size mod 2 <> 0 then
      begin
        raise Exception.CreateFmt('LoadTextFile(%s):文件不完整！', [FileName]);
      end;
      SetString(Value, nil, Size);
      fs.ReadBuffer(Pointer(Value)^, Size);
      P := Pointer(Value);
      if P <> nil then
      begin
        while P^ <> #0 do
        begin
          Start := P;
          if bigEndian then
          begin
            while not ((Byte(P^) = 0) and (Char(Word(P^) shr 8) in [#0, #10, #13] )) do Inc(P);
          end
          else
          begin
            while not ((P^ <= #$FF) and (Char(P^) in [#0, #10, #13] )) do Inc(P);
          end;
          SetString(S, Start, P - Start);
          if bigEndian then
          begin
            for i := 1 to Length(S) do
            begin
              w := Word(S[i]);
              w := (w shl 8) or (w shr 8);
              S[i] := WideChar(w);
            end;
          end;
          utf8Strings.Add(UTF8Encode(S));

          if bigEndian then
          begin
            if P^ = #$0D00 then Inc(P);
            if P^ = #$0A00 then Inc(P);
          end
          else
          begin
            if P^ = #13 then Inc(P);
            if P^ = #10 then Inc(P);
          end;
        end;
      end;

      Exit;
    end;

    if fs.Size < 3 then
    begin
      fs.Position := 0;
      LoadAnsiFile();
      Exit;
    end;

    fs.ReadBuffer(b3, SizeOf(b3));
    if (b1 = $EF) and (b2 = $BB) and (b3 = $BF) then  //UTF8
    begin
      utf8Strings.LoadFromStream(fs);
      Exit;
    end;

    if fs.Size < 4 then
    begin
      fs.Position := 0;
      LoadAnsiFile();
      Exit;
    end;

     {00 00 FE FF    =  UTF-32, big-endian
    FF FE 00 00    = UTF-32, little-endian}
    fs.ReadBuffer(b4, SizeOf(b4));
    if ((b1 = $00) and (b2 = $00) and (b3 = $FE) and (b4= $FF)) or
       ((b1 = $FF) and (b2 = $FE) and (b3 = $00) and (b4= $00)) then  
    begin
      //bigEndian := b1 = $00;
      raise Exception.CreateFmt('LoadTextFile(%s):不支持UTF-32文件！', [FileName]);
      Exit;
    end;

    //当成Ansi文件
    fs.Position := 0;
    LoadAnsiFile();
  finally
    fs.Free;
  end;
end;

procedure PerProcessLuaScript(sScritpFileName, sPatch: string; ScriptList: TStrings);
const
  sIncludeIdent = '--#include ';
var
  I, nCount, J, nPos: Integer;
  sLine, sFile, sInclude,sFilePath: string;
  SL: TStrings;
  boFound: Boolean;
begin
  SL := TStringList.Create;
  nCount := ScriptList.Count;
  I := 0;
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
        sFile := sPatch + sInclude;
        boFound := FileExists(  sFile );
      end;
      if not boFound then
      begin
        sFile := sFilePath + sInclude;
        boFound := FileExists(  sFile );
      end;
      if not boFound then
      begin
        sFile := 'F:\WorkSVN\idgp\AnHei\!SC\Server\'+ sInclude;
        boFound := FileExists(  sFile );
      end;
      if boFound then
      begin
        Inc(iFileCount);
        sFile := ExpandFileName( sFile );
        sFilePath := ExtractFilePath(sFile);
        LoadTextFile(SL, sFile);
        ScriptList[I] := '';
        for J := 0 to SL.Count - 1 do
        begin
          ScriptList.Insert( I + 1 + J, SL[J] );
        end;
        Inc( nCount, SL.Count );
      end
      else begin
        //MainOutException( Format('[脚本错误]"%s"包含文件"%s"未找到', [sScritpFileName, sFile]) );
      end;
    end;
    Inc( I );
  end;     
  SL.Free;
end;

function TraceBack(L: lua_State; luaScript: TBaseLuaScript): string;
var
  nLevel: Integer;
  DebugInfo: lua_Debug;
  sCode, sFunName: string;
begin
  Result := '';
  nLevel := 1;
  while True do
  begin
    if lua_getstack(L, nLevel, DebugInfo) = 0 then Break;
    if lua_getinfo(L, 'nSl', DebugInfo) = 0 then Break;
    sCode := '';
    if (luaScript <> nil) and (DebugInfo.currentline > 0)
      and (DebugInfo.currentline <= luaScript.m_SourceCodes.Count) then
    begin
      sCode := luaScript.m_SourceCodes[DebugInfo.currentline - 1];
    end;
    sFunName := DebugInfo.name;
    if sFunName = '' then sFunName := '<unknow function>'; 
    Result := Result + Format('%20s %05d %s'#13#10,
      [sFunName, DebugInfo.currentline, sCode]);
    Inc(nLevel);
  end;
end;

function OnLuaError(L: lua_State): Integer; cdecl;
var
  sError: string;
  //NPC: TNormNpc;
  Script: TBaseLuaScript;
begin
  sError := lua_tostring(L, 1);
//  Script := nil;
//  lua_getglobal(L, 'g_thisNPC');
//  if lua_islightuserdata(L, -1) then
//  begin
//    NPC := TNormNpc(lua_touserdata(L, -1));
//    if (NPC <> nil) and (NPC is TNormNpc) then
//    begin
//      Script := NPC.m_LuaScript;
//    end;
//  end;
  Script := g_CallingLuaScript;
  sError := sError + #13#10 + TraceBack(L, Script);
  lua_pushstring(L, PChar(sError));
  Result := 1;
end;

function TBaseLuaScript.GetFieldBoolean(sFieldName: PChar;
  var IsValid: Boolean): Boolean;
var
  boInvalidValue: Boolean;
begin
  Result := False;

  if sFieldName <> nil then
  begin
    lua_getfield(m_Lua, -1, sFieldName );
  end;

  boInvalidValue := False;
  if lua_isboolean( m_Lua, -1 ) then
  begin
    Result := lua_toboolean(m_Lua, -1);
  end
  else boInvalidValue := True;

  if boInvalidValue then
  begin
    IsValid := False;
    ShowScriptError('没有为' + sFieldName + '配置有效的布尔值');
  end;

  if sFieldName <> nil then
  begin
    lua_pop( m_Lua, 1 );
  end;
end;

function TBaseLuaScript.GetFieldInteger(sFieldName: PChar; var IsValid: Boolean): Integer;
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
    ShowScriptError('没有为' + sFieldName + '配置有效的整数值');
  end;

  if sFieldName <> nil then
  begin
    lua_pop( m_Lua, 1 );
  end;
end;

function TBaseLuaScript.GetFieldNumber(sFieldName: PChar; var IsValid: Boolean): Double;
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

function TBaseLuaScript.GetFieldString(sFieldName: PChar; var IsValid: Boolean): string;
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
    ShowScriptError('没有为' + sFieldName + '配置有效的字符串值');
  end;

  if sFieldName <> nil then
  begin
    lua_pop( m_Lua, 1 );
  end;
end;

function TBaseLuaScript.GetTableLength(): Integer;
begin
  result := lua_objlen(m_Lua, -1);
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

function GetGlobalTable(L: lua_State; tableName: PChar): Boolean;
begin
  lua_getglobal(L, tableName );
  Result := lua_istable( L, -1 );
  if not Result then lua_pop( L, 1 );
end;

function GetTableLength(L: lua_State): Integer;
begin
  result := lua_objlen(L, -1);
end;

function TBaseLuaScript.EnumTableFirst(): Boolean;
begin
  lua_pushnil(m_Lua);  (* first key *)
  Result := lua_next(m_Lua, -2) <> 0;
  if Result then
  begin
    m_TableStacks.Add('[1]');
  end;
end;

function TBaseLuaScript.EnumTableNext(): Boolean;
var
  s: string;
  nIndex: Integer;
begin
  lua_pop(m_Lua, 1);  (* remove value, reserve key for next iterate *)
  Result := lua_next(m_Lua, -2) <> 0;
  if Result then
  begin
    s := m_TableStacks[m_TableStacks.Count - 1];
    s := Copy(S, 2, Length(S) - 2);
    nIndex := StrToInt(s);
    s := '[' + IntToStr(nIndex + 1) + ']';
    m_TableStacks[m_TableStacks.Count - 1] := s;
  end
  else begin
    m_TableStacks.Delete(m_TableStacks.Count - 1);
  end;
end;

function TBaseLuaScript.FeildTableExists(const sTableName: PChar): Boolean;
begin
  lua_getfield(m_Lua, -1, sTableName );
  Result := lua_istable( m_Lua, -1 );
  lua_pop( m_Lua, 1 );
end;

procedure TBaseLuaScript.EndTableEnum();
begin                        
  lua_pop(m_Lua, 2);  (* remove value and key *)
  m_TableStacks.Delete(m_TableStacks.Count - 1);
end;

constructor TBaseLuaScript.Create;
begin
  m_SourceCodes := TStringList.Create;
  m_TableStacks := TStringList.Create;
  m_TableStacks.Delimiter := '.';
end;

procedure TBaseLuaScript.CreateLuaEngine;
begin
  m_Lua := lua.luaL_newstate();// lua_newstate( lua_allocater, nil );
  RaiseLuaError( lua_cpcall( m_Lua, luaopen_base, nil ) );
  RaiseLuaError( lua_cpcall( m_Lua, luaopen_string, nil ) );
  RaiseLuaError( lua_cpcall( m_Lua, luaopen_math, nil ) );
  RaiseLuaError( lua_cpcall( m_Lua, luaopen_table, nil ) );
  Lang.RegisteToScript(m_Lua);
end;

destructor TBaseLuaScript.Destroy;
begin
  SetScript('');
  m_SourceCodes.Free;
  m_TableStacks.Free;
  inherited;
end;

function TBaseLuaScript.GetAvailableMemorySize: Integer;
begin
  Result := ((lua_gc( m_Lua, LUA_GCCOUNT, 0 ) * 1024) or lua_gc( m_Lua, LUA_GCCOUNTB, 0 ));
end;

function TBaseLuaScript.pcall(const nArgs, nResults,
  nErrorFunc: Integer): Integer;
var
  nTop, nTop2: Integer;
  sError: string;
begin
  nTop := lua_gettop( m_Lua ) - nArgs - 1; //-1 for function name
  {$IFDEF ShowScriptStack}
  g_CallingLuaScript := Self;
  Result := lua_pcall( m_Lua, nArgs, nResults, m_nOnErrorFunIndex );
  {$ELSE}
  Result := lua_pcall( m_Lua, nArgs, nResults, 0 );
  {$ENDIF}
  nTop2 := lua_gettop( m_Lua ) - nResults;

  //检查错误
  if Result <> 0 then
  begin
    RaiseLuaError( Result );
  end;
  //检查堆栈
  if (nResults <> LUA_MULTRET) and (nTop2 <> nTop) then
  begin
    //'函数:%s,调用前的栈顶为:%d,调用后的栈顶为:%d,堆栈差值为:%d'
    sError :=  Format( '函数:%s,调用前的栈顶为:%d,调用后的栈顶为:%d,堆栈差值为:%d', [m_sLastFunction, nTop, nTop2, nTop2 - nTop] );
    ShowScriptError( Utf8ToAnsi(sError) );
  end;
end;

procedure TBaseLuaScript.RaiseLuaError(nErr: Integer);
begin
  if nErr <> 0 then
  begin
    m_nLastError := nErr;
    if lua_gettop( m_Lua ) > 0 then
    begin
      m_sLastErrorDesc := lua_tostring( m_Lua, -1 );
      lua_pop( m_Lua, 1 );
    end
    else m_sLastErrorDesc := 'falt system error: lua_gettop <= 0';
    if m_sLastErrorDesc = '' then m_sLastErrorDesc := '未指定的错误';  //'未指定的错误。
    //函数%s，错误内容：%s
    ShowScriptError( Utf8ToAnsi(Format('函数%s，错误内容：%s', [m_sLastFunction, m_sLastErrorDesc])) );
  end;
end;

procedure TBaseLuaScript.SetScript(const s: string);
var
  dwOldCW: DWord;
begin
  if m_Lua <> nil then
  begin
    try
      lua_close( m_Lua );
    except
      on E: Exception do
      begin
        //MainOutException('TBaseLuaScript.SetScript(' + E.Message + ')');
      end;
    end;
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
    RaiseLuaError( m_nLastError );
    pcall( 0, LUA_MULTRET, 0 );
    lua_pushcfunction(m_Lua, OnLuaError);
    m_nOnErrorFunIndex := lua_gettop(m_Lua);
    //拷贝地图NPC(TNormNpc.Assign)时,只是调用TBaseLuaScript.NewInstance，并没有调用Create
    if m_SourceCodes = nil then m_SourceCodes := TStringList.Create;
    m_SourceCodes.Text := s;
  end;
end;

procedure TBaseLuaScript.SetScriptFile(const sFileName: string);
var
  SL: TStrings;
begin
  SL := TStringList.Create;
  LoadTextFile(SL, sFileName);
  PerProcessLuaScript(sFileName, ExtractFilePath(sFileName), SL);
  try
    SL.Add('FileCount='+IntToStr(iFileCount));
    SL.SaveToFile('d:\StdItems.txt');
    SetScript(SL.Text);
  finally
    SL.Free;
  end;
end;

function TBaseLuaScript.OpenGlobalTable(const sTableName: PChar): Boolean;
begin
  lua_getglobal(m_Lua, sTableName );
  Result := lua_istable( m_Lua, -1 );
  if not Result then
  begin
    lua_pop( m_Lua, 1 );
    ShowScriptError('没有找到配置表“' + sTableName + '”');
  end
  else begin
    m_TableStacks.Add(sTableName);
  end;
end;

function TBaseLuaScript.OpenFieldTable(const sTableName: PChar): Boolean;
begin
  lua_getfield(m_Lua, -1, sTableName );
  Result := lua_istable( m_Lua, -1 );
  if not Result then
  begin
    lua_pop( m_Lua, 1 );
    ShowScriptError('没有找到配置表“' + sTableName + '”');
  end
  else begin
    m_TableStacks.Add(sTableName);
  end;
end;

procedure TBaseLuaScript.CloseTable();
begin
  if lua_gettop(m_Lua) > 0 then
  begin
    lua_pop(m_Lua, 1);
    m_TableStacks.Delete(m_TableStacks.Count - 1);
  end;
end;

procedure TBaseLuaScript.ShowScriptError(sError: string);
begin
  //输出脚本错误
end;

initialization
  LoadLuaLib( 'lua5.1.dll' );

finalization
  FreeLuaLib();
  
end.
