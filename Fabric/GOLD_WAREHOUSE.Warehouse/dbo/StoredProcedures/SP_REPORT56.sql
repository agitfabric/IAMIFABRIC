CREATE procedure [dbo].[SP_REPORT56]
as

truncate table Report_56;

insert into Report_56
Select a.AccountNum as AccountCustomer, b.Name Nama, c.Address Alamat, ab.Description City, ac.Name provinsi, 
		c.ZIPCodePublic KodePos, e.Locator phone, f.Locator as email,
		--Case when Isnull(b.PersonBirthYear,0) = 0   then Cast('1900-01-01' as date) 
				--else cast(CAST(b.PersonBirthYear as char(4)) + RIGHT('00' + LTRIM(b.PersonBirthMonth),2) + RIGHT('00' + LTRIM(b.PersonBirthDay),2) AS Date) end as Birthday,
		
		Cast('1900-01-01' as date) as Birthday, b.PersonGender as Gender,
		'' as ZSPOUSENAME, b.PersonMaritalStatus, b.PersonChildrenNames, a.ZReligion,'' as ZETHNIC, '' as ZPROFESSION, 0 as ZMONTHLYEXPENSESAMOUNT, 
		'' as ZEDUCATIONLEVEL, '' as ZSOCIALMEDIA, '' as ZBLOODTYPE, b.PersonHobbies, '' as ZREFERENCEDBY, '' as ZINFLUENCER, 
		x.*, g.ZDealerAfterSales DealerName, g.Name OutletName, g.AreaCode+' -'+g.ZIAMIArea as Area, g.Group_Dealer, a.ZCustPartType, a.ZCustType, 
		b.PartyType as ZBaseType


	From
		(
			select a.dataAreaId, b.InventSiteId,a.SalesId, b.SalesOrderPoolId, a.OrderAccount, a.InvoiceId, a.InvoiceDate, a.InvoiceAmountMST,
					case when b.SalesOrderPoolId = 'FU' then a.InvoiceDate else Cast('1900-01-01' as date) end as FU_InvoiceDate,
					case when b.SalesOrderPoolId = 'FU' then a.InvoiceAmountMST else 0 end as FU_InvoiceAmountMST,
					Cast('1900-01-01' as date) as SP_InvoiceDate, 0 as SP_InvoiceAmountMST,
					Cast('1900-01-01' as date) as SV_InvoiceDate, 0 as SV_InvoiceAmountMST, c.ItemId, e.AMItemMinorGroupId,
					f.ModifiedDateTime1 as LastOfferingDate, g.ZDecisionMaker, i.Name as OwnerWorker, g.ZSegmentation, g.ZGoodType, 1 as UnitBuy, 0 as UnitServed
			From SILVER_WAREHOUSE.dbo.CustInvoiceJour a 
				left join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader b on LOWER(b.SalesId) = LOWER(a.SalesId) and LOWER(b.dataAreaId) = LOWER(a.dataAreaId)
				left join SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans c on LOWER(c.InvoiceId) = LOWER(a.InvoiceId)
				left join SILVER_WAREHOUSE.dbo.InventItemGroupItem d on LOWER(d.ItemDataAreaId) = LOWER(a.dataAreaId) and LOWER(d.ItemId) = LOWER(c.ItemId)
				left join SILVER_WAREHOUSE.dbo.ZInventTables e on LOWER(e.ItemId) = LOWER(c.ItemId) and LOWER(e.dataAreaId) = LOWER(a.dataAreaId)
				left join SILVER_WAREHOUSE.dbo.SalesQuotationTable f on LOWER(f.SalesQuotationNumber) = LOWER(b.QuotationNumber)
				left join SILVER_WAREHOUSE.dbo.OpportunityTable g on LOWER(g.OpportunityId) = LOWER(f.OpportunityId)
				left join SILVER_WAREHOUSE.dbo.Worker h on LOWER(h.RecordId) = LOWER(g.OwnerWorker)
				left join SILVER_WAREHOUSE.dbo.DirPartyTable i on LOWER(i.RecordId) = LOWER(h.Person1)
			where b.SalesOrderPoolId = 'FU' and lower(a.dataAreaId) not in ('kzu', 'dat') and d.ItemGroupId = 'FU01' and b.ZSalesOrderType != 'KLAIM'

			Union All
			select a.dataAreaId, b.InventSiteId,a.SalesId, b.SalesOrderPoolId, a.OrderAccount, a.InvoiceId, a.InvoiceDate, a.InvoiceAmountMST,
					Cast('1900-01-01' as date) as FU_InvoiceDate, 0 as FU_InvoiceAmountMST,
					case when b.SalesOrderPoolId = 'SP' then a.InvoiceDate else Cast('1900-01-01' as date) end as SP_InvoiceDate,
					case when b.SalesOrderPoolId = 'SP' then a.InvoiceAmountMST else 0 end as SP_InvoiceAmountMST,
					Cast('1900-01-01' as date) as SV_InvoiceDate, 0 as SV_InvoiceAmountMST, '' as ItemId, '' as AMItemMinorGroupId,
					Cast('1900-01-01' as date) as LastOfferingDate, '' as ZDecisionMaker, '' as OwnerWorker,  '' as ZSegmentation, '' as ZGoodType,
					 0 as UnitBuy, 0 as UnitServed
			From SILVER_WAREHOUSE.dbo.CustInvoiceJour a 
				left join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader b on LOWER(b.SalesId) = LOWER(a.SalesId) and LOWER(b.dataAreaId) = LOWER(a.dataAreaId)
			where b.SalesOrderPoolId = 'SP' and lower(a.dataAreaId) not in ('kzu', 'dat') and b.ZSalesOrderType != 'KLAIM'

			Union All

			select a.dataAreaId, b.ZInventSiteId, a.ProjInvoiceProjId, 'SV' as PoolID, a.OrderAccount, a.ProjInvoiceId, a.InvoiceDate, a.InvoiceAmount,
						Cast('1900-01-01' as date) as FU_InvoiceDate, 0 as FU_InvoiceAmountMST, Cast('1900-01-01' as date) as SP_InvoiceDate, 0 as SP_InvoiceAmountMST,
						a.InvoiceDate as SV_InvoiceDate, a.InvoiceAmount as SV_InvoiceAmountMST, '' as ItemId, '' as AMItemMinorGroupId,
						Cast('1900-01-01' as date) as LastOfferingDate, '' as ZDecisionMaker, '' as OwnerWorker,  '' as ZSegmentation, '' as ZGoodType,
						 0 as UnitBuy, 1 as UnitServed
			from SILVER_WAREHOUSE.dbo.ProjInvoiceJour a
				left join SILVER_WAREHOUSE.dbo.CaseTable b on b.CaseId COLLATE Latin1_General_CI_AS = ProjInvoiceProjId COLLATE Latin1_General_CI_AS and b.dataAreaId COLLATE Latin1_General_CI_AS = a.dataAreaId COLLATE Latin1_General_CI_AS
			where lower(a.dataAreaId) not in ('kzu', 'dat')

)x
	left join SILVER_WAREHOUSE.dbo.ZCustomers a on a.AccountNum = x.OrderAccount and a.dataAreaId = x.dataAreaId
	left join SILVER_WAREHOUSE.dbo.DirPartyTable b on b.RecordId = a.Party 
	left join SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView c on LOWER(c.Party) = LOWER(a.Party)  and c.ValidTo >= DATEADD(HOUR,7,GETDATE()) and c.IsPrimary = 'Yes'
	left join SILVER_WAREHOUSE.dbo.DirPartyLocation d on LOWER(d.Party) = LOWER(a.Party) and d.IsPostalAddress = 'No'
	left join SILVER_WAREHOUSE.dbo.LogisticsElectronicAddress e on LOWER(e.Location) = LOWER(d.Location) and e.Type = 'Phone' and e.IsPrimary = 'Yes'
	left join SILVER_WAREHOUSE.dbo.LogisticsElectronicAddress f on LOWER(f.Location) = LOWER(d.Location) and f.Type = 'Email' and e.IsPrimary = 'Yes'
	left join SILVER_WAREHOUSE.dbo.ZInventSites g on LOWER(g.SiteId) = LOWER(x.InventSiteId)
	left join SILVER_WAREHOUSE.dbo.AddressState g1 on LOWER(g.ZProvinsi) = LOWER(g1.State)
	left join SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView aa on LOWER(aa.Party) = LOWER(a.Party) and aa.ValidTo >= DATEADD(HOUR,7,GETDATE()) and aa.IsPrimary = 'Yes'
	left join SILVER_WAREHOUSE.dbo.AddressCity ab on LOWER(ab.Name) = LOWER(aa.City)  
	left join SILVER_WAREHOUSE.dbo.AddressState ac on LOWER(ab.StateId) = LOWER(ac.State)