unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExcelXP, OleServer, MSXML;

type
  PTLangData = ^TLangData;
  TLangData = record
    nId: Integer;
    sValue: string;
  end;

  TForm2 = class(TForm)
    Button1: TButton;
    ExcelApplication: TExcelApplication;
    ExcelWorksheet: TExcelWorksheet;
    ExcelWorkbook: TExcelWorkbook;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    btn1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure OpenExcel(ExcelFileName: string);
    procedure CloseExcel;
  end;

var
  Form2: TForm2;

implementation

uses SQLite3, SQLiteTable3;

{$R *.dfm}

procedure CheckSQliteResult(ret, check: Integer);
begin
  if ret <> check then
    Raise Exception.Create('fail');
end;

function LoadUnicode(f:string;b:boolean=true):WideString;
var
  ms:TMemoryStream;
  hs:String;
begin
  Result:='';
  if not FileExists(f) then exit;
  ms:=TMemoryStream.Create;
  ms.LoadFromFile(f);
  if b then begin
    SetLength(hs,2);
    ms.Read(hs[1],2);
    if hs<>#$FF#$FE then begin ms.Free; exit; end;
    SetLength(Result,(ms.Size-2) div 2);
    ms.Read(Result[1],ms.Size-2);
  end else begin
    SetLength(Result,ms.Size div 2);
    ms.Read(Result[1],ms.Size);
  end;
  ms.Free;
end;

procedure TForm1.SqlLiteToList();
var
  sldb: TSQLiteDatabase;
  sltb: TSQLIteTable;
//  sltb:TSQLiteUniTable;
  plangRecord1:  PlangRecord;
  s: string;
begin
  sldb := TSQLiteDatabase.Create('D:\temp\test\zh-CN.db');
  try
    if sldb.TableExists('contents') then
    begin
      sltb := slDb.GetTable('select * from contents where id=2');
//      sltb := slDb.GetUniTable(lbledt6.Text);

    end;
//    ClearLanglist;
    while not sltb.EOF do
    begin
      s := sltb.FieldAsString(sltb.FieldIndex[colcontent]);
//      plangRecord1.Moddate := Utf8ToString(sltb.FieldAsString(sltb.FieldIndex[COlModdate]));
      s := utf8toansi(s);
      sltb.Next;
    end;
    sltb.Free;
  finally
//    showmessage(inttostr(langlist.Count));
    sldb.Free;
  end;
end;


procedure TForm2.Button1Click(Sender: TObject);
var
  sldb: TSQLiteDatabase;
  sltb: TSQLIteTable;
  Stmt: TSQLiteStmt;
  ID,iRow,iCount: Integer;
  sText: widestring;
  pzTail: PWideChar;
begin
  sldb := TSQLiteDatabase.Create('F:\WorkSVN\idgp\ZhanJiangII\!SC\Server\GameCenter\Language\zh-TA.db');
  OpenExcel('E:\delphi\工具程序测试\判断utf8中文\新建文件夹\地图名称长度问题02.xls');
  try
    if sldb.TableExists('contents') then
    begin
      sltb := slDb.GetTable('SELECT * FROM contents');
    end;
    ExcelWorkSheet.ConnectTo(ExcelWorkbook.WorkSheets['Sheet4'] as _Worksheet);
    iRow := 2;
    iCount := 0;
    while VarType(ExcelWorkSheet.Cells.Item[iRow,1].value) <> varEmpty do
    begin
      if iCount = 0 then
      begin
        sldb.BeginTransaction;
      end;
      id := StrToInt(ExcelWorkSheet.Cells.Item[iRow,1]);
      sText := ExcelWorkSheet.Cells.Item[iRow,2];
      CheckSQliteResult(
        sqlite3_prepare16(sldb.DB, 'UPDATE contents SET content = ? WHERE id= ?', -1, Stmt, pzTail),
        SQLITE_OK);
      CheckSQliteResult(sqlite3_bind_text16(Stmt, 1, PWideChar(sText), -1, nil), SQLITE_OK);
      CheckSQliteResult(sqlite3_bind_int(Stmt, 2, ID), SQLITE_OK);
      CheckSQliteResult(sqlite3_step(Stmt), SQLITE_DONE);
      sqlite3_finalize(Stmt);
      Inc(iCount);
      if iCount = 500 then
      begin
        sldb.Commit;
        iCount := 0;
      end;
      Inc(iRow);
    end;
    if iCount > 0 then
    begin
      sldb.Commit;
    end;
    sltb.Free;
  finally
    sldb.Free;
  end;
