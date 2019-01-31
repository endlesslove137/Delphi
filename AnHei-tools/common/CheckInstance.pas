unit CheckInstance;

interface

uses
  Windows, SysUtils, Tlhelp32;

function IsProcessLaunched(): Boolean;

implementation

function CheckMouleInProcess(const FileName: string; PID: DWord): Boolean;
var
  hSnap: THandle;
  Module32: TModuleEntry32;
begin
  Result := False;
  hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, PID);
  if hSnap = INVALID_HANDLE_VALUE then Exit;
  try
    FillChar(Module32, sizeof(Module32), 0);
    Module32.dwSize := sizeof(Module32);
    if Module32First( hSnap, Module32 ) then
    begin
      repeat
        if StrLIComp( Module32.szExePath, PChar(FileName), Length(FileName) ) = 0 then
        begin
          Result := True;
          break;
        end;
      until not Module32Next( hSnap, Module32 );
    end;
  finally
    CloseHandle( hSnap );
  end;
end;

function GetAnotherIntance(const FileName: string; var PID: DWord): Boolean;
var
  CurrentPID: DWord;
  hSnap, hProcess: THandle;
  Process32: TProcessEntry32;
  dwExitCode: DWord;
begin
  CurrentPID := GetCurrentProcessId();

  Result := False;
  hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  if hSnap = INVALID_HANDLE_VALUE then Exit;
  try
    FillChar(Process32, sizeof(Process32), 0);
    Process32.dwSize := sizeof(Process32);
    if Process32First( hSnap, Process32 ) then
    begin
      repeat     
        if CurrentPID = Process32.th32ProcessID then
          continue;
        if Process32.th32ProcessID = 0 then
          continue;
        if CheckMouleInProcess( FileName, Process32.th32ProcessID ) then
        begin
          hProcess := OpenProcess( PROCESS_QUERY_INFORMATION , False, Process32.th32ProcessID );
          if hProcess <> 0 then
          begin
            if GetExitCodeProcess( hProcess, dwExitCode ) then
            begin
              if STILL_ACTIVE = dwExitCode then
              begin
                PID := Process32.th32ProcessID;
                Result := True;
              end;
            end;
            CloseHandle( hProcess );
          end;
        end;
      until Result or not Process32Next( hSnap, Process32 );
    end;
  finally
    CloseHandle( hSnap );
  end;
end;

function IsProcessLaunched(): Boolean;
var
  FileName: string;
  PID: DWord;
begin
  Result := False;
  SetLength( FileName, 8192 );
  SetLength( FileName, GetModuleFileName( 0, @FileName[1], Length(FileName) ) );
  if (FileName <> '') then
  begin
    if GetAnotherIntance(FileName, PID) then
    begin
      Result := True;
    end
  end;
  SetLength( FileName, 0 );
end;

end.
