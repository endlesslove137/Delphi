unit GY;

interface

uses
  System.Types, System.UITypes, System.Classes,
  System.Variants, System.SysUtils;

const
  Delta: longword = $9E3779B9;
  Lim32 = 2147483648; // MaxInt32 +1

type
  TByte4 = array [0 .. 3] of byte; // 32-bit =   4-byte
  TLong2 = array [0 .. 1] of longword; // 64-bit =   8-byte
  TByte8 = array [0 .. 7] of byte; // 64-bit =   8-byte
  TTeaKey = array [0 .. 3] of longword; // 128-bit =  16-byte
  TLong2x2 = array [0 .. 1] of TLong2; // 128-bit =  16-byte
  TByte16 = array [0 .. 15] of byte; // 128-bit =  16-byte
  TTeaData = array of longword; // n*32-bit = n*4-byte
  TLong2Data = array of TLong2; // n*64-bit = n*8-byte

  // Algorithm: David Wheeler & Roger Needham, Cambridge University Computer Lab
  // TEA:       http://www.cl.cam.ac.uk/ftp/papers/djw-rmn/djw-rmn-tea.html (1994)
procedure TeaEncrypt(var data: TLong2; const key: TTeaKey);
procedure TeaDecrypt(var data: TLong2; const key: TTeaKey);

// Algorithm: David Wheeler & Roger Needham, Cambridge University Computer Lab
// Block XTEA: http://www.cl.cam.ac.uk/ftp/users/djw3/xtea.ps (1997)
procedure XTeaEncrypt(var data: TLong2; const key: TTeaKey; N: longword = 32);
procedure XTeaDecrypt(var data: TLong2; const key: TTeaKey; N: longword = 32);

// Algorithm: David Wheeler & Roger Needham, Cambridge University Computer Lab
// Block TEA: http://www.cl.cam.ac.uk/ftp/users/djw3/xtea.ps (1997)
procedure BlockTeaEncrypt(data: TTeaData; const key: TTeaKey);
procedure BlockTeaDecrypt(data: TTeaData; const key: TTeaKey);

// Algorithm: David Wheeler & Roger Needham, Cambridge University Computer Lab
// XXTEA:     http://www.cl.cam.ac.uk/ftp/users/djw3/xxtea.ps (1998)
procedure XXTeaEncrypt(data: TTeaData; const key: TTeaKey);
procedure XXTeaDecrypt(data: TTeaData; const key: TTeaKey);

// comparison of TTeaKey type variables
function SameKey(const key1, key2: TTeaKey): boolean;
// random key generation
procedure RandKey(var key: TTeaKey);

// key := 0
procedure ClearKey(var key: TTeaKey);
// data := 0
procedure ClearData(var data: TTeaData);
// data2 := 0
procedure ClearLong2Data(var data2: TLong2Data);

// XXTeaEncrypt encryption of RandomKey with Masterkey into data[0..3]
procedure EncryptKey(const RandomKey: TTeaKey; var data: TTeaData;
  const MasterKey: TTeaKey);
// XXTeaDecrypt decryption of data[0..3] with Masterkey into RandomKey
procedure DecryptKey(var RandomKey: TTeaKey; const data: TTeaData;
  const MasterKey: TTeaKey);

// random Long2 generation
procedure RandLong2(var dat: TLong2);
// inc(Long2)
procedure IncLong2(var dat: TLong2);
// dec(Long2)
procedure DecLong2(var dat: TLong2);
// dat := 0
procedure ClearLong2(var dat: TLong2);
// result = dat1 XOR dat2
function XORLong2(dat1, dat2: TLong2): TLong2;

// Conversion routine  Key <- string
procedure StrToKey(const s: string; var key: TTeaKey);
// Conversion routine  string <- Key
function KeyToStr(const key: TTeaKey): string;