end;

function IsCN(sText: WideString): Boolean;
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

function DecodeUtf8Str(const S: UTF8String): WideString;
var lenSrc, lenDst  : Integer;
begin
  lenSrc  := Length(S);
  if(lenSrc=0)then Exit;
  lenDst  := MultiByteToWideChar(CP_UTF8, 0, Pointer(S), lenSrc, nil, 0);
  SetLength(Result, lenDst);
  MultiByteToWideChar(CP_UTF8, 0, Pointer(S), lenSrc, Pointer(Result), lenDst);
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  sldb: TSQLiteDatabase;
  sltb: TSQLIteTable;
  Stmt: TSQLiteStmt;
  ID,iRow,iCount: Integer;
  sText: widestring;
  pzTail: PWideChar;
begin
  sldb := TSQLiteDatabase.Create('F:\WorkSVN\idgp\ZhanJiangII\!SC\Server\GameCenter\Language\zh-TA.db');
  try
    if sldb.TableExists('contents') then
    begin
      sltb := slDb.GetTable('SELECT * FROM contents');
    end;
    iCount := 0;
    while not sltb.EOF do
    begin
      if iCount = 0 then
      begin
        sldb.BeginTransaction;
      end;
      ID := sltb.FieldAsInteger(sltb.FieldIndex['id']);
      sText := utf8ToAnsi(sltb.FieldAsString(sltb.FieldIndex['content']));
      if IsCN(sText) then
      begin
        CheckSQliteResult(
          sqlite3_prepare16(sldb.DB, 'INSERT INTO idcontents(id) VALUES(?)', -1, Stmt, pzTail),
          SQLITE_OK);
        CheckSQliteResult(sqlite3_bind_int(Stmt, 1, ID), SQLITE_OK);
        CheckSQliteResult(sqlite3_step(Stmt), SQLITE_DONE);
        sqlite3_finalize(Stmt);
      end;
      sltb.Next;
      Inc(iCount);
      if iCount = 500 then
      begin
        sldb.Commit;
        iCount := 0;
      end;
    end;
    if iCount > 0 then
    begin
      sldb.Commit;
    end;
    sltb.Free;
  finally
    sldb.Free;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  sldb: TSQLiteDatabase;
  sltb: TSQLIteTable;
  Stmt: TSQLiteStmt;
  ID,iRow,iCount: Integer;
  sText,sValue,sValue2: widestring;
  pzTail: PWideChar;
begin
  sldb := TSQLiteDatabase.Create('F:\WorkSVN\idgp\ZhanJiangII\!SC\Server\GameCenter\Language\zh-KR.db');
  OpenExcel('E:\delphi\工具程序测试\判断utf8中文\新建文件夹\content_3-22_KR.xlsx');
  try
    if sldb.TableExists('contents_copy') then
    begin
      sltb := slDb.GetTable('SELECT * FROM contents_copy');
    end;
    ExcelWorkSheet.ConnectTo(ExcelWorkbook.WorkSheets['Sheet4'] as _Worksheet);
    iRow := 2;
    iCount := 0;
    while VarType(ExcelWorkSheet.Cells.Item[iRow,1].value) <> varEmpty do
    begin
      if iCount = 0 then
      begin
        sldb.BeginTransaction;
      end;
      id := StrToInt(ExcelWorkSheet.Cells.Item[iRow,1]);
      sText := ExcelWorkSheet.Cells.Item[iRow,2];
      sValue := ExcelWorkSheet.Cells.Item[iRow,3];
//      sValue2 := ExcelWorkSheet.Cells.Item[iRow,4];
      CheckSQliteResult(
        sqlite3_prepare16(sldb.DB, 'INSERT INTO contents_copy Values(?,?,?)', -1, Stmt, pzTail),
        SQLITE_OK);
      CheckSQliteResult(sqlite3_bind_int(Stmt, 1, ID), SQLITE_OK);
      CheckSQliteResult(sqlite3_bind_text16(Stmt, 2, PWideChar(sText), -1, nil), SQLITE_OK);
      CheckSQliteResult(sqlite3_bind_text16(Stmt, 3, PWideChar(sValue), -1, nil), SQLITE_OK);
