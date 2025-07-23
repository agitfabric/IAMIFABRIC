-- Auto Generated (Do not modify) 02A9EA3F044751D77E0CBF9FC586BDD624C8D31093CF6306CF38E87FB23DCFC5
CREATE view [dbo].[vw_report_40_ServiceShare] as
with FL as (
select 
Left(Convert(char,InvoiceDate,112),6) RunningDate,
Brand, InventSiteId, MajorGroup, Stall_BIB, sum(UnitServed_Qty) ServiceShared_Monthly from Report_44_UnitServed
group by 
Left(Convert(char,InvoiceDate,112),6), Brand, InventSiteId, MajorGroup, Stall_BIB

)
,get_last_12_month as (
select RunningDate, Brand, InventSiteId, MajorGroup, Stall_BIB, ServiceShared_Monthly,
sum(ServiceShared_Monthly) over(order by RunningDate asc, Brand, MajorGroup,InventSiteId rows between 11 PRECEDING AND 0 PRECEDING) ServiceShared_Yearly
from FL
)

select 
--FORMAT (cast(FL.invoicedate as date), 'dd/MM/yyyy ') invoicedate,
FL.RunningDate,
FL.Brand,
FL.InventSiteId,
FL.MajorGroup,
FL.Stall_BIB,
FL.ServiceShared_Monthly,
GL12M.ServiceShared_Yearly 
from FL
join get_last_12_month GL12M on FL.RunningDate = GL12M.RunningDate and FL.MajorGroup = GL12M.MajorGroup and FL.InventSiteId = GL12M.InventSiteId and FL.Brand = GL12M.Brand 
		and FL.Stall_BIB = GL12M.Stall_BIB