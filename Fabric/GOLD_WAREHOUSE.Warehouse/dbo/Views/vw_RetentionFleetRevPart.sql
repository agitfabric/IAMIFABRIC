-- Auto Generated (Do not modify) B75112BA249C544AC7F6D1D806046F3714F339DDF3746AE96FD5CCA9D0A1F00A
CREATE VIEW [dbo].[vw_RetentionFleetRevPart] AS
(
	SELECT  month(CAST(a.InvoiceDate AS DATE)) AS 'Bulan', 
		year(CAST(a.InvoiceDate AS DATE)) AS 'Tahun', 
		b.InventSiteId AS 'Code_Outlet',
		b.dataAreaId+b.InvoiceAccount  AS 'Code_Mapping', 
		sum(a.LineAmountMST) AS 'Revenue_SO_Parts'
	FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
	LEFT JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderHeader b ON a.SalesId = b.SalesId
	INNER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem c ON a.dataAreaId = c.ItemDataAreaId AND a.ItemId = c.ItemId AND c.ItemGroupId in ('SP01','SP02')
	WHERE year(CAST(a.InvoiceDate AS DATE)) = 2024 and b.SalesOrderPoolId = 'SP'
	GROUP BY  month(CAST(a.InvoiceDate AS DATE)), 
			year(CAST(a.InvoiceDate AS DATE)), 
			b.InventSiteId,
			b.dataAreaId+b.InvoiceAccount
)