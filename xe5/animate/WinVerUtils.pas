unit WinVerUtils;

//获取当前系统版本号

{
#===============================================================================

# Name:        WinVerUtils.pas
# Author:      Aleksander Oven
# Created:     2007-02-25
# Last Change: 2007-02-25
# Version:     1.0

# Description:

  All about the version of the Windows OS.
  Reference: http://msdn2.microsoft.com/en-us/library/ms724451.aspx

# Warnings and/or special considerations:

  Source code in this file is free for personal and commercial use.

#===============================================================================
}interface

type
  TWindowsVersion = (
    wvNotRecognized, wvWindows95, wvWindows95OSR2, wvWindows98, wvWindows98SE,
    wvWindowsME, wvWindowsNT, wvWindowsNT35, wvWindowsNT40, wvWindows2000,
    wvWindowsXP, wvWindowsXPSP2, wvWindowsXP64, wvWindowsServer2003,
    wvWindowsVista, wvWindowsServerLonghorn
  );

function GetWindowsVersion: TWindowsVersion;
function GetWindowsName: AnsiString;
function GetWindowsVersionString: AnsiString;

implementation

uses
  Windows, SysUtils;

type
  TOSVersionInfoExA = packed record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar;
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: WORD;
    wProductType: Byte;
    wReserved: Byte;
  end;

const
  cWindowsVersions: array [TWindowsVersion] of AnsiString = (
    'Not recognized', 'Windows 95', 'Windows 95 OSR 2', 'Windows 98',
    'Windows 98 Second Edition', 'Windows Millenium', 'Windows NT',
    'Windows NT 3.5', 'Windows NT 4.0', 'Windows 2000', 'Windows XP',
    'Windows XP Service Pack 2', 'Windows XP x64', 'Windows Server 2003',
    'Windows Vista', 'Windows Server Longhorn'
  );

function GetVersionExA(lpVersionInformation: Pointer): BOOL; stdcall;
  external kernel32 name 'GetVersionExA';

function GetWindowsVersion: TWindowsVersion;
const
  VER_NT_WORKSTATION = $01;
var
  VI: TOSVersionInfoA;
  VIEx: TOSVersionInfoExA;
begin
  Result := wvNotRecognized;

  VI.dwOSVersionInfoSize := SizeOf(TOSVersionInfoA);
  if not GetVersionExA(@VI) then
    Exit;

  case VI.dwPlatformID of
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        case VI.dwMinorVersion of
          0:
            begin
              if (VI.szCSDVersion[1] = 'B') then
                Result := wvWindows95OSR2
              else
                Result := wvWindows95;
            end;
          10:
            begin
              if (VI.szCSDVersion[1] = 'A') then
                Result := wvWindows98SE
              else
                Result := wvWindows98;
            end;
          90:
            begin
              if (VI.dwBuildNumber = $045A0BB8) then
                Result := wvWindowsME;
            end;
        end;
      end;
    VER_PLATFORM_WIN32_NT:
      begin
        case VI.dwMajorVersion of
          3: Result := wvWindowsNT35;
          4: Result := wvWindowsNT40;
        else
          VIEx.dwOSVersionInfoSize := SizeOf(TOSVersionInfoExA);
          if not GetVersionExA(@VIEx) then
            VIEx.dwOSVersionInfoSize := 0;

          case VI.dwMajorVersion of
            5:
              begin
                case VI.dwMinorVersion of
                  0: Result := wvWindows2000;
                  1:
                    begin
                      if (Pos('Service Pack 2', AnsiString(VI.szCSDVersion)) > 0) then
                        Result := wvWindowsXPSP2
                      else
                        Result := wvWindowsXP;
                    end;
                  2:
                    begin
                      Result := wvWindowsXP64;

                      if (VIEx.dwOSVersionInfoSize > 0) and
                        (VIEx.wProductType <> VER_NT_WORKSTATION)
                      then
                        Result := wvWindowsServer2003;
                    end
                else
                  Result := wvWindowsNT;
                end;
              end;
            6:
              begin
                Result := wvWindowsVista;

                if (VIEx.dwOSVersionInfoSize > 0) and
                  (VIEx.wProductType <> VER_NT_WORKSTATION)
                then
                  Result := wvWindowsServerLonghorn;
              end;
          end;
        end;
      end;
  end;
end;

function GetWindowsName: AnsiString;
begin
  Result := cWindowsVersions[GetWindowsVersion];
end;

function GetWindowsVersionString: AnsiString;
var
  VI: TOSVersionInfoA;
begin
  VI.dwOSVersionInfoSize := SizeOf(TOSVersionInfoA);
  if GetVersionExA(@VI) then
    with VI do
      Result := Trim(
        Format(
          '%d.%d build %d %s',
          [dwMajorVersion, dwMinorVersion, dwBuildNumber, szCSDVersion]
        )
      )
  else
    Result := '';
end;

end.


