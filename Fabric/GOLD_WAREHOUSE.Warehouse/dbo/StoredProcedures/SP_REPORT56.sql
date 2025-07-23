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
				left join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader b on b.SalesId = a.SalesId and b.dataAreaId = a.dataAreaId
				left join SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans c on c.InvoiceId = a.InvoiceId
				left join SILVER_WAREHOUSE.dbo.InventItemGroupItem d on d.ItemDataAreaId = a.dataAreaId and d.ItemId = c.ItemId
				left join SILVER_WAREHOUSE.dbo.ZInventTables e on e.ItemId = c.ItemId and e.dataAreaId = a.dataAreaId
				left join SILVER_WAREHOUSE.dbo.SalesQuotationTable f on f.SalesQuotationNumber = b.QuotationNumber
				left join SILVER_WAREHOUSE.dbo.OpportunityTable g on g.OpportunityId = f.OpportunityId
				left join SILVER_WAREHOUSE.dbo.Worker h on h.RecordId = g.OwnerWorker 
				left join SILVER_WAREHOUSE.dbo.DirPartyTable i on i.RecordId = h.Person1
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
				left join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader b on b.SalesId = a.SalesId and b.dataAreaId = a.dataAreaId
			where b.SalesOrderPoolId = 'SP' and lower(a.dataAreaId) not in ('kzu', 'dat') and b.ZSalesOrderType != 'KLAIM'

			Union All

			select a.dataAreaId, b.ZInventSiteId, a.ProjInvoiceProjId, 'SV' as PoolID, a.OrderAccount, a.ProjInvoiceId, a.InvoiceDate, a.InvoiceAmount,
						Cast('1900-01-01' as date) as FU_InvoiceDate, 0 as FU_InvoiceAmountMST, Cast('1900-01-01' as date) as SP_InvoiceDate, 0 as SP_InvoiceAmountMST,
						a.InvoiceDate as SV_InvoiceDate, a.InvoiceAmount as SV_InvoiceAmountMST, '' as ItemId, '' as AMItemMinorGroupId,
						Cast('1900-01-01' as date) as LastOfferingDate, '' as ZDecisionMaker, '' as OwnerWorker,  '' as ZSegmentation, '' as ZGoodType,
						 0 as UnitBuy, 1 as UnitServed
			from SILVER_WAREHOUSE.dbo.ProjInvoiceJour a
				left join SILVER_WAREHOUSE.dbo.CaseTable b on b.CaseId = ProjInvoiceProjId and b.dataAreaId = a.dataAreaId
			where lower(a.dataAreaId) not in ('kzu', 'dat')

)x
	left join SILVER_WAREHOUSE.dbo.ZCustomers a on a.AccountNum = x.OrderAccount and a.dataAreaId = x.dataAreaId
	left join SILVER_WAREHOUSE.dbo.DirPartyTable b on b.RecordId = a.Party 
	left join SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView c on c.Party = a.Party  and c.ValidTo >= getdate() and c.IsPrimary = 'Yes'
	left join SILVER_WAREHOUSE.dbo.DirPartyLocation d on d.Party = a.Party and d.IsPostalAddress = 'No'
	left join SILVER_WAREHOUSE.dbo.LogisticsElectronicAddress e on e.Location = d.Location and e.Type = 'Phone' and e.IsPrimary = 'Yes'
	left join SILVER_WAREHOUSE.dbo.LogisticsElectronicAddress f on f.Location = d.Location and f.Type = 'Email' and e.IsPrimary = 'Yes'
	left join SILVER_WAREHOUSE.dbo.ZInventSites g on g.SiteId = x.InventSiteId
	left join SILVER_WAREHOUSE.dbo.AddressState g1 on g.ZProvinsi = g1.State
	left join SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView aa on aa.Party = a.Party and aa.ValidTo >= getdate() and aa.IsPrimary = 'Yes'
	left join SILVER_WAREHOUSE.dbo.AddressCity ab on ab.Name = aa.City  
	left join SILVER_WAREHOUSE.dbo.AddressState ac on ab.StateId = ac.State