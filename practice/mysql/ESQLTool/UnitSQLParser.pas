unit UnitSQLParser;

interface

uses
  Windows, SysUtils, Classes;

type
  TNoteMessage = procedure(sMessage: string);

  TSQLParser = class
  private
    FText: string;
    FDelimiter: string;
    FTextPtr: PChar;
    FDenyTokens: TStringList;
    procedure SetDelimiter(const Value: string);
    procedure SetText(const Value: string);
    function GetToken(): string;
    function CopyRepSymbols(): string;
    function CopyLettes(): string;
    function CopyText(sEndChar: Char): string;
    function CopyDigits(): string;
    function CopyHex(): string;
    function CopyNote: PChar;
    function SkipWhiteChars(): PChar;
    function ParseToNewLine(): PChar;
    function ParseToBlockCommentEnd(): PChar;
  public
    OnNoteMessage: TNoteMessage;
    constructor Create();
    destructor Destroy();override;
    function GetStatement(): string;
  published
    property Text: string read FText write SetText;
    property Delimiter: string read FDelimiter write SetDelimiter;
    property DenyTokens: TStringList read FDenyTokens;
  end;

implementation

uses ConfigINI;
{ TSQLParser }

function TSQLParser.CopyDigits: string;
begin
  Result := '';
  repeat
    Result := Result + FTextPtr^;
    Inc(FTextPtr);
  until (FTextPtr^ = #0)
  or not (FTextPtr^ in ['0'..'9', 'e', 'E', '.']);
end;

function TSQLParser.CopyHex: string;
begin
  Result := '';
  while (FTextPtr^ <> #0) and (FTextPtr^ in ['0'..'9', 'a'..'f', 'A'..'F']) do
  begin
    Result := Result + FTextPtr^;
    Inc(FTextPtr);
  end;
end;

function TSQLParser.CopyLettes: string;
begin
  Result := '';
  repeat
    Result := Result + FTextPtr^;
    Inc(FTextPtr);
  until (FTextPtr^ = #0)
  or not (FTextPtr^ in ['a'..'z', 'A'..'Z', '0'..'9', '_', '`']);
end;

function TSQLParser.CopyNote: PChar;
var
  sMessage: string;
  boLNTag: Boolean;
begin
  boLNTag := False;  sMessage := '';
  while (FTextPtr^ <> #0) do
  begin
    if (FTextPtr^ = #13) or (FTextPtr^ = #10) then
      boLNTag := True
    else if boLNTag then
      break;
    sMessage := sMessage + FTextPtr^;
    Inc(FTextPtr);
  end;
  if Assigned(OnNoteMessage) then OnNoteMessage(sMessage);
  Result := SkipWhiteChars();
end;

function TSQLParser.CopyRepSymbols: string;
begin
  Result := '';
  repeat
    Result := Result + FTextPtr^;
    Inc(FTextPtr);
  until (FTextPtr^ = #0) or (FTextPtr^ <> Result[1]);
end;

function TSQLParser.CopyText(sEndChar: Char): string;
begin
  Result := '';
  repeat
    Result := Result + FTextPtr^;
    Inc(FTextPtr);
    if FTextPtr = '\' then
    begin
      if FTextPtr[1] = sEndChar then
      begin
        Result := Result + '\' + sEndChar;
        Inc(FTextPtr, 2);
      end;
    end
    else if FTextPtr^ = sEndChar then
    begin
      Result := Result + sEndChar;
      Inc(FTextPtr);
      break;
    end;
  until (FTextPtr^ = #0);
end;

constructor TSQLParser.Create;
begin
  FDelimiter := ';';
  FDenyTokens := TStringList.Create;
  FDenyTokens.Sorted := true;
  FDenyTokens.CaseSensitive := false;
end;

destructor TSQLParser.Destroy;
begin
  FDenyTokens.Free;
  inherited;
end;

function TSQLParser.GetStatement: string;
var
  sToken: string;
begin
  Result := '';
  if (FTextPtr <> nil) then
  begin
    repeat
      sToken := GetToken();
      
      if CompareText('delimiter', sToken) = 0 then
      begin
        sToken := GetToken();
        if sToken = '' then
          Raise Exception.Create('delimiter 后应当有分割符');
        Delimiter := sToken;
        continue;
      end;
      if (sToken = '') then
        break;
      if sToken = FDelimiter then
      begin
        if Result <> '' then
          break;
        //应付连续的多个分隔符
        continue;
      end;

      //检测禁止的字符(安全方面，例如source等字符)
      if FDenyTokens.IndexOf(sToken) > -1 then
      begin
        raise Exception.CreateFmt('token %s is disabled', [sToken]);
      end;

      if (sToken = '(') or (sToken = ')') then
      begin
        if Result[Length(Result)] = ' ' then
          Result[Length(Result)] := sToken[1]
        else Result := Result + sToken;
      end
      else if (sToken = '@') or (sToken = ':') then
      begin
        Result := Result + sToken + GetToken();
      end
      else Result := Result + sToken + ' ';
    until sToken = '';
  end;
end;

function TSQLParser.GetToken: string;
begin
  Result := '';

  SkipWhiteChars();

  //取下一个词 
  while FTextPtr^ <> #0 do
  begin
    case FTextPtr^ of   
      '$', '%', '^', '&', '*', '(', ')', '=', '|', '\', '{', '}', '[',
      ']', ':', ',', '?':begin
         Result := CopyRepSymbols();
         break;
      end;
      '/':begin
        if FTextPtr[1] = '*' then
        begin
          FTextPtr := ParseToBlockCommentEnd();
          continue;
        end;
        Result := CopyRepSymbols();
        break;
      end;
      '#':begin
        FTextPtr := CopyNote;
        continue;
      end;       
      '-':begin
        if FTextPtr[1] = '-' then
        begin
          FTextPtr := ParseToNewLine();
          continue;
        end;
        Result := FTextPtr^;
        Inc(FTextPtr);
        if FTextPtr^ in ['.', '0'..'9'] then
         Result := Result + CopyDigits();
        break;
      end;    
      '+':begin
        Result := FTextPtr^;
        Inc(FTextPtr);
        if FTextPtr^ in ['.', '0'..'9'] then
         Result := Result + CopyDigits();
        break;
      end;
      '!':begin
        Result := FTextPtr^;
        Inc(FTextPtr);
        if FTextPtr^ = '=' then
        begin
          Result := Result + FTextPtr^;
          Inc(FTextPtr);
        end;
        break;
      end;
      '<':begin
        Result := FTextPtr^;
        Inc(FTextPtr);
        if FTextPtr^ in ['=','<', '>'] then
        begin
          Result := Result + FTextPtr^;
          Inc(FTextPtr);
        end;
        break;
      end;
      '>':begin
        Result := Result + FTextPtr^;
        Inc(FTextPtr);
        if FTextPtr^ in ['=','>'] then
        begin
          Result := Result + FTextPtr^;
          Inc(FTextPtr);
        end;
        break;
      end;
      '.':begin    
        Result := Result + FTextPtr^;
        Inc(FTextPtr);      
        if FTextPtr^ in ['0'..'9'] then
        begin
          Result := Result + CopyDigits();
        end;
        break;
      end;
      ';':begin
        Result := FTextPtr^;
        Inc(FTextPtr);      
        break;
      end;
      '''', '"':begin
        Result := CopyText(FTextPtr^);
        break;
      end;
      '0'..'9':begin
        if (FTextPtr^ = '0') and (FTextPtr[1] = 'x') then
        begin
          Inc(FTextPtr, 2);
          Result := '0x' + CopyHex();
        end
        else Result := CopyDigits();
        break;
      end;
      #$1..#$20:begin
        Inc(FTextPtr);
        continue;
      end
      else begin
        Result := CopyLettes();
        break;
      end;
    end;
  end;
end;

function TSQLParser.ParseToBlockCommentEnd: PChar;
begin
  while (FTextPtr^ <> #0) do
  begin
    if (FTextPtr^ = '*') then
    begin
      if FTextPtr[1] = '/' then
      begin
        Inc(FTextPtr, 2);
        break;
      end;
    end;
    Inc(FTextPtr);
  end;
  Result := SkipWhiteChars();
end;

function TSQLParser.ParseToNewLine: PChar;
var
  boLNTag: Boolean;
begin
  boLNTag := False;
  while (FTextPtr^ <> #0) do
  begin
    if (FTextPtr^ = #13) or (FTextPtr^ = #10) then
      boLNTag := True
    else if boLNTag then
      break;
    Inc(FTextPtr);
  end;
  Result := SkipWhiteChars();
end;

procedure TSQLParser.SetDelimiter(const Value: string);
begin
  FDelimiter := Value;
end;

procedure TSQLParser.SetText(const Value: string);
begin
  FText := Value;
  FTextPtr := PChar(FText);
end;

function TSQLParser.SkipWhiteChars: PChar;
begin
  //过滤当前扫描位置开头的空格、制表符以及不可见字符
  while (FTextPtr^ <> #0) and (FTextPtr^ <= #$20) do
  begin
    Inc(FTextPtr);
  end;
  Result := FTextPtr;
end;

end.
