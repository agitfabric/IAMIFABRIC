-- Auto Generated (Do not modify) 1CF823D14F31759B5B3AAD5867FED454155795EA873C04416AB31F60CF7D287F
CREATE VIEW [dbo].[vw_Revenue_Sparepart] AS
select a.InvoiceDate as 'Tanggal Invoice', a.LineAmountMST as 'Revenue', b.InventSiteId as 'Kode Outlet', b.InvoiceAccount as 'Kode Customer'  from SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
Left Join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader b on  a.SalesId = b.SalesId
Left Join SILVER_WAREHOUSE.dbo.InventItemGroupItem c on a.dataAreaId = c.ItemDataAreaId and a.ItemId = c.ItemId