//      CheckSQliteResult(sqlite3_bind_text16(Stmt, 4, PWideChar(sValue2), -1, nil), SQLITE_OK);
      CheckSQliteResult(sqlite3_step(Stmt), SQLITE_DONE);
      sqlite3_finalize(Stmt);
      Inc(iCount);
      if iCount = 500 then
      begin
        sldb.Commit;
        iCount := 0;
      end;
      Inc(iRow);
    end;
    if iCount > 0 then
    begin
      sldb.Commit;
    end;
    sltb.Free;
  finally
    sldb.Free;
  end;
end;

procedure TForm2.Button4Click(Sender: TObject);
var
  I: Integer;
  S: string;
  strList: TStringList;
  xmlDoc : IXMLDOMDocument;
  NodeList: IXMLDomNodeList;
  Element : IXMLDOMElement;
begin
  xmlDoc := CoDOMDocument.Create();
  strList := TStringList.Create;
  if xmlDoc.load('F:\WorkSVN\idgp\ZhanJiangII\!SC\Server\GameCenter\StdItems.xml') then
  begin
    NodeList := xmlDoc.documentElement.selectNodes('//StdItem');
    for I := 0 to NodeList.length - 1 do
    begin
      S := NodeList[I].attributes.getNamedItem('id').nodeValue;
      S := S + ' ' + NodeList[I].attributes.getNamedItem('name').nodeValue;
      S := S + ' ' + NodeList[I].attributes.getNamedItem('desc').nodeValue;
      strList.Add(S);
    end;
  end;
  strList.SaveToFile('.\StdItems.txt');
  strList.Free;
  xmlDoc := nil;
end;

procedure TForm2.Button5Click(Sender: TObject);
var
  sldb: TSQLiteDatabase;
  sltb: TSQLIteTable;
  Stmt: TSQLiteStmt;
  I,ID,iRow,iCount: Integer;
  S,sType,sKey,sValue: widestring;
  sText: widestring;
  pzTail: PWideChar;
  strList: TStringList;
begin
  sldb := TSQLiteDatabase.Create('F:\WorkSVN\idgp\AnHei\!SC\Server\data\language\zh-cn.db');
  try
    if sldb.TableExists('contents') then
    begin
      sltb := slDb.GetTable('SELECT * FROM contents');
    end;
    strList := TStringList.Create;
    strList.LoadFromFile('d:\serverlang.txt');
    iCount := 0;
    for I := 0 to strList.Count - 1 do
    begin
      if iCount = 0 then
      begin
        sldb.BeginTransaction;
      end;
      S := strList.Strings[I];
      ID := StrToInt(Copy(S,1,Pos(' ',S)-1));
      Delete(S,1,Pos(' ',S));
      sType := Copy(S,1,Pos(' ',S)-1);
      Delete(S,1,Pos(' ',S));
      sKey := Copy(S,1,Pos(' ',S)-1);
      Delete(S,1,Pos(' ',S));
      sValue := Copy(S,1,Length(S));
      CheckSQliteResult(
        sqlite3_prepare16(sldb.DB, 'INSERT INTO contents Values(?,?,?,?)', -1, Stmt, pzTail),
        SQLITE_OK);
      CheckSQliteResult(sqlite3_bind_int(Stmt, 1, ID), SQLITE_OK);
      CheckSQliteResult(sqlite3_bind_text16(Stmt, 2, PWideChar(sType), -1, nil), SQLITE_OK);
      CheckSQliteResult(sqlite3_bind_text16(Stmt, 3, PWideChar(sKey), -1, nil), SQLITE_OK);
      CheckSQliteResult(sqlite3_bind_text16(Stmt, 4, PWideChar(sValue), -1, nil), SQLITE_OK);
      CheckSQliteResult(sqlite3_step(Stmt), SQLITE_DONE);
      sqlite3_finalize(Stmt);
      Inc(iCount);
      if iCount = 500 then
      begin
        sldb.Commit;
        iCount := 0;
      end;
    end;
    if iCount > 0 then
    begin
      sldb.Commit;
    end;
    sltb.Free;
  finally
    sldb.Free;
  end;
end;

procedure TForm2.Button6Click(Sender: TObject);
var
  I,Idx,ID,iCount,iRow: Integer;
  S,sType,sKey,sValue: widestring;
  strList,LangList: TStringList;
  RValue,TValue: Variant;