// Conversion routine  Long2 <- string
procedure StrToLong2(const s: string; var dat: TLong2);
// Conversion routine  string <- Long2
function Long2ToStr(const dat: TLong2): string;

// Conversion routine  Long2Data <- string
procedure StrToLong2Data(const s: string; var dat: TLong2Data;
  ExtraDim: integer);
// Conversion routine  string <- Long2Data
function Long2DataToStr(const dat: TLong2Data): string;

// Conversion routine  Data <- string
procedure StrToData(const s: string; var data: TTeaData);
// Conversion routine  string <- Data
procedure DataToStr(var s: string; const data: TTeaData);

// data <- File
procedure LoadLong2Data(const FileName: string; var data2: TLong2Data;
  var aFileSize: Int64; ExtraDim: integer);
// File <- data
procedure SaveLong2Data(const FileName: string; const data2: TLong2Data;
  const aFileSize: Int64);
// Clear and delete file擦除文件
function WipeFile(const FileName: string): boolean;

// reads a file of longword
procedure ReadData(const FileName: string; var data: TTeaData);
// writes a file of longword
procedure WriteData(const FileName: string; const data: TTeaData);
// ==============================================================================
// GY加入的：返回对S加解密后的字符串
function MyTextEncrypt(s: string; key: string): string;
function MyTextDEncrypt(s: string; key: string): string;
// GY加入的：将file1加密保存为tofile2。成功返回true,失败返回false.
function MyFileEncrypt(file1, tofile2: string; key: string): boolean;
// GY加入的：将file1解密保存为tofile2。成功返回true,失败返回false.
function MyFileDEncrypt(file1, tofile2: string; key: string): boolean;
function gethzPy(const AAHzStr: string): string; // 得到汉字着字母
function ReplaceText(const s, ReplacePiece, ReplaceWith: string): string;
function GetAFileName: string; // 得到一个当前时间组成的字符串

// ==============================================================================
implementation

uses
  math;

function GetAFileName: string; // 得到一个当前时间组成的字符串
var
  str, str1, FileName, filetemp: string;
  year1, month1, day1, hour1, min1, sec1, msec1: word;
begin
  DecodeDate(now, year1, month1, day1);
  DecodeTime(now, hour1, min1, sec1, msec1);
  result := floattostr(year1) + floattostr(month1) + floattostr(day1) +
    floattostr(hour1) + floattostr(min1) + floattostr(sec1) + floattostr(msec1);
end;

// 参数说明：c:分隔符，s：原字符串，n第几个分隔符，
// 功能说明：返回第n个分隔符在字符串S中的位置
function NPos(const C: string; s: string; N: integer): integer;
var
  I, P, K: integer;
begin
  result := 0;
  K := 0;
  for I := 1 to N do
  begin
    P := Pos(C, s);
    Inc(K, P);
    if (I = N) and (P > 0) then
    begin
      result := K;
      Exit;
    end;
    if P > 0 then
      Delete(s, 1, P)
    else
      Exit;
  end;
end;

// 参数说明：c:分隔符，s：原字符串，n第几个分隔符，
// 功能说明：返回第n个分隔符与第n-1个分隔符之间的字符串
function NString(const C: string; s: string; N: integer): string;
begin
  result := Copy(s, NPos(C, s, N - 1) + 1, NPos(C, s, N) - NPos(C, s,
    N - 1) - 1);
end;
{ -------------------------------------------------------------------------------
  过程名:    gethzPy
  作者:      jiangjun
  日期:      2006.08.19
  参数:      const AHzStr: string
  返回值:    string
  ------------------------------------------------------------------------------- }

function gethzPy(const AAHzStr: string): string; // 得到汉字首字母
const
  ChinaCode: array [0 .. 25, 0 .. 1] of integer = ((1601, 1636), (1637, 1832),
    (1833, 2077), (2078, 2273), (2274, 2301), (2302, 2432), (2433, 2593),
    (2594, 2786), (9999, 0000), (2787, 3105), (3106, 3211), (3212, 3471),
    (3472, 3634), (3635, 3722), (3723, 3729), (3730, 3857), (3858, 4026),
    (4027, 4085), (4086, 4389), (4390, 4557), (9999, 0000), (9999, 0000),
    (4558, 4683), (4684, 4924), (4925, 5248), (5249, 5589));
