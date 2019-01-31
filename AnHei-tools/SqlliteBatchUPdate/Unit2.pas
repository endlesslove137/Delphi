unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBXMySQL, FMTBcd, DB, SqlExpr, ExcelXP, OleServer, MSXML,
  DBXpress;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    SQLConnection: TSQLConnection;
    quContents: TSQLQuery;
    quIdTable: TSQLQuery;
    Button4: TButton;
    ExcelApplication: TExcelApplication;
    ExcelWorksheet: TExcelWorksheet;
    ExcelWorkbook: TExcelWorkbook;
    Edit2: TEdit;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Edit3: TEdit;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    quUpdate: TSQLQuery;
    Button12: TButton;
    Button13: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure InsertId(sTable: string;id: Integer);
    procedure ClearTableData(sTable: string);
    function IsCN(sText: string): Boolean;
    procedure InsertText(id: Integer;sText: string);
    procedure OpenExcel(ExcelFileName: string);
    procedure CloseExcel;
  end;

var
  Form2: TForm2;
  sLang: array of string;

implementation

{$R *.dfm}


function StrToHex(str: string; AEncoding: TEncoding): string;
var
  ss: TStringStream;
  i: Integer;
begin
  Result := '';
  ss := TStringStream.Create(str, AEncoding);
  for i := 0 to ss.Size - 1 do
    Result := Result + Format('%.2x', [ss.Bytes[i]]);
  ss.Free;
end;

function QuerySQLStr(sFieldName: string): string;
const
  CONVERTEncoding = 'convert(0x%s using latin1)';
begin
  Result := '""';
  if sFieldName <> '' then
  begin
    Result := Format(CONVERTEncoding,[StrToHex(sFieldName,TEncoding.UTF8)]);
  end;
end;

procedure TForm2.Button10Click(Sender: TObject);
const
  sqlcontents = 'INSERT INTO lang VALUES ';
var
  I,id,iRow,iCount: Integer;
  sText,sValue,sSQL: string;
  procedure InsertText(sSQLString: string);
  begin
    Delete(sSQLString,Length(sSQLString),1);
    quIdTable.SQL.Text := sqlcontents+sSQLString;
    quIdTable.ExecSQL();
    quIdTable.Close;
  end;
begin
  iRow := 2;
  OpenExcel('E:\delphi\工具程序测试\判断utf8中文\3-22.xlsx');
  try
    ClearTableData('lang');
    sSQL := ''; iCount := 0;
    ExcelWorkSheet.ConnectTo(ExcelWorkbook.WorkSheets['Sheet4'] as _Worksheet);
    while VarType(ExcelWorkSheet.Cells.Item[iRow,1].value) <> varEmpty do
    begin
      id := StrToInt(ExcelWorkSheet.Cells.Item[iRow,1]);
      sText := ExcelWorkSheet.Cells.Item[iRow,2];
      sValue := ExcelWorkSheet.Cells.Item[iRow,3];
      Inc(iCount);
      sSQL := sSQL + Format('(%d,%s,%s),',[id,QuerySQLStr(sText),QuerySQLStr(sValue)]);
      if iCount = 200 then
      begin
        InsertText(sSQL);
        sSQL := '';
        iCount := 0;
      end;
      Inc(iRow);
    end;
    if iCount > 0 then
    begin
      InsertText(sSQL);
    end;
  finally
    CloseExcel;
  end;
end;

procedure CheckSQliteResult(ret, check: Integer);
begin
  if ret <> check then
    Raise Exception.Create('fail');
end;

procedure TForm2.Button11Click(Sender: TObject);
var
  iCount: Integer;
  sContent,sContent1: string;
