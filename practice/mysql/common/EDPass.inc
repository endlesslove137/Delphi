
function _b2s(lpData: pByte; dwSize: DWord): string;
const
  _HexCharTable : array [0..15] of char =
  ( '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' );
var
  P: PChar;
begin
  SetLength( Result, dwSize * 2 );
  P := @Result[1];
  while dwSize > 0 do
  begin
    P^ := _HexCharTable[lpData^ shr 4];
    Inc( P );
    P^ := _HexCharTable[lpData^ and $F];  
    Inc( P );
    Inc( lpData );        
    Dec( dwSize );
  end;
end;

function _s2b(s: string; lpData: pByte; dwSize: DWord): DWord;
var
  I: Integer;
  p: PChar;
  c: Byte;
begin
  Result := Length(S) div 2;
  
  p := PChar(S);
  for I := 0 to Result - 1 do
  begin
    if dwSize <= 0 then break;
    
    if p^ >= 'A' then
      c := (Byte(p^) - Byte('A') + 10) shl 4
    else c := (Byte(p^) - Byte('0')) shl 4;
    Inc( p );
    if p^ >= 'A' then
      c := c or (Byte(p^) - Byte('A') + 10)
    else c := c or (Byte(p^) - Byte('0'));
    Inc( p );
    lpData^ := c;
    Inc( lpData );
    Dec( dwSize );
  end;
end;


function keyED(txt: string; sKey: string): string;
var
  smd5Key: string;
  I: Integer;
  c: Char;
begin
  Result := '';
  smd5Key := MD5EncryptString( sKey );
  for I := 0 to Length(txt) - 1 do
  begin
    c := smd5key[(i and $1F) + 1];
    Result := Result + Char(Byte(txt[i + 1]) xor Byte(c));
  end;
end;

function EncryptPassWord(sPass: string; sKey: string): string;
var
  smd5Key: string;
  I: Integer;
  c: Char;
begin
  Result := '';
  smd5Key := MD5EncryptString( sKey );
  for I := 0 to Length(sPass) - 1 do
  begin
    c := smd5Key[(I and $1F) + 1];
    Result := Result + c + Char(Byte(sPass[i + 1]) xor Byte(c));
  end; 
	Result := keyED(Result, sKey);
  Result := _b2s( @Result[1], Length(Result) );
end;

function DecryptPassWord(sText: string; sKey: string): string;
var
  I: Integer;
  S: string;
begin
  Result := '';
  SetLength( S, Length(sText) div 2 );

  _s2b( sText, @S[1], Length(S) );
  S := keyED( S, sKey );
  for I := 1 to Length(S) div 2 do
  begin
    Result := Result + Char(Byte(S[I*2]) xor Byte(S[I*2-1]));
  end;
end;




