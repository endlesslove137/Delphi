unit FuncUtil;

interface

uses Windows, SysUtils, Classes, Registry, ShlObj;

const
  HexCharTable : array [0..15] of Char
    = ( '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' );

type
  TQSortCallBack = function (lpData1, lpData2: Pointer): Integer;
                       
procedure RaiseLastError;overload;
procedure RaiseLastError(sExtMsg: string);overload;
function GetMinValueIndex(Values:array of Integer):Integer;
function GetMaxValueIndex(Values:array of Integer):Integer;
function MinValue(Values: array of Integer):Integer;
function MaxValue(Values: array of Integer):Integer;
function SearchBmpFilesInDirectory(const Root: string; var SL: TStrings):Integer;
function SearchDirectory(const Root: string; var SL: TStrings):Integer;
function DeepSearchFiles(const Root, sFilter: string; var SL: TStrings):Integer;
function FillStrL(Src: string; ALen: Integer; FillStr: string):string;
function FillStrR(Src: string; ALen: Integer; FillStr: string):string;
function GetRealFileName(sFileName: string):string;
function DeleteFileExt(FileName: string):string;
procedure RegFileType(DefExt,DefFileType,DefFileInfo,ExeName:string;
                          IcoIndex:integer;
                          DoUpdate:boolean=false);
function GetFileVersionString(const FileName: string): string;
function StrLTrim(s: string): string;
function CompareStrN(s1, s2: string; nLen: Integer): Boolean;
function CompareTextN(s1, s2: string; nLen: Integer): Boolean;
{TrimNumber: "0000 XXX" --> "XXX"}
function TrimNumber(s: string): string;
function GetMiddleStr(sText: string; sBefore, sAfter: string): string;   
function UnEscapeCString(s: string): string;
function strchr(s: PChar; tag: Char): PChar;assembler;
function strichr(s: PChar; tag: Char): PChar;assembler;
function stristr(s: PChar; tag: PChar): PChar;assembler;   
function strnistr(s: PChar; tag: PChar; size: Integer): PChar;assembler;
{通配符对比 *a*b**c(连续两个'*'用于匹配一个*) }
function WildcardCompare(S, sWildCards: string): Boolean;
function DeleteDirectory(sDir: string):Integer;
function EmptyDirectory(sDir: string):Integer;
function FormatSizeStr(dwSize: UInt64):string;
function GetFileSize(const sFile: string): Int64;
function GetPathName(var sPath: string): string;    
function GetParentDirectory(sPath: string): string;    
function ExtRactDirectoryName(sPath: string): string;
function ShortPathNameToFullPathName(sFileName: string): string;  
{*整理文件路径"abc//def\g" --> "abc/def/g"*}
function ArrangeFileName(sFileName: string; Delimiter: Char = '/'): string;  
{*整理路径"abc//def\g" --> "abc/def/g/"*}
function ArrangePath(sPath: string; Delimiter: Char = '/'): string;
function GetShortFileName(sFileName: string): string;
function GetSystemTempDir(): string;
procedure StepCreateFloders(sBaseDir: string; sDir: string);
function SetDirectoryModTime(FileName: string; ModTime: TFileTime): Boolean;
function GetModuleFilePath(hMod: HModule): string;
function ExtractFilePath(S: string): string;
function BinaryToStr(lpData: pByte; dwSize: DWord): string;
function StrToBinary(s: string; lpData: pByte; dwSize: DWord): DWord;
procedure qsort(lpData: Pointer; nDataSize, nCount: Integer; Compare:TQSortCallBack);
procedure PointerSwap(var a, b: Pointer);
function TickCountToStr(const dwTickCount: Cardinal): string;
function GetUrlFileName(const sUrl: string): string;

implementation
                   
procedure RaiseLastError;
begin
  raise Exception.CreateFmt('%d %s', [GetLastError, SysErrorMessage(GetLastError)]);
end;

procedure RaiseLastError(sExtMsg: string);
begin
  raise Exception.CreateFmt('%s'#13#10'%d %s',
    [sExtMsg, GetLastError, SysErrorMessage(GetLastError)]);
end;

function GetMinValueIndex(Values:array of Integer):Integer;
  var
    I, LowIndex, LowValue: Integer;
begin
    LowIndex  := Low(Values);
    LowValue  := Values[Low(Values)];
    for I := Low(Values) to High(Values) do
      begin
        if Values[I] < LowValue then
          begin
            LowValue  := Values[I];
            LowIndex  := I;
          end;
      end;
    Result  := LowIndex;
