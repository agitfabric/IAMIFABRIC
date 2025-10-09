-- Auto Generated (Do not modify) C67110D112BEA7BE53772ADE6C7CA0B8B01856A4DEA0B7596164FA0C6D20143C
CREATE view [dbo].[vw_report_komposisi_revenue] as
with Revenue as (
select uni.InvoiceDate,uni.MajorGroup,rev.Category_name,SUM(rev.Revenue) Revenue from Report_44_UnitServed uni
join
(select ProjID,Category_name,sum(Revenue) Revenue from Report_44_Revenue group by ProjID,Category_name) rev
on uni.ProjId = rev.ProjID
where uni.ParentId = ''
group by uni.InvoiceDate,uni.MajorGroup,rev.Category_name
)
,Qty as (
select InvoiceDate,MajorGroup,sum(UnitServed_Qty) qty from Report_44_UnitServed group by InvoiceDate,MajorGroup
)

select rev.InvoiceDate,rev.MajorGroup,rev.Category_name,Qty.qty,rev.Revenue, (rev.Revenue/Qty.qty) RevPerUnit from Revenue rev
join Qty
on rev.InvoiceDate = Qty.InvoiceDate and rev.MajorGroup = Qty.MajorGroup