begin
  {操作
  1、工具将Excel导入到mysql(包括lang_ta和content_ta)
  2、执行过程 repeatlang
  3、工具->处理同名翻译不同
  4、执行过程 sp_insertlang
  5、工具->导入lang.txt和content.xls到mysql (lang和content)
  6、执行过程 sp_mergerlang
  7、工具->提取中文
  }
  quContents.SQL.Text := 'SELECT * FROM tmpcontents';
  quContents.Open;
  iCount := 0;
  while not quContents.Eof do
  begin
    sContent := UTF8ToString(quContents.FieldByName('content').AsAnsiString);
    sContent1 := UTF8ToString(quContents.FieldByName('content1').AsAnsiString);
    quUpdate.SQL.Text := Format('UPDATE alllang SET content1=%s WHERE content=%s',[QuerySQLStr(sContent1),QuerySQLStr(sContent)]);
    quUpdate.ExecSQL;
    quUpdate.Close;
    Inc(iCount);
    quContents.Next;
  end;
  quContents.Close;
end;

procedure TForm2.Button12Click(Sender: TObject);
const
  sqlcontents = 'INSERT INTO contents VALUES ';
var
  I,id,iRow,iCount: Integer;
  sText,sValue,sSQL: string;
  procedure InsertText(sSQLString: string);
  begin
    Delete(sSQLString,Length(sSQLString),1);
    quIdTable.SQL.Text := sqlcontents+sSQLString;
    quIdTable.ExecSQL();
    quIdTable.Close;
  end;
begin
  iRow := 2;
  OpenExcel('E:\delphi\工具程序测试\判断utf8中文\contents.xlsx');
  try
    ClearTableData('contents');
    sSQL := ''; iCount := 0;
    ExcelWorkSheet.ConnectTo(ExcelWorkbook.WorkSheets['Sheet4'] as _Worksheet);
    while VarType(ExcelWorkSheet.Cells.Item[iRow,1].value) <> varEmpty do
    begin
      id := StrToInt(ExcelWorkSheet.Cells.Item[iRow,1]);
      sText := ExcelWorkSheet.Cells.Item[iRow,2];
      sValue := ExcelWorkSheet.Cells.Item[iRow,3];
      Inc(iCount);
      sSQL := sSQL + Format('(%d,%s,%s),',[id,QuerySQLStr(sText),QuerySQLStr(sValue)]);
      if iCount = 200 then
      begin
        InsertText(sSQL);
        sSQL := '';
        iCount := 0;
      end;
      Inc(iRow);
    end;
    if iCount > 0 then
    begin
      InsertText(sSQL);
    end;
  finally
    CloseExcel;
  end;
end;

procedure TForm2.Button13Click(Sender: TObject);
var
  I,Id,iCount: Integer;
  hs: AnsiString;
  S,sText,sSQL: string;
  strList: TStringList;
  StringStream: TStringStream;
  sLang: array of string;
  procedure SaveLangFile();
  var
    I: Integer;
    sList: TStringList;
    SS: TStringStream;
  begin
    sList := TStringList.Create;
    try
      for I := 0 to high(sLang) do
      begin
        if sLang[I] <> '' then
        begin
          sList.Add(IntToStr(I)+' '+sLang[I]);
        end;
      end;
      SS := TStringStream.Create(sList.Text,TEncoding.UTF8);
      SS.SaveToFile('E:\delphi\工具程序测试\判断utf8中文\lang.txt');
      SS.Free;
    finally
      sList.Free;
    end;
  end;
