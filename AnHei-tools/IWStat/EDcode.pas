unit EDcode;

interface

uses
  SysUtils;

type
  PTDefaultMessage = ^TDefaultMessage;
  TDefaultMessage = record
    Recog: Integer;
    Ident: Word;
    Param: SmallInt;
    Tag: Word;
    Series: Word;
  end;

const
  DEFBLOCKSIZE        = 16;     //协议头编码后的大小
  MAX_ENCODE_BUFSIZE  = 10000;  //最大编码长度

function EncodeMessage(sMsg: TDefaultMessage): AnsiString;
function DecodeMessage(str: AnsiString): TDefaultMessage;
function DecodeMessageA(buf: PAnsiChar): TDefaultMessage;
function EncodeString(str: AnsiString): AnsiString;
function DecodeString(str: AnsiString): AnsiString;
function EnCodeBuffer(buf: PAnsiChar; bufsize: Integer): AnsiString;
procedure DecodeBuffer(src: AnsiString; buf: PAnsiChar; bufsize: Integer);
function Encode6bitBuf(pSrc, pDest:PAnsiChar; SrcSize, DestSize:Cardinal):Cardinal;
function Decode6bitBuf(pSrc, pDest:PAnsiChar; SrcSize, DestSize:Cardinal):Cardinal;
function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: SmallInt): TDefaultMessage;

implementation

const
  EncryptMinChar      = $3C;    //编码后的最小值
  //3编4方式的，如果值需要保持在0..7F范围内，则此值的范围是3C..40

function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: SmallInt): TDefaultMessage;
begin
  Result.Recog := nRecog;
  Result.Ident := wIdent;
  Result.Param := wParam;
  Result.Tag := wTag;
  Result.Series := wSeries;
end;

//3字节编码为4字节
function Encode6bitBuf(pSrc, pDest:PAnsiChar; SrcSize, DestSize:Cardinal):Cardinal;
const
  //前端掩码
  btFrontMasks : array [0..3] of Byte = ($FF, $F8, $E0, $80);
  btBehindMasks: array [0..3] of Byte = ($00, $01, $07, $1F);
  btBitMasks   : array [0..3] of Byte = ($00, $06, $18, $60);
var
  btSrc, btNew, btIdx, btFront, btBehind : Byte;
  dwMaxSize : Cardinal;
begin
  dwMaxSize := DestSize;

  if DestSize > 0 then
  begin
    btIdx  := 3;
    btNew  := 0;

    while SrcSize > 0 do
    begin
      btSrc := Byte(pSrc^);
      //0000 0001
      btNew := btNew or (btSrc and btBitMasks[btIdx]);  //取第 btIdx 位
      btFront := (btSrc and btFrontMasks[btIdx]) shr 2; //保存 btIdx 前的位
      btBehind:= btSrc and btBehindMasks[btIdx];        //保存 btIdx 后的位

      pDest^ := AnsiChar((btFront or btBehind) + EncryptMinChar);
      Dec( DestSize );
      if DestSize = 0 then
        break;

      Inc( pDest );
      Dec( btIdx );

      if btIdx = 0 then
      begin
        pDest^ := AnsiChar((btNew shr 1) + EncryptMinChar);
        Dec( DestSize );
        if DestSize = 0 then
          break;
        Inc( pDest );
        btIdx := 3;
        btNew := 0;
      end;
                  
      Inc( pSrc );
      Dec( SrcSize );
    end;

    if (SrcSize = 0) and (btIdx <> 3) then
    begin
      pDest^ := AnsiChar((btNew shr 1) + EncryptMinChar);
      Dec( DestSize );
      Inc( pDest );
    end;

    if DestSize > 0 then
      pDest^ := #0;
    
  end;

  Result := dwMaxSize - DestSize;
end;

