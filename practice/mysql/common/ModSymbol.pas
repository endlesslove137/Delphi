unit ModSymbol;

interface

uses
  Windows, SysUtils, Classes, LinkMapAnalyzer, ImageHlp, SortList;

type
  TCustomSymbolTable = class
  private
    m_hModule: HMODULE;
    m_dwBaseAddress: DWord;
    m_dwModuleSize: DWord;
    m_sModulePath: string;
    function LoadSymbolTable(): Boolean; virtual;abstract;
    function GetModuleName: string;
  public
    constructor Create(hMod: HMODULE; sModulePath: string; dwBaseAddress: DWord;
      dwModuleSize: DWord);virtual;
    destructor Destroy();override;
    function GetSymbolAtAddress(dwAddress: DWord; var Symbol: TSYMBOLDATA): Boolean;virtual;

    property ModuleHandle: HMODULE read m_hModule;
    property ModulePath: string read m_sModulePath;
    property ModuleName: string read GetModuleName;
    property BaseAddress: DWord read m_dwBaseAddress;
    property ModuleSize: DWord read m_dwModuleSize;
  end;

(*  Link Map Analyzer   *)
  TLinkMapSymbolTable = class(TCustomSymbolTable)
  private
    m_hMapAnalyzer: TLinkMapAnalyzer;
    class function LinkMapFileExists(sModuleFile: string): string;
    function LoadSymbolTable(): Boolean;override;
  public
    constructor Create(hMod: HMODULE; sModulePath: string; dwBaseAddress: DWord;
      dwModuleSize: DWord);override;
    destructor Destroy();override;     
    function GetSymbolAtAddress(dwAddress: DWord; var Symbol: TSYMBOLDATA): Boolean;override;

    class function GetLinkMapFileType(sMapFile: string): TMapAnalyzerType; static;
  end;

(*  DLL Export Table Analyzer   *)
  
  PDllExportFunction = ^TDllExportFunction;
  TDllExportFunction = record
	  dwAddressStart: DWord;
	  dwAddressEnd: DWord;
	  sName: array [0..63] of Char;
  end;

  TExportSymbolTable = class(TCustomSymbolTable)
  private
    m_FunctionTable: array of TDllExportFunction;
    m_FunctionList: TSortList;
    function LoadSymbolTable(): Boolean;override;
    procedure CalcFunctionAddressEnd();
  public
    constructor Create(hMod: HMODULE; sModulePath: string; dwBaseAddress: DWord;
      dwModuleSize: DWord);override;
    destructor Destroy();override;    
    function GetSymbolAtAddress(dwAddress: DWord; var Symbol: TSYMBOLDATA): Boolean;override;
  end;


function CreateSymbolTable(hMod: HMODULE; sModulePath: string; dwBaseAddress: DWord;
  dwModuleSize: DWord): TCustomSymbolTable;
  
implementation

uses FuncUtil;

function CreateSymbolTable(hMod: HMODULE; sModulePath: string; dwBaseAddress: DWord;
  dwModuleSize: DWord): TCustomSymbolTable;
begin
  Result := TLinkMapSymbolTable.Create( hMod, sModulePath, dwBaseAddress, dwModuleSize );
  if Result.LoadSymbolTable() then Exit;
  Result.Free;

  Result := TExportSymbolTable.Create( hMod, sModulePath, dwBaseAddress, dwModuleSize );   
  if Result.LoadSymbolTable() then Exit;
  Result.Free;

  Result := nil;
end;

{ TCustomSymbolTable }

constructor TCustomSymbolTable.Create(hMod: HMODULE; sModulePath: string;
  dwBaseAddress, dwModuleSize: DWord);
begin
  m_hModule := hMod;
  m_sModulePath := sModulePath;
  m_dwBaseAddress := dwBaseAddress;
  m_dwModuleSize := dwModuleSize;
end;

destructor TCustomSymbolTable.Destroy;
begin

  inherited;
end;

function TCustomSymbolTable.GetModuleName: string;
begin
  Result := GetRealFileName(m_sModulePath);
end;

function TCustomSymbolTable.GetSymbolAtAddress(dwAddress: DWord;
  var Symbol: TSYMBOLDATA): Boolean;
begin
  Result := False;
end;

{ TLinkMapSymbolTable }

constructor TLinkMapSymbolTable.Create(hMod: HMODULE; sModulePath: string;
  dwBaseAddress, dwModuleSize: DWord);
begin
  inherited;
  m_hMapAnalyzer := 0;
end;

destructor TLinkMapSymbolTable.Destroy;
begin
  if m_hMapAnalyzer <> 0 then
    FreeLinkMapAnalyzer(m_hMapAnalyzer);
  inherited;
end;

class function TLinkMapSymbolTable.GetLinkMapFileType(sMapFile: string):TMapAnalyzerType;
var
  sIdent: array [0..3] of Char;
