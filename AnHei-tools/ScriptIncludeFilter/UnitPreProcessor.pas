unit UnitPreProcessor;

(****************************************************************

                   通用LUA脚本文本内容预处理器

    由于LUA词法分析器不具有代码文本预处理的功能且在实际是用中需要用到代码包含等
  类似C语言的预处理功能，因此提供此类用于对脚本文本内容进行简单的预处理。为了使
  预处理指令的代码语法兼容lua语法，采用类似在HTML中书写JavaScript代码的方式，
  使用原生语言的注释语法实现预处理语法。在lua预处理器中预处理指令的语法规则如下：
  --#directive implemente data
    即，预处理指令必须在行开始的第一个字符处书写，一个预处理指令不得超过一行。预
  处理指令是不区分大小写的。

  预处理目前实现了下列功能：
    1）代码文件包含，使用“--#include "FilePath"”来包含一个代码文件。
	  代码文件的搜索顺序是首先从当前文件的目录开始使用相对路径搜索，如果找不到
	  文件则在预设的代码文件搜索目录中降序进行相对目录搜索。代码包含指令最多支持
	  对最终长度为1024个字符的路径进行处理

****************************************************************)

interface

uses
  Windows, SysUtils, Classes, Contnrs;

type                         
	//预处理器分析环境
  PPreProcParseEnvir = ^TPreProcParseEnvir;
  TPreProcParseEnvir = record
    sParsePtr     : PAnsiChar;
    sNewLinePtr   : PAnsiChar;
    sLineEndPtr   : PAnsiChar;
    cCharAtLineEnd: AnsiChar;
  end;

  TLineRange = class
  public
    sFileName: string;
    nStart : Integer;
    nEnd   : Integer;
  end;

  TCustomLuaPreProcessor = class(TMemoryStream)
  protected                            
    m_ParseEnvir      : TPreProcParseEnvir;		//当前分析环境
    m_ParseEnvirStack : TStack;             	//预处理器代码分析环境列表，后进先出
    m_IncludeDirList  : TStrings;             //调用者预设的预处理包含文件搜索目录列表
	  m_FilePathStack   : TStrings;	            //预处理器包含文件分析栈，后进先出
    m_LineRangeList   : TObjectList;          //行范围记录列表
	  m_NewLineChar     : AnsiChar;		          //新行符，默认是'\n'
    m_LineNo          : Integer;              //当前写入内容的行号
  public
    constructor Create();virtual;
    destructor Destroy();override;

    (* 对输入脚本内容进行预处理
     *sSourceText	输入字符串起始指针，输入字符串必须是0结尾的
     *sFilePath		代码所在文件包含文件名的完整路径，用于进行优先包含目录搜索
     *cNewLine		换行字符，默认值为'\n'
     *@return 返回处理后的字符串指针，字符串在预处理器销毁或进行下次分析之前一直有效
     *)
    function parse(sSourceText: PAnsiChar; sFilePath: String; const cNewLine: AnsiChar  = #10):PAnsiChar;
    //添加包含文件搜索目录
    procedure addIncludeDirectory(sPath: string);
	  //清空包含文件搜索目录
	  procedure clearIncludeDirectory();
    //获取行对应的文件路径以及所属行号
    function getLineFileInfo(const nLineNo: Integer): TLineRange;

  protected
	  (* 保留当前处理结果内并对新的输入脚本内容进行预处理
	  *sSourceText	输入字符串起始指针，输入字符串必须是0结尾的
	  *)
	  function ParseSource(sSourceText: PAnsiChar): PAnsiChar;
	  //保存当前预处理器分析环境，将分析环境压入环境栈中
	  procedure SaveParseEnvir();
	  //恢复上一个预处理器分析环境，恢复后将删除栈顶的分析环境对象
	  procedure RestorsParseEnvir();
    //分析以“--#”文本开头的预处理行
    procedure ProcessLine(sLineText: PAnsiChar);
    (* 处理并执行预处理指令的功能
     * 如果子类需要对已实现更多的预处理指令或修改现有预处理指令的实现规则，则可以覆盖此函数
     *)
    procedure ProcessDirective(sDirective: PAnsiChar; sData: PAnsiChar);
    //对#include预处理指令功能的实现
    procedure DirectiveOfInclude(sData: PAnsiChar);

  protected
    function Realloc(var NewCapacity: Longint): Pointer; override;

  private
    (* 保留当前处理结果内并对新的输入脚本内容进行预处理
     * 分析代码前会取得代码文件的目录并压入预处理器包含文件分析栈中，处理后会从栈中将目录移除
     *sSourceText	输入字符串起始指针，输入字符串必须是0结尾的
     *sFillFilePath	代码文件的完整路径
     *)
    function SaveFileDirAndParse(sSourceText: PAnsiChar; sFullFilePath: String): PAnsiChar;
    //搜索并加载包含文件
    function SearchAndLoadIncludeFile(sIncludeFileName: PAnsiChar): Boolean;
    //加载并分析包含文件
    function LoadIncludeFile(sIncludeFilePath: string): Boolean;
    
  end;


implementation

uses FuncUtil;

function GetFileNamePart(sFullFilePath: PAnsiChar): PAnsiChar;
begin
  Result := sFullFilePath;
  while sFullFilePath^ <> #0 do
  begin
    if (sFullFilePath^ = '/') or (sFullFilePath^ = '\') then
      Result := sFullFilePath + 1;
    Inc(sFullFilePath);
  end;
end;

{ TCustomLuaPreProcessor }

procedure TCustomLuaPreProcessor.addIncludeDirectory(sPath: string);
begin       
  m_IncludeDirList.add(sPath);
end;

procedure TCustomLuaPreProcessor.clearIncludeDirectory;
begin
  m_IncludeDirList.Clear();
end;

constructor TCustomLuaPreProcessor.Create;
begin
  inherited;
  m_NewLineChar := #10;
  m_ParseEnvirStack := TStack.Create;
  m_IncludeDirList := TStringList.Create;
  m_FilePathStack := TStringList.Create;
  m_LineRangeList := TObjectList.Create;
end;

destructor TCustomLuaPreProcessor.Destroy;
begin
  m_IncludeDirList.Free;
  m_FilePathStack.Free;
  m_ParseEnvirStack.Free;
  m_LineRangeList.Free;
  inherited;
end;

procedure TCustomLuaPreProcessor.DirectiveOfInclude(sData: PAnsiChar);
var
  sFile: array [0..1023] of AnsiChar;
  sPtr: PAnsiChar;
  dwSize: DWord;
begin
	//取出包含文件中引号之内的文件名称
	if ( sData^ <> '"') then Exit;

	Inc(sData);
	if ( sData^ = '"' ) then Exit;

  sPtr := strchr(sData, '"');
  if sPtr = nil then Exit;

	//将文件名拷贝到sFile缓冲区中
	dwSize := sPtr - sData;
	if ( dwSize > sizeof(sFile) div sizeof(sFile[0]) -1 ) then
		dwSize := sizeof(sFile) div sizeof(sFile[0]) -1;
	StrLCopy(sFile, sData, dwSize);
	sFile[dwSize] := #0;
	SearchAndLoadIncludeFile(sFile);
end;

function TCustomLuaPreProcessor.getLineFileInfo(const nLineNo: Integer): TLineRange;
var
  I: Integer;
  Line: TLineRange;
begin
  Result := nil;
  for I := 0 to m_LineRangeList.Count - 1 do
  begin
    Line := m_LineRangeList[I] as TLineRange;
    if Line.nStart <= nLineNo then
      Result := Line;
  end;
end;

function TCustomLuaPreProcessor.LoadIncludeFile(
  sIncludeFilePath: string): Boolean;
var
  ms: TMemoryStream;
  dwSize: Int64;
begin
  ms := TMemoryStream.Create;
  try
    ms.LoadFromFile(sIncludeFilePath);
    dwSize := ms.Size;
    ms.SetSize(dwSize + sizeof(Integer));
    PChar(ms.Memory)[dwSize] := #0;
	  SaveParseEnvir();  
	  SaveFileDirAndParse(ms.Memory, sIncludeFilePath);
	  RestorsParseEnvir();
    Result := True;
  finally
    ms.Free;
  end;
end;

function TCustomLuaPreProcessor.parse(sSourceText: PAnsiChar; sFilePath: String;
  const cNewLine: AnsiChar): PAnsiChar;
begin
	SetSize(0);
  m_LineNo := 0;
	m_NewLineChar := cNewLine;
  m_LineRangeList.Clear;
	Result := SaveFileDirAndParse(sSourceText, sFilePath);
end;

function TCustomLuaPreProcessor.ParseSource(sSourceText: PAnsiChar): PAnsiChar;
const
  cEndChar: AnsiChar = #0;
var
  dwPos, dwSize: Int64;
begin
	dwPos := Position;            
  //跳过UTF-8 BOM
  if ( (PInteger(sSourceText)^ and $00FFFFFF) = $00BFBBEF ) then
    Inc(sSourceText, 3);
	m_ParseEnvir.sParsePtr := sSourceText;
	while ( m_ParseEnvir.sParsePtr^ <> #0 ) do
  begin
		m_ParseEnvir.sNewLinePtr := strchr(m_ParseEnvir.sParsePtr, m_NewLineChar);
		//定位新行位置
		if ( m_ParseEnvir.sNewLinePtr <> nil ) then
    begin
			m_ParseEnvir.sLineEndPtr := m_ParseEnvir.sNewLinePtr - 1;
			Inc(m_ParseEnvir.sNewLinePtr);//调过新行字符
		end
    else begin
			m_ParseEnvir.sNewLinePtr := m_ParseEnvir.sParsePtr + strlen(m_ParseEnvir.sParsePtr);
			m_ParseEnvir.sLineEndPtr := m_ParseEnvir.sNewLinePtr - 1;
		end;
		//定位当前行尾，调过\n\r以及制表符
		while ((m_ParseEnvir.sLineEndPtr >= m_ParseEnvir.sParsePtr) and (m_ParseEnvir.sLineEndPtr < #$20)) do
		begin
			Dec(m_ParseEnvir.sLineEndPtr);
    end;
  
		if ( m_ParseEnvir.sLineEndPtr >= m_ParseEnvir.sParsePtr ) then
    begin
			//终止行尾有效字符之后的后一个字符
			Inc(m_ParseEnvir.sLineEndPtr);
			m_ParseEnvir.cCharAtLineEnd := m_ParseEnvir.sLineEndPtr^;
			m_ParseEnvir.sLineEndPtr^ := #0;
			//分析并处理文本行，如果前3个字符预处理指令字符（--#）则进行预处理，否则直接写入文本内容
			if ( StrLIComp(m_ParseEnvir.sParsePtr, '--#', 3) = 0 ) then
			begin
				ProcessLine(m_ParseEnvir.sParsePtr);
			end
			else begin
				Write(m_ParseEnvir.sParsePtr^, m_ParseEnvir.sLineEndPtr - m_ParseEnvir.sParsePtr);
				//在代码中写入换行符
				Write(m_NewLineChar, sizeof(m_NewLineChar));
        //递增源文件行号
        Inc(m_LineNo);
			end;
			//恢复被终止的字符
			m_ParseEnvir.sLineEndPtr^ := m_ParseEnvir.cCharAtLineEnd; 
		end
    else begin
      //在代码中写入换行符
      Write(m_NewLineChar, sizeof(m_NewLineChar));
      //递增源文件行号
      Inc(m_LineNo);
    end;
		//将输入处理指针调整到下一行
		m_ParseEnvir.sParsePtr := m_ParseEnvir.sNewLinePtr;
	end;
           
  dwSize := Size;
	if dwSize > 0 then
  begin
    Write(cEndChar, sizeof(cEndChar));  //写入终止符
    SetSize(dwSize);
    Result := PChar(Memory) + dwPos;
  end
  else Result := '';
end;

procedure TCustomLuaPreProcessor.ProcessDirective(sDirective, sData: PAnsiChar);
begin
	//代码文件包含指令--#include
	if ( StrLIComp(sDirective, 'include', 7) = 0 ) then
	begin
		DirectiveOfInclude(sData);
	end;
end;

procedure TCustomLuaPreProcessor.ProcessLine(sLineText: PAnsiChar);
var
  nIdx: Integer;
  sDirective: array [0..127] of AnsiChar;
begin
	//取得预处理指令以及指令内容
	Inc(sLineText, 3);//调过--#
  nIdx := 0;
	while (nIdx < sizeof(sDirective) div sizeof(sDirective[0]) -1) do
	begin
		if ( (sLineText^ = #0) or (sLineText^ <= #$20) ) then
			break;
		sDirective[nIdx] := sLineText^;
		Inc(sLineText);
		Inc(nIdx);
	end;
	if ( nIdx > 0 ) then
	begin
		sDirective[nIdx] := #0;
		//调过预处理指令数据部分开头的不可见字符
		while (sLineText^ <> #0) and (sLineText^ <= #$20) do
			Inc(sLineText);
		//执行预处理指令
		ProcessDirective(sDirective, sLineText);
	end;
end;

function TCustomLuaPreProcessor.Realloc(var NewCapacity: Integer): Pointer;
begin
  if NewCapacity = 0 then
  begin
    Result := Inherited Realloc(NewCapacity);
  end
  else begin
    //保留4个字节用于书写字符串终止符
    NewCapacity := NewCapacity + sizeof(Integer);
    Result := Inherited Realloc(NewCapacity);
    Dec(NewCapacity, sizeof(Integer));
    PAnsiChar(Result)[NewCapacity] := #0;
  end;
end;

procedure TCustomLuaPreProcessor.RestorsParseEnvir;
var
  pEnvir: PPreProcParseEnvir;
begin
  pEnvir := m_ParseEnvirStack.Pop();
  m_ParseEnvir := pEnvir^;
  Dispose(pEnvir);
end;

function TCustomLuaPreProcessor.SaveFileDirAndParse(sSourceText: PAnsiChar;
  sFullFilePath: String): PAnsiChar;
var
  Line: TLineRange;
begin
	//生成文件路径字符串并将路径压入预处理器包含文件分析栈
	m_FilePathStack.add(ExtRactFilePath(sFullFilePath));

  Line := TLineRange.Create;
  Line.sFileName := sFullFilePath;
  Line.nStart := m_LineNo;
  m_LineRangeList.Add(Line);

	//分析文件中的代码
	Result := ParseSource(sSourceText);
  Line.nEnd := m_LineNo - 1;

	//从预处理器包含文件分析栈从弹出文件路径
	m_FilePathStack.Delete(m_FilePathStack.Count - 1);
end;

procedure TCustomLuaPreProcessor.SaveParseEnvir;  
var
  pEnvir: PPreProcParseEnvir;
begin
  New(pEnvir);
  pEnvir^ := m_ParseEnvir;
  m_ParseEnvirStack.push(pEnvir);
end;

function TCustomLuaPreProcessor.SearchAndLoadIncludeFile(
  sIncludeFileName: PAnsiChar): Boolean;
var
  sPath: string;
  i, nCount: Integer;
begin
  Result := False;
	//开始搜索文件，优先从当前文件的目录开始搜索
	nCount := m_FilePathStack.Count;
	if ( nCount > 0 ) then
	begin
		Dec(nCount);
		sPath := m_FilePathStack[nCount] + sIncludeFileName;
    sPath := ExpandFileName(sPath);
		if ( FileExists(sPath) ) then
		begin
			Result := LoadIncludeFile(sPath);
      Exit;
    end;
  end;
	//无法从当前文件的目录找到文件则从包含文件目录列表中降序循环搜索
	for i := m_IncludeDirList.Count-1 downto 0 do
  begin
		sPath := m_IncludeDirList[i] + sIncludeFileName;
    sPath := ExpandFileName(sPath);
		if ( FileExists(sPath) ) then
		begin
			Result := LoadIncludeFile(sPath);
      Exit;
    end;
  end;
	//最后将文件视为绝对路径中的文件
	if ( FileExists(sIncludeFileName) ) then
  begin
    Result := LoadIncludeFile(sPath);
    Exit;
  end;
end;

end.