begin
  StringStream := TStringStream.Create('',TEncoding.UTF8);
  strList := TStringList.Create;
  try
    StringStream.LoadFromFile('F:\WorkSVN\idgp\ZhanJiangII\!SC\Client\lang\zh-YN\lang.txt');
    StringStream.Position := 3;
    strList.Text := StringStream.ReadString(StringStream.Size-3);
    iCount := 0;
    SetLength(sLang,0);
    for I := 0 to strList.Count-1 do
    begin
      S := strList.Strings[I];
      id := StrToIntDef(Copy(S,1,Pos(' ',S)-1),0);
      if id = 0 then Continue;
      sText := Copy(S,Pos(' ',S)+1,Length(S));
      if id >= High(sLang) then
      begin
        SetLength(sLang,id+1);
      end;
      sLang[id] := sText;
      Inc(iCount);
    end;
    StringStream.LoadFromFile('F:\WorkSVN\idgp\ZhanJiangII\!SC\Client\lang\zh-CN\lang.txt');
    StringStream.Position := 3;
    strList.Text := StringStream.ReadString(StringStream.Size-3);
    iCount := 0;
    for I := 0 to strList.Count-1 do
    begin
      S := strList.Strings[I];
      id := StrToIntDef(Copy(S,1,Pos(' ',S)-1),0);
      if id = 0 then Continue;
      sText := Copy(S,Pos(' ',S)+1,Length(S));
      if id >= High(sLang) then
      begin
        SetLength(sLang,id+1);
        sLang[id] := sText;
      end
      else begin
        if (sLang[id] = '') and (sText <> '') then
        begin
          sLang[id] := sText;
        end;
      end;
      Inc(iCount);
    end;
    SaveLangFile();
  finally
    strList.Free;
    StringStream.Free;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  S: string;
begin
  ClearTableData('idcontents');
  quContents.SQL.Text := 'SELECT * FROM contents';
  quContents.Open;
  while not quContents.Eof do
  begin
    S := UTF8ToString(quContents.FieldByName('content').AsAnsiString);
    if IsCN(S) then
    begin
      InsertId('idcontents',quContents.FieldByName('id').AsInteger);
    end;
    quContents.Next;
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  bResult: Boolean;
  S: string;
  I: Integer;
begin
  S := Edit1.Text;
  bResult := False;
  for I := 0 to Length(S) do
  begin
    if (Ord(S[I]) >= $4E00{19968})  and  (Ord(S[I]) <=  $9FA5{40869}) then
    begin
      bResult := True;
    end;
  end;
  if bResult then
  begin
    ShowMessage('含有中文');
  end
  else begin
    ShowMessage('不含中文')
  end;
  //0x4E00 – 0x9FFF
//SELECT * FROM gamelog.game2_0log_100_20121012  where char_length(objectname)!=length(objectname)
end;

procedure TForm2.Button3Click(Sender: TObject);
const
  sqlLang = 'INSERT INTO lang VALUES ';
var
  I,Id,iCount: Integer;
  hs: AnsiString;
  S,sText,sSQL: string;
  strList: TStringList;
  StringStream: TStringStream;
  procedure InsertText(sSQLString: string);
  begin
    Delete(sSQLString,Length(sSQLString),1);
    quIdTable.SQL.Text := sqlLang+sSQLString;
    quIdTable.ExecSQL();
    quIdTable.Close;
  end;
begin
  StringStream := TStringStream.Create('',TEncoding.UTF8);
  strList := TStringList.Create;
  try
    StringStream.LoadFromFile('F:\WorkSVN\idgp\ZhanJiangII\!SC\Client\lang\zh-KR\lang.txt');
    SetLength(hs,3);
    StringStream.Position := 0;
    StringStream.Read(hs[1],3);
    strList.Text := StringStream.ReadString(StringStream.Size-3);
    iCount := 0;
    sSQL := '';
    ClearTableData('lang');
    for I := 0 to strList.Count-1 do
    begin
      S := strList.Strings[I];
      id := StrToIntDef(Copy(S,1,Pos(' ',S)-1),0);
      if id = 0 then Continue;
      sText := Copy(S,Pos(' ',S)+1,Length(S));
      Inc(iCount);
      sSQL := sSQL + Format('(%d,null,%s),',[id,QuerySQLStr(sText)]);
      if iCount = 200 then
      begin
        InsertText(sSQL);
        sSQL := '';
        iCount := 0;
      end;
    end;
    if iCount > 0 then
    begin
      InsertText(sSQL);
    end;
  finally
    strList.Free;
    StringStream.Free;
  end;
end;

procedure TForm2.Button4Click(Sender: TObject);
var
  S: string;