begin
  strList := TStringList.Create;
  LangList := TStringList.Create;
  strList.LoadFromFile('d:\serverlang.txt');
  iCount := 0;
  for I := 0 to strList.Count - 1 do
  begin
    S := strList.Strings[I];
    ID := StrToInt(Copy(S,1,Pos(' ',S)-1));
    Delete(S,1,Pos(' ',S));
    sType := Copy(S,1,Pos(' ',S)-1);
    Delete(S,1,Pos(' ',S));
    sKey := Copy(S,1,Pos(' ',S)-1);
    Delete(S,1,Pos(' ',S));
    sValue := Copy(S,1,Length(S));
    if sType = 'Item' then
    begin
      LangList.AddObject('Lang.'+sType+'.'+sKey,TObject(ID));
    end;
  end;
  OpenExcel('F:\WorkSVN\idgp\AnHei\!MEMBER\配置模板\道具表配置表.xlsx');
  try
    ExcelWorkSheet.ConnectTo(ExcelWorkbook.WorkSheets['装备通用数据'] as _Worksheet);
    iRow := 5;
    iCount := 0;
    while True do
    begin
      RValue := ExcelWorkSheet.Cells.Item[iRow,4].value;
      TValue := ExcelWorkSheet.Cells.Item[iRow,5].value;
      if VarType(RValue) = varEmpty then break;
      sValue := RValue;
      Idx := LangList.IndexOf(sValue);
      if Idx <> -1 then
      begin
        Id := Integer(LangList.Objects[Idx]);
        ExcelWorkSheet.Cells.Item[iRow,4] := Format('Lang[%d]',[Id]);
      end;
      sValue := TValue;
      Idx := LangList.IndexOf(sValue);
      if Idx <> -1 then
      begin
        Id := Integer(LangList.Objects[Idx]);
        ExcelWorkSheet.Cells.Item[iRow,5] := Format('Lang[%d]',[Id]);
      end;
      Inc(iRow);
    end;
    ExcelWorkSheet.SaveAs('F:\WorkSVN\idgp\AnHei\!MEMBER\配置模板\temp.xlsx');
  finally
    CloseExcel;
  end;
  ShowMessage('完成');
end;

procedure TForm2.Button7Click(Sender: TObject);
var
  I,Idx,ID,iCount,iRow: Integer;
  S,sType,sKey,sValue: widestring;
  strList,LangList: TStringList;
  RValue,TValue: Variant;
begin
  strList := TStringList.Create;
  LangList := TStringList.Create;
  strList.LoadFromFile('d:\serverlang.txt');
  iCount := 0;
  for I := 0 to strList.Count - 1 do
  begin
    S := strList.Strings[I];
    ID := StrToInt(Copy(S,1,Pos(' ',S)-1));
    Delete(S,1,Pos(' ',S));
    sType := Copy(S,1,Pos(' ',S)-1);
    Delete(S,1,Pos(' ',S));
    sKey := Copy(S,1,Pos(' ',S)-1);
    Delete(S,1,Pos(' ',S));
    sValue := Copy(S,1,Length(S));
    if sType = 'EntityName' then
    begin
      LangList.AddObject('Lang.'+sType+'.'+sKey,TObject(ID));
    end;
  end;
  OpenExcel('F:\WorkSVN\idgp\AnHei\!MEMBER\配置模板\怪物配置表.xlsx');
  try
    ExcelWorkSheet.ConnectTo(ExcelWorkbook.WorkSheets['主模板'] as _Worksheet);
    iRow := 5;
    iCount := 0;
    while True do
    begin
      RValue := ExcelWorkSheet.Cells.Item[iRow,4].value;
      if VarType(RValue) = varEmpty then break;
      sValue := RValue;
      Idx := LangList.IndexOf(sValue);
      if Idx <> -1 then
      begin
        Id := Integer(LangList.Objects[Idx]);
        ExcelWorkSheet.Cells.Item[iRow,4] := Format('Lang[%d]',[Id]);
      end;
      Inc(iRow);
    end;
    ExcelWorkSheet.SaveAs('F:\WorkSVN\idgp\AnHei\!MEMBER\配置模板\temp.xlsx');
  finally
    CloseExcel;
  end;
  ShowMessage('完成');
end;

procedure TForm2.Button8Click(Sender: TObject);
var
  I,Idx,ID,iCount,iRow: Integer;
  S,sType,sKey,sValue: widestring;
  strList,LangList: TStringList;
  RValue,TValue: Variant;