function Decode6BitBuf(pSrc, pDest: PAnsiChar; SrcSize, DestSize:Cardinal): Cardinal;
const
  //前端掩码                                           
  btFrontMasks : array [0..3] of Byte = ($FF, $FE, $F8, $E0);
  btBehindMasks: array [0..3] of Byte = ($00, $01, $07, $1F);
  btBitMasks   : array [0..3] of Byte = ($00, $06, $18, $60);
var
  btSrc, btFront, btBehind, btBits, btIdx: Byte;
  dwMaxSize : Cardinal;
begin
  btBits := 0;
  dwMaxSize := DestSize;
  if DestSize > 0 then
  begin
    btIdx := 3;
    
    while SrcSize > 1 do
    begin
      if btIdx = 3 then
      begin
        if SrcSize > 3 then
          btBits := Byte(pSrc[3])
        else
          btBits := Byte(pSrc[SrcSize-1]);
        btBits := (btBits - EncryptMinChar) shl 1;
      end;

      btSrc := Byte(pSrc^) - EncryptMinChar;
      btFront := (btSrc and btFrontMasks[btIdx]) shl 2;
      btBehind:= btSrc and btBehindMasks[btIdx];
      pDest^ := AnsiChar(btFront or btBehind or (btBits and btBitMasks[btIdx]));

      Dec( DestSize );
      if DestSize = 0 then
        break;
      Inc( pDest );
      Dec( btIdx );

      if btIdx = 0 then
      begin
        Dec( SrcSize ); 
        if SrcSize = 0 then
          break;
        Inc( pSrc );  
        btIdx := 3;
      end;

      Dec( SrcSize );  
      Inc( pSrc );
    end;

    if DestSize > 0 then
      pDest^ := #0;
  end;
  Result := dwMaxSize - DestSize;
end;

function DecodeMessage(str: AnsiString): TDefaultMessage;
var
  msg: TDefaultMessage;
begin
  Decode6BitBuf(PAnsiChar(str), @msg, length(str), Sizeof(msg));
  Result := msg;
end;

function DecodeMessageA(buf: PAnsiChar): TDefaultMessage;
var
  msg: TDefaultMessage;
begin
  Decode6BitBuf(buf, @msg, DEFBLOCKSIZE, Sizeof(msg));
  Result := msg;
end;


function DecodeString(str: AnsiString): AnsiString;
var
  EncBuf            : array[0..MAX_ENCODE_BUFSIZE - 1] of AnsiChar;
  aLen: Integer;
begin
  aLen := length(str);
  if length(str) > 0 then
  begin
    Decode6BitBuf(PAnsiChar(AnsiString(str)), @EncBuf, aLen, Sizeof(EncBuf));
    Result := StrPas(EncBuf);
  end
  else Result := '';
end;

procedure DecodeBuffer(src: AnsiString; buf: PAnsiChar; bufsize: Integer);
begin
  Decode6BitBuf(PAnsiChar(src), buf, length(src), bufsize);
end;


function EncodeMessage(sMsg: TDefaultMessage): AnsiString;
var
  TempBuf : array[0..63] of AnsiChar;
begin
  Encode6BitBuf(@sMsg, @TempBuf, Sizeof(TDefaultMessage), Sizeof(TempBuf));
  Result := StrPas(TempBuf);
end;


function EncodeString(str: AnsiString): AnsiString;
var
  EncBuf : array[0..MAX_ENCODE_BUFSIZE - 1] of AnsiChar;
begin
  Encode6BitBuf(PAnsiChar(str), @EncBuf, length(str), Sizeof(EncBuf));
  Result := StrPas(EncBuf);
end;


function EnCodeBuffer(buf: PAnsiChar; bufsize: Integer): AnsiString;
var
  TempBuf : array[0..MAX_ENCODE_BUFSIZE - 1] of AnsiChar;
begin
  if bufsize < MAX_ENCODE_BUFSIZE then
  begin
    Encode6BitBuf(buf, @TempBuf[0], bufsize, Sizeof(TempBuf));
    Result := StrPas(TempBuf);
  end
  else Result := '';
end;

end.
