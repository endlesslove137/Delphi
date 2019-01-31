unit UOrderAccess;
////////////////////////////////////////////////////////
///                 Announce                        ////
///      Author: 张明明/zmm                         ////
///      QQ    : 378982719                          ////
///      Email : 378982719@qq.com                   ////
///                                                 ////
///      Power by zmm  20100713                     ////
///                                                 ////
////////////////////////////////////////////////////////

interface

uses
  Windows,ADODB,classes,sysutils,Dialogs,DB,variants,stdctrls;
const
   SqlTables='select name from MSysObjects where type=1 and flags=0';
type
  FieldMap = record
    FieldName: string;
    ColIndex: integer;
  end;
procedure ComboboxAddTablename(var adoquery: tadoquery;var combobox: tcombobox);
function AutoMatch(var comparefields, mapcol: tadoquery): boolean;overload;
function AutoMatch(var comparefields, mapcol: TADOTable): boolean;overload;
procedure ComboboxAddItems(var table:tadotable;Fieldname:string;var Combobox:TComboBox);
procedure DropTable(Tablename:string;var adocommand:tadocommand);
function AppendCompare(fieldname,fielddesc,datatype:string;var adocommand:tadocommand):boolean;
Procedure AlterTable(var tableBI:tadoquery;var tableI:tadotable;var adocommand:tadocommand);overload;
Procedure AlterTable(var tableBI:TADOTable;var tableI:TADOTable;var adocommand:tadocommand);overload;
procedure craetetable(tablename: string; var mapcol: tadoquery;var adocommand: tadocommand);overload;
procedure craetetable(tablename: string; var mapcol: TADOTable;var adocommand: tadocommand);overload;
function GetValueByOtherField(var table:TADOTable;setField,setFieldValue,GetField:string):variant;overload;
function GetValueByOtherField(var table:TADOQuery;setField,setFieldValue,GetField:string):variant;overload;

function GetValueByTwoField(var table:TADOTable;FirstFieldname,SecondFieldname,TheFieldname:string;FirstValue,SecondValue:Variant):variant;
procedure SetStringListByFieldName(var stringlist:tstringlist;var adoquery:tadoquery;Fieldname:string);



var
  ExcelApp: variant;

implementation

function GetValueByTwoField(var table:TADOTable;FirstFieldname,SecondFieldname,TheFieldname:string;FirstValue,SecondValue:Variant):variant;
begin
try
 if not table.Active then table.Open;
 table.First;
 if  table.Locate(FirstFieldname+';'+secondfieldname,vararrayof([FirstValue,SecondValue]), [loCaseInsensitive]) then
  result:=table.FieldByName(TheFieldname).Value
 else
  result:='null';
except on E: Exception do
 ShowMessage('Error From UorderAccess.GetValueByTwoField');
end;
end;

function GetValueByOtherField(var table:TADOQuery;setField,setFieldValue,GetField:string):variant;
begin
 if not table.Active then table.Open;
 table.First;
 if  table.Locate(setField,setFieldValue,[loCaseInsensitive,loPartialKey]) then
 result:=table.FieldByName(GetField).Value
 else
 result:='Null';
end;

procedure ComboboxAddItems(var table:tadotable;Fieldname:string;var Combobox:TComboBox);
begin
 Combobox.Clear;
 if not table.Active then table.Open;
 table.First;
 while not table.Eof do
 begin
  Combobox.Items.Add(table.FieldByName(Fieldname).Value);
  table.Next;
 end;
end;

procedure DropTable(Tablename:string;var adocommand:tadocommand);
var
 sql:string;
begin
   if tablename='新增一个表' then  exit
   else   if trim(tablename)='' then  exit
   else
   begin
    sql:='drop table '+tablename;
    adocommand.CommandText:=sql;
    adocommand.Execute;
    showmessage('删除成功');
   end;
end;



procedure Updatetable(tablename,PrimaryName,PrimaryValue,Fieldname,FieldValue:string;var adocommand:tadocommand);
var
 sql:string;
begin
 sql:='update '+tablename+' set '+fieldname+'='+quotedstr(Fieldvalue)+' where '+PrimaryName+'='+quotedstr(PrimaryValue);
 adocommand.CommandText:=sql;
 adocommand.Execute;
end;

// 在表中找一个特定字段并返回这一行的另一个字段的值
function GetValueByOtherField(var table:TADOTable;setField,setFieldValue,GetField:string):variant;
begin
 if not table.Active then table.Open;
 table.First;
 if  table.Locate(setField,setFieldValue,[loCaseInsensitive,loPartialKey]) then
 result:=table.FieldByName(GetField).Value
 else
 result:='Null';
end;