begin
  strList := TStringList.Create;
  LangList := TStringList.Create;
  strList.LoadFromFile('d:\serverlang.txt');
  iCount := 0;
  for I := 0 to strList.Count - 1 do
  begin
    S := strList.Strings[I];
    ID := StrToInt(Copy(S,1,Pos(' ',S)-1));
    Delete(S,1,Pos(' ',S));
    sType := Copy(S,1,Pos(' ',S)-1);
    Delete(S,1,Pos(' ',S));
    sKey := Copy(S,1,Pos(' ',S)-1);
    Delete(S,1,Pos(' ',S));
    sValue := Copy(S,1,Length(S));
    if sType = 'Skill' then
    begin
      LangList.AddObject('Lang.'+sType+'.'+sKey,TObject(ID));
    end;
  end;
  OpenExcel('F:\WorkSVN\idgp\AnHei\!MEMBER\配置模板\技能配置表.xlsx');
  try
    ExcelWorkSheet.ConnectTo(ExcelWorkbook.WorkSheets['主模板'] as _Worksheet);
    iRow := 5;
    iCount := 0;
    while True do
    begin
      RValue := ExcelWorkSheet.Cells.Item[iRow,4].value;
      TValue := ExcelWorkSheet.Cells.Item[iRow,5].value;
      if VarType(RValue) = varEmpty then break;
      sValue := RValue;
      Idx := LangList.IndexOf(sValue);
      if Idx <> -1 then
      begin
        Id := Integer(LangList.Objects[Idx]);
        ExcelWorkSheet.Cells.Item[iRow,4] := Format('Lang[%d]',[Id]);
      end;
      sValue := TValue;
      Idx := LangList.IndexOf(sValue);
      if Idx <> -1 then
      begin
        Id := Integer(LangList.Objects[Idx]);
        ExcelWorkSheet.Cells.Item[iRow,5] := Format('Lang[%d]',[Id]);
      end;
      Inc(iRow);
    end;
    ExcelWorkSheet.SaveAs('F:\WorkSVN\idgp\AnHei\!MEMBER\配置模板\temp.xlsx');
  finally
    CloseExcel;
  end;
  ShowMessage('完成');
end;

procedure TForm2.Button9Click(Sender: TObject);
var
  sldb: TSQLiteDatabase;
  sltb: TSQLIteTable;
  Stmt: TSQLiteStmt;
  I,ID,iRow,iCount: Integer;
  S,sValue: widestring;
  sText: widestring;
  pzTail: PWideChar;
  strList: TStringList;
begin
  sldb := TSQLiteDatabase.Create('F:\WorkSVN\idgp\AnHei\!SC\Server\data\language\zh-cn.db');
  try
    if sldb.TableExists('lang') then
    begin
      sltb := slDb.GetTable('SELECT * FROM lang');
    end;
    strList := TStringList.Create;
    strList.LoadFromFile('E:\delphi\工具程序测试\AS语言包\lang.txt');
    iCount := 0;
    for I := 0 to strList.Count - 1 do
    begin
      if iCount = 0 then
      begin
        sldb.BeginTransaction;
      end;
      S := strList.Strings[I];
      ID := StrToInt(Copy(S,1,Pos(' ',S)-1));
      Delete(S,1,Pos(' ',S));
      sValue := Copy(S,1,Length(S));
      CheckSQliteResult(
        sqlite3_prepare16(sldb.DB, 'INSERT INTO lang Values(?,?)', -1, Stmt, pzTail),
        SQLITE_OK);
      CheckSQliteResult(sqlite3_bind_int(Stmt, 1, ID), SQLITE_OK);
      CheckSQliteResult(sqlite3_bind_text16(Stmt, 2, PWideChar(sValue), -1, nil), SQLITE_OK);
      CheckSQliteResult(sqlite3_step(Stmt), SQLITE_DONE);
      sqlite3_finalize(Stmt);
      Inc(iCount);
      if iCount = 500 then
      begin
        sldb.Commit;
        iCount := 0;
      end;
    end;
    if iCount > 0 then
    begin
      sldb.Commit;
    end;
    sltb.Free;
  finally
    sldb.Free;
  end;
end;

procedure TForm2.CloseExcel;
begin
  ExcelWorkSheet.Disconnect;
  ExcelWorkbook.Disconnect;
  ExcelApplication.Quit;
  ExcelApplication.Disconnect;
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
