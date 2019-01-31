unit uTestSqlite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SQLiteTable3, ExtCtrls, jpeg, TestThreadUnit, OfflineMessages;

type
  TForm1 = class(TForm)
    btnTest: TButton;
    memNotes: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    ebName: TEdit;
    Label3: TLabel;
    ebNumber: TEdit;
    Label4: TLabel;
    ebID: TEdit;
    Image1: TImage;
    btnLoadImage: TButton;
    btnDisplayImage: TButton;
    btnBackup: TButton;
    pnStatus: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label7: TLabel;
    Edit2: TEdit;
    Memo1: TMemo;
    procedure btnTestClick(Sender: TObject);
    procedure btnLoadImageClick(Sender: TObject);
    procedure btnDisplayImageClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ShowThreadMessage(threadhandle: THandle; ThreadIndex: integer; Msg: string);
  private
    { Private declarations }
  public
    { Public declarations }
    threadcount: integer;
    threads: array of TTestThread;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//
// 测试SQLite3功能...
procedure TForm1.btnTestClick(Sender: TObject);
var
  SqlDBpath: string;
  SqlDB: TSQLiteDatabase;
  SqlTable: TSQLIteTable;
  sSQL: String;
  Notes: String;
begin
  SqlDBPath := ExtractFilepath(application.exename)+ 'test.db';
  SqlDB := TSQLiteDatabase.Create(SqlDBPath);
  try
    //
    // 判断表存在否，存在就删除它...
    if SqlDB.TableExists('testTable') then
      begin
        sSQL := 'DROP TABLE testtable';
        SqlDB.execsql(AnsiString(sSQL));
      end;
    //
    // 重新建个表...
    sSQL := 'CREATE TABLE testtable ([ID] INTEGER PRIMARY KEY,[OtherID] INTEGER NULL,';
    sSQL := sSQL + '[Name] VARCHAR (255),[Number] FLOAT, [notes] BLOB, [picture] BLOB COLLATE NOCASE);';
    SqlDB.execsql(AnsiString(sSQL));
    //
    // 建索引...
    SqlDB.execsql('CREATE INDEX TestTableName ON [testtable]([Name]);');
    //
    // 开始事务...
    SqlDB.BeginTrans;
    try
      //
      // 插入一个记录...
      sSQL := 'INSERT INTO testtable(Name,OtherID,Number,Notes) VALUES ("Some Name",4,587.6594,"Here are some notes");';
      SqlDB.ExecSQL(AnsiString(sSQL));
      //
      // 插入一个记录...
      sSQL := 'INSERT INTO testtable(Name,OtherID,Number,Notes) VALUES ("Another Name",12,4758.3265,"More notes");';
      SqlDB.ExecSQL(AnsiString(sSQL));
      //
      // 提交事务...
      SqlDB.CommitTrans;
    //
    // 异常就卷回事务...
    except
       SqlDB.RollbackTrans;
    end;
    //
    // 读数据集...
    SqlTable := SqlDB.GetTable('SELECT * FROM testtable');
    try
      //
      // 有记录，就显示第一个记录...
      if SqlTable.Count > 0 then
        begin
          ebName.Text := SqlTable.FieldAsString(SqlTable.FieldIndex['Name']);
          ebID.Text := inttostr(SqlTable.FieldAsInteger(SqlTable.FieldIndex['ID']));
          ebNumber.Text := floattostr( SqlTable.FieldAsDouble(SqlTable.FieldIndex['Number']));
          Notes :=  SqlTable.FieldAsBlobText(SqlTable.FieldIndex['Notes']);
          memNotes.Text := notes;
        end;
      //
      // 查询测试完成，释放数据集...
      pnStatus.Caption:='测试SQLite功能完成！';
    finally
      SqlTable.Free;
    end;
//
// 结束，释放数据库...
  finally
    SqlDB.Free;
  end;
end;

//
// 多线程测试...
procedure TForm1.Button1Click(Sender: TObject);
var
   i: integer;
begin
   ThreadCount:=strtoint(edit1.Text);
   memo1.Lines.Clear;
   SetLength(Threads,ThreadCount);
   for i:=0 to ThreadCount-1 do
      begin
         memo1.Lines.Add('');
         Threads[i]:=TTestThread.Create(i,strtoint(edit2.text),ExtractFilepath(application.exename)+ 'test.db',true);
         Threads[i].Resume;
      end;
end;

//
// 显示一条线程工作信息的过程...
procedure TForm1.ShowThreadMessage(threadhandle: THandle; ThreadIndex: integer; Msg: string);
begin
   memo1.Lines[threadindex]:='线程'+inttostr(threadhandle)+': '+msg;
end;

//
// 写图片文件到BLOB字段的测试...
procedure TForm1.btnLoadImageClick(Sender: TObject);
var
  SqlDBpath: string;
  SqlDB: TSQLiteDatabase;
  SqlTable: TSQLIteTable;
  iID: integer;
  fs: TFileStream;
