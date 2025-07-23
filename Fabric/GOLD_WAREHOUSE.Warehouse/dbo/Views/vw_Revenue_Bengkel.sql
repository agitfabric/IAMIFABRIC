-- Auto Generated (Do not modify) C3D676A8A09D47B451FAD01733E419120DA874CB1C6284590E60C8E1F3E0C2CD
CREATE VIEW [dbo].[vw_Revenue_Bengkel] AS
select a.InventSiteId as 'Kode Outlet', a.CustAccount as 'Kode Customer', d.InvoiceDate as 'Tanggal Invoice', d.InvoiceAmount as 'Revenue' from SILVER_WAREHOUSE.dbo.CaseTable as a
left join SILVER_WAREHOUSE.dbo.DeviceTable as b on b.DeviceId = a.DeviceId and b.dataAreaId = a.dataAreaId
left join SILVER_WAREHOUSE.dbo.ZInventTables as c on c.ItemId = b.ItemId and c.dataAreaId = b.dataAreaId
right join SILVER_WAREHOUSE.dbo.ProjInvoiceJour as d on d.ProjInvoiceProjId = a.CaseId
where c.AMItemMajorGroupId = 'CV'