begin
  ClearTableData('idlang');
  quContents.SQL.Text := 'SELECT * FROM lang';
  quContents.Open;
  while not quContents.Eof do
  begin
    S := UTF8ToString(quContents.FieldByName('content1').AsAnsiString);
    if IsCN(S) then
    begin
      InsertId('idlang',quContents.FieldByName('id').AsInteger);
    end;
    quContents.Next;
  end;
end;

procedure TForm2.Button5Click(Sender: TObject);
var
  StringStream: TStringStream;
  strList: TStringList;
  id,sText,sValue,S: string;
begin
  strList := TStringList.Create;
  quContents.SQL.Text := 'SELECT * FROM contents';
  quContents.Open;
  while not quContents.Eof do
  begin
    id := quContents.FieldByName('id').AsString;
    sText := UTF8ToString(quContents.FieldByName('content').AsAnsiString);
    sValue := UTF8ToString(quContents.FieldByName('content1').AsAnsiString);
    S := Format('UPDATE lang_ta SET content=REPLACE(content,"%s","%s") WHERE content like "|%s|";',[sText,sValue,sText]);
    S := StringReplace(S,'|', '%', [rfReplaceAll]);
    strList.Add(S);
    quContents.Next;
  end;
  StringStream := TStringStream.Create(strList.Text,TEncoding.UTF8);
  StringStream.SaveToFile('E:\delphi\工具程序测试\判断utf8中文\update.txt');
  StringStream.Free;
  strList.Free;
end;

procedure TForm2.Button6Click(Sender: TObject);
var
  I,Id,iCount: Integer;
  hs: AnsiString;
  S,sText,sSQL: string;
  strList: TStringList;
  StringStream: TStringStream;
begin
  StringStream := TStringStream.Create('',TEncoding.UTF8);
  strList := TStringList.Create;
  try
    StringStream.LoadFromFile('F:\WorkSVN\idgp\ZhanJiangII\!SC\Client\lang\zh-YN\lang.txt');
    SetLength(hs,3);
    StringStream.Position := 0;
    StringStream.Read(hs[1],3);
    strList.Text := StringStream.ReadString(StringStream.Size-3);
    iCount := 0;
    SetLength(sLang,0);
    for I := 0 to strList.Count-1 do
    begin
      S := strList.Strings[I];
      id := StrToIntDef(Copy(S,1,Pos(' ',S)-1),0);
      if id = 0 then Continue;
      sText := Copy(S,Pos(' ',S)+1,Length(S));
      if id >= High(sLang) then
      begin
        SetLength(sLang,id+1);
      end;
      sLang[id] := sText;
      Inc(iCount);
    end;
  finally
    strList.Free;
    StringStream.Free;
  end;
end;

procedure TForm2.Button7Click(Sender: TObject);
var
  I,id,iRow: Integer;
  sText: string;
  strList: TStringList;
  StringStream: TStringStream;
begin
  iRow := 1;
  OpenExcel('E:\delphi\工具程序测试\判断utf8中文\121111_lang.xls');
  try
    ExcelWorkSheet.ConnectTo(ExcelWorkbook.WorkSheets['lang'] as _Worksheet);
    while VarType(ExcelWorkSheet.Cells.Item[iRow,1].value) <> varEmpty do
    begin
      id := StrToInt(ExcelWorkSheet.Cells.Item[iRow,1]);
      sText := ExcelWorkSheet.Cells.Item[iRow,2];
      if id <= High(sLang) then
      begin
        sLang[id] := sText;
      end;
      Inc(iRow);
    end;
    strList := TStringList.Create;
    try
      for I := 0 to high(sLang) do
      begin
        if sLang[I] <> '' then
        begin
          strList.Add(IntToStr(I)+' '+sLang[I]);
        end;
      end;
      StringStream := TStringStream.Create(strList.Text,TEncoding.UTF8);
      StringStream.SaveToFile('E:\delphi\工具程序测试\判断utf8中文\lang.txt');
      StringStream.Free;
    finally
      strList.Free;
    end;
  finally
    CloseExcel;
  end;
end;

