unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, RzLabel, Mask, RzEdit, RzBtnEdt,
  RzShellDialogs, Buttons, RzPrgres, ComCtrls, comobj, RzSplit, Menus, DB,
  SqlExpr, RzButton, RzRadChk, SQLiteTable3, SQLite3, RzBorder, DBXMySQL, FMTBcd, inifiles,
  RzStatus, sSkinManager;
const
 MsgSucce = '恭喜 您的操作已经成功完成';
 ColID= 'id';
 ColContent = 'content';
 COlCateGory = 'category';
 COlModdate = 'moddate';
 StrInfor = '正在执行[当前%d/共%d]';
 SqlUPdate = 'UPDATE contents SET content = ? WHERE id= ?';
 MySqlUPdate = 'UPDATE contents SET content = %s WHERE id= %d';
 SqlMaxid = 'SELECT max(id) as id FROM contents';
 SqlAll = 'SELECT * FROM contents';
 sqlInsert = 'INSERT INTO contents Values(?,?,?,?)';
 MysqlInsert = 'INSERT INTO contents Values';
 MySqlInsertValue = '(%d,%s,%d,%s),';
 StrSucc = '数据库连接成功...';
 StrFail = '数据库连接失败...';
 StrNoTable = '你所连接的数据库木有 contents表';
 StrTable = '正在连接到表 contents';
 StrTablename = 'contents';
 DefMysqlExcelName = 'Mysql-contents';
 ConfigFile = 'Config.ini';
 TxtIndent = 'Txt';
 MysqlIndent = 'Mysql';

 SqlliteIndent = 'Sqllite';
 SqlliteFile = 'Filename';


