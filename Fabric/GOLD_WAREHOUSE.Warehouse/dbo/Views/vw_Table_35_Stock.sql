-- Auto Generated (Do not modify) 4D1A8EC67C65C09618665120B3C49247A3C7C8ADCFDB650A37C160BC4F38B4B8
CREATE VIEW [dbo].[vw_Table_35_Stock]
AS


SELECT	a.dataAreaId AS Dealer, d.ZDealerAfterSales DealerName,
		b.InventSiteId AS Outlet, d.Name OutletName,
		b.InventLocationId AS Warehouse, 
		a.ItemId, e.NameAlias ItemName,
		a.Qty, a.CostAmountPosted + a.CostAmountAdjustment AS Amount, 
		cast(a.DatePhysical as date) DatePhysical

		
FROM      dbo.InventTrans AS a LEFT OUTER JOIN
                dbo.Dim AS b ON b.inventDimId = a.inventDimId LEFT OUTER JOIN
                dbo.InventItemGroupItem AS c ON c.ItemId = a.ItemId AND c.ItemDataAreaId = a.dataAreaId LEFT OUTER JOIN
				dbo.ZInventSites AS d ON d.SiteId = b.InventSiteId LEFT OUTER JOIN
				dbo.ZInventTables AS e ON e.ItemId = a.ItemId AND e.dataAreaId = a.dataAreaId
				
WHERE   (a.DatePhysical > '1900-01-01 12:00:00.000') AND (LOWER(a.dataAreaId) <> 'kzu') 
--AND (CONVERT(char, a.DatePhysical, 112) < '20210101') 
AND (c.ItemGroupId = 'SP01')
--and lower(b.InventSiteId) = 'ARM01'