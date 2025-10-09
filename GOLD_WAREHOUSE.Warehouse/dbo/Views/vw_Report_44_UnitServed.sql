-- Auto Generated (Do not modify) C41406956B98874408E7B30E18AAB04AF3DC4F493EB10CBCFA3F9A1244DDED68
CREATE VIEW [dbo].[vw_Report_44_UnitServed]
AS
SELECT TOP (100) PERCENT a.dataAreaId, b.InventSiteId, a.InvoiceDate, a.ProjInvoiceProjId AS ProjID, b.DeviceId, c.ItemId, d.NameAlias AS Item_Description, CASE WHEN c.ItemId = '9999999999' THEN 'Merk Lain' ELSE 'Isuzu' END AS Brand, d.AMItemMajorGroupId AS MajorGroup, 
             CASE WHEN d .AMItemMinorGroupId = '' AND d .AMItemMajorGroupId = 'LCV' THEN 'LCV' WHEN d .AMItemMinorGroupId = '' AND d .AMItemMajorGroupId = 'CV' THEN 'CV' ELSE d .AMItemMinorGroupId END AS MinorGroupId, CASE WHEN substring(b.WrkCtrId, 7, 1) = 'B' OR
             b.GroupId = 'SM003' THEN 'BIB' ELSE 'Stall' END AS Stall_BIB, CASE WHEN b.GroupId = 'SM005' THEN 'Service Kontrak' ELSE '' END AS Tipe_Service, 1 AS UnitServed_Qty, a.InvoiceAmount AS UnitServed_Revenue
FROM   SILVER_WAREHOUSE.dbo.ProjInvoiceJour AS a INNER JOIN
             SILVER_WAREHOUSE.dbo.CaseTable AS b ON b.CaseId = a.ProjInvoiceProjId AND b.ParentId = '' LEFT OUTER JOIN
             SILVER_WAREHOUSE.dbo.DeviceTable AS c ON c.DeviceId = b.DeviceId AND c.dataAreaId = b.dataAreaId LEFT OUTER JOIN
             SILVER_WAREHOUSE.dbo.ZInventTables AS d ON d.ItemId = c.ItemId AND d.dataAreaId = c.dataAreaId
WHERE (a.dataAreaId = 'zir') AND (CONVERT(char, a.InvoiceDate, 112) BETWEEN '20220101' AND '20220131')
ORDER BY a.dataAreaId, a.ProjInvoiceId