unit StackSymbolWalk;

interface

uses
  Windows, SysUtils, Classes, Contnrs, Tlhelp32, ModSymbol, LinkMapAnalyzer;

type
  TStackWalkRecordFrame = procedure (Sender: TObject; Address: DWord;
    Module: TCustomSymbolTable; const pSymbol: PSYMBOLDATA; UserKey: TObject) of Object;

  TStcakSymbolWalker = class
  private
    FModuleList: TObjectList;
    FOnRecordFrame: TStackWalkRecordFrame;
    procedure GotError(sDesc: string; nError: Integer);
    function GetModuleByAddress(Address: DWord): TCustomSymbolTable;
  public
    constructor Create();virtual;
    destructor Destroy();override;

    procedure StackWalk(UserKey: TObject);
    function FormatSymbolString(dwAddress: DWord; Module: TCustomSymbolTable;
      const pSymbol: PSYMBOLDATA): string;

    function RefreshModuleSymbols(): Integer;
    property Modules[Address: DWord]: TCustomSymbolTable read GetModuleByAddress;  
    property OnRecordFrame: TStackWalkRecordFrame read FOnRecordFrame write FOnRecordFrame;
  end;

implementation

{ TStcakSymbolWalker }

constructor TStcakSymbolWalker.Create;
begin
  FModuleList := TObjectList.Create;
end;

destructor TStcakSymbolWalker.Destroy;
begin
  FModuleList.Free;
  inherited;
end;

function TStcakSymbolWalker.FormatSymbolString(dwAddress: DWord;
  Module: TCustomSymbolTable; const pSymbol: PSYMBOLDATA): string;
begin
  if pSymbol <> nil then
  begin
    if pSymbol^.lpSourceName <> nil then
    begin
      if pSymbol^.dwLineNumber <> InvalidLineNumber then
      begin
        //symbol(file:NUMBER)[ + offset Line NUMBER]
        Result := pSymbol^.lpName + '(' + pSymbol^.lpSourceName + ':' + IntToStr(pSymbol^.dwLineNumber) + ')';
        if pSymbol^.dwOffsetLineNumber <> 0 then
          Result := Result + 'Line + ' + IntToStr(pSymbol^.dwOffsetLineNumber);
      end
      else begin
        //symbol(file)
        Result := pSymbol^.lpName + '(' + pSymbol^.lpSourceName + ')';
      end;
    end
    else begin       
      //module.symbol[ + offset]
      Result := Module.ModuleName + '.' + pSymbol^.lpName;
      if pSymbol^.dwAddressStart < dwAddress then
        Result := Result + ' + ' + IntToHex(dwAddress - pSymbol^.dwAddressStart, 1) + 'h';
    end;
  end
  else if Module <> nil then
  begin
    Result := Module.ModuleName + '.' + IntToHex(dwAddress, 8) + 'h';
  end
  else begin     
    Result := IntToHex(dwAddress, 8);
  end;
end;

function TStcakSymbolWalker.GetModuleByAddress(
  Address: DWord): TCustomSymbolTable;
var
  I: Integer;
  Module: TCustomSymbolTable;
begin
  Result := nil;
  for I := 0 to FModuleList.Count - 1 do
  begin
    Module := TCustomSymbolTable(FModuleList[I]);
    if (Module.BaseAddress <= Address) and (Module.BaseAddress + Module.ModuleSize > Address) then
    begin
      Result := Module;
      break;
    end;
  end;
end;

procedure TStcakSymbolWalker.GotError(sDesc: string; nError: Integer);
begin
  Raise Exception.CreateFmt('%s，%d %s', [sDesc, nError, SysErrorMessage(nError)]);
end;

function TStcakSymbolWalker.RefreshModuleSymbols: Integer;
var
  Modules, Temp: TObjectList;
  hSnap: THandle;
  mdEntry: TModuleEntry32;   
  SymbolTable: TCustomSymbolTable;
begin
  Result := 0;
  Modules := TObjectList.Create;
  try
    repeat
      hSnap := CreateToolhelp32Snapshot( TH32CS_SNAPMODULE, GetCurrentProcessId() );
      if hSnap <> INVALID_HANDLE_VALUE then
        break;
      if GetLastError() = ERROR_PARTIAL_COPY then
      begin
        Sleep( 500 );
        continue;
      end;
      GotError( '枚举模块列表失败', GetLastError() );
      Exit;
    until False;

    try
      mdEntry.dwSize := sizeof(mdEntry);
      if not Module32First( hSnap, mdEntry ) then
      begin   
        GotError( '枚举模块列表失败', GetLastError() );
      end
      else begin
        repeat               
          SymbolTable := CreateSymbolTable( mdEntry.hModule,
            StrPas(mdEntry.szExePath),
            DWord(mdEntry.modBaseAddr),
            mdEntry.modBaseSize );
          if SymbolTable = nil then
          begin
            SymbolTable := TCustomSymbolTable.Create(mdEntry.hModule,
            StrPas(mdEntry.szExePath),
            DWord(mdEntry.modBaseAddr),
            mdEntry.modBaseSize);
          end;
          Modules.Add(SymbolTable);
        until not Module32Next( hSnap, mdEntry );
      end;
    finally
      CloseHandle( hSnap );
    end;
    Temp := FModuleList;
    FModuleList := Modules;
    Modules := Temp;
  finally
    Modules.Free;
  end;
  Result := FModuleList.Count;
end;

procedure TStcakSymbolWalker.StackWalk(UserKey: TObject);
var
  dwESP, dwEBP, dwEIP: DWord;
  Module: TCustomSymbolTable;
  Symbol: TSYMBOLDATA;      
  pSymbol: PSYMBOLDATA;
begin
  if not Assigned(FOnRecordFrame) then Exit;

  asm
    MOV DWORD PTR [dwEBP], EBP
  end;

  while True do
  begin
    dwESP := dwEBP;
    if IsBadReadPtr(PDWord(dwESP), 8) then
      break;
    dwEBP := PDWord(dwESP)^;
    dwEIP := PDWord(dwESP + 4)^;
    if dwEIP = 0 then
      break;

    Module := Modules[dwEIP];
    pSymbol := nil;
    if Module <> nil then
    begin
      if Module.GetSymbolAtAddress(dwEIP, Symbol) then
      begin
        pSymbol := @Symbol;
      end;
    end;
    FOnRecordFrame(Self, dwEIP, Module, pSymbol, UserKey);
  end;
end;

end.
