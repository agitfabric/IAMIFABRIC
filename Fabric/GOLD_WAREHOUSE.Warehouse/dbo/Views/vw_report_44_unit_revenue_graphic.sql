-- Auto Generated (Do not modify) 4824F207177418133159D72507259E4463662ECE2706C573A86A4C239E775E92
CREATE view [dbo].[vw_report_44_unit_revenue_graphic]
as 
with 
FL as (
select concat(left(InvoiceDate,7),'-01') ReportDate,uni.InventSiteId,uni.InvoiceDate,uni.ProjId,uni.Stall_BIB,uni.Brand,uni.MajorGroup,uni.MinorGroupId,UnitServed_Qty qty,rev.revenue,rev.cost from Report_44_UnitServed uni
join
(select ProjID,sum(Revenue) revenue,sum(Cost) cost from Report_44_Revenue group by ProjID) rev 
on uni.ProjId = rev.ProjID
where uni.ParentId = ''
)
,FL_T as (
select
Dealer
,[Kode Outlet]
,Target
,case 
when Target ='REVENUE LCV TARGET' THEN 'LCV'
when Target ='REVENUE CV TARGET' THEN 'CV'
when Target ='UNIT SERVED LCV TARGET' THEN 'LCV'
when Target ='UNIT SERVED  CV TARGET' THEN 'CV'
ELSE NULL END MajorGroup
,case 
when Target ='REVENUE LCV TARGET' THEN 'REVENUE'
when Target ='REVENUE CV TARGET' THEN 'REVENUE'
when Target ='UNIT SERVED LCV TARGET' THEN 'UNIT'
when Target ='UNIT SERVED  CV TARGET' THEN 'UNIT'
ELSE NULL END Scenario
,Bulan
,case
  when Bulan = 'Jan' Then FORMAT(cast('2022-01-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Feb' Then FORMAT(cast('2022-02-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Mar' Then FORMAT(cast('2022-03-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Apr' Then FORMAT(cast('2022-04-01' as date), 'yyyy-MM-dd')
  when Bulan = 'May' Then FORMAT(cast('2022-05-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Jun' Then FORMAT(cast('2022-06-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Jul' Then FORMAT(cast('2022-07-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Aug' Then FORMAT(cast('2022-08-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Sep' Then FORMAT(cast('2022-09-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Oct' Then FORMAT(cast('2022-10-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Nov' Then FORMAT(cast('2022-11-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Dec' Then FORMAT(cast('2022-12-01' as date), 'yyyy-MM-dd')
  ELSE NULL END Date
,case when Target IN ('REVENUE LCV TARGET','REVENUE CV TARGET') THEN (Value * 1000) ELSE Value end value
from [dbo].[TargetUnitServed]
)
,target_unit as (
select Date ReportDate,[Kode Outlet]InventSiteId,MajorGroup,sum(value) Value,'Plan' as Scenario from FL_T
where Scenario = 'UNIT'
group by Date,[Kode Outlet],MajorGroup
)
,actual_unit as (
select ReportDate,InventSiteId,MajorGroup,sum(qty) Value,'Actual' as Scenario from FL
group by ReportDate,InventSiteId,MajorGroup
)
,actual_LY_unit as (
select CONCAT(left(ReportDate,4)+1,RIGHT(ReportDate,6)) ReportDate,InventSiteId,MajorGroup,sum(qty) Value,'Actual Last Year' as Scenario from FL
group by ReportDate,InventSiteId,MajorGroup
)
,achievement_unit as (
select ac.ReportDate,ac.InventSiteId,ac.MajorGroup,(ac.Value/ta.Value) as value,'Achievement' as Scenario from actual_unit ac
join target_unit ta on ac.ReportDate = ta.ReportDate and ac.InventSiteId = ta.InventSiteId and ac.MajorGroup = ta.MajorGroup
)
,target_revenue as (
select Date ReportDate,[Kode Outlet]InventSiteId,MajorGroup,sum(value) Value,'Plan' as Scenario from FL_T
where Scenario = 'REVENUE'
group by Date,[Kode Outlet],MajorGroup
)
,actual_revenue as (
select ReportDate,InventSiteId,MajorGroup,sum(revenue) Value,'Actual' as Scenario from FL
group by ReportDate,InventSiteId,MajorGroup
)
,actual_LY_revenue as (
select CONCAT(left(ReportDate,4)+1,RIGHT(ReportDate,6)) ReportDate,InventSiteId,MajorGroup,sum(revenue) Value,'Actual Last Year' as Scenario from FL
group by ReportDate,InventSiteId,MajorGroup
)
,achievement_revenue as (
select ac.ReportDate,ac.InventSiteId,ac.MajorGroup,(ac.Value/ta.Value) as value,'Achievement' as Scenario from actual_unit ac
join target_unit ta on ac.ReportDate = ta.ReportDate and ac.InventSiteId = ta.InventSiteId and ac.MajorGroup = ta.MajorGroup
)
,comb as (

select *,'Unit' as UniRev from target_unit
union all
select *,'Unit' as UniRev from actual_unit
union all
select *,'Unit' as UniRev from actual_LY_unit
union all
select *,'Unit' as UniRev from achievement_unit
union all
select *,'Revenue' as UniRev from target_revenue
union all
select *,'Revenue' as UniRev from actual_revenue
union all
select *,'Revenue' as UniRev from actual_LY_revenue
union all
select *,'Revenue' as UniRev from achievement_revenue
)

select * from comb