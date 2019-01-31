select * from [DBZhuShui]

----定边注水日报的处理
---------------------------------------
----在【DR】【2010819】【张明明】--------
----            中请示各位老师   -------
----    请按顺序执行,否则后果自负 -------
---------------------------------------
use zmm
select * from [dbzhushui]
---如果今天的累计注水量＜昨天的累计注水量那么　把昨天的值给今天，今天的值给昨天
update [DBZhuShui] set todayzsl=yesterdayzsl,yesterdayzsl=todayzsl where yesterdayzsl>=todayzsl

---------删除无效的信息行
　--------wellname为空的行，将wellnamea的值赋值给wellname(在下个阶段会对wellname进行重命名)
    update [DBZhuShui] set wellname=wellnamea where wellname is null or wellname=''
  --------清除井名为空的行（wellname）
    delete  from [DBZhuShui] where wellname is null

　---处理　wellnamea 不包含数字的井
  select distinct(wellnamea) from [DBZhuShui] where wellnamea not like '%[123456789]%'
   -----查看异常井号　采油队,录入表格,录入时间等信息　并在所对应的excel中查看以确定信息是否无效,若不能判断要请示各位老师
   --- select depname,biaogemingcheng,inputdate from [dbzhushui] where wellnamea='尹渠集输站水源井'
  --在确定之后删除　wellnamea 不包含数字的井的无效行
  --delete from [DBZhuShui] where wellnamea not like '%[123456789]%'

　---处理　wellname 不包含数字的井
  select distinct(wellname) from [DBZhuShui] where wellname not like '%[123456789]%'
   -----查看异常井号　采油队,录入表格,录入时间等信息　并在所对应的excel中查看以确定信息是否无效,若不能判断要请示各位老师
   --- select depname,biaogemingcheng,inputdate from [dbzhushui] where wellname='尹渠集输站水源井'
  --在确定之后删除　wellname 不包含数字的井的无效行
  --delete from [DBZhuShui] where wellname not like '%[123456789]%'

　---查询　zsd like 合计,负责的行（这个信息要对数据表格进行一定的分析后才可以进行操作）
  select * from [DBZhuShui] where zsd like '%合%计%' 
　---删除　zsd like 合计,负责的行
　---delete from [DBZhuShui] where zsd like '%合%计%'

  
----重命名井wellname(最新的命名规则是以数字开头的井更名为：'定注'+wellname+'井'；以汉字开头的井保持不变)
 --select distinct(wellname) from dbzhushui
   --重命名以'#','＃','井'　结尾的井信息(去掉'#','＃','井')
      update dbzhushui set wellname=replace(wellname,'＃','') where wellname like '%[＃]'
      update dbzhushui set wellname=replace(wellname,'#','') where wellname like '%[#]'
      update dbzhushui set wellname=replace(wellname,'井','') where wellname like '%[井]'
   --重命名以'定注'开头的部分井名(先去掉'定注'以便于统一处理)
      update dbzhushui set wellname=replace(wellname,'定注','') where wellname like '定注%'
   --重命名以数字开头的井名('定注'+wellname+'井')
      --select  '定注'+rtrim(convert(nvarchar(40),[wellname]))+'井' from dbzhushui where wellname like '[123456789]%[^井]'
      --update dbzhushui set wellname='定注'+rtrim(convert(nvarchar(40),[wellname]))+'井' where wellname like '[123456789]%[^井]'

-----查看井的信息
select count(*) 总数 from dbzhushui
select count(*) 有wellname的总数 from dbzhushui where wellname is not null
select distinct(wellnamea) wellname为空的总数 from dbzhushui where wellname is  null


update temp set name='定注'+rtrim(convert(nvarchar(40),[name]))+'井'
select name from temp