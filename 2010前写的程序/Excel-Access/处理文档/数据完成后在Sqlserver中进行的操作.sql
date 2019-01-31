----对定边液量数据的整理
---------------------------------------
----在【DR】【2010819】【张明明】-------
----            中请示各位老师   -------
----    请按顺序执行,否则后果自负 -------
---------------------------------------
use zmm
select distinct(inputdate) from [welldayprod] order by inputdate

--------删除无效的信息行
　--------wellname为空的行，将wellnamea的值赋值给wellname(在下了阶段会对wellname进行重命名)
    update [WellDayProd] set wellname=wellnamea where wellname is null or ltrim(wellname)=''
  --------清除井名为空的行（wellname）
    delete  from [WellDayProd] where wellname is null or ltrim(wellname)=''
　--------处理　wellnamea 不包含数字的行
     -----处理井组的合计信息（在excel中出现　“xx井组”的无效合计信息）
     ---select wellname,wellnamea from [WellDayProd] where wellnamea like '%井%组%' or wellname like '%井%组%'
     ---delete from [WellDayProd] where wellnamea like '%井%组%' or wellname like '%井%组%'
　　 -----查询不包含数字的行(wellnamea)
     select wellname,wellnamea,depname,biaogemingcheng,inputdate from [WellDayProd] where wellnamea<>'' and wellnamea not like '%[123456789]%' 
     select distinct(wellnamea) from [WellDayProd] where wellnamea<>'' and wellnamea not like '%[123456789]%' 
     select * from [WellDayProd] where wellnamea='新井' 
  　 -----删除　wellnamea 不包含数字的行(不能确定的无效信息要向各位老师请示)
  　 --delete from [WellDayProd] where wellnamea<>'' and wellnamea not like '%[123456789]%' and wellnamea<>
　 -------处理　wellname 不包含数字的行
　　 -----查询不包含数字的行(wellname)
     select wellname,wellnamea,depname,biaogemingcheng,inputdate from [WellDayProd] where  wellname not like '%[123456789]%'
     select distinct(wellname) from [WellDayProd] where  wellname not like '%[123456789]%'
  　 -----删除　wellname 不包含数字的行(不能确定的无效信息要向各位老师请示)
  　 --delete from [WellDayProd] where  wellname not like '%[123456789]%'

select * from welldayprod 
--where wellname not like '定%'
----重命名井wellname(最新的命名规则是液量表中以数字开头的井更名为：'定'+wellname+'井'；以汉字开头的井保持不变)
 --select distinct(wellname) from [WellDayProd]
   --重命名以'#','＃','井'　结尾的井信息(去掉'#','＃','井')
      update [WellDayProd] set wellname=replace(wellname,'＃','') where wellname like '%[＃]%'
      update [WellDayProd] set wellname=replace(wellname,'#','') where wellname like '%[#]%'
      update [WellDayProd] set wellname=replace(wellname,'井','') where wellname like '%[井]%'
   --重命名以'定'开头的部分井名(先去掉'定'以便于统一处理)
      update [WellDayProd] set wellname=replace(wellname,'定','') where wellname like '定%'
   --重命名以数字开头的井名('定'+wellname+'井')
      --select '定'+rtrim(convert(nvarchar(40),[wellname]))+'井' from [WellDayProd] where wellname like '[123456789]%[^井]'
      update [WellDayProd] set wellname='定'+rtrim(convert(nvarchar(40),[wellname]))+'井' where wellname  like '[123456789]%[^井]'

select wellname,depname,inputdate,biaogemingcheng from [WellDayProd]

alter trigger Processother on temp
 instead of  insert
 as
begin 
  declare @OldWellName  nvarchar(37)
  select @OldWellName=name from inserted
  if @oldwellname='张明明'
  print @oldwellname
end;

insert into temp(name) values('张明明')

select * from temp
alter table temp add id2 int identity(1,1) 