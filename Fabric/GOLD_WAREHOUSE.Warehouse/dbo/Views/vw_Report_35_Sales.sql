-- Auto Generated (Do not modify) EADE3A0911C588C04E1F34A2A543CFCF83BF1708DEB6E6DF96977BE95E9C9578
CREATE VIEW [dbo].[vw_Report_35_Sales]
AS
SELECT b.InventSiteId AS Outlet, d.InventLocationId Warehouse, 
		CAST(a.InvoiceDate AS date) AS InvoiceDate, a.ItemId, a.Qty, a.LineAmountMST AS Amount
FROM     SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans AS a LEFT OUTER JOIN
                  SILVER_WAREHOUSE.dbo.ZSalesOrderHeader AS b ON b.SalesId = a.SalesId LEFT OUTER JOIN
                  SILVER_WAREHOUSE.dbo.InventItemGroupItem AS c ON c.ItemDataAreaId = a.dataAreaId AND c.ItemId = a.ItemId LEFT OUTER JOIN
				SILVER_WAREHOUSE.dbo.Dim as d on d.inventDimId = a.InventDimId
WHERE  (b.SalesOrderPoolId = 'SP') AND (c.ItemGroupId = 'SP01') AND (lower(a.dataAreaId) <> 'kzu') and b.ZSalesType != 'Klaim'