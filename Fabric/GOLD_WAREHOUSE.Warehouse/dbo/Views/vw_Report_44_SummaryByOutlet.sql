-- Auto Generated (Do not modify) AA662D1C43CC2221F5AA27F361A5B2512834E79ABF275A38C600D11FB2E8E243
CREATE VIEW [dbo].[vw_Report_44_SummaryByOutlet]
AS
Select  Outlet, sum(JumlahHariKerja) as JumlahHariKerja, sum(JamTersedia) as JamTersedia, 
				sum(JumlahMekanik) as JumlahMekanik, sum(JamTerjual)  as JamTerjual, sum(CustomerAll) as CustomerAll, sum(CustomerContract) as CustomerContract,
				sum(HJNSER) HJNSER, sum(HJFSER) HJFSER, sum(HJPSER) HJPSER, sum(HJTBSER) HJTBSER, sum(HJTFSER) HJTFSER, sum(HJBISON) HJBISON
From
(
	--Jumlah Hari Kerja
	Select a.Outlet, sum(WorkDay) as JumlahHariKerja, sum(WorkDay*8) as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll, 0 as CustomerContract,
			0 HJNSER, 0 HJFSER, 0 HJPSER, 0 HJTBSER, 0 HJTFSER, 0 HJBISON
	From(
		Select  ZOutlet Outlet, 1 as WorkDay
		from SILVER_WAREHOUSE.dbo.ZInqAbsensiMekanikLine a
			left join SILVER_WAREHOUSE.dbo.Worker b on b.PersonnelNumber = a.ResourceNumber
		Where a.DataAreaId = 'zir' and year(AbsensiDate) = 2022 and MONTH(AbsensiDate) = 1  and ResourceNumber != ''and ZOutlet is not null 
		Group by ZOutlet, AbsensiDate
	)a
	Group by a.Outlet

	Union All
	--JumlahMekanik
	Select a.Outlet, 0 as JumlahHariKerja, 0 as JamTersedia, count(ResourceNumber) as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll, 0 as CustomerContract,
			0 HJNSER, 0 HJFSER, 0 HJPSER, 0 HJTBSER, 0 HJTFSER, 0 HJBISON
	From(
		Select  ZOutlet Outlet, ResourceNumber
		from SILVER_WAREHOUSE.dbo.ZInqAbsensiMekanikLine a
			left join SILVER_WAREHOUSE.dbo.Worker b on b.PersonnelNumber = a.ResourceNumber
		Where a.DataAreaId = 'zir' and year(AbsensiDate) = 2022 and MONTH(AbsensiDate) = 1  and ResourceNumber != ''and ZOutlet is not null 
		Group by ZOutlet, ResourceNumber
	)a
	Group by a.Outlet

	Union All
	--Jam Terjual
	Select left(ProjId,5) Outlet, 0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, Isnull(sum(Qty),0) as JamTerjual, 0 as CustomerAll, 0 as CustomerContract,
			0 HJNSER, 0 HJFSER, 0 HJPSER, 0 HJTBSER, 0 HJTFSER, 0 HJBISON
	from SILVER_WAREHOUSE.dbo.ZProjInvoiceEmpl  
	where ActivityNumber != '' 
	and year(InvoiceDate) = 2022 and MONTH(InvoiceDate) = 1 and DataAreaId = 'zir'
	Group by left(ProjId,5)

	Union All
	--CustomerAll

	Select Outlet, 0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, sum(CustAccount) CustomerAll, 0 as CustomerContract,
			0 HJNSER, 0 HJFSER, 0 HJPSER, 0 HJTBSER, 0 HJTFSER, 0 HJBISON

	From
	(
		Select x.Outlet, 1 as CustAccount
		From
		(
			Select  c.InventSiteId as Outlet, c.CustAccount 
			From SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans b 
				inner join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader c on c.SalesId = b.SalesId and c.SalesOrderPoolId  in ('SP','SV')
				inner join SILVER_WAREHOUSE.dbo.InventItemGroupItem k on k.ItemDataAreaId = b.dataAreaId and k.ItemId = b.ItemId and k.ItemGroupId in ('SP01') 
			Where year(b.InvoiceDate) = 2022 and MONTH(b.InvoiceDate) = 1 and b.dataAreaId = 'zir'
			union all
			select 	a.ZInventSiteId outlet, a.CustAccount 
			from SILVER_WAREHOUSE.dbo.ProjInvoiceItem c 
				inner join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader f on f.ProjId = c.ProjId and f.SalesOrderPoolId = 'SV'
				left join SILVER_WAREHOUSE.dbo.CaseTable a on  a.CaseId = c.ProjId
			Where year(c.InvoiceDate) = 2022 and MONTH(c.InvoiceDate) = 1 and c.dataAreaId = 'zir'
		)x
		Group by x.Outlet, x.CustAccount
	)y
	Group by Outlet

	Union All
	--CustomerContract
	Select Outlet, 0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll,
			sum(CustomerContract) CustomerContract,
			0 HJNSER, 0 HJFSER, 0 HJPSER, 0 HJTBSER, 0 HJTFSER, 0 HJBISON
	From
	(
	select b.ZInventSiteId Outlet, 1 as CustomerContract
	from  SILVER_WAREHOUSE.dbo.ProjInvoiceJour a
		inner join SILVER_WAREHOUSE.dbo.CaseTable b on b.CaseId = a.ProjInvoiceProjId and b.GroupId = 'SM005'
	where a.dataAreaId = 'zir'
	  and year(InvoiceDate) = 2022 and MONTH(InvoiceDate) = 1
	)a
	Group by Outlet

	Union All

	Select b.SiteId outlet,  0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll, 0 CustomerContract,
			sum(HJNSER) HJNSER, sum(HJFSER) HJFSER, sum(HJPSER) HJPSER, sum(HJTBSER) HJTBSER, sum(HJTFSER) HJTFSER, sum(HJBISON) HJBISON
	From
	(
	select a.dataAreaId, 
			case when a.ProjCategoryRelation = 'HJNSER'  then Isnull(a.Amount,0) else 0 end HJNSER,
			case when a.ProjCategoryRelation = 'HJFSER'  then Isnull(a.Amount,0) else 0 end HJFSER,
			case when a.ProjCategoryRelation = 'HJPSER'  then Isnull(a.Amount,0) else 0 end HJPSER,
			case when a.ProjCategoryRelation = 'HJTBSER' then Isnull(a.Amount,0) else 0 end HJTBSER,
			case when a.ProjCategoryRelation = 'HJTFSER' then Isnull(a.Amount,0) else 0 end HJTFSER,
			case when a.ProjCategoryRelation = 'HJBISON' then Isnull(a.Amount,0) else 0 end HJBISON

	from SILVER_WAREHOUSE.dbo.CaseProjHourPrice a
	where  ProjCategoryRelation in ('HJNSER','HJFSER','HJPSER','HJTBSER','HJTFSER','HJBISON') and ResourceCode = 'All'
	  and a.dataAreaId = 'zir'
	)x
		left join SILVER_WAREHOUSE.dbo.ZInventSites b on b.dataAreaId = x.dataAreaId
	Group by b.SiteId
)x 
Group by Outlet