//从一张表中取出特定的字段放在一个tstinglist中
procedure SetStringListByFieldName(var stringlist:tstringlist;var adoquery:tadoquery;Fieldname:string);
var
 temps:string;
begin
  stringlist := TStringList.Create;
  if adoquery.Active then adoquery.Open;
  adoquery.First;
  while not adoquery.eof do
  begin
    temps:=adoquery.FieldByName(Fieldname).AsString;
    stringlist.add(temps);
    adoquery.Next;
  end;
  stringlist.Sort;
  adoquery.Close;
end;

Procedure AlterTable(var tableBI:TADOTable;var tableI:TADOTable;var adocommand:tadocommand);
var
  Altersql,Valuesql,sql:string;
  fi:integer;
  IsNewField,HaveNewField:boolean;
begin
  Altersql:=' alter table '+tableI.TableName+' add column ';
  Valuesql:='';
  tableI.Close;
  tablebi.Close;
  if not tableI.Active then tableI.Open;
  if not tableBI.Active then tablebi.Open;
  tablebi.First;
  while not tableBI.Eof do
  begin
   fi:=0;
   IsNewField:=true;
   HaveNewField:=false;
   while fi<=tableI.FieldCount-1  do
   begin
      if (trim(tableBI.FieldByName('DBfieldname').Value)=tableI.Fields[fi].FieldName)
      or (trim(tableBI.FieldByName('DBfieldname').Value)='DoesNotHandle')
      or (trim(tableBI.FieldByName('DBfieldname').Value)='') then
      begin
        IsNewField:=false;
        break;
      end;
      HaveNewField:=true;
      fi:=fi+1;
   end;
   if IsNewField  then
   begin
     if ValueSql<>'' then
     begin
      Valuesql:= valuesql
                 +','
                 +tableBI.FieldByName('dbfieldname').Value+' '
                 +tableBI.FieldByName('datatype').Value

     end
      else
     begin
      Valuesql:=  tableBI.FieldByName('dbfieldname').Value+' '
                 +tableBI.FieldByName('datatype').Value;

     end;

   end;
   tablebi.Next;
  end;
  if trim(Valuesql)<>'' then
  begin
    adocommand.CommandText:=Altersql+ValueSql;
    adocommand.Execute;
  end;
  tableI.Close;
  tableI.Open;
end;



//提高程序的的速度,刷新对照信息 并更新对照表中的对照信息在原表的基础上修改表结构
Procedure AlterTable(var tableBI:tadoquery;var tableI:tadotable;var adocommand:tadocommand);
var
  Altersql,Valuesql,sql:string;
  fi:integer;
  IsNewField,HaveNewField:boolean;
begin
  Altersql:=' alter table '+tableI.TableName+' add column ';
  Valuesql:='';
  tableI.Close;
  tablebi.Close;
  if not tableI.Active then tableI.Open;
  if not tableBI.Active then tablebi.Open;
  tablebi.First;
  while not tableBI.Eof do
  begin
   fi:=0;
   IsNewField:=true;
   HaveNewField:=false;
   while fi<=tableI.FieldCount-1  do
   begin
      if (trim(tableBI.FieldByName('DBfieldname').Value)=tableI.Fields[fi].FieldName)
      or (trim(tableBI.FieldByName('DBfieldname').Value)='DoesNotHandle')
      or (trim(tableBI.FieldByName('DBfieldname').Value)='') then
      begin
        IsNewField:=false;
        break;
      end;
      HaveNewField:=true;
      fi:=fi+1;
   end;
   if IsNewField  then
   begin
     if ValueSql<>'' then
     begin
      Valuesql:= valuesql
                 +','
                 +tableBI.FieldByName('dbfieldname').Value+' '
                 +tableBI.FieldByName('datatype').Value

     end
      else
     begin
      Valuesql:=  tableBI.FieldByName('dbfieldname').Value+' '
                 +tableBI.FieldByName('datatype').Value;

     end;

   end;
   tablebi.Next;
  end;
  if trim(Valuesql)<>'' then
  begin
    adocommand.CommandText:=Altersql+ValueSql;
    adocommand.Execute;
  end;
  tableI.Close;
  tablei.Open;
end;
//在无匹配的情况下要增加匹配内容
function AppendCompare(fieldname,fielddesc,datatype:string;var adocommand:tadocommand):boolean;
var
 TDT:string;
 sql:string;
begin
 result:=false;
  if (trim(fieldname)='') or (trim(fielddesc)='') or (trim(datatype)='')  then
  begin
    showmessage('要增加的匹配内容不能为空');
    exit;
  end
  else if datatype='数字' then  TDT:='float'
  else if datatype='日期' then  TDT:='date'
  else if datatype='文字' then  TDT:='varchar(73)';
  sql:='insert into comparefields(fieldname,fielddesc,datatype) values('
  +quotedstr(fieldname)+','
  +quotedstr(fielddesc)+','
  +quotedstr(tdt)+')';
  adocommand.CommandText:=sql;
  adocommand.Execute;
  result:=true;