begin
//
// 判断数据库文件存在否...
  SqlDBPath := ExtractFilepath(application.exename)+ 'test.db';
  if not FileExists(SqlDBPath) then
    begin
      MessageDLg('Test.db does not exist. Click Test Sqlite 3 to create it.',mtInformation,[mbOK],0);
      exit;
    end;
//
// 若存在，创建数据库对象（即打开数据库文件）...
  SqlDB := TSQLiteDatabase.Create(SqlDBPath);
  try
    //
    // 先取首记录的ID字段的值，以便后面生成sql语句之用...
    SqlTable := SqlDB.GetTable('SELECT ID FROM testtable');
    try
      if SqlTable.Count = 0 then
        begin
          MessageDLg('There are no rows in the database. Click Test Sqlite 3 to insert a row.',mtInformation,[mbOK],0);
          exit;
        end;
      iID := SqlTable.FieldAsInteger(SqlTable.FieldIndex['ID']);
    finally
      SqlTable.Free;
    end;
    //
    // 写入一个图片文件到BLOB字段...
    fs:=TFileStream.Create(ExtractFileDir(application.ExeName) + '\sunset.jpg',fmOpenRead);
    try
      SqlDB.UpdateBlob('UPDATE testtable set picture=? WHERE ID=' + AnsiString(inttostr(iID)),fs);
      pnStatus.Caption:='写入图片到Blob字段成功！';
    finally
      fs.Free;
    end;
//
// 完成，关闭数据库...
  finally
    SqlDB.Free;
  end;
end;

//
// 从数据表的Blob字段读一个图片...
procedure TForm1.btnDisplayImageClick(Sender: TObject);
var
  SqlDBpath: string;
  SqlDB: TSQLiteDatabase;
  SqlTable: TSQLIteTable;
  iID: integer;
  ms: TMemoryStream;
  pic: TJPegImage;
begin
//
// 打开数据库...
  SqlDBPath := ExtractFilepath(application.exename)+ 'test.db';
  if not FileExists(SqlDBPath) then
    begin
      MessageDLg('Test.db does not exist. Click Test Sqlite 3 to create it, then Load image to load an image.',mtInformation,[mbOK],0);
      exit;
    end;
//
// 打开数据表...
  SqlDB := TSQLiteDatabase.Create(SqlDBPath);
  try
    //
    // 取ID，供后面使用...
    SqlTable := SqlDB.GetTable('SELECT ID FROM testtable');
    try
      if not SqlTable.Count = 0 then
        begin
          MessageDLg('No rows in the test database. Click Test Sqlite 3 to insert a row, then Load image to load an image.',mtInformation,[mbOK],0);
          exit;
        end;
      iID := SqlTable.FieldAsInteger(SqlTable.FieldIndex['ID']);
    finally
      SqlTable.Free;
    end;
    //
    // 查找记录，并将图片取出到流，再显示到图片对象...
    SqlTable := SqlDB.GetTable('SELECT picture FROM testtable where ID = ' + AnsiString(inttostr(iID)));
    try
      //
      // 取出到流对象MS中（注意此对象会在下一语句执行时自动创建，也会在表对象释放时自动一起释放）...
      ms:=SqlTable.FieldAsBlob(SqlTable.FieldIndex['picture']);
      if (ms = nil) then
        begin
          MessageDLg('No image in the test database. Click Load image to load an image.',mtInformation,[mbOK],0);
          exit;
        end;
      ms.Position := 0;
      pic := TJPEGImage.Create;
      pic.LoadFromStream(ms);
      self.Image1.Picture.Graphic:= pic;
      pic.Free;
      pnStatus.Caption:='从Blob字段读取图片成功！';
    finally
      SqlTable.Free;
    end;
//
// 完成，释放数据库对象...
  finally
    SqlDB.Free;
  end;
end;

//
// 数据库备份测试...
procedure TForm1.btnBackupClick(Sender: TObject);
var
  SqlDBpath: string;
  SqlDB: TSQLiteDatabase;
  SqlDBBak: TSQLiteDatabase;
begin
//
// 打开数据库...
  SqlDBPath := ExtractFilepath(application.exename);
  if not FileExists(SqlDBPath + 'test.db') then
    begin
      MessageDLg('Test.db does not exist. Click Test Sqlite 3 to create it.',mtInformation,[mbOK],0);
      exit;
    end;
  SqlDB := TSQLiteDatabase.Create(SqlDBPath + 'test.db');
//
// 备份到新的库文件...
  try
    SqlDBBak := TSQLiteDatabase.Create(SqlDBPath + 'testbak.db');
    try
      if SqlDB.Backup(SqlDBBak) = 101 then
        pnstatus.Caption := '备份数据库成功！'
      else
        pnstatus.Caption := '备份数据库失败啦';
    finally
      SqlDBBak.Free;
    end;
  finally
    SqlDB.Free;
  end;
end;

end.
