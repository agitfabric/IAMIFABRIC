-- Auto Generated (Do not modify) 03179A32CEEE0AE7918B14D2226C5CF68908D910067B708699B44193B6F0D1CF
CREATE VIEW [dbo].[vw_BrandMajorMinor]
AS
SELECT TOP (100) PERCENT Brand, MajorGroup, MinorGroupId
FROM   (SELECT DISTINCT 
                           CASE WHEN c.ItemId = '9999999999' THEN 'Merk Lain' ELSE 'Isuzu' END AS Brand, d.AMItemMajorGroupId AS MajorGroup, CASE WHEN d .AMItemMinorGroupId = '' AND d .AMItemMajorGroupId = 'LCV' THEN 'LCV' WHEN d .AMItemMinorGroupId = '' AND 
                           d .AMItemMajorGroupId = 'CV' THEN 'CV' ELSE d .AMItemMinorGroupId END AS MinorGroupId
             FROM    SILVER_WAREHOUSE.dbo.ProjInvoiceJour AS a INNER JOIN
                           SILVER_WAREHOUSE.dbo.CaseTable AS b ON b.CaseId = a.ProjInvoiceProjId AND b.ParentId = '' LEFT OUTER JOIN
                           SILVER_WAREHOUSE.dbo.DeviceTable AS c ON c.DeviceId = b.DeviceId AND c.dataAreaId = b.dataAreaId LEFT OUTER JOIN
                           SILVER_WAREHOUSE.dbo.ZInventTables AS d ON d.ItemId = c.ItemId AND d.dataAreaId = c.dataAreaId
             WHERE  (a.dataAreaId = 'zir')) AS x
WHERE (MajorGroup IS NOT NULL) AND (MinorGroupId <> '')
ORDER BY Brand, MajorGroup, MinorGroupId