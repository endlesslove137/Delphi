unit TestThreadUnit;

interface

Uses
   {$IF CompilerVersion>=23.0}System.Classes{$ELSE}Classes{$IFEND},
   {$IF CompilerVersion>=23.0}System.SysUtils{$ELSE}SysUtils{$IFEND},
   {$IF CompilerVersion>=23.0}Winapi.Windows{$ELSE}Windows{$IFEND},
   SQLiteTable3;

type
    TTestThread = class(TThread)
    private
       filename: string;
       ThreadIndex: integer;
       Msg: string;
       taskcount: integer;
       TestCount: integer;
    protected
       procedure Execute; override;
       procedure ShowMsg;
    public
       constructor Create(ThreadIdx: integer; MaxCount: integer; dbfilename: string; CreateSuspended: boolean);
       destructor Destroy; override;
    end;

implementation

uses uTestSqlite;

//
// 创建对象实例...
constructor TTestThread.Create(ThreadIdx: integer; MaxCount: integer; dbfilename: string; CreateSuspended: boolean);
begin
   inherited Create(CreateSuspended);
   FreeOnTerminate:=true;
   filename:=dbfilename;
   ThreadIndex:=ThreadIdx;
   taskcount:=0;
   TestCount:=MaxCount;
end;

//
// 释放对象实例...
destructor TTestThread.Destroy;
begin
   inherited;
end;

//
// 显示消息的过程...
procedure TTestThread.ShowMsg;
begin
   Form1.ShowThreadMessage(self.Handle,ThreadIndex,msg);
end;

//
// 线程执行过程...
procedure TTestThread.Execute;
var
//   ssql: string;
   SqlDB: TSQLiteDatabase;
   SqlTable: TSQLIteTable;
   i: integer;
begin
   SqlDB := TSQLiteDatabase.Create(filename);
   for i:=1 to TestCount do
      begin
         inc(taskcount);
         try
            //
            // 插入一个记录...
//            sSQL := 'INSERT INTO testtable(Name,OtherID,Number,Notes) VALUES ("Some Name",4,587.6594,"Here are some notes");';
//            SqlDB.ExecSQL(AnsiString(sSQL));
            //
            SqlTable := SqlDB.GetTable('SELECT * FROM testtable');
            Msg:='第'+inttostr(taskcount)+'次读数据表成功！RecordCount='+inttostr(SqlTable.RowCount);
            synchronize(showmsg);
         except
            Msg:='第'+inttostr(taskcount)+'次读数据表出现异常！';
            synchronize(showmsg);
         end;
         if assigned(SqlTable) then
            FreeAndNil(SqlTable);
         sleep(1);
      end;
   freeandnil(SqlDB);
end;

end.

