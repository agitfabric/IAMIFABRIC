CREATE PROCEDURE [dbo].[SP_Report_44_DatabyOutlet]  @Year char(4), @Month char(2)

AS
BEGIN
    
  DECLARE @FirstDOM date, @LastDOM date

  Set @FirstDOM = CAST(DATEADD(mm, DATEDIFF(mm, 0, @year + @month + '01' ), 0) AS Date) 
  Set @LastDOM = (select dateadd(s,-1,dateadd(mm,datediff(m,0,@FirstDOM)+1,0))) 
            
    

	Delete Report_44_DatabyOutlet where year(Dates) = @Year and month(Dates) = @Month

	insert into Report_44_DatabyOutlet

	Select  @FirstDOM as Dates, Outlet, sum(JumlahHariKerja) as JumlahHariKerja, sum(JamTersedia)*sum(JumlahMekanik) as JamTersedia, 
			sum(JumlahMekanik) as JumlahMekanik, sum(JamTerjual)  as JamTerjual, sum(CustomerAll) as CustomerAll, sum(CustomerContract) as CustomerContract,
			sum(HJNSER) HJNSER, sum(HJFSER) HJFSER, sum(HJPSER) HJPSER, sum(HJTBSER) HJTBSER, sum(HJTFSER) HJTFSER, sum(HJBISON) HJBISON,
			sum(HJCESER) HJCESER, sum(HJFGSER) HJFGSER, sum(HJKSCG) HJKSCG, sum(HJLTSER) HJLTSER, sum(HJUCSER) HJUCSER,
			sum(JumlahStall) as JumlahStall, sum(JumlahBIB) as JumlahBIB, 
			sum(RevenuePartNotaKontanIndirect) as RevenuePartNotaKontanIndirect, sum(RevenuePartNotaKontandirect) as RevenuePartNotaKontandirect, sum(JamAktual) as JamAktual
	From
	(
		--Jumlah Hari Kerja
		Select a.Outlet, sum(WorkDay) as JumlahHariKerja, sum(WorkDay*7) as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll, 0 as CustomerContract,
				0 HJNSER, 0 HJFSER, 0 HJPSER, 0 HJTBSER, 0 HJTFSER, 0 HJBISON, 0 HJCESER, 0 HJFGSER, 0 HJKSCG, 0 HJLTSER, 0 HJUCSER,
				0 as JumlahStall, 0 as JumlahBIB, 0 as RevenuePartNotaKontanIndirect, 0 as RevenuePartNotaKontandirect, 0 as JamAktual
		From(
			Select  ZOutlet Outlet, 1 as WorkDay
			from SILVER_WAREHOUSE.[dbo].ZInqAbsensiMekanikLine a
				left join SILVER_WAREHOUSE.[dbo].Worker b on lower(b.PersonnelNumber) = lower(a.ResourceNumber)
			Where cast(AbsensiDate as date) between @FirstDOM and @LastDOM
			and ResourceNumber != ''and ZOutlet is not null 
			--and a.dataAreaId = 'zir' 
			Group by ZOutlet, AbsensiDate
		)a
		Group by a.Outlet

		Union All
		--JumlahMekanik
		Select a.Outlet, 0 as JumlahHariKerja, 0 as JamTersedia, count(ResourceNumber) as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll, 0 as CustomerContract,
				0 HJNSER, 0 HJFSER, 0 HJPSER, 0 HJTBSER, 0 HJTFSER, 0 HJBISON, 0 HJCESER, 0 HJFGSER, 0 HJKSCG, 0 HJLTSER, 0 HJUCSER,
				0 as JumlahStall, 0 as JumlahBIB, 0 as RevenuePartNotaKontanIndirect, 0 as RevenuePartNotaKontandirect, 0 as JamAktual
		From(
			Select  ZOutlet Outlet, ResourceNumber
			from SILVER_WAREHOUSE.[dbo].ZInqAbsensiMekanikLine a
				left join SILVER_WAREHOUSE.[dbo].Worker b on lower(b.PersonnelNumber) = lower(a.ResourceNumber)
			Where cast(AbsensiDate as date) between @FirstDOM and @LastDOM
			and ResourceNumber != ''and ZOutlet is not null 		
			--and a.dataAreaId = 'zir' 
			Group by ZOutlet, ResourceNumber
		)a
		Group by a.Outlet

		Union All
		--Jam Terjual
		Select left(ProjId,5) Outlet, 0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, Isnull(sum(Qty),0) as JamTerjual, 0 as CustomerAll, 0 as CustomerContract,
				0 HJNSER, 0 HJFSER, 0 HJPSER, 0 HJTBSER, 0 HJTFSER, 0 HJBISON, 0 HJCESER, 0 HJFGSER, 0 HJKSCG, 0 HJLTSER, 0 HJUCSER,
				0 as JumlahStall, 0 as JumlahBIB, 0 as RevenuePartNotaKontanIndirect, 0 as RevenuePartNotaKontandirect, 0 as JamAktual
		from SILVER_WAREHOUSE.[dbo].ZProjInvoiceEmpl  
		where ActivityNumber != '' 
		and cast(InvoiceDate as date) between @FirstDOM and @LastDOM
		--and DataAreaId = 'zir'
		Group by left(ProjId,5)

		Union All
		--CustomerAll
		Select Outlet, 0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, sum(CustAccount) CustomerAll, 0 as CustomerContract,
				0 HJNSER, 0 HJFSER, 0 HJPSER, 0 HJTBSER, 0 HJTFSER, 0 HJBISON, 0 HJCESER, 0 HJFGSER, 0 HJKSCG, 0 HJLTSER, 0 HJUCSER,
				0 as JumlahStall, 0 as JumlahBIB, 0 as RevenuePartNotaKontanIndirect, 0 as RevenuePartNotaKontandirect, 0 as JamAktual
		From
		(
			Select x.Outlet, 1 as CustAccount
			From
			(
				Select  c.InventSiteId as Outlet, c.CustAccount 
				From SILVER_WAREHOUSE.[dbo].ZCustInvoiceTrans b 
					inner join SILVER_WAREHOUSE.[dbo].ZSalesOrderHeader c on lower(c.SalesId) = lower(b.SalesId) and c.SalesOrderPoolId  in ('SP','SV')
					inner join SILVER_WAREHOUSE.[dbo].InventItemGroupItem k on lower(k.ItemDataAreaId) = lower(b.dataAreaId) and k.ItemId = b.ItemId and k.ItemGroupId in ('SP01') 
				Where cast(b.InvoiceDate as date) between @FirstDOM and @LastDOM --and b.dataAreaId = 'zir'
				union all
				select 	a.ZInventSiteId outlet, a.CustAccount 
				from SILVER_WAREHOUSE.[dbo].ProjInvoiceItem c 
					inner join SILVER_WAREHOUSE.[dbo].ZSalesOrderHeader f on lower(f.ProjId) = lower(c.ProjId) and f.SalesOrderPoolId = 'SV'
					left join SILVER_WAREHOUSE.[dbo].CaseTable a on  lower(a.CaseId) = lower(c.ProjId)
				Where cast(c.InvoiceDate as date) between @FirstDOM and @LastDOM
				--and c.dataAreaId = 'zir'
			)x
			Group by x.Outlet, x.CustAccount
		)y
		Group by Outlet

		Union All
		--CustomerContract
		Select Outlet, 0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll,
				sum(CustomerContract) CustomerContract,
				0 HJNSER, 0 HJFSER, 0 HJPSER, 0 HJTBSER, 0 HJTFSER, 0 HJBISON, 0 HJCESER, 0 HJFGSER, 0 HJKSCG, 0 HJLTSER, 0 HJUCSER,
				0 as JumlahStall, 0 as JumlahBIB, 0 as RevenuePartNotaKontanIndirect, 0 as RevenuePartNotaKontandirect, 0 as JamAktual
		From
		(
		select b.ZInventSiteId Outlet, 1 as CustomerContract
		from  SILVER_WAREHOUSE.[dbo].ProjInvoiceJour a
			inner join SILVER_WAREHOUSE.[dbo].CaseTable b on lower(b.CaseId) = lower(a.ProjInvoiceProjId) and b.GroupId = 'SM005'
		where cast(InvoiceDate as date) between @FirstDOM and @LastDOM
			-- and a.dataAreaId = 'zir'
		)a
		Group by Outlet

		Union All
		--Harga Jasa
		Select b.SiteId outlet,  0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll, 0 CustomerContract,
				sum(HJNSER) HJNSER, sum(HJFSER) HJFSER, sum(HJPSER) HJPSER, sum(HJTBSER) HJTBSER, sum(HJTFSER) HJTFSER, sum(HJBISON) HJBISON,
				sum(HJCESER) HJCESER, sum(HJFGSER) HJFGSER, sum(HJKSCG) HJKSCG, sum(HJLTSER) HJLTSER, sum(HJUCSER) HJUCSER,
				0 as JumlahStall, 0 as JumlahBIB, 0 as RevenuePartNotaKontanIndirect, 0 as RevenuePartNotaKontandirect, 0 as JamAktual
		From
		(
		select a.dataAreaId, 
				case when a.ProjCategoryRelation = 'HJNSER'  then Isnull(a.Amount,0) else 0 end HJNSER,
				case when a.ProjCategoryRelation = 'HJFSER'  then Isnull(a.Amount,0) else 0 end HJFSER,
				case when a.ProjCategoryRelation = 'HJPSER'  then Isnull(a.Amount,0) else 0 end HJPSER,
				case when a.ProjCategoryRelation = 'HJTBSER' then Isnull(a.Amount,0) else 0 end HJTBSER,
				case when a.ProjCategoryRelation = 'HJTFSER' then Isnull(a.Amount,0) else 0 end HJTFSER,
				case when a.ProjCategoryRelation = 'HJBISON' then Isnull(a.Amount,0) else 0 end HJBISON,
				case when a.ProjCategoryRelation = 'HJCESER' then Isnull(a.Amount,0) else 0 end HJCESER,
				case when a.ProjCategoryRelation = 'HJFGSER' then Isnull(a.Amount,0) else 0 end HJFGSER,
				case when a.ProjCategoryRelation = 'HJKSCG' then Isnull(a.Amount,0) else 0 end HJKSCG,
				case when a.ProjCategoryRelation = 'HJLTSER' then Isnull(a.Amount,0) else 0 end HJLTSER,
				case when a.ProjCategoryRelation = 'HJUCSER' then Isnull(a.Amount,0) else 0 end HJUCSER
		from SILVER_WAREHOUSE.[dbo].CaseProjHourPrice a
		where  ProjCategoryRelation in ('HJNSER','HJFSER','HJPSER','HJTBSER','HJTFSER','HJBISON','HJCESER','HJFGSER','HJKSCG','HJLTSER','HJUCSER') and ResourceCode = 'All'
		--  and a.DATAAREAID = 'zir'
		)x
			left join SILVER_WAREHOUSE.[dbo].ZInventSites b on lower(b.dataAreaId) = lower(x.dataAreaId)
		Group by b.SiteId

		Union All
		--Jumlah Stall
		Select Left(WrkCtrId,5) Outlet, 0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll, 0 CustomerContract,
				0 as HJNSER, 0 as HJFSER, 0 as HJPSER, 0 as HJTBSER, 0 as HJTFSER, 0 as HJBISON, 0 HJCESER, 0 HJFGSER, 0 HJKSCG, 0 HJLTSER, 0 HJUCSER,
				count(WrkCtrId) as JumlahStall, 0 as JumlahBIB, 0 as RevenuePartNotaKontanIndirect, 0 as RevenuePartNotaKontandirect,
				0 as JamAktual
		from SILVER_WAREHOUSE.[dbo].WRKCTRTABLE
		where Substring(WrkCtrId,7,1) = 'S' -- and dataAreaId ='zir'
		Group by Left(WrkCtrId,5)

		Union All
		--Jumlah BIB
		Select Left(WrkCtrId,5) Outlet, 0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll, 0 CustomerContract,
				0 as HJNSER, 0 as HJFSER, 0 as HJPSER, 0 as HJTBSER, 0 as HJTFSER, 0 as HJBISON, 0 HJCESER, 0 HJFGSER, 0 HJKSCG, 0 HJLTSER, 0 HJUCSER,
				0 as JumlahStall, count(WrkCtrId) as JumlahBIB, 0 as RevenuePartNotaKontanIndirect, 0 as RevenuePartNotaKontandirect,
				0 as JamAktual
		from SILVER_WAREHOUSE.[dbo].WRKCTRTABLE
		where Substring(WrkCtrId,7,1) = 'B' -- and dataAreaId ='zir'
		Group by Left(WrkCtrId,5)

		Union All
		--Revenue Part Nota Kontan
		Select  Left(c.SalesId,5) as Outlet,  0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll, 0 CustomerContract,
				0 as HJNSER, 0 as HJFSER, 0 as HJPSER, 0 as HJTBSER, 0 as HJTFSER, 0 as HJBISON, 0 HJCESER, 0 HJFGSER, 0 HJKSCG, 0 HJLTSER, 0 HJUCSER,
				0 as JumlahStall, 0 as JumlahBIB, 
				case when l.ZCustPartType in  ('BMI','PartShop') then sum(b.LineAmount) else 0 end as RevenuePartNotaKontanIndirect,
				case when l.ZCustPartType not in  ('BMI','PartShop') then sum(b.LineAmount) else 0 end as RevenuePartNotaKontandirect,
				0 as JamAktual
		From SILVER_WAREHOUSE.[dbo].ZCustInvoiceTrans b 
			inner join SILVER_WAREHOUSE.[dbo].ZSalesOrderHeader c on lower(c.SalesId) = lower(b.SalesId) and c.SalesOrderPoolId  in ('SP','SV')
			inner join SILVER_WAREHOUSE.[dbo].InventItemGroupItem k on lower(k.ItemDataAreaId) = lower(b.dataAreaId) and lower(k.ItemId) = lower(b.ItemId) and k.ItemGroupId in ('SP01') 
			left join SILVER_WAREHOUSE.[dbo].ZCustomers l on lower(l.AccountNum) = lower(c.CustAccount) and lower(l.dataAreaId) = lower(c.dataAreaId) 
		Where cast(b.InvoiceDate as date) between @FirstDOM and @LastDOM -- and b.dataAreaId = 'zir'
		Group by Left(c.SalesId,5), l.ZCustPartType

		Union All
		-- Jam Aktuak
		select Left(CaseId,5) as Outlet, 0 as JumlahHariKerja, 0 as JamTersedia, 0 as JumlahMekanik, 0  as JamTerjual, 0 as CustomerAll, 0 CustomerContract,
				0 as HJNSER, 0 as HJFSER, 0 as HJPSER, 0 as HJTBSER, 0 as HJTFSER, 0 as HJBISON, 0 HJCESER, 0 HJFGSER, 0 HJKSCG, 0 HJLTSER, 0 HJUCSER,
				0 as JumlahStall, 0 as JumlahBIB, 0 as RevenuePartNotaKontanIndirect, 0 as RevenuePartNotaKontandirect,	
				sum(ProjectHours) as JamAktual
		from SILVER_WAREHOUSE.[dbo].ZCaseTimeSheetTrans 
		where cast(PostedDate as date) between @FirstDOM and @LastDOM			 
			and  Adjusted = 'No' and TransType = 'Summary'
			--and DataAreaId = 'zir'
		Group by Left(CaseId,5) 

	)x 
	Group by Outlet

END