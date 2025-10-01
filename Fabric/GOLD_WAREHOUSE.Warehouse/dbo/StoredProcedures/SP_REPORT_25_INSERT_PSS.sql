CREATE   PROCEDURE [dbo].[SP_REPORT_25_INSERT_PSS]
	
AS
BEGIN	
	
--Exec  [SP_Report_25_Insert_PSS]


DECLARE
	@GetMaxRunningDate DATE,
	@GetCurrentDate DATE


select @GetMaxRunningDate = Isnull(max(cast(DatePhysical as date)),'2021-11-01'), @GetCurrentDate = cast(DATEADD(hour,7,getdate()-1) as date) from Report_25 where kode_dealer = 'AI'

Delete Report_25 where cast(DatePhysical as date) >= @GetMaxRunningDate AND kode_dealer = 'AI'

insert into Report_25

Select cast(r25.TransactionDate as Date) as TransactionDate, f.Area, f.DealerName, f.SiteName, g.ClassId as SegmentID, 
			r25.data_itemNo as ItemNo, c.NameAlias Type_description, c.AMItemMinorGroupId as Series, c.AMItemMajorGroupId as  CV_LCV,
			sum(r25.wholesales) as wholesales,
			sum(r25.EUS) as eus,
			sum(r25.TransferIn) as TransferIn,
			sum(r25.TransferOut) as transferOut,
			sum(r25.Transactions) as Transactions,
			0 as BeginStock, 0 as EndStock,
			getdate() as Last_update, r25.SiteCode, f.Dealer
	From
	(
		--Wholesales
		Select 'Wholesales' as Type,  cast(data_billingDate as date) as TransactionDate, e.SiteCode, ws.data_deviceNo,
				ws.data_qty as wholesales, 0 as EUS, 0 as TransferIn, 0 as TransferOut, 0 as Transactions, ws.data_itemNo
		from SILVER_WAREHOUSE.dbo.sales_POUnit ws
		left join SILVER_WAREHOUSE.dbo.site_mapping e on e.SiteCodePSS = ws.data_kodeOutlet
		Where data_poStatus = 'Invoiced' 
		and cast(data_billingDate as date) between @GetMaxRunningDate and @GetCurrentDate

		Union All
		--EUS
		Select 'EUS' as Type, eus.tanggal_EUS as TransactionDate, eus.Outlet as SiteCode, eus.ChassisNumber as data_deviceNo,
				0 as wholesales, eus.jumlah_unit*-1 as EUS, 0 as TransferIn, 0 as TransferOut, 0 as Transactions, eus.ItemId
		from Report_1 eus
		Where eus.dealer = 'AI'  
		and cast(tanggal_EUS as date) between @GetMaxRunningDate and @GetCurrentDate

		Union All
		--Transfer In 
		select 'Transfer In' as Type, cast(tfin.data_receiptDate as date) as TransactionDate, e.SiteCode, tfin.data_deviceNo, 
				0 as wholesales, 0 as EUS, tfin.data_qty as TransferIn, 0 as TransferOut, 0 as Transactions,  
				case when tfin.data_itemNo is null then b.ItemId else tfin.data_itemNo end as data_itemNo
		from SILVER_WAREHOUSE.dbo.sales_TransferOrder tfin
			left join SILVER_WAREHOUSE.dbo.DeviceTable b on b.DeviceId = tfin.data_deviceNo and b.dataAreaId = 'zir'
			left join SILVER_WAREHOUSE.dbo.site_mapping e on e.SiteCodePSS = tfin.data_toSiteCode
		where cast(tfin.data_receiptDate as date) between @GetMaxRunningDate and @GetCurrentDate and 
		  tfin.data_transferStatus = 'Received'

		Union All
		--Transfer Out
		select  'Transfer Out' as Type, cast(tfout.data_shipDate as date) as TransactionDate, e.SiteCode, tfout.data_deviceNo, 
				0 as wholesales, 0 as EUS, 0 as TransferIn, tfout.data_qty*-1 as TransferOut, 0 as Transactions,  
				case when tfout.data_itemNo is null then b.ItemId else tfout.data_itemNo end as data_itemNo
		from SILVER_WAREHOUSE.dbo.sales_TransferOrder tfout
				left join SILVER_WAREHOUSE.dbo.DeviceTable b on b.DeviceId = tfout.data_deviceNo and b.dataAreaId = 'zir'
				left join SILVER_WAREHOUSE.dbo.site_mapping e on e.SiteCodePSS = tfout.data_fromSiteCode
			where cast(tfout.data_shipDate as date) between @GetMaxRunningDate and @GetCurrentDate and
			tfout.data_transferStatus = 'Received'

		Union All
		--Transaction
		select 'Transactions' as Type, cast(trx.Date as date) as TransactionDate, e.SiteCode, ChassisNumber as data_deviceNo,  
				0 as wholesales, 0 as EUS, 0 as TransferIn, 0 as TransferOut, trx.Qty as Transactions, trx.ItemID
		from SILVER_WAREHOUSE.dbo.dataUnitBegBal trx
		left join SILVER_WAREHOUSE.dbo.site_mapping e on e.SiteCodePSS = SUBSTRING(kode_outlet, 1, 4)
		Where cast(trx.Date as date) between @GetMaxRunningDate and @GetCurrentDate

	) r25
	left join SILVER_WAREHOUSE.dbo.ZInventTables c on c.ItemId = r25.data_itemNo and c.dataAreaId = 'zir'
	left join SILVER_WAREHOUSE.dbo.ZAISITES f on f.SiteCode = r25.SiteCode
	left join SILVER_WAREHOUSE.dbo.DeviceModel g on g.ModelId = r25.data_itemNo and g.Stopped = 'No'
	Where c.AMItemMajorGroupId = 'CV'
	Group by cast(r25.TransactionDate as Date), f.Area, f.DealerName, f.SiteName, r25.data_itemNo, c.NameAlias, c.AMItemMinorGroupId,
			c.AMItemMajorGroupId, r25.SiteCode, f.Dealer, g.ClassId
	order by r25.data_itemNo
-----
END