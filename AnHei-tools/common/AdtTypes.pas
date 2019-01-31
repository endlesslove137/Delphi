unit AdtTypes;

interface

uses
  SysUtils, Windows, Classes, ZLib;

type
  TMemAllocater = class
    m_pDataBuffer  : Pointer;
    m_dwDataSize   : DWord;
    m_dwBufferSize : DWord;
    function AllocMemory(const dwSize: DWord): Pointer;
  public
    constructor Create(const MemorySize: DWord);
    destructor Destroy();override;
    procedure Reset();
    procedure SaveToFile(const sFileName: string);
    procedure CompressionSaveToFile(const sFileName: string);
  end;

  TADTFileHeaderIdent = record
    case Integer of
      0 : ( sIdent: array [1..4] of Char; );
      1 : (dwIdent: DWord; );
  end;

  TADTNamePtr = record
    dwNameSize  : DWord;
    procedure SetName(Allocater: TMemAllocater; const Name: string);
    case Integer of
      0: ( sName  : PChar; );
      1: (dwOffset: DWord; );
  end;

  TADTDate = record
    wYear: SmallInt;  //精度为从 BC 32767 年到 AD 32767 
    btMonth: Byte;
    btDay: Byte;
  end;

  TADTTime = record
    btHour: Byte;
    btMinute: Byte;
    btSecond: Byte;
    btMilSecond: Byte;//精度为10毫秒
  end;

function StrToADTDate(s: string): TADTDate;  
function StrToADTTime(s: string): TADTTime;

implementation

function StrToADTDate(s: string): TADTDate;
var
  wYear, wMonth, wDay: Word;
begin
  DecodeDate( StrToDate(s), wYear, wMonth, wDay );
  Result.wYear := wYear;
  Result.btMonth := wMonth;
  Result.btDay := wDay;
end;

function StrToADTTime(s: string): TADTTime;
var
  wHour, wMinute, wSecond, wMilSecond: Word;
begin
  DecodeTime( StrToTime(s), wHour, wMinute, wSecond, wMilSecond );
  Result.btHour := wHour;
  Result.btMinute := wMinute;
  Result.btSecond := wSecond;
  Result.btMilSecond := wMilSecond div 10;
end;

{ TMemAllocater }  

function TMemAllocater.AllocMemory(const dwSize: DWord): Pointer;
var
  ptr: PByte;
begin
  if m_dwDataSize + dwSize > m_dwBufferSize then
    Raise Exception.Create( 'out of memory on TMemAllocater.AllocMemory' );
  if dwSize = 0 then
  begin
    Result := nil;
    Exit;
  end;
  ptr := m_pDataBuffer;
  Inc( ptr, m_dwDataSize );
  Inc( m_dwDataSize, dwSize );
  Result := ptr;
end;

procedure TMemAllocater.CompressionSaveToFile(const sFileName: string);
var
  ReadStream: TMemoryStream;
  CompressionStream: TCompressionStream;
begin
  ReadStream := TMemoryStream.Create;
  try
    CompressionStream := TCompressionStream.Create(clMax, ReadStream);
    try
      CompressionStream.Write( m_pDataBuffer^, m_dwDataSize );
    finally
      CompressionStream.Free;
    end;
    ReadStream.SaveToFile(sFileName);
  finally
    ReadStream.Free;
  end;
end;

constructor TMemAllocater.Create(const MemorySize: DWord);
begin
  m_dwBufferSize := MemorySize;
  m_pDataBuffer := AllocMem( m_dwBufferSize );
  m_dwDataSize := 0;
end;

destructor TMemAllocater.Destroy;
begin
  if m_pDataBuffer <> nil then
    FreeMem( m_pDataBuffer );
  inherited;
end;

procedure TMemAllocater.Reset;
begin
  ZeroMemory( m_pDataBuffer, m_dwBufferSize );
  m_dwDataSize := 0;
end;

procedure TMemAllocater.SaveToFile(const sFileName: string);
begin
  with TFileStream.Create( sFileName, fmCreate ) do
  begin
    try
      Write( m_pDataBuffer^, m_dwDataSize );
    finally
      Free();
    end;
  end;
end;

{ TADTNamePtr }

procedure TADTNamePtr.SetName(Allocater: TMemAllocater; const Name: string);
begin
  dwNameSize := Length(Name) + 1;
  sName := Allocater.AllocMemory( dwNameSize );
  Move( Name[1], sName^, dwNameSize - 1 );
end;

end.