type
 PlangRecord = ^TlangRecord;
 TlangRecord = record
   ID: integer;
   Content: String;
   Category:integer;
   Moddate:string;
 end;

  TForm1 = class(TForm)
    RzGroupBox1: TRzGroupBox;
    RzGroupBox2: TRzGroupBox;
    RzGroupBox3: TRzGroupBox;
    RZBTTxt: TRzButtonEdit;
    RzLabel1: TRzLabel;
    OD1: TRzOpenDialog;
    btnTxtToExcel: TSpeedButton;
    btnExcelToTxt: TSpeedButton;
    btn4: TSpeedButton;
    RzLabel2: TRzLabel;
    RZBTExcelToTxt: TRzButtonEdit;
    SD1: TRzSaveDialog;
    RzSplitter1: TRzSplitter;
    RzPanel1: TRzPanel;
    lbledtHost: TLabeledEdit;
    lbledtport: TLabeledEdit;
    lbledtDB: TLabeledEdit;
    lbledtuser: TLabeledEdit;
    btn1: TSpeedButton;
    lbledtpw: TLabeledEdit;
    RzSplitter2: TRzSplitter;
    btn2: TSpeedButton;
    btn3: TSpeedButton;
    RzLabel4: TRzLabel;
    RZBTSqlLiteExcel: TRzButtonEdit;
    SCTemp: TSQLConnection;
    RzLabel3: TRzLabel;
    RZBTSLDB: TRzButtonEdit;
    lbledt6: TLabeledEdit;
    SqlLiteInsert: TRzCheckBox;
    lbledt7: TLabeledEdit;
    RZBT4: TRzButtonEdit;
    RCBMysqlInsert: TRzCheckBox;
    btn5: TSpeedButton;
    btn6: TSpeedButton;
    RzLabel5: TRzLabel;
    btn7: TSpeedButton;
    SQTemp: TSQLQuery;
    rpb1: TRzProgressBar;
    procedure RZBTTxtButtonClick(Sender: TObject);
    procedure RZBTExcelToTxtButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnTxtToExcelClick(Sender: TObject);
    procedure btnExcelToTxtClick(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure RZBTSqlLiteExcelClick(Sender: TObject);
    procedure RZBT4Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
  private
    procedure SetContByFile(edit: TRzButtonEdit; const FileExt: string;
      Sb: TSpeedButton);
    procedure ReadTxtTolist;
    procedure TxtToExcel;
    procedure ReadExcelTolist;
    procedure SqlLiteToList;
    procedure ClearLanglist;
    procedure SqlLiteListToExcel;
    procedure SqlListExcelTolist(ExcelFilename:string);
    procedure listToSqlLite;
    function ConnectionMysql(TargetSC: TSQLConnection): boolean;
    function HaveTable(SQLQuery: TSQLQuery; sDBName,
      sTableName: string): Boolean;
    procedure MySqlToList;
    procedure MysqlListToExcel;
    procedure listToMysql;
    procedure ExcSql(const SqlStr: string);
    procedure SaveConfig;
    procedure CheckConfig;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  LangList: Tstringlist;
  LangFilename: string;

implementation

{$R *.dfm}
procedure CheckSQliteResult(ret, check: Integer);
begin
  if ret <> check then
    Raise Exception.Create('fail');
end;

procedure TForm1.RZBTExcelToTxtButtonClick(Sender: TObject);
begin
 SetContByFile(RZBTExcelToTxt, 'Excel文件|*.xls;*.xlsx;', btnExcelToTxt);
end;

procedure TForm1.RZBTSqlLiteExcelClick(Sender: TObject);
begin
 SetContByFile(RZBTSqlLiteExcel, 'Excel文件|*.xls;*.xlsx;', btn3);
end;

procedure TForm1.SaveConfig;
var
 MyConfig : TIniFile;
 function SaveIndent(Const indent,indentFild,defaltvalue:string):string;
 begin
    with MyConfig do
      WriteString(indent,indentFild,defaltvalue);
 end;
begin
  MyConfig :=TIniFile.Create(ExtRactFilePath(ParamStr(0)) + ConfigFile);
  with MyConfig do
  try
    SaveIndent(SqlliteIndent, SqlliteFile, RZBTSLDB.Text);
    SaveIndent(MysqlIndent, 'Host', lbledtHost.Text);
    SaveIndent(MysqlIndent, 'Port', lbledtport.Text);
    SaveIndent(MysqlIndent, 'User', lbledtuser.Text);
    SaveIndent(MysqlIndent, 'Password', lbledtpw.Text);
    SaveIndent(MysqlIndent, 'DB', lbledtDB.Text);
  finally
    Free;
  end;

end;

procedure TForm1.SetContByFile(edit:TRzButtonEdit; Const FileExt:string; Sb:TSpeedButton);
begin
 OD1.Filter := FileExt;
 if OD1.Execute then
 begin
   edit.Text := OD1.FileName;
 end;
 if fileexists(edit.Text) then
   Sb.Enabled := true
 else
   Sb.Enabled := false;
end;

procedure TForm1.ClearLanglist();
var
 i: integer;
begin
 try
   for i := 0 to Langlist.Count-1 do
   begin
     dispose(PlangRecord(Langlist.Objects[i]));
   end;
   Langlist.Clear;
 except
  Langlist.Clear;
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

procedure TForm1.SqlLiteToList();
var
  sldb: TSQLiteDatabase;
  sltb:TSQLiteUniTable;
  plangRecord1:  PlangRecord;
  s: ansistring;
begin
  sldb := TSQLiteDatabase.Create(RZBTSLDB.Text);
  try
    if sldb.TableExists('contents') then
    begin
     s := Utf8encode(lbledt6.Text);
     sltb := slDb.GetUniTable(s);
    end;
    ClearLanglist;
    while not sltb.EOF do
    begin
      new(plangRecord1);
      plangRecord1.ID := sltb.FieldAsInteger(sltb.FieldIndex[colid]);
      s := sltb.FieldAsString(sltb.FieldIndex[colcontent]);
      plangRecord1.Content :=Utf8decode(s);

      plangRecord1.Category := sltb.FieldAsInteger(sltb.FieldIndex[COlCateGory]);
      plangRecord1.Moddate := Utf8ToString(sltb.FieldAsString(sltb.FieldIndex[COlModdate]));
      langlist.AddObject(plangRecord1.Content, Tobject(plangRecord1));
      sltb.Next;
    end;
    sltb.Free;
  finally
    sldb.Free;
  end;
end;

procedure TForm1.SqlLiteListToExcel;
var
  ExcelApp,workbook,sheet:Variant;
  iRow, iCol :integer;
  I: Integer;
  id, name, ItemDup, ItemDesc :string;
  a:OleVariant;
begin
  SD1.Filter := 'Excel2007格式文件|*.xlsx|Excel2003格式文件|*.xls';
  try


    ExcelApp:=UnAssigned();
    ExcelApp := CreateOleObject('Excel.application');
    workbook := ExcelApp.WorkBooks.Add;
    Sheet := ExcelApp.Sheets[1];
    Sheet.cells[1,1].value := ColID;
    Sheet.cells[1,2].value := ColContent;
    Sheet.cells[1,3].value := COlCateGory;
    Sheet.cells[1,4].value := COlModdate;
    Sheet.Columns[2].numberformatlocal:=AnsiString('@');
    rpb1.TotalParts := LangList.Count;
   for I := 0 to LangList.Count-1 do
    begin
      Sheet.cells[2 + I,1].value := PlangRecord(Langlist.Objects[i]).ID;
      Sheet.cells[2 + I,2].value := PlangRecord(Langlist.Objects[i]).Content;
      Sheet.cells[2 + I,3].value := PlangRecord(Langlist.Objects[i]).Category;
      Sheet.cells[2 + I,4].value := PlangRecord(Langlist.Objects[i]).Moddate;
      rpb1.IncPartsByOne;
      application.ProcessMessages;
    end;
    Sheet.Columns[1].Columnwidth  := 20;
    Sheet.Columns[2].Columnwidth  := 20;
    Sheet.Columns[3].Columnwidth  := 20;
    Sheet.Columns[4].Columnwidth  := 20;
  finally
    if SD1.Execute then
      begin
        ExcelApp.ActiveWorkbook.saveas(SD1.FileName);
      end
    else
      ExcelApp.ActiveWorkBook.Saved := True;
    Sheet := unassigned;
    workbook.Close;
    ExcelApp.quit;
    ExcelApp := unassigned;
    showmessage(MsgSucce)
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
 if ConnectionMysql(SCTemp) then
  caption := StrSucc
 else
  caption := StrFail;

end;

procedure TForm1.btn2Click(Sender: TObject);
var
 x:TEncoding;
begin
 SqlLiteToList;
 SqlLiteListToExcel;
end;

procedure TForm1.SqlListExcelTolist(ExcelFilename:string);
var
  ExcelApp,workbook,sheet:Variant;
  iRow, iCol, Rows :integer;
  Bselect : Boolean;
  I, id, Category: Integer;
  content :string;
  Moddate :Tdatetime;
  plangRecord1:  PlangRecord;
begin
  try
    ExcelApp:=UnAssigned();
    ExcelApp := CreateOleObject('Excel.application');
    ExcelApp.WorkBooks.Open(ExcelFilename);
    ExcelApp.Visible := false;
    Sheet := ExcelApp.Sheets[1];
    Rows:=ExcelApp.ActiveSheet.UsedRange.Rows.Count;
    rpb1.TotalParts := Rows;
    clearlanglist;
    for I := 2 to Rows do
    begin
      content := Sheet.cells[I,2].value;
      if (not trystrtoint(Sheet.cells[I,1].value, id)) or (content = '') then
       continue;
      new(plangRecord1);
      plangRecord1.ID := id;
      plangRecord1.Content :=content;

      if trystrtoint(Sheet.cells[I,3].value, Category) then
       plangRecord1.Category := Category
      else
       plangRecord1.Category := 0;
      if trystrtodatetime(Sheet.cells[I,4].value, Moddate) then
       plangRecord1.Moddate := formatdatetime('YYYY-MM-DD HH:MM:SS', Moddate)
      else
       plangRecord1.Moddate := '';

      langlist.AddObject(inttostr(id), Tobject(plangRecord1));
      rpb1.IncPartsByOne;
      application.ProcessMessages;
    end;
  finally
    ExcelApp.ActiveWorkBook.Saved := True;
    ExcelApp.ActiveWorkBook.Close;
    Sheet := unassigned;
    ExcelApp.quit;
    ExcelApp := unassigned;
//    showmessage(MsgSucce)
  end;
end;

procedure TForm1.listToSqlLite;
var
  sldb: TSQLiteDatabase;
  sltb: TSQLIteTable;
  Stmt: TSQLiteStmt;
  i,iCount, maxid: Integer;
//  sText: widestring;
  pzTail: PWideChar;
begin
  sldb := TSQLiteDatabase.Create(RZBTSLDB.Text);
  try
    if sldb.TableExists('contents') then
    begin
      sltb  := slDb.GetTable(utf8encode(SqlMaxid));
      if sltb.CountResult = 0 then
       maxid :=0
      else
       maxid := sltb.FieldAsInteger(sltb.FieldIndex[colid]);
//      sltb := slDb.GetTable(utf8encode(SqlAll));
    end;
    iCount := 0;

    rpb1.TotalParts := LangList.Count;
    for i := 0 to langlist.Count -1 do
    begin
      if iCount = 0 then sldb.BeginTransaction;
      if PlangRecord(Langlist.Objects[i]).ID <= maxid then
      begin
        CheckSQliteResult(
          sqlite3_prepare16(sldb.DB, PWideChar(SqlUPdate), -1, Stmt, pzTail),
          SQLITE_OK);
        CheckSQliteResult(sqlite3_bind_text16(Stmt, 1, PWideChar(PlangRecord(Langlist.Objects[i]).Content), -1, nil), SQLITE_OK);
        CheckSQliteResult(sqlite3_bind_int(Stmt, 2, PlangRecord(Langlist.Objects[i]).ID), SQLITE_OK);
        CheckSQliteResult(sqlite3_step(Stmt), SQLITE_DONE);
        sqlite3_finalize(Stmt);
      end
      else
      begin
       if not SqlLiteInsert.Checked then continue;

        CheckSQliteResult(
          sqlite3_prepare16(sldb.DB, PWideChar(sqlInsert), -1, Stmt, pzTail),
          SQLITE_OK);
        CheckSQliteResult(sqlite3_bind_int(Stmt, 1, PlangRecord(Langlist.Objects[i]).id), SQLITE_OK);
        CheckSQliteResult(sqlite3_bind_text16(Stmt, 2, PWideChar(PlangRecord(Langlist.Objects[i]).Content), -1, nil), SQLITE_OK);
        CheckSQliteResult(sqlite3_bind_int(Stmt, 3, PlangRecord(Langlist.Objects[i]).Category), SQLITE_OK);
        CheckSQliteResult(sqlite3_bind_text16(Stmt, 4, PWideChar(formatdatetime('YYYY-MM-DD HH:MM:SS', now)), -1, nil), SQLITE_OK);
        CheckSQliteResult(sqlite3_step(Stmt), SQLITE_DONE);
        sqlite3_finalize(Stmt);
      end;


      rpb1.IncPartsByOne;
      caption := format(StrInfor, [i + 1, rpb1.TotalParts]);
      Inc(iCount);
      if iCount = 500 then
      begin
        sldb.Commit;
        iCount := 0;
      end;
    end;
    if iCount > 0 then sldb.Commit;

    sltb.Free;
  finally
    sldb.Free;
  end;
end;



procedure TForm1.btn3Click(Sender: TObject);
begin
 SqlListExcelTolist(RZBTSqlLiteExcel.Text);
 listToSqlLite;
end;

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

procedure TForm1.ExcSql(Const SqlStr:string);
begin
  with SQTemp do
  begin
   close;
   sql.Text := SqlStr;
   SQTemp.ExecSQL();
  end;
end;


procedure TForm1.listToMysql;
var
  i, maxid, icount: Integer;
  SqlStr, sqlUPdate : string;
  PlangRecord1: PlangRecord;
begin
  try
    if HaveTable(SQTemp, lbledtDB.Text, StrTablename) then
    begin
      caption := strtable;
      with SQTemp do
      begin
       close;
       sql.Text := SqlMaxid;
       open;
       if SQTemp.RecordCount=0 then
        maxid := 0
       else
        maxid := FieldValues[ColID];
      end;

      rpb1.TotalParts := LangList.Count;

      SqlStr := MysqlInsert;
      icount := 0;
      for i := 0 to langlist.Count -1 do
      begin
        PlangRecord1 := PlangRecord(Langlist.Objects[i]);
        if PlangRecord1.ID <= maxid then
        begin
         ExcSql(format(MySqlUPdate, [QuerySQLStr(PlangRecord1.Content), PlangRecord1.ID]));
        end
        else
        begin
          if not RCBMysqlInsert.Checked then continue;
          SqlStr := SqlStr + (format(MySqlInsertValue, [PlangRecord1.ID, QuerySQLStr(PlangRecord1.Content), PlangRecord1.Category, QuerySQLStr(formatdatetime('YYYY-MM-DD HH:MM:SS', now))]));
          icount := icount + 1;
          if icount = 100 then
          begin
            system.Delete(SqlStr,Length(SqlStr),1);
            ExcSql(SqlStr);
            icount := 0;
            SqlStr := MysqlInsert;
          end;
        end;
        rpb1.IncPartsByOne;
        caption := format(StrInfor, [i + 1, rpb1.TotalParts]);
      end;
      if icount<>0 then
      begin
        system.Delete(SqlStr,Length(SqlStr),1);
        ExcSql(SqlStr);
      end;

    end
    else
     caption := StrNoTable;
  finally
  end;
end;


procedure TForm1.btn5Click(Sender: TObject);
begin
 ConnectionMysql(SCTemp);
 SqlListExcelTolist(RZBT4.Text);
 listToMysql;
end;

procedure TForm1.MysqlListToExcel;
var
  ExcelApp,workbook,sheet:Variant;
  iRow, iCol :integer;
  I: Integer;
  id, name, ItemDup, ItemDesc :string;
  a:OleVariant;
begin
  SD1.Filter := 'Excel2007格式文件|*.xlsx|Excel2003格式文件|*.xls';
  try
    ExcelApp:=UnAssigned();
    ExcelApp := CreateOleObject('Excel.application');
    workbook := ExcelApp.WorkBooks.Add;
    Sheet := ExcelApp.Sheets[1];
    Sheet.cells[1,1].value := ColID;
    Sheet.cells[1,2].value := ColContent;
    Sheet.cells[1,3].value := COlCateGory;
    Sheet.cells[1,4].value := COlModdate;
    Sheet.Columns[2].numberformatlocal:=AnsiString('@');
    rpb1.TotalParts := LangList.Count;

    for I := 0 to LangList.Count-1 do
    begin
      Sheet.cells[2 + I,1].value := PlangRecord(Langlist.Objects[i]).ID;
      Sheet.cells[2 + I,2].value := PlangRecord(Langlist.Objects[i]).Content;
      Sheet.cells[2 + I,3].value := PlangRecord(Langlist.Objects[i]).Category;
      Sheet.cells[2 + I,4].value := PlangRecord(Langlist.Objects[i]).Moddate;
      rpb1.IncPartsByOne;
      caption := format(StrInfor, [i + 1, rpb1.TotalParts]);
      application.ProcessMessages;
    end;
    Sheet.Columns[1].Columnwidth  := 20;
    Sheet.Columns[2].Columnwidth  := 20;
    Sheet.Columns[3].Columnwidth  := 20;
    Sheet.Columns[4].Columnwidth  := 20;

  finally
    SD1.FileName := DefMysqlExcelName;
    if SD1.Execute then
      begin
        ExcelApp.ActiveWorkbook.saveas(SD1.FileName);
      end
    else
      ExcelApp.ActiveWorkBook.Saved := True;
    Sheet := unassigned;
    workbook.Close;
    ExcelApp.quit;
    ExcelApp := unassigned;
    showmessage(MsgSucce)
  end;
end;


procedure TForm1.btn6Click(Sender: TObject);
begin
 ConnectionMysql(SCTemp);
 MySqlToList;
 MysqlListToExcel;
end;

procedure TForm1.btn7Click(Sender: TObject);
begin
SaveConfig;
end;

procedure TForm1.MySqlToList();
var
  plangRecord1:  PlangRecord;
begin
  try
    if HaveTable(SQTemp, lbledtDB.Text, StrTablename) then
    begin
      caption := StrTable;
      ClearLanglist;
      with SQTemp do
      begin
        close;
        SQL.Text := (lbledt7.Text);
        Open;
        while not EOF do
        begin
          new(plangRecord1);
          plangRecord1.ID := FieldValues[ColID];
          plangRecord1.Content :=utf8decode(FieldValues[ColContent]) ;
          plangRecord1.Category := FieldValues[COlCateGory];
          plangRecord1.Moddate := FieldValues[COlModdate];
          langlist.AddObject(plangRecord1.Content, Tobject(plangRecord1));
          Next;
        end;
      end;
    end
    else caption := StrNoTable;
//    showmessage(inttostr(langlist.Count));
  finally
  end;
end;


function TForm1.ConnectionMysql(TargetSC:TSQLConnection):boolean;
begin
  try
    TargetSC.Connected := False;
    targetsc.DriverName := 'MySQL';
    targetsc.GetDriverFunc := 'getSQLDriverMYSQL';
    TargetSC.LibraryName := 'dbxmys.dll';
    targetsc.VendorLib := 'LIBMYSQL.dll';
    TargetSC.Params.Clear;
    TargetSC.Params.Append('HostName='+lbledtHost.Text);
    TargetSC.Params.Append('Database=' + lbledtDB.Text);
    TargetSC.Params.Append('User_Name=' + lbledtuser.Text);
    TargetSC.Params.Append('Password=' + lbledtpw.Text);
    TargetSC.Params.Append('ServerCharset=utf-8');
    TargetSC.Connected := True;
    TargetSC.KeepConnection := true;
    result := true;
  except
   on e:exception do
   begin
//    showmessage(e.Message);
    result := false;
   end;
  end;
end;

function TForm1.HaveTable(SQLQuery: TSQLQuery; sDBName, sTableName: string): Boolean;
const
  tSql = 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA="%s" AND TABLE_NAME="%s"';
begin
  if not SCTemp.Connected  then SCTemp.Connected := true;

  with SQLQuery do
  begin
    close;
    SQL.Text := (Format(tSql,[sDBName,sTableName]));
    Open;
    Result := Fields[0].AsString<>'';
    Close;
  end;
end;




procedure TForm1.btnExcelToTxtClick(Sender: TObject);
begin
 ReadExcelTolist;
end;

procedure TForm1.btnTxtToExcelClick(Sender: TObject);
begin
  LangFilename := RZBTTxt.Text;
  ReadTxtTolist;
  TxtToExcel;
end;

procedure TForm1.CheckConfig();
var
 MyConfig : TIniFile;
 function CheckIndent(Const indent,indentFild,defaltvalue:string):string;
 begin
    with MyConfig do
    if not ValueExists(indent,indentFild) then
    begin
      WriteString(indent,indentFild,defaltvalue);
    end else
    result := ReadString(indent,indentFild,defaltvalue);
 end;
begin
  MyConfig :=TIniFile.Create(ExtRactFilePath(ParamStr(0)) + ConfigFile);
  with MyConfig do
  try
    RZBTSLDB.Text := CheckIndent(SqlliteIndent, SqlliteFile, RZBTSLDB.Text);
    lbledtHost.Text := CheckIndent(MysqlIndent, 'Host', lbledtHost.Text);
    lbledtport.Text := CheckIndent(MysqlIndent, 'Port', lbledtport.Text);
    lbledtuser.Text := CheckIndent(MysqlIndent, 'User', lbledtuser.Text);
    lbledtpw.Text := CheckIndent(MysqlIndent, 'Password', lbledtpw.Text);
    lbledtDB.Text := CheckIndent(MysqlIndent, 'DB', lbledtDB.Text);
  finally
    Free;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 CheckConfig;
 LangList := tstringlist.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 ClearLanglist;
 LangList.Free;
end;

procedure TForm1.ReadTxtTolist;
var
  I,Id,iCount: Integer;
  hs: AnsiString;
  S,sText,sSQL: string;
  strList: TStringList;
  StringStream: TStringStream;
begin
//  StringStream := TStringStream.Create('',TEncoding.UTF8);
  strList := TStringList.Create;
  try
//    StringStream.LoadFromFile(RZBTTxt.text);
    LangList.clear;
    strList.LoadFromFile(RZBTTxt.text, TEncoding.UTF8);
//    SetLength(hs,3);
//    StringStream.Position := 0;
//    StringStream.Read(hs[1],3);
//    strList.Text := StringStream.ReadString(StringStream.Size-3);

    for I := 0 to strList.Count-1 do
    begin
      S := strList.Strings[I];
      id := StrToIntDef(Copy(S,1,Pos(' ',S)-1),0);
      if id = 0 then Continue;
      sText := Copy(S,Pos(' ',S)+1,Length(S));
      LangList.Add(inttostr(id) + '=' + sText);
      application.ProcessMessages;
    end;
  finally
    strList.Free;
//    StringStream.Free;
  end;
end;


procedure TForm1.TxtToExcel;
var
  ExcelApp,workbook,sheet:Variant;
  iRow, iCol :integer;
  I: Integer;
  id, name, ItemDup, ItemDesc :string;
begin
  SD1.Filter := 'Excel2007格式文件|*.xlsx|Excel2003格式文件|*.xls';
  try
    ExcelApp:=UnAssigned();
    ExcelApp := CreateOleObject('Excel.application');
    workbook := ExcelApp.WorkBooks.Add;
    Sheet := ExcelApp.Sheets[1];
    Sheet.cells[1,1].value := 'ID';
    Sheet.cells[1,2].value := 'Text';

    rpb1.TotalParts := LangList.Count;

    for I := 0 to LangList.Count-1 do
    begin
      Sheet.cells[2 + I,1].value := LangList.Names[i];
      Sheet.cells[2 + I,2].value := LangList.ValueFromIndex[i];
      rpb1.IncPartsByOne;
      application.ProcessMessages;
      caption := format(StrInfor, [i + 1, rpb1.TotalParts]);
    end;
      ExcelApp.ActiveSheet.Columns[1].Columnwidth  := 20;
      ExcelApp.ActiveSheet.Columns[2].Columnwidth  := 20;
  finally
    if SD1.Execute then
      begin
        ExcelApp.ActiveWorkbook.saveas(SD1.FileName);
      end
    else
      ExcelApp.ActiveWorkBook.Saved := True;
    Sheet := unassigned;
    workbook.Close;
    ExcelApp.quit;
    ExcelApp := unassigned;
    showmessage(MsgSucce)
  end;
end;

procedure TForm1.ReadExcelTolist;
var
  ExcelApp,workbook,sheet:Variant;
  iRow, iCol, Rows :integer;
  Bselect : Boolean;
  I: Integer;
  id, name, ItemDup, ItemDesc,newfilname :string;
  StringStream: TStringStream;
begin
  try
    ExcelApp:=UnAssigned();
    ExcelApp := CreateOleObject('Excel.application');
    ExcelApp.WorkBooks.Open(RZBTExcelToTxt.Text);
    newfilname := changefileext(RZBTExcelToTxt.Text, '.txt');
    ExcelApp.Visible := false;
    Sheet := ExcelApp.Sheets[1];
    Rows:=ExcelApp.ActiveSheet.UsedRange.Rows.Count;
    LangList.Clear;
    rpb1.TotalParts := Rows;

    for I := 2 to Rows do
    begin
      id := Sheet.cells[I,1].value;
      name := Sheet.cells[I,2].value;
      if trim(id)= '' then continue;
      LangList.Add(id + ' ' + name);
      rpb1.IncPartsByOne;
      application.ProcessMessages;
      caption := format(StrInfor, [i + 1, rpb1.TotalParts]);
    end;
  finally
//    LangList.SaveToFile(newfilname);
    StringStream := TStringStream.Create(LangList.Text,TEncoding.UTF8);
    StringStream.SaveToFile(newfilname);
    StringStream.Free;
    ExcelApp.ActiveWorkBook.Saved := True;
    ExcelApp.ActiveWorkBook.Close;
    Sheet := unassigned;
    ExcelApp.quit;
    ExcelApp := unassigned;
    showmessage(MsgSucce)
  end;
end;





procedure TForm1.RZBTTxtButtonClick(Sender: TObject);
begin
 SetContByFile(RZBTSLDB, 'Txt文件|*.txt', btnTxtToExcel);
end;

procedure TForm1.RZBT4Click(Sender: TObject);
begin
 SetContByFile(RZBT4, 'Excel文件|*.xls;*.xlsx;', btn5);
end;

end.
