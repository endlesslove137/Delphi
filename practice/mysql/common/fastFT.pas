unit fastFT;

interface

uses
  SysUtils;

const
  FastFTLib = 'fastFT.dll';

type
  TFastFilter = Pointer;

//MBCSDef
function CreateMBCSFilter(lpReserved: Pointer): TFastFilter; stdcall;
procedure FreeMBCSFilter(Filter: TFastFilter); stdcall;
function MemoryUsageOfMBCSFilter(const Filter: TFastFilter): Cardinal; stdcall;
function LoadMBCSFilterWords(Filter: TFastFilter; const lpFileName: PAnsiChar): Integer; stdcall;
function SaveMBCSFilterWords(Filter: TFastFilter; const lpFileName: PAnsiChar): Integer; stdcall;
function MatchMBCSFilterWord(Filter: TFastFilter; const lpInput: PAnsiChar; var (* out *)WordLen: Integer): PAnsiChar; stdcall;
function AddMBCSFilterStrToTable(Filter: TFastFilter; const lpWord: PAnsiChar): LongBool; stdcall;

//UCSDef
function CreateUCSFilter(lpReserved: Pointer): TFastFilter; stdcall;
procedure FreeUCSFilter(Filter: TFastFilter); stdcall;
function MemoryUsageOfUCSFilter(const Filter: TFastFilter): Cardinal; stdcall;
function LoadUCSFilterWords(Filter: TFastFilter; const lpFileName: PWideChar): Integer; stdcall;
function SaveUCSFilterWords(Filter: TFastFilter; const lpFileName: PWideChar): Integer; stdcall;
function MatchUCSFilterWord(Filter: TFastFilter; const lpInput: PWideChar; var (* out *)WordLen: Integer): PWideChar; stdcall;
function AddUCSFilterStrToTable(Filter: TFastFilter; const lpWord: PWideChar): LongBool; stdcall;

implementation

//MBCSDef
function CreateMBCSFilter(lpReserved: Pointer): TFastFilter; stdcall; external FastFTLib;
procedure FreeMBCSFilter(Filter: TFastFilter); stdcall; external FastFTLib;
function MemoryUsageOfMBCSFilter(const Filter: TFastFilter): Cardinal; stdcall; external FastFTLib;
function LoadMBCSFilterWords(Filter: TFastFilter; const lpFileName: PAnsiChar): Integer; stdcall; external FastFTLib;
function SaveMBCSFilterWords(Filter: TFastFilter; const lpFileName: PAnsiChar): Integer; stdcall; external FastFTLib;
function MatchMBCSFilterWord(Filter: TFastFilter; const lpInput: PAnsiChar; var (* out *)WordLen: Integer): PAnsiChar; stdcall; external FastFTLib;
function AddMBCSFilterStrToTable(Filter: TFastFilter; const lpWord: PAnsiChar): LongBool; stdcall; external FastFTLib;

//UCSDef
function CreateUCSFilter(lpReserved: Pointer): TFastFilter; stdcall; external FastFTLib;
procedure FreeUCSFilter(Filter: TFastFilter); stdcall; external FastFTLib;
function MemoryUsageOfUCSFilter(const Filter: TFastFilter): Cardinal; stdcall; external FastFTLib;
function LoadUCSFilterWords(Filter: TFastFilter; const lpFileName: PWideChar): Integer; stdcall; external FastFTLib;
function SaveUCSFilterWords(Filter: TFastFilter; const lpFileName: PWideChar): Integer; stdcall; external FastFTLib;
function MatchUCSFilterWord(Filter: TFastFilter; const lpInput: PWideChar; var (* out *)WordLen: Integer): PWideChar; stdcall; external FastFTLib;
function AddUCSFilterStrToTable(Filter: TFastFilter; const lpWord: PWideChar): LongBool; stdcall; external FastFTLib;

end.
