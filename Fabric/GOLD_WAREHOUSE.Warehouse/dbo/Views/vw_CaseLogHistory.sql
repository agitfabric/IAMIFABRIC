-- Auto Generated (Do not modify) 994FD0B5B0BC84F3EF62B405EE1F7601913CE80FFEDBAF7DA2B44ACBA6EE883B

CREATE VIEW [dbo].[vw_CaseLogHistory]
AS
SELECT a.InventSiteID, a.CaseID, a.CreatedDateTime, a.Status, 
CASE WHEN a.StatusName IN ('Reveiwed','Approved') THEN  'Created' ELSE a.StatusName END StatusName,
b.DeviceId, c.ItemId, CASE WHEN c.ItemId = 'ADMIN' THEN 'LCV' ELSE d .AMItemMajorGroupId END AS MajorGroup, 
CASE WHEN c.ItemId = 'ADMIN' THEN 'PANTHER' ELSE d .AMItemMinorGroupId END AS MinorGroup, 
CASE WHEN c.ItemId = '9999999999' THEN 'Merk Lain' else 'Isuzu' end as Brand
FROM   dbo.CaseLogHistory AS a LEFT OUTER JOIN
             dbo.CaseTable AS b ON b.CaseId = a.CaseID LEFT OUTER JOIN
             dbo.DeviceTable AS c ON c.DeviceId = b.DeviceId AND c.dataAreaId = b.dataAreaId LEFT OUTER JOIN
             dbo.ZInventTables AS d ON d.ItemId = c.ItemId AND d.dataAreaId = c.dataAreaId