end;




function AutoMatch(var comparefields, mapcol: TADOTable): boolean;
var
  n,iz: integer;
begin
  comparefields.Open;
  comparefields.Filtered := false;
  mapcol.First;
  result := true;
  while not mapcol.eof do
  begin
    if comparefields.Locate('XlsColName',
      mapcol.FieldByName('XlsColName').AsString, [loCaseInsensitive]) then
    begin
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := comparefields.FieldByName
        ('FieldDesc').AsString;
      mapcol.FieldByName('DBFieldName').AsString := comparefields.FieldByName
        ('FieldName').AsString;
      mapcol.FieldByName('datatype').AsString := comparefields.FieldByName
        ('datatype').AsString;
      mapcol.Post;
      mapcol.Next;
    end
    else
    begin
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := '';
      mapcol.FieldByName('DBFieldName').AsString := '';
      mapcol.FieldByName('datatype').AsString := '';
      mapcol.Post;
      mapcol.Next;
      result := false;
    end;
  end;

  // 判断井名(可以是井名,也可以是新井名)是什么 匹配
  n := 0;
  iz:=0;
  mapcol.First;
  while not mapcol.eof do
  begin
    if trim(mapcol.FieldByName('DBFieldDesc').AsString) = '井名' then
      n := n + 1;
    if trim(mapcol.FieldByName('DBFieldDesc').AsString) = '前天历年累计注水量' then
      iz := iz + 1;
    mapcol.Next;
  end;
  if n >= 2 then
  begin
    if mapcol.Locate('XlsColName', '原', [loPartialKey]) or mapcol.Locate
      ('XlsColName', '旧', [loPartialKey]) or mapcol.Locate('XlsColName', '老',
      [loPartialKey]) then
    begin
      if not mapcol.Locate('XlsColName', '井名', [loPartialKey]) then
      mapcol.Locate('XlsColName', '井号', [loPartialKey]);
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := '井名';
      mapcol.FieldByName('DBFieldName').AsString := 'WELLNAME';
      mapcol.FieldByName('datatype').AsString := 'varchar(150)';
      mapcol.Post;
      mapcol.Next;
    end
    else
    begin
      if not mapcol.Locate('XlsColName', '井名', [loPartialKey]) then
        mapcol.Locate('XlsColName', '井号', [loPartialKey]);
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := '旧井名';
      mapcol.FieldByName('DBFieldName').AsString := 'WELLNAMEA';
      mapcol.FieldByName('datatype').AsString := 'varchar(150)';
      mapcol.Post;
      mapcol.Next;
    end;
  end;
    if iz >= 2 then
  begin
      mapcol.First;
    if mapcol.Locate('DBFieldDesc', '前天历年累计注水量', [loPartialKey])then
      mapcol.Locate('DBFieldDesc', '前天历年累计注水量', [loPartialKey]);
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := '今天历年累计注水量';
      mapcol.FieldByName('DBFieldName').AsString := 'TodayZSL';
      mapcol.FieldByName('datatype').AsString := 'float';
      mapcol.Post;
  end;


//  if result = false then
//    showmessage('自动匹配未完成,请手动匹配');
end;
// 自动匹配列
function AutoMatch(var comparefields, mapcol: tadoquery): boolean;
var
  n: integer;
begin
  comparefields.Open;
  comparefields.Filtered := false;
  mapcol.First;
  result := true;
  while not mapcol.eof do
  begin
    if comparefields.Locate('XlsColName',
      mapcol.FieldByName('XlsColName').AsString, [loCaseInsensitive]) then
    begin
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := comparefields.FieldByName
        ('FieldDesc').AsString;
      mapcol.FieldByName('DBFieldName').AsString := comparefields.FieldByName
        ('FieldName').AsString;
      mapcol.FieldByName('datatype').AsString := comparefields.FieldByName
        ('datatype').AsString;
      mapcol.Post;
      mapcol.Next;
    end
    else
    begin
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := '';
      mapcol.FieldByName('DBFieldName').AsString := '';
      mapcol.FieldByName('datatype').AsString := '';
      mapcol.Post;
      mapcol.Next;
      result := false;
    end;
  end;

  // 判断井名(可以是井名,也可以是新井名)是什么 匹配
  n := 0;
  mapcol.First;
  while not mapcol.eof do
  begin
    if trim(mapcol.FieldByName('DBFieldDesc').AsString) = '井名' then
      n := n + 1;
    mapcol.Next;
  end;
  if n >= 2 then
  begin
    if mapcol.Locate('XlsColName', '原', [loPartialKey]) or mapcol.Locate
      ('XlsColName', '旧', [loPartialKey]) or mapcol.Locate('XlsColName', '老',
      [loPartialKey]) then
    begin
      if not mapcol.Locate('XlsColName', '井名', [loPartialKey]) then
        mapcol.Locate('XlsColName', '井号', [loPartialKey]);
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := '井名';
      mapcol.FieldByName('DBFieldName').AsString := 'WELLNAME';
      mapcol.FieldByName('datatype').AsString := 'varchar(150)';
      mapcol.Post;
      mapcol.Next;
    end
    else
    begin
      if not mapcol.Locate('XlsColName', '井名', [loPartialKey]) then
        mapcol.Locate('XlsColName', '井号', [loPartialKey]);
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := '旧井名';
      mapcol.FieldByName('DBFieldName').AsString := 'WELLNAMEA';
      mapcol.FieldByName('datatype').AsString := 'varchar(150)';
      mapcol.Post;
      mapcol.Next;
    end;
  end;

  if result = false then
    showmessage('自动匹配未完成,请手动匹配');