begin
  Result := maUnTyped;
  FillChar( sIdent, sizeof(sIdent), 0 );
  with TFileStream.Create(sMapFile, fmShareDenyNone) do
  begin
    if Size > 0 then
    begin
      Position := 0;
      Read( sIdent[0], sizeof(sIdent) );
      if sIdent[0] = ' ' then
        Result := maVCMap
      else if (sIdent[0] = #13) and (sIdent[1] = #10) then
        Result := maDelphiMap;
    end;
    Free;
  end;
end;

function TLinkMapSymbolTable.GetSymbolAtAddress(dwAddress: DWord;
  var Symbol: TSYMBOLDATA): Boolean;
begin
  Result := LinkMapAnalyzerGetSymbolAtAddress( m_hMapAnalyzer, dwAddress, Symbol );
end;

class function TLinkMapSymbolTable.LinkMapFileExists(sModuleFile: string): string;
var
  sMapName, sFile: string;
  I: Integer;
begin
  Result := '';
  sMapName := ExtRactFileName(sModuleFile);
  for I := Length(sMapName) downto 1 do
  begin
    if sMapName[I] = '.' then
    begin
      sMapName := Copy(sMapName, 1, I - 1);
      break;
    end;
  end;
  sMapName := sMapName + '.map';


  sFile := ExtRactFilePath(sModuleFile) + sMapName;
  if FileExists( sFile ) then
  begin
    Result := sFile;
    Exit;
  end;

{  sFile := ExtRactFilePath(m_Process.ExeFileName) + sMapName;
  if FileExists( sFile ) then
  begin
    Result := sFile;
    Exit;
  end;  }
end;

function TLinkMapSymbolTable.LoadSymbolTable: Boolean;
var
  MapType: TMapAnalyzerType;
  sMapFile: string;
begin
  Result := False;
  sMapFile := LinkMapFileExists( m_sModulePath );
  if sMapFile <> '' then
  begin
    MapType := GetLinkMapFileType( sMapFile );
    m_hMapAnalyzer := CreateLinkMapAnalyzer( MapType );
    if (m_hMapAnalyzer <> 0) and LinkMapAnalyzerLoadMap( m_hMapAnalyzer, PChar(sMapFile) ) then
    begin
      LinkMapAnalyzerSetModuleBaseAddress( m_hMapAnalyzer, m_dwBaseAddress );
      Result := True;
    end;
  end;
end;

{ TExportSymbolTable }

function FunctionAddressCompare(const pFunction1, pFunction2: Pointer): Integer;
begin
  if PDllExportFunction(pFunction1)^.dwAddressStart < PDllExportFunction(pFunction2)^.dwAddressStart then
    Result := -1
  else if PDllExportFunction(pFunction1)^.dwAddressStart > PDllExportFunction(pFunction2)^.dwAddressStart then
    Result := 1
  else Result := 0;
end;   

function FunctionAddressSearch(const pFunction, dwAddress: Pointer): Integer;
begin
  if DWord(dwAddress) > PDllExportFunction(pFunction)^.dwAddressEnd  then
    Result := -1
  else if DWord(dwAddress) < PDllExportFunction(pFunction)^.dwAddressStart then
    Result := 1
  else Result := 0;
end;

procedure TExportSymbolTable.CalcFunctionAddressEnd;
var
  I: Integer;
  pFunction, pPrevFunction: PDllExportFunction;
begin
  if m_FunctionList.Count <= 0 then Exit;
  
  pPrevFunction := m_FunctionList.List[0];
  for I := 1 to m_FunctionList.Count - 1 do
  begin
    pFunction := m_FunctionList.List[I];
    pPrevFunction^.dwAddressEnd := pFunction^.dwAddressStart - 1;
    pPrevFunction := pFunction;
  end;
  pPrevFunction^.dwAddressEnd := pPrevFunction^.dwAddressStart + $FF; 
end;

constructor TExportSymbolTable.Create(hMod: HMODULE; sModulePath: string;
  dwBaseAddress, dwModuleSize: DWord);
begin
  inherited;
  m_FunctionList := TSortList.Create;
  m_FunctionList.OnCompare := FunctionAddressCompare;
  m_FunctionList.Sorted := True;
end;

destructor TExportSymbolTable.Destroy;
begin
  m_FunctionList.Free;
  SetLength(m_FunctionTable, 0);
  inherited;
end;

function TExportSymbolTable.GetSymbolAtAddress(dwAddress: DWord;
  var Symbol: TSYMBOLDATA): Boolean;
var
  pExportFunction: PDllExportFunction;
begin
  pExportFunction := m_FunctionList.SearchItem(Pointer(dwAddress), FunctionAddressSearch);
  if pExportFunction <> nil then
  begin
    Symbol.dwAddressStart := pExportFunction^.dwAddressStart;
    Symbol.dwAddressEnd := pExportFunction^.dwAddressEnd;
    Symbol.lpName := pExportFunction.sName;
    Symbol.lpSourceName := nil;
    Symbol.dwLineNumber := InvalidLineNumber;
    Symbol.dwOffsetLineNumber := 0;
    Result := True;
  end
  else Result := False;
end;

function TExportSymbolTable.LoadSymbolTable: Boolean;
var
  hFile: THANDLE;
  hFileMapping: THANDLE;
  lpFileBase: Pointer;
  pImg_DOS_Header: PImageDosHeader;
  pImg_NT_Header: PImageNtHeaders;
  pImg_Export_Dir: PImageExportDirectory;
  pdwNames, pdwFunctions: PDWORD;
  szFunc: PChar;
  i: Integer;
  pExportFuncion: PDllExportFunction;
begin
  Result := False;
  hFile := CreateFile(PChar(m_sModulePath), GENERIC_READ, FILE_SHARE_READ, nil,
    OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if(hFile = INVALID_HANDLE_VALUE)then Exit;
  hFileMapping := CreateFileMapping(hFile, nil, PAGE_READONLY, 0, 0, nil);
  if hFileMapping = 0 then
  begin
    CloseHandle(hFile);
    Exit;
  end;


  lpFileBase :=MapViewOfFile(hFileMapping, FILE_MAP_READ, 0, 0, 0);
  if lpFileBase = nil then
  begin   
    CloseHandle(hFileMapping);
    CloseHandle(hFile);
    Exit;
  end;   
    
  pImg_DOS_Header := PImageDosHeader(lpFileBase);
  pImg_NT_Header := PImageNtHeaders(
    Integer(pImg_DOS_Header) + Integer(pImg_DOS_Header._lfanew));

  if IsBadReadPtr(pImg_NT_Header, SizeOf(IMAGE_NT_HEADERS)) or
    (pImg_NT_Header.Signature <> IMAGE_NT_SIGNATURE)then
  begin
    UnmapViewOfFile(lpFileBase);
    CloseHandle(hFileMapping);
    CloseHandle(hFile);
    Exit;
  end;   

  pImg_Export_Dir := PImageExportDirectory(
    pImg_NT_Header.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].
    VirtualAddress);
  if not Assigned(pImg_Export_Dir) then
  begin
    UnmapViewOfFile(lpFileBase);
    CloseHandle(hFileMapping);
    CloseHandle(hFile);
    Exit;
  end;   

  pImg_Export_Dir := PImageExportDirectory(
    ImageRvaToVa(pImg_NT_Header,   pImg_DOS_Header, DWORD(pImg_Export_Dir),
    PImageSectionHeader(Pointer(nil)^)));

  pdwNames := Pointer(pImg_Export_Dir.AddressOfNames);
  pdwNames := Pointer(ImageRvaToVa(pImg_NT_Header, pImg_DOS_Header,
    DWORD(pdwNames), PImageSectionHeader(Pointer(nil)^)));

  pdwFunctions := Pointer(pImg_Export_Dir.AddressOfFunctions);
  pdwFunctions := Pointer(ImageRvaToVa(pImg_NT_Header, pImg_DOS_Header,
    DWORD(pdwFunctions), PImageSectionHeader(Pointer(nil)^)));

  if not Assigned(pdwNames) or not Assigned(pdwFunctions) then
  begin
    UnmapViewOfFile(lpFileBase);
    CloseHandle(hFileMapping);
    CloseHandle(hFile);
    Exit;
  end;

  SetLength(m_FunctionTable, pImg_Export_Dir.NumberOfNames);
  pExportFuncion := @m_FunctionTable[0];
  m_FunctionList.Trunc(0);
  
  for i := 0 to pImg_Export_Dir.NumberOfNames - 1 do
  begin
    szFunc := PChar(ImageRvaToVa(pImg_NT_Header, pImg_DOS_Header,
      pdwNames^,   PImageSectionHeader(Pointer(nil)^)));

    if szFunc <> nil then
    begin
      pExportFuncion^.dwAddressStart := m_dwBaseAddress + pdwFunctions^;
      SysUtils.StrLCopy(@pExportFuncion^.sName[0], szFunc, sizeof(pExportFuncion^.sName)-1);
      pExportFuncion^.sName[High(pExportFuncion^.sName)] := #0;
      pExportFuncion^.dwAddressEnd := 0;
      m_FunctionList.Add(pExportFuncion);    
      Inc(pExportFuncion);
    end;
    
    Inc(pdwNames);
    Inc(pdwFunctions);
  end;
  UnmapViewOfFile(lpFileBase);
  CloseHandle(hFileMapping);
  CloseHandle(hFile);

  CalcFunctionAddressEnd();
  Result := m_FunctionList.Count > 0;
end;

end.
