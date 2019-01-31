unit Share;

interface

uses
  Windows, Classes, SysUtils;

const
  UM_DATA_LOCALLOG =	'cq_locallog'; //新版公共日志


  UM_DATA_ACTOR    =	'cq_actor';

  UM_USERNAME	     =	'gamestatic'; //用户名称
  UM_PASSWORD     	=	'xianhaiwangluo'; //密码

function Str_ToInt (Str: string; def: Longint): Longint;
function Str_ToInt64 (Str: string; def: Longint): Int64;
function ArrestStringEx(Source, SearchAfter, ArrestBefore: string; var ArrestStr: string): string;
function GetValidStr3 (Str: string; var Dest: string; const Divider: array of Char): string;

implementation


function Str_ToInt (Str: string; def: Longint): Longint;
begin
   Result := def;
   if Str <> '' then begin
      if ((word(Str[1]) >= word('0')) and (word(str[1]) <= word('9'))) or
         (str[1] = '+') or (str[1] = '-') then
         try
            Result := StrToInt (Str);
         except
         end;
   end;
end;

function Str_ToInt64 (Str: string; def: Longint): Int64;
begin
   Result := def;
   if Str <> '' then begin
      if ((word(Str[1]) >= word('0')) and (word(str[1]) <= word('9'))) or
         (str[1] = '+') or (str[1] = '-') then
         try
            Result := StrToInt64 (Str);
         except
         end;
   end;
end;

function ArrestStringEx(Source, SearchAfter, ArrestBefore: string; var
  ArrestStr: string): string;
var
  srclen   : Integer;
  GoodData : Boolean;
  i, n  : Integer;
begin
  ArrestStr := '';                                          {result string}
  if Source = '' then
  begin
    Result := '';
    exit;
  end;

  try
    srclen := Length(Source);
    GoodData := False;
    if srclen >= 2 then
      if Source[1] = SearchAfter then
      begin
        Source := Copy(Source, 2, srclen - 1);

        srclen := Length(Source);
        GoodData := True;
      end
      else
      begin
        n := Pos(SearchAfter, Source);
        if n > 0 then
        begin
          Source := Copy(Source, n + 1, srclen - (n));

          srclen := Length(Source);
          GoodData := True;
        end;
      end;
    if GoodData then
    begin
      n := Pos(ArrestBefore, Source);
      if n > 0 then
      begin
        ArrestStr := Copy(Source, 1, n - 1);
         Result := Copy(Source, n + 1, srclen - n);
      end
      else
      begin
        Result := SearchAfter + Source;
      end;
    end
    else
    begin
      for i := 1 to srclen do
      begin
        if Source[i] = SearchAfter then
        begin
          Result := Copy(Source, i, srclen - i + 1);
          break;
        end;
      end;
    end;
  except
    ArrestStr := '';
    Result := '';
  end;
end;

function GetValidStr3 (Str: string; var Dest: string; const Divider: array of Char): string;
const
   BUF_SIZE = 20480; //$7FFF;
var
	Buf: array[0..BUF_SIZE] of char;
   BufCount, Count, SrcLen, I, ArrCount: Longint;
   Ch: char;
label
	CATCH_DIV;
begin
   try
      SrcLen := Length(Str);
      BufCount := 0;
      Count := 1;
      Ch := #0;

      if SrcLen >= BUF_SIZE-1 then begin
         Result := '';
         Dest := '';
         exit;
      end;

      if Str = '' then begin
         Dest := '';
         Result := Str;
         exit;
      end;
      ArrCount := sizeof(Divider) div sizeof(char);

      while TRUE do begin
         if Count <= SrcLen then begin
            Ch := Str[Count];
            for I:=0 to ArrCount- 1 do
               if Ch = Divider[I] then
                  goto CATCH_DIV;
         end;
         if (Count > SrcLen) then begin
            CATCH_DIV:
            if (BufCount > 0) then begin
               if BufCount < BUF_SIZE-1 then begin
                  Buf[BufCount] := #0;
                  Dest := string (Buf);
                  Result := Copy (Str, Count+1, SrcLen-Count);
               end;
               break;
            end else begin
               if (Count > SrcLen) then begin
                  Dest := '';
                  Result := Copy (Str, Count+2, SrcLen-1);
                  break;
               end;
            end;
         end else begin
            if BufCount < BUF_SIZE-1 then begin
               Buf[BufCount] := Ch;
               Inc (BufCount);
            end;// else
               //ShowMessage ('BUF_SIZE overflow !');
         end;
         Inc (Count);
      end;
   except
      Dest := '';
      Result := '';
   end;
end;


end.