var
  I, j, k, HzOrd: integer;
  AHzStr, sa: tbytes;
begin
  sa:=bytesof('');
  AHzStr := bytesof(AAHzStr);
  I := 0;
  while I <= Length(AHzStr) - 1 do
  begin
    // if (AHzStr[I] >= #160) and (AHzStr[I + 1] >= #160) then
    if (char(AHzStr[I]) >= #160) and (char(AHzStr[I + 1]) >= #160) then
    begin
      HzOrd := (AHzStr[I] - 160) * 100 + AHzStr[I + 1] - 160;
      for j := 0 to 25 do
      begin
        if (HzOrd >= ChinaCode[j][0]) and (HzOrd <= ChinaCode[j][1]) then
        begin
          k := Length(sa);
          setlength(sa, k + 1);
          sa[k + 1] := byte(Ord('A')) + j;
          // result := result + char(byte('A') + j);
          break;
        end;
      end;
      Inc(I);
    end
    else
    begin
      k := Length(sa);
      setlength(sa, k + 1);
      sa[k + 1] := AHzStr[I];
      // result := result + AHzStr[I];
    end;
    Inc(I);
  end;
  result := stringof(sa);
end;

{ -------------------------------------------------------------------------------
  过程名:    ReplaceText
  作者:      jiangjun
  日期:      2006.08.19
  参数:      const S, ReplacePiece, ReplaceWith: string
  返回值:    string
  ------------------------------------------------------------------------------- }

function ReplaceText(const s, ReplacePiece, ReplaceWith: string): string;
var
  Position: integer;
  TempStr: string;
begin
  Position := Pos(ReplacePiece, s);
  if Position > 0 then
  begin
    TempStr := s;
    Delete(TempStr, 1, Position - 1 + Length(ReplacePiece));
    result := Copy(s, 1, Position - 1) + ReplaceWith +
      ReplaceText(TempStr, ReplacePiece, ReplaceWith)
  end
  else
    result := s;
end;

procedure TeaEncrypt(var data: TLong2; const key: TTeaKey);
var
  y, z, sum: longword;
  a: byte;
begin
  y := data[0];
  z := data[1];
  sum := 0;
  for a := 0 to 31 do
  begin
    { c code:
      sum += delta;
      y += (z << 4)+key[0] ^ z+sum ^ (z >> 5)+key[1];
      z += (y << 4)+key[2] ^ y+sum ^ (y >> 5)+key[3];
    }
    Inc(sum, Delta);
    Inc(y, ((z shl 4) + key[0]) xor (z + sum) xor ((z shr 5) + key[1]));
    Inc(z, ((y shl 4) + key[2]) xor (y + sum) xor ((y shr 5) + key[3]));
  end;
  data[0] := y;
  data[1] := z
end;

procedure TeaDecrypt(var data: TLong2; const key: TTeaKey);
var
  y, z, sum: longword;
  a: byte;
begin
  y := data[0];
  z := data[1];
  sum := Delta shl 5;
  for a := 0 to 31 do
  begin
    { c code:
      z -= (y << 4)+key[2] ^ y+sum ^ (y >> 5)+key[3];
      y -= (z << 4)+key[0] ^ z+sum ^ (z >> 5)+key[1];
      sum -= delta;
    }
    dec(z, ((y shl 4) + key[2]) xor (y + sum) xor ((y shr 5) + key[3]));
    dec(y, ((z shl 4) + key[0]) xor (z + sum) xor ((z shr 5) + key[1]));
    dec(sum, Delta);
  end;
  data[0] := y;
  data[1] := z
end;

procedure XTeaEncrypt(var data: TLong2; const key: TTeaKey; N: longword = 32);
var
  y, z, sum, limit: longword;
begin
  y := data[0];
  z := data[1];
  sum := 0;
  limit := Delta * N;
  while sum <> limit do
  begin
    { c code:
      y += (z << 4 ^ z >> 5) + z ^ sum + key[sum&3];
      sum += delta;
      z += (y << 4 ^ y >> 5) + y ^ sum + key[sum>>11 & 3];
    }
    // inc(y,((z shl 4) xor (z shr 5)) xor (sum+key[sum and 3]));
    Inc(y, (((z shl 4) xor (z shr 5)) + z) xor (sum + key[sum and 3]));
    Inc(sum, Delta);
    // inc(z,((y shl 4) xor (y shr 5)) xor (sum+key[(sum shr 11) and 3]));
    Inc(z, (((y shl 4) xor (y shr 5)) + y) xor (sum + key[(sum shr 11) and 3]));
  end;
  data[0] := y;
  data[1] := z
end;

procedure XTeaDecrypt(var data: TLong2; const key: TTeaKey; N: longword = 32);
var
  y, z, sum: longword;
begin
  y := data[0];
  z := data[1];
  sum := Delta * N;
  while sum <> 0 do
  begin
    { c code:
      z -= (y << 4 ^ y >> 5) + y ^ sum + key[sum>>11 & 3];
      sum -= delta;
      y -= (z << 4 ^ z >> 5) + z ^ sum + key[sum&3];
    }
    // dec(z,((y shl 4) xor (y shr 5)) xor (sum+key[(sum shr 11) and 3]));
    dec(z, (((y shl 4) xor (y shr 5)) + y) xor (sum + key[(sum shr 11) and 3]));
    dec(sum, Delta);
    // dec(y,((z shl 4) xor (z shr 5)) xor (sum+key[sum and 3]));
    dec(y, (((z shl 4) xor (z shr 5)) + z) xor (sum + key[sum and 3]));
  end;
  data[0] := y;
  data[1] := z
end;

procedure BlockTeaEncrypt(data: TTeaData; const key: TTeaKey);
var
  z, y, sum, e, P: longword;
  q, N: integer;

  function mx: longword;
  begin
    result := (((z shl 4) xor (z shr 5)) + z) xor (key[(P and 3) xor e] + sum);
  end;

begin
  N := Length(data);
  q := 6 + 52 div N;
  z := data[N - 1];
  sum := 0;
  repeat
    Inc(sum, Delta);
    e := (sum shr 2) and 3;
    for P := 0 to N - 1 do
    begin
      y := data[P];
      Inc(y, mx);
      data[P] := y;
      z := y;
    end;
    dec(q);
  until q = 0;
end;

procedure BlockTeaDecrypt(data: TTeaData; const key: TTeaKey);
var
  z, y, sum, e, P, q: longword;
  N: integer;

  function mx: longword;
  begin
    result := (((z shl 4) xor (z shr 5)) + z) xor (key[(P and 3) xor e] + sum);
  end;

begin
  N := Length(data);
  q := 6 + 52 div N;
  sum := q * Delta;
  while sum <> 0 do
  begin
    e := (sum shr 2) and 3;
    for P := N - 1 downto 1 do
    begin
      z := data[P - 1];
      y := data[P];
      dec(y, mx);
      data[P] := y;
    end;
    z := data[N - 1];
    y := data[0];
    dec(y, mx);
    data[0] := y;
    dec(sum, Delta);
  end;
end;

procedure XXTeaEncrypt(data: TTeaData; const key: TTeaKey);
var
  z, y, x, sum, e, P: longword;
  q, N: integer;

  function mx: longword;
  begin
    result := (((z shr 5) xor (y shl 2)) + ((y shr 3) xor (z shl 4)))
      xor ((sum xor y) + (key[(P and 3) xor e] xor z));
  end;

begin
  N := Length(data);
  q := 6 + 52 div N;
  z := data[N - 1];
  y := data[0];
  sum := 0;
  repeat
    Inc(sum, Delta);
    e := (sum shr 2) and 3;
    for P := 0 to N - 2 do
    begin
      y := data[P + 1];
      x := data[P];
      Inc(x, mx);
      data[P] := x;
      z := x;
    end;
    y := data[0];
    x := data[N - 1];
    Inc(x, mx);
    data[N - 1] := x;
    z := x;
    dec(q);
  until q = 0;
end;

procedure XXTeaDecrypt(data: TTeaData; const key: TTeaKey);
var
  z, y, x, sum, e, P, q: longword;
  N: integer;

  function mx: longword;
  begin
    result := (((z shr 5) xor (y shl 2)) + ((y shr 3) xor (z shl 4)))
      xor ((sum xor y) + (key[(P and 3) xor e] xor z));
  end;

begin
  N := Length(data);
  q := 6 + 52 div N;
  z := data[N - 1];
  y := data[0];
  sum := q * Delta;
  while sum <> 0 do
  begin
    e := (sum shr 2) and 3;
    for P := N - 1 downto 1 do
    begin
      z := data[P - 1];
      x := data[P];
      dec(x, mx);
      data[P] := x;
      y := x;
    end;
    z := data[N - 1];
    x := data[0];
    dec(x, mx);
    data[0] := x;
    y := x;
    dec(sum, Delta);
  end;
end;

function SameKey(const key1, key2: TTeaKey): boolean;
var
  I: integer;
begin
  result := false;
  for I := 0 to 3 do
    if key1[I] <> key2[I] then
      Exit;
  result := true;
end;

procedure RandKey(var key: TTeaKey);
var
  I: integer;
begin
  for I := 0 to 3 do
    key[I] := Random(Lim32);
end;

procedure ClearKey(var key: TTeaKey);
var
  I: integer;
begin
  for I := 0 to 3 do
    key[I] := 0;
end;

procedure ClearData(var data: TTeaData);
var
  I: integer;
begin
  for I := 0 to Length(data) - 1 do
    data[I] := 0;
end;

procedure ClearLong2Data(var data2: TLong2Data);
var
  I: integer;
begin
  for I := 0 to Length(data2) - 1 do
    ClearLong2(data2[I]);
end;

procedure EncryptKey(const RandomKey: TTeaKey; var data: TTeaData;
  const MasterKey: TTeaKey);
var
  I: integer;
begin
  // SetLength(data, 4);
  for I := 0 to 3 do
    data[I] := RandomKey[I];
  XXTeaEncrypt(data, MasterKey);
end;

procedure DecryptKey(var RandomKey: TTeaKey; const data: TTeaData;
  const MasterKey: TTeaKey);
var
  I: integer;
begin
  // SetLength(data, 4);
  XXTeaDecrypt(data, MasterKey);
  for I := 0 to 3 do
    RandomKey[I] := data[I];
end;

procedure RandLong2(var dat: TLong2);
var
  I: integer;
begin
  for I := 0 to 1 do
    dat[I] := Random(Lim32);
end;

procedure IncLong2(var dat: TLong2);
var
  I: Int64;
begin
  I := Int64(dat);
  I := I + 1;
  dat := TLong2(I);
end;

procedure DecLong2(var dat: TLong2);
var
  I: Int64;
begin
  I := Int64(dat);
  I := I - 1;
  dat := TLong2(I);
end;

procedure ClearLong2(var dat: TLong2);
var
  I: integer;
begin
  for I := 0 to 7 do
  begin
    TByte8(dat)[I] := 0;
    // TByte8(dat[1])[i] := 0;
  end;
end;

function XORLong2(dat1, dat2: TLong2): TLong2;
var
  I: integer;
begin
  for I := 0 to 1 do
    result[I] := dat1[I] xor dat2[I];
end;

procedure StrToLong2(const s: string; var dat: TLong2);
var
  sa, sb: tbytes;
  I, N: integer;
begin
  sa := bytesof(s);
  sb := bytesof(StringOfChar(' ', 8));
  N := min(Length(sa), 8);
  for I := 0 to N - 1 do
    sb[I] := sa[I];
  for I := 0 to 7 do
    TByte8(dat)[I] := sb[I];
  sa := bytesof('');
  sb := bytesof('');
end;

function Long2ToStr(const dat: TLong2): string;
var
  s: tbytes;
  I: integer;
begin
  setlength(s, 8);
  for I := 0 to 7 do
  begin
    s[I] := TByte8(dat)[I];
  end;
  result := stringof(s);
end;

// Conversion routine  Long2Data <- string
procedure StrToLong2Data(const s: string; var dat: TLong2Data;
  ExtraDim: integer);
var
  sa, sb: tbytes;
  I, N, j, k1, k2, m: integer;
  ss: tbytes;
begin
  sa := bytesof(s);
  k1 := Length(sa);
  k2 := k1 mod 8;
  setlength(sa, k1 + k2);
  for m := 1 to k2 do
    sa[k1 + m-1] := byte(Ord(' '));
  // sb := StringOfChar(' ', Length(sa) mod 8);
  // sa := sa + sb;
  N := Length(sa) div 8;
  setlength(dat, N + ExtraDim);
  setlength(ss, 8);
  for I := 0 to N - 1 do
  begin
    for j := 0 to 7 do
      ss[j] := sa[j + 8 * I];
    StrToLong2(stringof(ss), dat[I]);
  end;
  sa := bytesof('');
  sb := bytesof('');
end;

// Conversion routine  string <- Long2Data
function Long2DataToStr(const dat: TLong2Data): string;
var
  s, ss: string;
  I: integer;
begin
  ss := '';
  for I := Low(dat) to High(dat) do
  begin
    s := Long2ToStr(dat[I]);
    ss := ss + s;
  end;
  result := ss;
end;

procedure StrToKey(const s: string; var key: TTeaKey);
var
  sa, sb: tbytes;
  I, N: integer;
begin
  sa := bytesof(s);
  sb := bytesof(StringOfChar(' ', 16));
  N := min(Length(sa), 16);
  for I := 0 to N - 1 do
    sb[I] := sa[I];
  for I := 1 to 16 do
    TByte16(key)[I - 1] := sb[I - 1];
  sa := bytesof('');
  sb := bytesof('');
end;

function KeyToStr(const key: TTeaKey): string;
var
  s: string;
  I: integer;
begin
  setlength(s, 16);
  for I := 1 to 16 do
  begin
    s[I] := char(Chr(TByte16(key)[I - 1]));
  end;
  result := s;
end;

procedure StrToData(const s: string; var data: TTeaData);
var
  sa: tbytes;
  I, N, m, j, L: integer;
begin
  sa := bytesof(s);
  L := Length(sa);
  N := Length(sa) div 4;
  m := Length(sa) mod 4;
  if m <> 0 then
  begin
    setlength(sa, L + m);
    for j := 1 to m do
      sa[L + j-1] := byte(Ord(' '));
    Inc(N);

    // sa := bytesof(stringof(sa)+StringOfChar(' ', m));
  end;
  if N < 2 then // n = 1
  begin
    N := 2;
    setlength(sa, 4 + 4);
    for j := 1 to 4 do
      sa[4 + j-1] := byte(Ord(' '));
    // sa := bytesof(stringof(sa)+StringOfChar(' ', 4));
  end;

  setlength(data, N);
  for I := 0 to N - 1 do
    for m := 0 to 3 do
      TByte4(data[I])[m] := sa[I * 4 + m];
  sa := bytesof('');
end;

procedure DataToStr(var s: string; const data: TTeaData);
var
  sa: tbytes;
  I, N, m: integer;
  b: byte;
begin
  N := Length(data);
  setlength(sa, N * 4);
  for I := 0 to N - 1 do
    for m := 0 to 3 do
    begin
      b := TByte4(data[I])[m];
      sa[I * 4 + m] := b; // char(Chr(b));
    end;
  s := stringof(sa);
  sa := bytesof('');
end;

procedure LoadLong2Data(const FileName: string; var data2: TLong2Data;
  var aFileSize: Int64; ExtraDim: integer);
var
  infile: TFileStream;
  L, I, j, m, dim: integer; // Int64;
  // buf : longword;
  buf: TByte8;
begin
  L := 8;
  m := L;
  try
    infile := TFileStream.Create(FileName, fmOpenRead);
    aFileSize := infile.Size;
    dim := (aFileSize + L - 1) div L;
    setlength(data2, dim + ExtraDim);

    for I := 0 to dim - 1 do
    begin
      m := infile.Read(buf, L);
      data2[I] := TLong2(buf);
    end;
  finally
    infile.Free;
  end;

  for j := m to L - 1 do
    TByte8(data2[dim - 1])[j] := $0;
  // TByte8(data2[dim-1])[j-1] := $0;

  if ExtraDim > 0 then
    for I := dim to Length(data2) - 1 do
      ClearLong2(data2[I]);
end;

procedure SaveLong2Data(const FileName: string; const data2: TLong2Data;
  const aFileSize: Int64);
var
  outfile: TFileStream;
  L, I, m, N, dim: integer; // Int64;
  // buf : longword;
  buf: TByte8;
begin
  L := 8;
  try
    outfile := TFileStream.Create(FileName, fmCreate);
    m := aFileSize mod L;
    if m = 0 then
      m := L;
    dim := (aFileSize + L - 1) div L;
    for I := 0 to dim - 1 do
    begin
      buf := TByte8(data2[I]);
      if (I = (dim - 1)) and (m <> 0) then
        N := m
      else
        N := L;
      outfile.Write(buf, N);
    end;
  finally
    outfile.Free;
  end;
end;

function WipeFile(const FileName: string): boolean;
var
  outfile: TFileStream;
  L, I, m, N, dim: integer; // Int64;
  zero: TLong2;
  buf: TByte8;
  aFileSize: Int64;
begin
  L := 8;
  ClearLong2(zero);
  result := false;
  buf := TByte8(zero);
  try
    outfile := TFileStream.Create(FileName, fmOpenWrite);
    aFileSize := outfile.Size;
    m := aFileSize mod L;
    dim := (aFileSize + L - 1) div L;
    for I := 0 to dim - 1 do
    begin
      if (I = (dim - 1)) and (m <> 0) then
        N := m
      else
        N := L;
      outfile.Write(buf, N);
    end;
  finally
    outfile.Free;
  end;
  result := DeleteFile(FileName);
end;

procedure ReadData(const FileName: string; var data: TTeaData);
var
  I, N: integer;
  ww: longword;
  wwf: file of longword;
begin
  try
    AssignFile(wwf, FileName);
    Reset(wwf);
    N := FileSize(wwf);
    setlength(data, N);
    for I := 0 to N - 1 do
    begin
      read(wwf, ww);
      data[I] := ww;
    end;
  finally
    CloseFile(wwf);
  end;
end;

procedure WriteData(const FileName: string; const data: TTeaData);
var
  I, N: integer;
  ww: longword;
  wwf: file of longword;
begin
  try
    AssignFile(wwf, FileName);
    Rewrite(wwf);
    N := Length(data);
    for I := 0 to N - 1 do
    begin
      ww := data[I];
      write(wwf, ww);
    end;
  finally
    CloseFile(wwf);
  end;
end;

// GY加入的：返回对S加密后的字符串
function MyTextEncrypt(s: string; key: string): string;
var
  data0: TTeaData;
  MYKey: TTeaKey;
  strlist: Tstringlist;
  I: integer;
begin
  strlist := Tstringlist.Create();
  StrToKey(key, MYKey);
  StrToData(s, data0);
  BlockTeaEncrypt(data0, MYKey);
  for I := 0 to Length(data0) - 1 do
    strlist.Add(inttostr(data0[I])); // 将数字数组变成字符串列表
  // result:=strlist.Text;
  result := Copy(strlist.Text, 1, Length(strlist.Text) - 1);
  strlist.Free;
end;

// GY加入的：返回对S解密后的字符串
function MyTextDEncrypt(s: string; key: string): string;
var
  data0: TTeaData;
  MYKey: TTeaKey;
  strlist: Tstringlist;
  I: integer;
  TempStr: string;
begin
  strlist := Tstringlist.Create();
  StrToKey(key, MYKey);
  strlist.Text := s;
  setlength(data0, strlist.Count);
  for I := 0 to strlist.Count - 1 do
    data0[I] := StrToInt64(strlist[I]); // 将字符串列表变成数字数组
  BlockTeaDecrypt(data0, MYKey);
  DataToStr(TempStr, data0);
  result := trim(TempStr);
  strlist.Free;
end;

// GY加入的：将file1加密保存为tofile2。成功返回true,失败返回false.
function MyFileEncrypt(file1, tofile2: string; key: string): boolean;
var
  I, dim, ExtraDim: integer; // Int64;
  s: string;
  temp: TLong2;
  dat: TLong2;
  data2: TLong2Data;
  fFileSize: Int64;
  MYKey: TTeaKey;
begin
  result := false;
  ExtraDim := 4;
  if not FileExists(file1) then
  begin
    result := false;
    Exit;
  end;
  LoadLong2Data(file1, data2, fFileSize, ExtraDim);
  dim := Length(data2) - ExtraDim;

  StrToLong2('XTEA_CNT', temp);
  data2[dim] := temp;
  StrToLong2('Ver 1.00', temp);
  data2[dim + 1] := temp;
  data2[dim + 2] := TLong2(fFileSize);
  ClearLong2(temp);
  data2[dim + 3] := temp;

  StrToKey(key, MYKey);
  RandLong2(dat);
  // ClearLong2(dat);
  for I := 0 to Length(data2) - 1 do
  begin
    temp := dat;
    XTeaEncrypt(temp, MYKey);
    data2[I] := XORLong2(temp, data2[I]);
    IncLong2(dat);
  end;
  fFileSize := 8 * (dim + ExtraDim);

  try
    SaveLong2Data(tofile2, data2, fFileSize);
  except
    result := false;
    Exit;
  end;
  result := true;
end;

// GY加入的：将file1解密保存为tofile2。成功返回true,失败返回false.
function MyFileDEncrypt(file1, tofile2: string; key: string): boolean;
var
  L, I: integer; // Int64;
  s: string;
  temp: TLong2;
  dat: TLong2;
  data2: TLong2Data;
  fFileSize: Int64;
  MYKey: TTeaKey;
begin
  if not FileExists(file1) then
  begin
    result := false;
    Exit;
  end;
  LoadLong2Data(file1, data2, fFileSize, 0);

  StrToKey(key, MYKey);
  L := Length(data2);
  // dim := Length(data) - ExtraDim;
  dat := data2[L - 1];
  XTeaDecrypt(dat, MYKey);

  for I := Length(data2) - 2 downto 0 do
  begin
    DecLong2(dat);
    temp := dat;
    XTeaEncrypt(temp, MYKey);
    data2[I] := XORLong2(temp, data2[I]);
  end;
  fFileSize := Int64(data2[L - 2]);

  try
    SaveLong2Data(tofile2, data2, fFileSize);
  except
    result := false;
    Exit;
  end;
  result := true;

end;

end.
