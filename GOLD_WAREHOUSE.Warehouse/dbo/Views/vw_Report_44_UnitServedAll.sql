-- Auto Generated (Do not modify) AC34A2242727862EA5A385D754F5F83F394EE8412672FC32B298C53A413E1E9D
CREATE VIEW [dbo].[vw_Report_44_UnitServedAll] AS (SELECT TOP (100) PERCENT x.dataAreaId, x.InventSiteId, x.InvoiceDate, x.ProjId, x.DeviceId, c.ItemId, d.NameAlias AS Item_Description, CASE WHEN c.ItemId = '9999999999' THEN 'Merk Lain' ELSE 'Isuzu' END AS Brand, d.AMItemMajorGroupId AS MajorGroup, 
             CASE WHEN d .AMItemMinorGroupId = '' AND d .AMItemMajorGroupId = 'LCV' THEN 'LCV' WHEN d .AMItemMinorGroupId = '' AND d .AMItemMajorGroupId = 'CV' THEN 'CV' ELSE d .AMItemMinorGroupId END AS MinorGroupId, CASE WHEN x.GroupId = 'SM003' OR
             SUBSTRING(x.WrkCtrId, 7, 1) = 'B' THEN 'BIB' ELSE 'Stall' END AS Stall_BIB, x.GroupId, x.ParentId, CASE WHEN x.GroupId = 'SM005' AND x.ParentId = '' THEN 1 ELSE 0 END AS Contract_Qty, CASE WHEN x.ParentId != '' THEN 0 WHEN x.ParentId = '' AND 
             x.InvoiceAmount < 0 THEN - 1 ELSE 1 END AS UnitServed_Qty
FROM   (SELECT a.dataAreaId, LEFT(a.ProjInvoiceProjId, 5) AS InventSiteId, MIN(CAST(a.InvoiceDate AS date)) AS InvoiceDate, a.ProjInvoiceProjId AS ProjId, b.DeviceId, SUM(a.qty) AS qty, SUM(a.InvoiceAmount) AS InvoiceAmount, b.GroupId, b.ParentId, b.WrkCtrId
             FROM    SILVER_WAREHOUSE.dbo.ProjInvoiceJour AS a INNER JOIN
                           SILVER_WAREHOUSE.dbo.CaseTable AS b ON b.CaseId = a.ProjInvoiceProjId LEFT OUTER JOIN
                           SILVER_WAREHOUSE.dbo.DeviceTable AS c ON c.DeviceId = b.DeviceId AND c.dataAreaId = b.dataAreaId
             WHERE  (a.dataAreaId = 'zir') AND (CONVERT(char, a.InvoiceDate, 112) BETWEEN '20220101' AND '20220630')
             GROUP BY a.dataAreaId, a.ProjInvoiceProjId, b.DeviceId, b.GroupId, b.ParentId, b.WrkCtrId) AS x LEFT OUTER JOIN
             SILVER_WAREHOUSE.dbo.DeviceTable AS c ON c.DeviceId = x.DeviceId AND c.dataAreaId = x.dataAreaId LEFT OUTER JOIN
             SILVER_WAREHOUSE.dbo.ZInventTables AS d ON d.ItemId = c.ItemId AND d.dataAreaId = c.dataAreaId
WHERE (x.InvoiceAmount <> 0)
ORDER BY x.ProjId)