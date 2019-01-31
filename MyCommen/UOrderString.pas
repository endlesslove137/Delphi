////////////////////////////////////////////////////////
///                 Announce                        ////
///      Author: 张明明/zmm                         ////
///      QQ    : 378982719                          ////
///      Email : 378982719@qq.com                   ////
///                                                 ////
///      Power by zmm  20100713                     ////
///                                                 ////
////////////////////////////////////////////////////////


unit UOrderString;

interface

uses classes,sysutils,Dialogs,controls, variants;
//Remove chinese characters
procedure DC(var StrSource: string);
//Judgement is not a chinese character
function IsMBCSChar(const ch: char): boolean;
//is include figures?
function IsNumeric(AStr: string): boolean;
{$IFDEF   VER150}
// Get Date from string
function GetDate(var str: String): Tdate;
{$ENDIF}
// Get index of chinese character in the Strsource
function ChineseIndexIInString(var StrSource:string):integer;
// Get a list of string split by Ch
function SplitString(const Source, ch: string): TStringList;

procedure StringlistDistinctItems(var Stringlist:tstringlist);

// 将全角转换为半角
function ToDBC(input: String): WideString;
function GetlistBySplit(const Source, Strartch, EndCh: string): TStringList;
// 从字符串里取 在 EndCh 和  EndCh 间的数据 返回
function GetlistAfterDel(const Source, Strartch, EndCh: string): string;


implementation

procedure VariantToStream(const Data: OleVariant; Stream: TStream);
var
  P: Pointer;
begin
  P := VarArrayLock(Data);
  try
    Stream.Write(P^, VarArrayHighBound(Data, 1) + 1);
    Stream.Position := 0;
  finally
    VarArrayUnlock(Data);
  end;
end;

function StreamToVariant(Stream: TStream): OleVariant;
var
  P: Pointer;
begin
  Result := VarArrayCreate([0, Stream.Size - 1], varByte);
  P := VarArrayLock(Result);
  try
    Stream.Position := 0;
    Stream.Read(P^, Stream.Size);
    Stream.Position := 0;
  finally
    VarArrayUnlock(Result);
  end;
end;

// 将全角转换为半角
function ToDBC(input: String): WideString;
var
  c: WideString;
  i: integer;
begin
  c := input;
  for i := 1 to length(input) do
  begin
    if (Ord(c[i]) = 12288) then
    begin
      c[i] := chr(32);
      Continue;
    end;
    if (Ord(c[i]) > 65280) and (Ord(c[i]) < 65375) then
      c[i] := WideChar(chr(Ord(c[i]) - 65248));
    if (Ord(c[i]) = 10005) or (c[i] = '*') or (Ord(c[i]) = 215) then
    begin
      c[i] := 'x';
    end;
  end;
  result := c;
end;

// 从字符串里取 在 EndCh 和  EndCh 间的数据 返回
function GetlistAfterDel(const Source, Strartch, EndCh: string): string;
var
  StrTemp, str1: String;
  i, p1, p2: integer;
begin
  StrTemp := Source;
//  StrTemp := stringreplace(Source,#13#10, '',[rfreplaceall]);
  while True do
  begin
    p1 := Pos( Strartch, StrTemp );
    if p1<1 then Break;
    p2 := Pos( EndCh, StrTemp );
    if p2<1 then Break;
    if p2 < p1 then
    begin
      System.Delete(StrTemp, p2, Length(EndCh));
      Continue;
    end;
    System.Delete(StrTemp, p1, p2-p1 +1 );
  end;
  Result := StrTemp;
end;

function GetValueBySpecial(const Source: TStringList; const SpecialStr, TrueValue, FalseValue: string): TStringList;
var
  StrTemp, str1: String;
  i, p1, p2: integer;
  SplitList : TStrings;
