unit Base64;

interface

uses SysUtils;

function Base64Encode(const Buf; const BufSize: Integer): string;
procedure Base64Decode(const Base64: string; var OutBuf; const OutBufSize: Integer);

implementation

//const
// Base64_Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

function Base64Encode(const Buf; const BufSize: Integer): string;
var
  I, J, K, Len, Len1: Integer;
  pBuf: PChar;
  B3: array[0..2] of Byte;
  B4: array[0..3] of Byte;
begin           
  pBuf := @Buf;
  if (pBuf = nil) or (BufSize <= 0) then
  begin
    Result := '';
    Exit;
  end;
  Len := BufSize;
  Len1 := ((Len + 2) div 3) shl 2;
  SetString(Result, nil, Len1);
  I := 0;
  J := 1;
  while I < Len do
  begin
    for K := 0 to 2 do
    begin
      if K + I >= Len then
        B3[K] := 0
      else B3[K] := Ord(pBuf[K + I]);
    end;
    B4[0] := B3[0] shr 2;
    B4[1] := ((B3[0] shl 4) or (B3[1] shr 4)) and 63;
    B4[2] := ((B3[1] shl 2) or (B3[2] shr 6)) and 63;
    B4[3] := B3[2] and 63;
    for K := 0 to 3 do
    begin
      case B4[K] of
        0..25: Result[J] := Chr(B4[K] + 65);   // 'A'..'Z'
        26..51: Result[J] := Chr(B4[K] + 71);  // 'a'..'z'(B4[K]-26+97)
        62: Result[J] := '+';
        63: Result[J] := '/';
        else Result[J] := Chr(B4[K] - 4);      // '0'..'9'(B4[K]-52+48)
      end;
      Inc(J);
    end;
    Inc(I, 3);
  end;
  K := 3 - Len mod 3 - 1;
  if K <> 2 then
  begin
    for I := Len1 - K to Len1 do
    begin
      Result[I] := '=';
    end;
  end;
end;

procedure Base64Decode(const Base64: string; var OutBuf; const OutBufSize: Integer);
var
  I, K, Len: Integer;
  pBuf, pBufEnd: PChar;
  B4: array[0..3] of Byte;
begin
  pBuf := @OutBuf;
  if (Base64 = '') or (pBuf = nil) or (OutBufSize <= 0) then
  begin
    Exit;
  end;
  Len := Length(Base64);
  if Len and 3 <> 0 then raise Exception.Create('Invalid Base64 length');

  pBufEnd := pBuf + OutBufSize;
  //Result := (Len shr 2) * 3;
  I := 1;
  while (I <= Len) do
  begin
    for K := 0 to 3 do
    begin
      case Base64[I] of
        'A'..'Z': B4[K] := Ord(Base64[I]) - 65;
        'a'..'z': B4[K] := Ord(Base64[I]) - 71;
        '0'..'9': B4[K] := Ord(Base64[I]) + 4;
        '+': B4[K] := 62;
        '/': B4[K] := 63;
        '=': B4[K] := 0;
        else raise Exception.CreateFmt('#%d: Invalid char in Base64', [Ord(Base64[I])]);
      end;
      Inc(I);
    end;
    pBuf^ := Chr((B4[0] shl 2) or (B4[1] shr 4));
    Inc(pBuf);
    if pBuf >= pBufEnd then break;

    pBuf^ := Chr((B4[1] shl 4) or (B4[2] shr 2));  
    Inc(pBuf);
    if pBuf >= pBufEnd then break;

    pBuf^ := Chr((B4[2] shl 6) or B4[3]);  
    Inc(pBuf);
    if pBuf >= pBufEnd then break;
  end;
end;

end.