end;

// 从一个字符串中获取时间




// ADD Table's name to combobox
procedure ComboboxAddTablename(var adoquery: tadoquery;
  var combobox: tcombobox);
var
  sqlstr: string;
begin // and name not in('log','mapcol','comparefields','comparefieldsbackup')
  sqlstr :=SqlTables
    + 'and name not in(' + quotedstr('log') + ',' + quotedstr('mapcol')
    + ',' + quotedstr('comparefields') + ','+ quotedstr('MapSheets') + ','+ quotedstr('XLSSchema') + ',' + quotedstr
    ('comparefieldsbackup') + ')';
  adoquery.SQL.Clear;
  adoquery.SQL.Add(sqlstr);
  adoquery.Open;
  adoquery.First;
  combobox.Items.Clear;
  while not adoquery.eof do
  begin
    combobox.Items.Add(adoquery.FieldByName('name').Value);
    adoquery.Next;
  end;
  combobox.Items.Add('新增一个表');
end;

procedure craetetable(tablename: string; var mapcol: TADOTable;var adocommand: tadocommand);
var
  sqlstr: string;
  sqladd:string;
begin
  if trim(tablename) = '' then
  begin
    showmessage('Tatget Table Can not be empty');
    exit;
  end;
  sqlstr := 'create table ' + trim(tablename) + '(';
  mapcol.Open;
  mapcol.First;
  while not mapcol.eof do
  if (trim(vartostr(mapcol.FieldByName('dbfieldname').Value))='DoesNotHandle')
  or (trim(vartostr(mapcol.FieldByName('dbfieldname').Value))='') then
  begin
   mapcol.Next;
   continue;
  end else
  begin
    sqlstr := sqlstr + mapcol.FieldByName('dbfieldname').Value
            + ' '
            + mapcol.FieldByName('datatype').Value + ',';
      mapcol.Next;
  end;
 try
  //warter_well_no varchar(30) null,oil_well_no varchar(30) null,
  sqlstr:=sqlstr+'BiaoGeMingCheng varchar(30),InputDate date,' +
    'DEPNAME varchar(30),WELLNAMEC varchar(30),WELLNAMEB varchar(30),ICHK yesno,iSel yesno,USERNAME varchar(30)'+ ')';
  adocommand.CommandText := sqlstr;
  adocommand.Execute;
 except on E:exception do
    showmessage('create table 语句中 '+e.Message);
 end;
end;


procedure craetetable(tablename: string; var mapcol: tadoquery;var adocommand: tadocommand);
var
  sqlstr: string;
  sqladd:string;
begin
  if trim(tablename) = '' then
  begin
    showmessage('Tatget Table Can not be empty');
    exit;
  end;
  sqlstr := 'create table ' + trim(tablename) + '( ';
  mapcol.Open;
  mapcol.First;
  while not mapcol.eof do
  if trim(vartostr(mapcol.FieldByName('dbfieldname').Value))='DoesNotHandle' then
  begin
   mapcol.Next;
   continue;
  end else
  begin
    sqlstr := sqlstr + mapcol.FieldByName('dbfieldname')
      .Value + ' ' + mapcol.FieldByName('datatype').Value + ',';
      mapcol.Next;
  end;
 try
  //warter_well_no varchar(30) null,oil_well_no varchar(30) null,
  sqlstr:=sqlstr+'BiaoGeMingCheng varchar(30),InputDate date,' +
    'SchemaName varchar(30),InputUser varchar(30)'+ ')';
  adocommand.CommandText := sqlstr;
  adocommand.Execute;
 except on exception do
    showmessage('创建表失败');
 end;
end;
end.