procedure TForm2.Button8Click(Sender: TObject);
var
  StringStream: TStringStream;
  strList: TStringList;
  id,sText: string;
begin
  strList := TStringList.Create;
  quContents.SQL.Text := 'SELECT * FROM lang_kr';
  quContents.Open;
  while not quContents.Eof do
  begin
    id := quContents.FieldByName('id').AsString;
    sText := UTF8ToString(quContents.FieldByName('content1').AsAnsiString);
    strList.Add(id + ' ' + sText);
    quContents.Next;
  end;
  StringStream := TStringStream.Create(strList.Text,TEncoding.UTF8);
  StringStream.SaveToFile('E:\delphi\工具程序测试\判断utf8中文\lang.txt');
  StringStream.Free;
  strList.Free;
end;

procedure TForm2.Button9Click(Sender: TObject);
var
  I,id,iRow: Integer;
  sText: string;
  xmlDoc : IXMLDOMDocument;
  RootNode: IXMLDOMNode;
  Element : IXMLDOMElement;
begin
  iRow := 2;
  OpenExcel('E:\delphi\工具程序测试\判断utf8中文\htlang_kr.xls');
  xmlDoc := CoDOMDocument.Create();
  xmlDoc.appendChild(xmlDoc.createProcessingInstruction('xml', 'version="1.0" encoding="utf-8"'));
  RootNode := xmlDoc.appendChild(xmlDoc.createElement('langClass'));
  try
    ExcelWorkSheet.ConnectTo(ExcelWorkbook.WorkSheets['htlang'] as _Worksheet);
    while VarType(ExcelWorkSheet.Cells.Item[iRow,1].value) <> varEmpty do
    begin
      id := StrToInt(ExcelWorkSheet.Cells.Item[iRow,1]);
      sText := ExcelWorkSheet.Cells.Item[iRow,3];
      Element := RootNode.appendChild(xmlDoc.createElement('langRecord')) as IXMLDOMElement;
      Element.setAttribute('langID',id);
      Element.setAttribute('langValue',sText);
      Inc(iRow);
    end;
    xmlDoc.save('E:\delphi\工具程序测试\判断utf8中文\lang.xml');
  finally
    xmlDoc := nil;
    CloseExcel;
  end;
end;

procedure TForm2.ClearTableData(sTable: string);
begin
  quIdTable.SQL.Text := Format('DELETE FROM %s',[sTable]);
  quIdTable.ExecSQL();
  quIdTable.Close;
end;

procedure TForm2.CloseExcel;
begin
  ExcelWorkSheet.Disconnect;
  ExcelWorkbook.Disconnect;
  ExcelApplication.Quit;
  ExcelApplication.Disconnect;
end;

procedure TForm2.InsertId(sTable: string;id: Integer);
begin
  quIdTable.SQL.Text := Format('INSERT INTO %s VALUES (%d)',[sTable,id]);
  quIdTable.ExecSQL();
  quIdTable.Close;
end;

procedure TForm2.InsertText(id: Integer; sText: string);
begin
  quIdTable.SQL.Text := Format('INSERT INTO lang VALUES (%d,%s)',[id,QuerySQLStr(sText)]);
  quIdTable.ExecSQL();
  quIdTable.Close;
end;

function TForm2.IsCN(sText: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  if sText = '' then Exit;
  for I := 0 to Length(sText) do
  begin
    if (Ord(sText[I]) >= $4E00{19968})  and  (Ord(sText[I]) <=  $9FA5{40869}) then
    begin
      Result := True;
      break;
    end;
  end;
end;

procedure TForm2.OpenExcel(ExcelFileName: string);
begin
  ExcelApplication.Connect;
  ExcelApplication.Visible[0] := False;
  ExcelApplication.DisplayAlerts[0] := False;
  ExcelWorkbook.ConnectTo(ExcelApplication.Workbooks.Open   (ExcelFileName,
                EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,
                EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,
                EmptyParam,EmptyParam,EmptyParam,EmptyParam,0));
end;

end.
