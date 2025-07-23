CREATE PROCEDURE [dbo].[SP_Report_44_Revenue]  @Year char(4), @month char(2)

AS
BEGIN


	DECLARE @FirstDOM date, @LastDOM date

	Set @FirstDOM = CAST(DATEADD(mm, DATEDIFF(mm, 0, @year + @month + '01' ), 0) AS Date) 
	Set @LastDOM = (select dateadd(s,-1,dateadd(mm,datediff(m,0,@FirstDOM)+1,0))) 
			
	Delete GOLD_WAREHOUSE.dbo.Report_44_Revenue where ProjID in  (Select ProjId From GOLD_WAREHOUSE.dbo.Report_44_UnitServed where Year(InvoiceDate) = @Year and Month(InvoiceDate) = @month Group by ProjId)

	Insert Into GOLD_WAREHOUSE.dbo.Report_44_Revenue

	Select x.dataAreaId, x.inventSiteId, x.ProjId , x.CategoryId, x.Category_name, x.ParentId, 
			sum(Isnull(x.LineAmount,0)) as LineAmount, sum(Isnull(x.Cost,0)) as Cost, ItemId, x.GroupId
	From
	(
	select   a.dataAreaId, left(a.ProjId,5) inventSiteId, a.ProjId, a.CategoryId,
			case when a.CategoryId = 'SP01' then 'Part'
					when a.CategoryId = 'SP02' then 'Bahan'
					when a.CategoryId = 'SV02' then 'OPL'
					when a.CategoryId = 'SV03' then 'Jasa' end Category_name, b.ParentId, a.LineAmount, 
			case when a.CategoryId in ('SP01','SP02') then a.Qty*d.COGS					
					when a.CategoryId in ('SV02') and a.LineAmount < 0 then ABS(e.LineAmount)*-1 
					when a.CategoryId in ('SV02') and a.LineAmount > 0 then ABS(e.LineAmount) 
					else 0 end as Cost,	
			a.ItemId, b.GroupId
	from SILVER_WAREHOUSE.dbo.ProjInvoiceItem a
		inner join GOLD_WAREHOUSE.dbo.Report_44_UnitServed b on b.ProjId = a.ProjId
		left join SILVER_WAREHOUSE.dbo.InventTransOrigin c on c.InventTransId = a.InventTransId
		left join (select ProjId, ItemId, (CostAmountPosted+CostAmountAdjustment)/Qty as COGS
					from SILVER_WAREHOUSE.dbo.InventTrans 
					Group by ProjId, ItemId, (CostAmountPosted+CostAmountAdjustment)/Qty) d on d.ProjId = a.ProjId and d.ItemId = a.ItemId
		left join (select ProjectId, ItemNumber, LineAmount from SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2
						where ProjectId != '' )e on e.ProjectId = a.ProjId and e.ItemNumber = a.ItemId
	where  cast(a.InvoiceDate as date)  between @FirstDOM and @LastDOM
   
	Union All
	Select  a.DataAreaId, left(a.ProjId,5) inventSiteId, a.ProjId , a.CategoryId, 'Jasa' as Category_name, b.ParentId,
			a.LineAmount,  0 as cost, '' as ItemID, b.GroupId
	from SILVER_WAREHOUSE.dbo.ZProjInvoiceEmpl a
		inner join Report_44_UnitServed b on b.ProjId = a.ProjId
	where  cast(a.InvoiceDate as date) between @FirstDOM and @LastDOM
	)x
	Group by x.dataAreaId, x.inventSiteId, x.ProjId, x.CategoryId, x.Category_name, x.ParentId, x.ItemId, x.GroupId
	Order by x.ProjId, x.CategoryId

END