begin
//  SplitList := SplitString(SpecialStr, ',');
//  Result := TStringList.Create;
////  StrTemp := stringreplace(Source,#13#10, '',[rfreplaceall]);
//  for I := 0 to Source.Count do
//  begin
//
//  end;
//
//
//  while True do
//  begin
//    p1 := Pos( SpecialStr, StrTemp );
//    if p1<1 then Break;
//
//
//    p2 := Pos( EndCh, StrTemp );
//    if p2<1 then Break;
//    if p2 < p1  then
//    begin
//      System.Delete(StrTemp, p2, length(EndCh) );
//      Continue;
//    end;
//
//
//    str1 := Copy(StrTemp, p1+1, p2-p1 - 1);
//    Result.add(str1);
//    System.Delete(StrTemp, p1, p2-p1 +1 );
////    System.Insert(',',text ,p1);
////    System.inser
//  end;
end;


// 从字符串里取 在 EndCh 和  EndCh 间的数据 返回
function GetlistBySplit(const Source, Strartch, EndCh: string): TStringList;
var
  StrTemp, str1: String;
  i, p1, p2: integer;
begin
  Result := TStringList.Create;
  StrTemp :=  Source;
  while True do
  begin
    p1 := Pos( Strartch, StrTemp );
    if p1<1 then Break;


    p2 := Pos( EndCh, StrTemp );
    if p2<1 then Break;
    if p2 < p1  then
    begin
      System.Delete(StrTemp, p2, length(EndCh) );
      Continue;
    end;
    

    str1 := Copy(StrTemp, p1+1, p2-p1 - 1);
    Result.add(str1);
    System.Delete(StrTemp, p1, p2-p1 +1 );
  end;
end;


function SplitString(const Source, ch: string): TStringList;
var
  sources,temp: String;
  i: integer;
begin
  sources:=stringreplace(Source,' ','',[rfreplaceall]);
  Result := TStringList.Create;
  // 如果是空自符串则返回空列表
  if Source = '' then
    exit;
  temp := stringreplace(Sources,' ','',[rfreplaceall]);
  i := pos(ch, Sources);
  while i <> 0 do
  begin
    Result.add(copy(temp, 0, i - 1));
    DELETE(temp, 1, i);
    i := pos(ch, temp);
  end;
  Result.add(temp);
end;


procedure DC(var StrSource: string);
var
  Sl, ci: integer;
begin
  ci := 0;
  Sl := length(StrSource);
  while ci <= Sl do
  begin
    if ((Word(StrSource[ci]) >= $3447) and (Word(StrSource[ci]) <= $FA29)) then
      StrSource := stringreplace(StrSource, StrSource[ci], ' ', [rfreplaceall]);
    ci := ci + 1;
  end;
  StrSource := stringreplace(StrSource, ' ', '', [rfreplaceall]);
end;

// 判断字符是否汉字
function IsMBCSChar(const ch: char): boolean;
begin
  // Result := (ByteType(ch, 1) <> mbSingleByte);
  result := (Word(ch) >= $3447) and (Word(ch) <= $FA29);
end;

function IsNumeric(AStr: string): boolean;
var
  Value: Double;
  Code: integer;
begin
  Val(AStr, Value, Code);
  result := Code = 0;
end;

{$IFDEF   VER150}
function GetDate(var str: String): Tdate;
begin
try
  str := ExtractFilename(str);
  str := stringreplace(str, 'xls', '', [rfreplaceall]);
  DC(str);
  str := stringreplace(str, '.', '', [rfreplaceall]);
  result := strtodate(str);  
except on E: Exception do
 // ShowMessage(e.Message);
end;
end;
{$endif}

function ChineseIndexIInString(var StrSource:string):integer;
var
  Sl, ci: integer;
begin
  result:=0;
  ci := 0;
  Sl := length(StrSource);
  while ci <= Sl do
  begin
    if ((Word(StrSource[ci]) >= $3447) and (Word(StrSource[ci]) <= $FA29)) then
    begin
     result:=ci;
     break;
    end
    else ci := ci + 1;
  end;
end;

procedure StringlistDistinctItems(var Stringlist:tstringlist);
var
 i:integer;
begin
  if stringlist.Count<0 then exit;
  stringlist.Sort;
  for i :=stringlist.Count-1  downto 1 do
  begin
    if stringlist[i]=stringlist[i-1] then
    stringlist.Delete(i);
  end;
end;

end.