end;

function GetMaxValueIndex(Values:array of Integer):Integer;
  var
    K, MaxIndex, MaxValue: Integer;
begin
    MaxIndex  := Low(Values);
    MaxValue  := Values[Low(Values)];
    for K := Low(Values) to High(Values) do
      begin
        if Values[K] > MaxValue then
          begin
            MaxValue  := Values[K];
            MaxIndex  := K;
          end;
      end;
    Result  := MaxIndex;
end;

function MinValue(Values: array of Integer):Integer;
var
  I: Integer;
begin
  Result  := Values[Low(Values)];
  for I := Low(Values) to High(Values) do
    if Values[I] < Result then
      Result  := Values[I];
end;

function MaxValue(Values: array of Integer):Integer;
var
  I: Integer;
begin
  Result  := Values[Low(Values)];
  for I := Low(Values) to High(Values) do
    if Values[I] > Result then
      Result  := Values[I];
end;

function SearchBmpFilesInDirectory(const Root: string;
  var SL: TStrings):Integer;
var
  Sc: TSearchRec;
begin
  if FindFirst(Root + '\*.bmp', faAnyFile, Sc) = 0 then
    SL.Add(Root + '\' + Sc.Name);
  while FindNext(Sc) = 0 do
    SL.Add(Root + '\' + Sc.Name);
  FindClose(Sc);
  Result  := SL.Count;
end;

function FillStrL(Src: string; ALen: Integer; FillStr: string):string;
begin
  Result  := Src;
  while Length(Result) < ALen do
    Result  := FillStr + Result;
end;

function FillStrR(Src: string; ALen: Integer; FillStr: string):string; 
begin
  Result  := Src;
  while Length(Result) < ALen do
    Result  := Result + FillStr;
end;

function GetRealFileName(sFileName: string):string;
var
  I: Integer;
begin
  sFileName := ExtRactFileName(sFileName);
  for I := Length(sFileName) downto 1 do
  begin
    if sFileName[I] = '.' then
    begin
      Delete( sFileName, I, Length(sFileName) - I + 1 );
      break;
    end;
  end;
  Result := sFileName;
  {for I := Length(Result) downto 1 do
  begin
    if (Result[I] = '/') or (Result[I] = '\') then
    begin
      Result := Copy( Result, I + 1, Length(Result) - I );
      break;
    end;
  end;  }
end;

function SearchDirectory(const Root: string;
  var SL: TStrings):Integer;
var
  Sc: TSearchRec;
begin
  if FindFirst(Root + '\*.*', faAnyFile, Sc) = 0 then
  begin
    repeat
      if (Sc.Name <> '.') and (Sc.Name <> '..') then
      begin
        if Sc.Attr and faDirectory = faDirectory then
          SL.Add(Root + '\' + Sc.Name);
      end;
    until FindNext(Sc) <> 0;
    FindClose(Sc);
  end;
  Result  := SL.Count;
end;

function DeepSearchFiles(const Root, sFilter: string; var SL: TStrings):Integer;
var
  Sc: TSearchRec;
begin
  Result := 0;
  if FindFirst(Root + '\*.*', faAnyFile, Sc) = 0 then
  begin
    repeat
      if (Sc.Name = '.') then continue;
      if (Sc.Name = '..') then continue;
      if Sc.Attr and faDirectory = faDirectory then
      begin
        Result := Result + DeepSearchFiles(Root + '\' + Sc.Name, sFilter, SL )
      end
      else if CompareText(ExtractFileExt(Sc.Name), sFilter) = 0 then
      begin
        SL.Add(Root + '\' + Sc.Name);
        Inc( Result );
      end;
    until FindNext(Sc) <> 0;
    FindClose(Sc);
  end;
end;

function DeleteFileExt(FileName: string):string;
var
  I: Integer;
begin
  Result := '';
  for I := Length(FileName) downto 1 do
  begin
    if FileName[I] = '.' then
    begin
      Result := Copy(FileName, 1, I - 1 );
      break;
    end;
  end;
  if Result = '' then
  begin
    Result := FileName;
  end;
end;

procedure RegFileType(DefExt,DefFileType,DefFileInfo,ExeName:string;
                          IcoIndex:integer;
                          DoUpdate:boolean=false);
var
  Reg: TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_CLASSES_ROOT;
    Reg.OpenKey(DefExt, True);
    //写入自定义文件后缀
    Reg.WriteString('', DefFileType);
    Reg.CloseKey;
    //写入自定义的文件类型
    //格式为：HKEY_CLASSES_ROOT\cMyExt\(Default) = 'cMyFileType'

    //下面为该文件类型创建关联
    Reg.OpenKey(DefFileType, True);
    Reg.WriteString('', DefFileInfo);
    //写入文件类型的描述信息
    Reg.CloseKey;

    // 下面为自定义文件类型选择图标
    // 加入键格式为 HKEY_CLASSES_ROOT\cMyFileType\DefaultIcon
    //  \(Default) = 'Application Dir\Project1.exe,0'
    Reg.OpenKey(DefFileType + '\DefaultIcon', True);
    Reg.WriteString('', ExeName + ',' + IntToStr(IcoIndex));
    Reg.CloseKey;

    // 下面注册在资源管理器中打开文件的程序
    Reg.OpenKey(DefFileType + '\Shell\Open', True);
    Reg.WriteString('', '打开 (&O)');
    Reg.CloseKey;

    Reg.OpenKey(DefFileType + '\Shell\Edit', True);
    Reg.WriteString('', '使用'+ DefFileType+ '编辑 (&E)');
    Reg.CloseKey;

    Reg.OpenKey(DefFileType + '\Shell\Edit\Command', True);
    Reg.WriteString('', '"' + ExeName + '" "%1"');
    Reg.CloseKey;    
    
    //  格式：HKEY_CLASSES_ROOT\Project1.FileType\Shell\Open\Command
    //  (Default) = '"Application Dir\Project1.exe" "%1"'
    Reg.OpenKey(DefFileType + '\Shell\Open\Command', True);
    Reg.WriteString('', '"' + ExeName + '" "%1"');
    Reg.CloseKey;

    //最后，让资源管理器实现我们加入的文件类型，只需调用SHChangeNotify即可
    if DoUpdate then SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
  finally
    Reg.Free;
  end;
end;

function GetFileVersionString(const FileName: string): string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  Result := '0.0.0.0';

  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  try
    GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    with VerValue^ do
    begin
      dwProductVersionMS := dwFileVersionMS;
      dwProductVersionLS := dwFileVersionLS;
      Result :=Format('%d.%d.%d.%d', [
        dwProductVersionMS shr 16,
        dwProductVersionMS and $FFFF,
        dwProductVersionLS shr 16,
        dwProductVersionLS and $FFFF
        ]);
    end;
  finally
    FreeMem(VerInfo, VerInfoSize);
  end;
end;

function StrLTrim(s: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(s) do
  begin
    if Byte(s[I]) > $20 then
    begin
      Result := Copy( s, I, Length(S) - I + 1 );
      break;
    end;
  end;
end;

function CompareStrN(s1, s2: string; nLen: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if Length(s1) < nLen then
    Exit;
  if Length(s2) < nLen then
    Exit;
  for I := 1 to nLen do
  begin
    if s1[I] <> s2[I] then
      Exit;
  end;
  Result := True;
end;  

function CompareTextN(s1, s2: string; nLen: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if Length(s1) < nLen then
    Exit;
  if Length(s2) < nLen then
    Exit;

  for I := 1 to nLen do
  begin
    if (Byte(s1[I]) or $20) <> (Byte(s2[I]) or $20) then
      Exit;
  end;
  Result := True;
end;

function TrimNumber(s: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    if (s[I] >= '0') and (s[I] <= '9') then
      continue;
    if s[I] <= ' ' then
      continue;
    Result := Result + s[I];
  end;
end;

function GetMiddleStr(sText: string; sBefore, sAfter: string): string;
var
  nPos: Integer;
begin
  Result := '';
  nPos := Pos( sBefore, sText );
  if nPos > 0 then
  begin
    Delete( sText, 1, nPos + Length(sBefore) - 1 );
    nPos := Pos( sAfter, sText );
    if nPos > 1 then
    begin
      Result := Copy( sText, 1, nPos - 1 );
    end;
  end;
end;

function UnEscapeCString(s: string): string;
const
  OctalChars = ['0'..'7'];
  HexChars = ['0'..'9', 'A'..'F', 'a'..'f'];
var
  ptr: PChar;
  nChar, I: Integer;
begin
  Result := '';
  ptr := PChar(s);
	while (ptr[0] <> #0) do
  begin
		if ( ptr[0] = '\' ) then
		begin
			Inc(ptr);
			case ptr[0] of
        'a': begin	//\a 响铃(BEL) 007
          Result := Result + #$07;
				end;
        'b': begin	//\b 退格(BS) 008
				  Result := Result + #$08;
				end;
			  'f': begin	//\f 换页(FF) 012
				  Result := Result + #$0C;
				end;
			  'n': begin	//\n 换行(LF) 010
				  Result := Result + #$0A;
				end;
			  'r': begin	//\r 回车(CR) 013
				  Result := Result + #$0D;
				end;
			  't': begin	//\t 水平制表(HT) 009
				  Result := Result + #$09;
				end;
			  'v': begin	//\v 垂直制表(VT) 011
				  Result := Result + #$0B;
				end;
			  '\': begin	//\\ 反斜杠 092
				  Result := Result + #$5C;
				end;
			  '?': begin	//\? 问号字符 063
				  Result := Result + #$3F;
				end;
			  '''':	begin//\' 单引号字符 039
				  Result := Result + #$27;
				end;
			  '"': begin	//\" 双引号字符 034
				  Result := Result + #$22;
				end;
			  '0'..'7':begin//(\0 空字符(NULL) 000) (\ddd 任意字符 三位八进制)
					nChar := Ord(ptr[0]) - Ord('0');
          for I := 1 to 2 do
          begin
            if (ptr[1] in OctalChars) then
            begin
              nChar := nChar shl 3;
              nChar := nChar + Ord(ptr[1]) - Ord('0');
              Inc(ptr);
            end
            else Break;
          end;
					if (nChar <= $FF) then
          begin
            Result := Result + Chr(nChar);
          end;
				end;
			  'x': begin	//\xhh 任意字符 二位十六进制
          Inc(ptr);
          if (ptr[0] in HexChars) then
          begin
            if (ptr[0] < '9') then
              nChar := Ord(ptr[0]) - Ord('0')
            else nChar := (Ord(ptr[0]) and $5F) - Ord('A') + 10;
						if (ptr[1] in HexChars) then
            begin
              Inc(ptr);
              nChar := nChar shl 4;
              if (ptr[0] < '9') then
                nChar := nChar + Ord(ptr[0]) - Ord('0')
              else nChar := nChar + (Ord(ptr[0]) and $5F) - Ord('A') + 10;
            end;        
            Result := Result + Chr(nChar);
          end;
        end;
        else begin
          //invalid escape token
        end;
      end;
    end
    else begin
      Result := Result + ptr[0];
    end;    
    Inc(ptr);
  end;
end;

function strchr(s: PChar; tag: Char): PChar;assembler;
asm
        DEC   EAX
@@1:
        INC   EAX
        MOV   CL, BYTE PTR[EAX]
        TEST  CL, CL
        JZ    @@2
        CMP   CL, DL
        JNZ   @@1
        RET
@@2:
        XOR   EAX, EAX
end;    

function strichr(s: PChar; tag: Char): PChar;assembler;
asm
        DEC   EAX
        OR    DL, $20   //make lower
@@1:
        INC   EAX
        MOV   CL, BYTE PTR[EAX]
        TEST  CL, CL
        JZ    @@2
        OR    CL, $20   //make lower
        CMP   CL, DL
        JNZ   @@1
        RET
@@2:
        XOR   EAX, EAX
end;

function stristr(s: PChar; tag: PChar): PChar;assembler;
asm
        MOV   EDI, EAX
@@1:
        MOV   CH, BYTE PTR[EDX]
        TEST  CH, CH
        JNZ   @@2
        RET

@@2:
        INC   EDX
        OR    CH, $20   //make lower
@@3:
        MOV   CL, BYTE PTR[EDI]
        TEST  CL, CL
        JZ    @@4
        INC   EDI

        OR    CL, $20   //make lower
        CMP   CL, CH
        JZ    @@1
        MOV   EAX, EDI
        JMP   @@3
@@4:
        XOR   EAX, EAX
end;       

function strnistr(s: PChar; tag: PChar; size: Integer): PChar;assembler;
asm
        PUSH  EBX
        MOV   EBX, size
        MOV   EDI, EAX
@@1:
        TEST  EBX, 0FFFFFFFFh
        JNZ   @@101
        POP   EBX
        RET
@@101:
        DEC   EBX
        MOV   CH, BYTE PTR[EDX]
        TEST  CH, CH
        JNZ   @@2   
        POP   EBX
        RET

@@2:
        INC   EDX
        OR    CH, $20   //make lower
@@3:
        MOV   CL, BYTE PTR[EDI]
        TEST  CL, CL
        JZ    @@4
        INC   EDI

        OR    CL, $20   //make lower
        CMP   CL, CH
        JZ    @@1
        MOV   EAX, EDI
        JMP   @@3
@@4:
        XOR   EAX, EAX   
        POP   EBX
end;

function WildcardCompare(S, sWildCards: string): Boolean;
var
  sptr, swild, stag: PChar;
  nlen, nlen2: Integer;
begin
  Result := False;

  sptr := PChar(S);
  swild := PChar(sWildCards);
  while True do
  begin
    if swild[0] = '*' then
    begin
      //'*'  -->  仅仅星号，匹配任何字符
      if swild[1] = #0 then
      begin
        Result := True;
        break;
      end;

      //查找下一个星号
      Inc( swild );
      stag := strchr( swild, '*' );
      if stag = swild then Inc( stag );//连续两个'*'用于匹配一个*

      if stag = nil then
      begin                
        //'*abc' ---> '*'号后面不再有'*'号则对比abc
        nlen := StrLen( sptr );
        nlen2:= StrLen( swild );
        if nlen >= nlen2 then
        begin
          Inc( sptr, nlen - nlen2 );  
          if StrIComp( sptr, swild ) = 0 then Result := True;
        end;
        break;
      end;

      //'*abc*' ---> '*'号后面还有'*'号则对比下一个星号之前的abc
      sptr := strnistr( sptr, swild, stag - swild );
      if sptr = nil then break;
      Inc( sptr, stag - swild );


      swild := stag;
    end
    else begin   
      //查找下一个星号
      stag := strchr( swild, '*' );    
      if stag = nil then
      begin
        //没有'*'号则对比字符串
        if StrIComp( sptr, swild ) = 0 then Result := True;
        break;
      end;

      //'abc*' --->  有'*'号则对比字符串开头
      if StrLIComp( sptr, swild, stag - swild ) <> 0 then break;
      Inc( sptr, stag - swild );

      swild := stag;
    end;
  end; 
end;

function DeleteDirectory(sDir: string):Integer;
var
  Sc: TSearchRec;
begin
  Result := 0;
  try
    if FindFirst(sDir + '\*', faAnyFile, Sc) = 0 then
    begin
      if (Sc.Name <> '.') and (Sc.Name <> '..' ) then
      begin
        if Sc.Attr and faDirectory = faDirectory then
        begin
          Result := Result + DeleteDirectory( sDir + '\' + Sc.Name );
        end
        else begin
          if DeleteFile( sDir + '\' + Sc.Name ) then
            Inc( Result )
          else Raise Exception.Create('无法删除文件:' + ExpandFileName(sDir + '\' + Sc.Name) );
        end;
      end;
    end;
    while FindNext(Sc) = 0 do
    begin
      if (Sc.Name <> '.') and (Sc.Name <> '..' ) then
      begin
        if Sc.Attr and faDirectory = faDirectory then
        begin
          Result := Result + DeleteDirectory( sDir + '\' + Sc.Name );
        end
        else begin
          if DeleteFile( sDir + '\' + Sc.Name ) then
            Inc( Result )
          else Raise Exception.Create('无法删除文件:' + ExpandFileName(sDir + '\' + Sc.Name) );
        end;
      end;
    end;
  finally
    FindClose( Sc );
  end;
  
  if RemoveDir( sDir ) then
    Inc( Result )
  else Raise Exception.Create('无法删除目录:' + ExpandFileName(sDir + '\' + Sc.Name) );
end;      

function EmptyDirectory(sDir: string):Integer;
var
  Sc: TSearchRec;
begin
  Result := 0;
  try
    if FindFirst(sDir + '\*', faAnyFile, Sc) = 0 then
    begin
      if (Sc.Name <> '.') and (Sc.Name <> '..' ) then
      begin
        if Sc.Attr and faDirectory = faDirectory then
        begin
          Result := Result + DeleteDirectory( sDir + '\' + Sc.Name );
        end
        else begin
          if DeleteFile( sDir + '\' + Sc.Name ) then
            Inc( Result )
          else Raise Exception.Create('无法删除文件:' + ExpandFileName(sDir + '\' + Sc.Name) );
        end;
      end;
    end;
    while FindNext(Sc) = 0 do
    begin
      if (Sc.Name <> '.') and (Sc.Name <> '..' ) then
      begin
        if Sc.Attr and faDirectory = faDirectory then
        begin
          Result := Result + DeleteDirectory( sDir + '\' + Sc.Name );
        end
        else begin
          if DeleteFile( sDir + '\' + Sc.Name ) then
            Inc( Result )
          else Raise Exception.Create('无法删除文件:' + ExpandFileName(sDir + '\' + Sc.Name) );
        end;
      end;
    end;
  finally
    FindClose( Sc );
  end;
end;

function FormatSizeStr(dwSize: UInt64):string;
const
  SizeOfKB : UInt64 = 1024;
  SizeOfMB : UInt64 = 1024 * 1024;
  SizeOfGB : UInt64 = 1024 * 1024 * 1024;
var
  sDicemil: string;
begin
  if dwSize >= SizeOfGB * 1024 then
  begin
    Result := IntToStr(dwSize div (SizeOfGB * 1024));
    dwSize := dwSize mod (SizeOfGB * 1024);
    if dwSize >= SizeOfGB then
    begin
      sDicemil := FloatToStr(dwSize / (SizeOfGB * 1024));
      sDicemil := Copy( sDicemil, 2, 3 );
      Result := Result + sDicemil + 'TB'
    end
    else Result := Result + 'TB';
  end
  else if dwSize >= SizeOfGB then
  begin
    Result := IntToStr(dwSize div SizeOfGB);
    dwSize := dwSize mod SizeOfGB;
    if dwSize >= SizeOfMB then
    begin
      sDicemil := FloatToStr(dwSize / SizeOfGB);
      sDicemil := Copy( sDicemil, 2, 3 );
      Result := Result + sDicemil + 'GB'
    end
    else Result := Result + 'GB';
  end
  else if dwSize >= SizeOfMB then
  begin
    Result := IntToStr(dwSize div SizeOfMB);
    dwSize := dwSize mod SizeOfMB;
    if dwSize >= SizeOfKB then
    begin
      sDicemil := FloatToStr(dwSize / SizeOfMB);
      sDicemil := Copy( sDicemil, 2, 3 );
      Result := Result + sDicemil + 'MB'
    end
    else Result := Result + 'MB';
  end
  else if dwSize >= SizeOfKB then
  begin
    Result := IntToStr(dwSize div SizeOfKB);
    dwSize := dwSize mod SizeOfKB;
    if dwSize >= 0 then
    begin
      sDicemil := FloatToStr(dwSize / SizeOfKB);
      sDicemil := Copy( sDicemil, 2, 3 );
      Result := Result + sDicemil + 'KB'
    end
    else Result := Result + 'KB';
  end
  else Result := IntToStr(dwSize) + 'B';
end;    

function GetFileSize(const sFile: string): Int64;
var
  FileAttrData: TWin32FileAttributeData;
begin
  FileAttrData.nFileSizeLow := 0;
  FileAttrData.nFileSizeHigh := 0;
  if FileExists(sFile) then
  begin
    GetFileAttributesEx( PChar(sFile), GetFileExInfoStandard, @FileAttrData );
  end;
  Result := Int64(FileAttrData.nFileSizeLow)
    or (Int64(FileAttrData.nFileSizeHigh) shl 32);
end;

function GetPathName(var sPath: string): string;
var
  I, nNeedDelete: Integer;
begin
  Result := '';
  nNeedDelete := 0;
  for I := 1 to Length(sPath) do
  begin            
    Inc( nNeedDelete );
    if (sPath[I] = '/') or (sPath = '\') then
    begin
      if (I > 1) and (Length(Result) > 0) then
        break;
    end
    else Result := Result + sPath[I];
  end;
  if nNeedDelete > 0 then
  begin
    Delete( sPath, 1, nNeedDelete );
  end;
end;

function GetParentDirectory(sPath: string): string;
var
  I: Integer;
begin
  Result := '';
  I := Length(sPath);
  while I > 0 do
  begin
    if (sPath[I] = '/') or (sPath[I] = '\') then
    begin
      Dec( I );
    end
    else break;
  end;

  while I > 0 do
  begin
    if (sPath[I] <> '/') and (sPath[I] <> '\') then
    begin
      Dec( I );
    end
    else break;
  end;

  if I > 0 then
  begin
    Result := Copy( sPath, 1, I );
  end;
end;

function ExtRactDirectoryName(sPath: string): string;
var
  I: Integer;
begin
  Result := '';
  I := Length(sPath);
  while I > 0 do
  begin
    if (sPath[I] = '/') or (sPath[I] = '\') then
    begin
      Dec( I );
    end
    else break;
  end;

  while I > 0 do
  begin
    if (sPath[I] <> '/') and (sPath[I] <> '\') then
    begin
      Result := sPath[I] + Result;
      Dec( I );
    end
    else break;
  end;
end;

function ShortPathNameToFullPathName(sFileName: string): string;
var
  sDir: string;
  nPos: Integer;
  Sc: TSearchRec;
begin
  Result := '';
  while True do
  begin
    nPos := Pos('\', sFileName);
    if nPos > 0 then
    begin
      sDir := Copy(sFileName, 1, nPos - 1);
      Delete(sFileName, 1, nPos);
      if FindFirst(Result + '\' + sDir, faAnyFile, Sc) = 0 then
      begin
        Result := Result + '\' + Sc.Name;
        FindClose(Sc);
      end
      else if Pos(':', sDir) > 0 then
      begin
        Result := sDir;
      end
      else begin
        Result := sFileName;
        exit;
      end;
    end
    else break;
  end;
  if FindFirst(Result + '\' + sFileName, faAnyFile, Sc) = 0 then
  begin
    Result := Result + '\' + Sc.Name;
    FindClose(Sc);
  end
  else Result := Result + '\' + sFileName;
end;

function ArrangeFileName(sFileName: string; Delimiter: Char): string;
var
  nIdx, nLen: Integer;
begin
  Result := '';
  nIdx := 1;
  nLen := Length(sFileName);
  while nIdx <= nLen do
  begin
    if (sFileName[nIdx] = '/') or (sFileName[nIdx] = '\') then
    begin
      Result := Result + Delimiter;
      Inc( nIdx );    
      while nIdx <= nLen do
      begin
        if (sFileName[nIdx] <> '/') and (sFileName[nIdx] <> '\') then
          break;
        Inc( nIdx );
      end;
    end
    else begin
      Result := Result + sFileName[nIdx];
      Inc( nIdx );
    end;
  end;
end;

function ArrangePath(sPath: string; Delimiter: Char): string;
begin
  Result := ArrangeFileName(sPath, Delimiter);
  if (Result <> '') then
  begin
    if Result[Length(Result)] <> Delimiter then
      Result := Result + Delimiter;
  end;
end;

function GetShortFileName(sFileName: string): string;
var
  iLen: Integer;
  sPath: array [0..MAX_PATH] of Char;
begin
  Windows.GetShortPathName( PChar(sFileName), sPath, sizeof(sPath) - 1 );
  iLen := sizeof(sPath)-1;
  sPath[iLen] := #0;
  Result := StrPas( sPath );
end;

function GetFloderName(var sFloder: string): string;
var
  nIndex, nLen: Integer;
begin
  Result := '';

  nIndex := 1;
  nLen := Length(sFloder);
  while nIndex <= nLen do
  begin
    if (sFloder[nIndex] <> '/') and (sFloder[nIndex] <> '\') then
      break;
    Inc(nIndex);
  end;
  while nIndex <= nLen do
  begin
    if (sFloder[nIndex] = '/') or (sFloder[nIndex] = '\') then
      break;
    Result := Result + sFloder[nIndex];   
    Inc(nIndex);
  end;
  if nIndex > 1 then
  begin
    Delete( sFloder, 1, nIndex );
  end;
end;

procedure StepCreateFloders(sBaseDir: string; sDir: string);
begin
  while sDir <> '' do
  begin
    sBaseDir := sBaseDir + '\' + GetFloderName( sDir );
    if not DirectoryExists(sBaseDir)
    and not CreateDir(sBaseDir) then
    begin
      Raise Exception.CreateFmt('Can not create directory :%s', [ExpandFileName(sBaseDir)]);
    end;
  end;
end;

function SetDirectoryModTime(FileName: string; ModTime: TFileTime): Boolean;
var
  hFile: THandle;
begin
  hFile := CreateFile (PChar(FileName), GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_DELETE,
    nil, OPEN_EXISTING,
    FILE_FLAG_BACKUP_SEMANTICS, 0);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    Result := SetFileTime( hFile, nil, nil, @ModTime );
    CloseHandle( hFile );
  end
  else Result := False;
end;

function GetSystemTempDir(): string;
var
  szPath: array [0..1023] of Char;
begin
  GetTempPath( sizeof(szPath), @szPath[0] );
  Result := StrPas( szPath );
end;

function GetModuleFilePath(hMod: HModule): string;
var
  szName: array [0..1023] of Char;
begin
  Windows.GetModuleFileName( hMod, @szName[0], sizeof(szName) );
  Result := StrPas( szName );
end;

function ExtractFilePath(S: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := Length(S) downto 1 do
  begin
    if (S[I] = '/') or (S[I] = '\') then
    begin
      Result := Copy( S, 1, I );
      break;
    end;
  end;
end;

function BinaryToStr(lpData: pByte; dwSize: DWord): string;
var
  P: PChar;
begin
  SetLength( Result, dwSize * 2 );
  P := @Result[1];
  while dwSize > 0 do
  begin
    P^ := HexCharTable[lpData^ shr 4];
    Inc( P );
    P^ := HexCharTable[lpData^ and $F];  
    Inc( P );
    Inc( lpData );        
    Dec( dwSize );
  end;
end;

function StrToBinary(s: string; lpData: pByte; dwSize: DWord): DWord;
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

procedure qsort(lpData: Pointer; nDataSize, nCount: Integer; Compare:TQSortCallBack);
var
  I, Index, Value: Integer;
  pCur, pTarget: PByte;
  TempData: array [0..2047] of Char;
begin              
  if nCount > sizeof(TempData) then Exit;
  
  I := 1;
  while I < nCount  do
  begin
    Index := I - 1;
    pCur := lpData;
    Inc( pCur, I * nDataSize );
    pTarget := lpData;
    Inc( pTarget, Index * nDataSize );

    Value := Compare( pCur, pTarget );
    if Value <> 0 then
    begin
      if Value < 0 then
      begin
        if Index > 0 then
        begin
          repeat
            Dec( Index );
            Dec( pTarget, nDataSize );
          until (Index < 0) or (Compare( pCur, pTarget ) >= 0);
          Inc( Index );
        end;
      end
      else begin
        if Index < nCount - 1 then
        begin     
          Inc( Index );
          repeat
            Inc( Index );    
            Inc( pTarget, nDataSize );
          until (Index >= nCount) or (Compare( pCur, pTarget ) <= 0);
          Dec( Index );
        end;
      end;  
      if I <> Index then
      begin               
        pTarget := lpData;
        Inc( pTarget, Index * nDataSize );
        Move( pTarget^, TempData[0], nDataSize );
        Move( pCur^, pTarget^, nDataSize );
        Move( TempData[0], pCur^, nDataSize );
      end
      else Inc( I );
    end
    else Inc( I );
  end;
end;

procedure PointerSwap(var a, b: Pointer);
var
  Temp: Pointer;
begin
  Temp := a;
  a := b;
  b := Temp;
end;

function TickCountToStr(const dwTickCount: Cardinal): string;
const
  ASecTick          = 1000;
  AMinTick          = ASecTick * 60;
  AHourTick         = AMinTick * 60;
  ADaysTick         = AHourTick * 24;
var
  nD, nH, nM, nS    : Integer;
  TickCount         : Cardinal;
  sTime             : string;
begin
  nD := 0;
  nH := 0;
  nM := 0;
  nS := 0;
  TickCount := dwTickCount;
  while TickCount > ADaysTick do
  begin
    Inc(nD);
    Dec(TickCount, ADaysTick);
  end;
  while TickCount > AHourTick do
  begin
    Inc(nH);
    Dec(TickCount, AHourTick);
  end;
  while TickCount > AMinTick do
  begin
    Inc(nM);
    Dec(TickCount, AMinTick);
  end;
  while TickCount > ASecTick do
  begin
    Inc(nS);
    Dec(TickCount, ASecTick);
  end;
  sTime := IntToStr(nS) + '秒';
  if (nM > 0) or (nH > 0) or (nD > 0) then
    Insert(IntToStr(nM) + '分', sTime, 0);
  if (nH > 0) or (nD > 0) then
    Insert(IntToStr(nH) + '小时', sTime, 0);
  if (nD > 0) then
    Insert(IntToStr(nD) + '天', sTime, 0);
  Result := sTime;
end;

function GetUrlFileName(const sUrl: string): string;
var
  I: Integer;
begin
  Result := 'default';
  for I := Length(sUrl) downto 1 do
  begin
    if (sUrl[i] = '/') or (sUrl[i] = '\') then
    begin
      Result := Copy( sUrl, i + 1, Length(sUrl) - i );
      break;
    end; 
  end;
end;

end.
