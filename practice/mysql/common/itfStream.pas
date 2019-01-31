unit itfStream;

interface

uses
  Windows, SysUtils, Classes, ActiveX;

type
  TGlobalMemoryStream = class(TMemoryStream)
  private
    FGlobal : HGlobal;
  protected
    function Realloc(var NewCapacity: Longint): Pointer; override;
  end;

  TIMemoryStream = class(TObject, IStream)
  private
    FStream: TMemoryStream;
    FRefCount: Integer;
  public
    // IUnknown
    function QueryInterface(const IID: TGUID; out Obj): HResult;stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
                  
  protected
    //  IStream
    function Read(pv: Pointer; cb: Longint; pcbRead: PLongint): HResult;
      stdcall;
    function Write(pv: Pointer; cb: Longint; pcbWritten: PLongint): HResult;
      stdcall;
    function Seek(dlibMove: Largeint; dwOrigin: Longint;
      out libNewPosition: Largeint): HResult; stdcall;
    function SetSize(libNewSize: Largeint): HResult; stdcall;
    function CopyTo(stm: IStream; cb: Largeint; out cbRead: Largeint;
      out cbWritten: Largeint): HResult; stdcall;
    function Commit(grfCommitFlags: Longint): HResult; stdcall;
    function Revert: HResult; stdcall;
    function LockRegion(libOffset: Largeint; cb: Largeint;
      dwLockType: Longint): HResult; stdcall;
    function UnlockRegion(libOffset: Largeint; cb: Largeint;
      dwLockType: Longint): HResult; stdcall;
    function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult;
      stdcall;
    function Clone(out stm: IStream): HResult; stdcall;
  public
    constructor Create();overload;virtual;
    constructor Create(AStream: TStream; ASize: Int64 = 0);overload;virtual;   
    destructor Destroy();override;

    property MemoryStream: TMemoryStream read FStream;
  end;

implementation

uses RTLConsts;

{ TInterfaceStream }

function TIMemoryStream.Clone(out stm: IStream): HResult;
begin
  Result := E_NOTIMPL;
end;

function TIMemoryStream.Commit(grfCommitFlags: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TIMemoryStream.CopyTo(stm: IStream; cb: Largeint; out cbRead,
  cbWritten: Largeint): HResult;
var
  Buf: array [0..8191] of Char;
  SizeToRead, SizeReaded, SizeWriten: LargeInt;
begin
  Result := S_OK;
  while cb > 0 do
  begin
    if cb > sizeof(Buf) then
      SizeToRead := sizeof(Buf)
    else SizeToRead := cb;
    Result := Read( @Buf[0], SizeToRead, @SizeReaded );
    if FAILED( Result ) then
    begin
      break;
    end;
    if SizeReaded = 0 then
      break;
    Dec( cb, SizeReaded );
    Inc( cbRead, SizeReaded );
    Result := stm.Write(@Buf[0], SizeReaded, @SizeWriten );
    if FAILED( Result ) then
    begin
      break;
    end;
    Inc( cbWritten, SizeReaded );
    if SizeWriten < SizeReaded then
    begin
      break;
    end;
  end;
end;

constructor TIMemoryStream.Create;
begin
  FStream := TGlobalMemoryStream.Create;    
  _AddRef();
end;

constructor TIMemoryStream.Create(AStream: TStream; ASize: Int64);
begin
  Create();
  FStream.CopyFrom(AStream, ASize);
end;

destructor TIMemoryStream.Destroy;
begin
  FStream.Free;
  inherited;
end;

function TIMemoryStream.LockRegion(libOffset, cb: Largeint;
  dwLockType: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TIMemoryStream.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else Result := E_NOINTERFACE;
end;

function TIMemoryStream.Read(pv: Pointer; cb: Integer;
  pcbRead: PLongint): HResult;
var
  BytesRead: Int64;
begin
  BytesRead := FStream.Read(pv^, cb);
  if pcbRead <> nil then
    pcbRead^ := BytesRead;
  Result := S_OK;
end;

function TIMemoryStream.Revert: HResult;
begin
  Result := E_NOTIMPL;
end;

function TIMemoryStream.Seek(dlibMove: Largeint; dwOrigin: Integer;
  out libNewPosition: Largeint): HResult;
var
  NewPos: Int64;
begin
  NewPos := FStream.Seek(dlibMove, dwOrigin);
  if @libNewPosition <> nil then
    libNewPosition := NewPos;
  Result := S_OK;
end;

function TIMemoryStream.SetSize(libNewSize: Largeint): HResult;
begin
  FStream.Size := libNewSize;  
  Result := S_OK;
end;

function TIMemoryStream.Stat(out statstg: TStatStg;
  grfStatFlag: Integer): HResult;
begin
  FillChar(statstg, sizeof(statstg), 0);
  statstg.cbSize := FStream.Size;
  Result := S_OK;
end;

function TIMemoryStream.UnlockRegion(libOffset, cb: Largeint;
  dwLockType: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TIMemoryStream.Write(pv: Pointer; cb: Integer;
  pcbWritten: PLongint): HResult;
var
  BytesWriten: Int64;
begin
  BytesWriten := FStream.Write(pv^, cb);
  if pcbWritten <> nil then
    pcbWritten^ := BytesWriten;
  Result := S_OK;
end;

function TIMemoryStream._AddRef: Integer;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TIMemoryStream._Release: Integer;
begin
  Dec(FRefCount);
  Result := FRefCount;
  if FRefCount <= 0 then
    Free();
end;

{ TGlobalMemoryStream }

function TGlobalMemoryStream.Realloc(var NewCapacity: Integer): Pointer;
const
  MemoryDelta = $2000; { Must be a power of 2 }
begin
  if (NewCapacity > 0) and (NewCapacity <> Size) then
    NewCapacity := (NewCapacity + (MemoryDelta - 1)) and not (MemoryDelta - 1);
  Result := Memory;
  if NewCapacity <> Capacity then
  begin
    if NewCapacity = 0 then
    begin
      GlobalUnlock(FGlobal);
      GlobalFree(FGlobal);
      FGlobal := 0;
      Result := nil;
    end else
    begin
      if Capacity = 0 then
        FGlobal := GlobalAlloc(GMEM_MOVEABLE, NewCapacity)
      else FGlobal := GlobalRealloc( FGlobal, NewCapacity, GMEM_MOVEABLE );
      if FGlobal = 0 then raise EStreamError.CreateRes(@SMemoryStreamError);
      Result := GlobalLock( FGlobal );
    end;
  end;
end;

end.
