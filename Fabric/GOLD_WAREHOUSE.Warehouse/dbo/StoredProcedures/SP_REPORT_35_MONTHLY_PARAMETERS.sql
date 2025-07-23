CREATE PROCEDURE [dbo].[SP_REPORT_35_MONTHLY_PARAMETERS]  @Year char(4), @month char(2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @firstdate date, @lastdate date, @firstdate6mth date, @mrpcount int

	--Select @Year = Left(Convert(char,getdate(),112),4), @month = SUBSTRING(Convert(char,getdate(),112),5,2)

	select  @firstdate = Cast(DATEADD(MONTH,0, @Year+@month+'01') as date),
			@lastdate = Cast(DATEADD(MONTH,1, @Year+@month+'01')-1 as date), 
			@firstdate6mth = Cast(DATEADD(MONTH,-5, @Year+@month+'01') as date)
 		
	select @mrpcount = count(*) from SILVER_WAREHOUSE.dbo.MRPDemand where ZDemandYear = @Year and MonthsInNumb = cast(@month as int)

	Delete Report_35_Monthly where RunningDate = @Year+@month

	Insert Into Report_35_Monthly

	
	
	Select  Cast(DATEADD(MONTH,0, @Year+@month+'01') as date) as EstDate,
			RunningDate, x.dataAreaId, Outlet, Warehouse, x.ItemId, y.NameAlias as Description, 
			Case when z.ZMRPABCCode IS NOT NULL then z.ZMRPABCCode 
				 when z.ZMRPABCCode IS NULL and @mrpcount > 0 and DATEDIFF(month, @lastdate,cast(y.AgitPartsCreatedDate as date)) < 24 then 'X' 
				 when z.ZMRPABCCode IS NULL and @mrpcount > 0 and DATEDIFF(month, @lastdate,cast(y.AgitPartsCreatedDate as date)) >= 24 then 'N'  end as ABCCode,
			CASE WHEN lower(z.ZMRPABCCode) IN ('a', 'b') THEN 'Fast Moving' 
			 WHEN lower(z.ZMRPABCCode) = 'c' THEN 'Medium Moving' 
			 WHEN lower(z.ZMRPABCCode) = 'd' THEN 'Slow Moving' 
			 WHEN lower(z.ZMRPABCCode) IN ('e', 'x', 'n') THEN 'No Moving' 
			 WHEN lower(z.ZMRPABCCode) IS NULL and @mrpcount > 0 THEN 'No Moving'  END AS ABCClassification,
			Sum(Qty) StockQty, 
			Case when sum(Qty) = 0 then 0 else Sum(Amount) end as StockAmount, 
			Case when sum(SalesQtyMTD) > 0 then sum(SalesCogs) else Sum(StdCost) end as StdCost, 
			Sum(ZDStockLevel) StockLevel, Sum(FD) FD, 
			Sum(POQty) POQty,Sum(POAmount) POAmount, Sum(SOQty) SOQty,Sum(SOAmount) SOAmount, 
			sum(SalesQtyMTD) as SalesQtyMTD, Sum(SalesAmountMTD) SalesAmountMTD,
			Case when sum(SalesQtyMTD) > 0 then sum(SalesQtyMTD)*sum(SalesCogs) else sum(SalesQtyMTD)*Sum(StdCost) end as COGS, 
			0 as AvgSales6mth, 0 as AvgCogs6mth,
			Warehouse+x.ItemId+RunningDate as sortby
	From
	(
	SELECT	@Year+@month as RunningDate, a.dataAreaId, b.InventSiteId Outlet, b.InventLocationId AS Warehouse, 
			a.ItemId, sum(a.Qty) as Qty, sum(a.CostAmountPosted + a.CostAmountAdjustment) AS Amount, 
			Case when sum(a.Qty) = 0 then 0 else sum(a.CostAmountPosted + a.CostAmountAdjustment)/sum(a.Qty) end as StdCost,
			0 as ZDStockLevel, 0 as FD, 0 as POQty, 0 as POAmount, 0 as SOQty, 0 as SOAmount, 
			0 as SalesQtyMTD, 0 as SalesAmountMTD, 0 as SalesCogs
	FROM      SILVER_WAREHOUSE.dbo.InventTrans AS a LEFT OUTER JOIN
				SILVER_WAREHOUSE.dbo.Dim AS b ON b.inventDimId = a.inventDimId LEFT OUTER JOIN
				SILVER_WAREHOUSE.dbo.InventItemGroupItem AS c ON c.ItemId = a.ItemId AND c.ItemDataAreaId = a.dataAreaId INNER JOIN
				SILVER_WAREHOUSE.dbo.ForecastModel as e on e.Warehouse = b.InventLocationId 
	WHERE   (a.DatePhysical > '1900-01-01 12:00:00.000') AND (LOWER(a.dataAreaId) <> 'kzu') 
	AND c.ItemGroupId = 'SP01'
	--and b.InventLocationId = 'ARM01-2000' and a.ItemId = 'I1-09070 085-0'
	AND cast(a.DatePhysical as date) <= @lastdate
	Group by a.dataAreaId, b.InventSiteId, b.InventLocationId, a.ItemId

	-- Stock Level & FD
	Union All
	select  @Year+@month as RunningDate, DataAreaIdHeader, ZInventSiteId Outlet, ZInventLocationId Warehouse, ZItemId ItemId, 
			0 as Qty, 0 as Amount, 0 as StdCost, ZDStockLevel, ZQtyDemandAvgNormalized as FD, 0 as POQty, 0 as POAmount, 0 as SOQty, 0 as SOAmount,
			0 as SalesQtyMTD, 0 as SalesAmountMTD, 0 as SalesCogs
	from SILVER_WAREHOUSE.dbo.MRPDemandNormalized
	where ZDemandYear = @Year and MonthsInNumb = cast(@month as int) and DataAreaIdHeader != 'kzu'
	--and ZInventLocationId = 'ARM01-2000' and ZItemId = 'I1-09070 085-0'

	-- On Order
	Union All
	select  @Year+@month as RunningDate, a.dataAreaId, a.ReceivingSiteId Outlet, a.ReceivingWarehouseId Warehouse, ItemNumber ItemId, 
			0 as Qty, 0 as Amount, 0 as Stdcost, 0 as ZDStockLevel, 0 as FD,
			sum(a.OrderedPurchaseQuantity) as POQty, sum(a.LineAmount) as POAmount,
			0 as SOQty, 0 as SOAmmount,
			0 as SalesQtyMTD, 0 as SalesAmountMTD, 0 as SalesCogs
	from SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2 a
		left join SILVER_WAREHOUSE.dbo.ZVendInvoiceTrans b on b.PurchID = a.PurchaseOrderNumber and b.PurchaseLineLineNumber = a.LineNumber
		inner join SILVER_WAREHOUSE.dbo.InventItemGroupItem c on c.ItemDataAreaId = a.dataAreaId and c.ItemId = a.ItemNumber
		inner join SILVER_WAREHOUSE.dbo.ForecastModel as d on d.Warehouse = a.ReceivingWarehouseId	
	where cast(a.CreatedDateTime1 as date) <= @lastdate 
		and c.ItemGroupId = 'SP01' and lower(a.dataAreaId) != 'kzu'
		and cast(b.InvoiceDate as date) > @lastdate
		--and a.ReceivingWarehouseId = 'ARM01-2000' and a.ItemNumber = 'I1-09070 085-0'
	Group by a.dataAreaId, a.ReceivingSiteId, a.ReceivingWarehouseId, ItemNumber

	--Back Order (SO Open)
	Union All
	select  @Year+@month as RunningDate, a.dataAreaId, d.InventSiteId Outlet, d.InventLocationId Warehouse, ItemNumber ItemId, 
			0 as Qty, 0 as Amount, 0 as StdCost, 0 as ZDStocklevel, 0 as FD, 0 as POQty, 0 as POAmount,
			sum(a.SalesQty) as SOQty,sum(a.LineAmount) as SOAmount, 0 as SalesQtyMTD, 0 as SalesAmountMTD, 0 as SalesCogs
	from SILVER_WAREHOUSE.dbo.ZSalesOrderLine a
		left join SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans b on b.SalesId = a.SalesOrderNumber and b.LineNum = a.LineNum
		inner join SILVER_WAREHOUSE.dbo.InventItemGroupItem c on c.ItemDataAreaId = a.dataAreaId and c.ItemId = a.ItemNumber
		left join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader d on d.SalesId = a.SalesOrderNumber
		left join SILVER_WAREHOUSE.dbo.Dim e on e.inventDimId = a.InventDimId
		inner join SILVER_WAREHOUSE.dbo.ForecastModel as f on f.Warehouse = d.InventLocationId
	where cast(a.CreatedDateTime1 as date) <= @lastdate 
		and c.ItemGroupId = 'SP01' and d.SalesOrderPoolId = 'SP'
		and a.SalesOrderLineStatus != 'Canceled' and a.SalesQty > 0 and lower(a.dataAreaId) != 'kzu'
		and cast(b.InvoiceDate as date) > @lastdate
		--and d.InventLocationId = 'ARM01-2000' and a.ItemNumber = 'I1-09070 085-0'
		Group by a.dataAreaId, d.InventLocationId, d.InventSiteId, ItemNumber

	Union All
	Select  @Year+@month as RunningDate, a.dataAreaId, b.InventSiteId, b.InventLocationId, a.ItemId, 
			0 as Qty, 0 as Amount, 0 as StdCost, 
			0 as ZDStocklevel, 0 as FD, 0 as POQty, 0 as POAmount, 
			0 as SOQty, 0 as SOAmount, 
			Sum(a.Qty) SalesQtyMTD, sum(a.LineAmount) as SalesAmountMTD, 
			Case when sum(g.qty) = 0 then 0 else SUM(g.CostAmountPosted+CostAmountAdjustment)/ sum(g.qty) end as SalesCogs
	from SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
		Left join SILVER_WAREHOUSE.dbo.Dim b on b.inventDimId = a.InventDimId
		inner join SILVER_WAREHOUSE.dbo.InventItemGroupItem c on c.ItemDataAreaId = a.dataAreaId and c.ItemId = a.ItemId
		left join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader d on d.SalesId = a.SalesId 
		inner join SILVER_WAREHOUSE.dbo.ForecastModel as e on e.Warehouse = d.InventLocationId
		left join SILVER_WAREHOUSE.dbo.InventTransOrigin as f on f.InventTransId = a.InventTransId
		left join (select dataAreaId, InventTransOrigin, ItemId, InvoiceId, sum(Qty) qty ,sum(CostAmountPosted) CostAmountPosted, sum(CostAmountAdjustment) CostAmountAdjustment
			from SILVER_WAREHOUSE.dbo.InventTrans
			Group by dataAreaId, InventTransOrigin, ItemId, InvoiceId) g on g.InventTransOrigin= f.RecId1 and g.InvoiceId = a.InvoiceId and g.ItemId = a.ItemId
	Where c.ItemGroupId = 'SP01' -- and LineAmount > 0 
	and d.SalesOrderPoolId  in ('SP','SV') and a.dataAreaId != 'kzu'
	and cast(InvoiceDate as date) between @firstdate and @lastdate
	Group by a.dataAreaId, b.InventSiteId, b.InventLocationId, a.ItemId

	--Select  @Year+@month as RunningDate, a.dataAreaId, b.InventSiteId, b.InventLocationId, a.ItemId, 
	--		0 as Qty, 0 as Amount, 0 as StdCost, 
	--		0 as ZDStocklevel, 0 as FD, 0 as POQty, 0 as POAmount, 
	--		0 as SOQty, 0 as SOAmount, 
	--		Sum(a.Qty) SalesQtyMTD, sum(a.LineAmountMST+ a.TaxAmountMST) as SalesMTD, 
	--		Case when sum(g.qty) = 0 then 0 else SUM(g.CostAmountPhysical)/ sum(g.qty) end as SalesCogs
	--from ZCustInvoiceTrans a
	--	Left join Dim b on b.inventDimId = a.InventDimId
	--	inner join InventItemGroupItem c on c.ItemDataAreaId = a.dataAreaId and c.ItemId = a.ItemId
	--	left join ZSalesOrderHeader d on d.SalesId = a.SalesId
	--	inner join ForecastModel as e on e.Warehouse = d.InventLocationId
	--	left join InventTransOrigin as f on f.InventTransId = a.InventTransId
	--	left join InventTrans as g on g.InventTransOrigin = f.RecId1
	--Where c.ItemGroupId = 'SP01' and LineAmount > 0 and d.SalesOrderPoolId = 'SP' and a.dataAreaId != 'kzu'
	--  and cast(InvoiceDate as date) between @firstdate and @lastdate 
	--  --and b.InventLocationId = 'ARM01-2000' and a.ItemId = 'I1-09070 085-0'
	--Group by a.dataAreaId, b.InventSiteId, b.InventLocationId, a.ItemId
	)x
		Inner Join SILVER_WAREHOUSE.dbo.ZInventTables y on y.ItemId = x.ItemId and y.dataAreaId = x.dataAreaId
		Left Join SILVER_WAREHOUSE.dbo.MRPDemand as z on z.ZInventLocationId = x.Warehouse and z.ZItemId = x.ItemId and z.ZDemandYear = @Year and z.MonthsInNumb = cast(@month as int)
	Group by x.RunningDate, x.dataAreaId, x.Outlet, x.Warehouse, x.ItemId, y.NameAlias, z.ZMRPABCCode, y.AgitPartsCreatedDate
	Order by x.RunningDate, x.dataAreaId, x.Outlet, x.Warehouse, x.ItemId

	Update Report_35_Monthly
	set AvgSales6mth = b.SalesAvg6bln, AvgCogs6mth = b.CogsAvg6mth
	from Report_35_Monthly a
		left join (select ItemId, Warehouse, sum(SalesAmountMTD)/6 as SalesAvg6bln, sum(COGS)/count(RunningDate) as CogsAvg6mth
					from Report_35_Monthly
					where EstDate between  @firstdate6mth and @lastdate
					  Group by ItemId, Warehouse) b on b.ItemId = a.ItemId and b.Warehouse = a.Warehouse		
	where RunningDate = @Year+@month

	select Max(RunningDate) runningdate From Report_35_Monthly
END