
use zmm
select wellname,depname,count(distinct(depname)) from [tWellDayProd20100101-0729]  group by wellname,depname having count(distinct(depname))>=2
 
-----查询出现在一个部门以上的井信息(液量信息)
select wellname,depname,biaogemingcheng,inputdate 
 from [tWellDayProd20100101-0729] 
 where wellname in
   (
select wellname
 from [tWellDayProd20100101-0729]
 group by wellname
 having count(distinct(depname))>=2
 --order by wellname
)
group by depname,wellname,inputdate,biaogemingcheng
order by wellname

-----查询出现在一个部门以上的井(液量信息)
select wellname
 from [WellDayProd20100730-20100820]
 group by wellname
 having count(distinct(depname))>=2
 order by wellname

----油房庄采油有测试录入数据(要根据实际情况查询)
select count(*) 
 from [tWellDayProd20100101-0729]
 where depname='油房庄采油队'
    and biaogemingcheng<>'采油队生产报表'
delete from [tWellDayProd20100101-0729] where depname='油房庄采油队' and biaogemingcheng<>'采油队生产报表'

