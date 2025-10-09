-- Auto Generated (Do not modify) 0363A92026BDC8BBB1C2B54623DBDD5887D29D3E02F91E10C120A5954C4D264C
CREATE VIEW [dbo].[vw_mart_51_outlet_eus]
AS
SELECT a.dataAreaId AS kode_dealer, d.ZDealerSales AS nama_dealer, c.InventSiteId AS kode_outlet, d.Name AS nama_outlet, a.InvoiceDate AS tanggal_invoice, c.SalesPoolIdPublic AS pool, c.ZSalesType AS tipe_sales, 
                  d.AreaCode + ' - ' + d.ZIAMIArea AS area, d.Group_Dealer, c.City, b.ItemId AS item, f.NameAlias AS nama_item, b.Qty
FROM     dbo.CustInvoiceJour AS a LEFT OUTER JOIN
                  dbo.ZCustInvoiceTrans AS b ON b.InvoiceId = a.InvoiceId LEFT OUTER JOIN
                  dbo.SalesTable AS c ON c.SalesId = a.SalesId LEFT OUTER JOIN
                  dbo.ZInventSites AS d ON d.SiteId = c.InventSiteId LEFT OUTER JOIN
                  dbo.InventItemGroupItem AS e ON e.ItemId = b.ItemId AND e.ItemDataAreaId = b.dataAreaId LEFT OUTER JOIN
                  dbo.ZInventTables AS f ON f.ItemId = b.ItemId AND f.dataAreaId = b.dataAreaId
WHERE  (e.ItemGroupId = 'FU01')