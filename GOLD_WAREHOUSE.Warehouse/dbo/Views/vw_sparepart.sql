-- Auto Generated (Do not modify) 8ED5C95FE1E1989C9EAFF02D8B53CE68AC167D23E7296E8FF210101244B1308B
CREATE VIEW [dbo].[vw_sparepart]
AS
SELECT a.ItemId, a.NameAlias
FROM     dbo.ZInventTables AS a LEFT OUTER JOIN
                  dbo.InventItemGroupItem AS b ON b.ItemDataAreaId = a.dataAreaId AND b.ItemId = a.ItemId
WHERE  (b.ItemGroupId = 'SP01')
Group by  a.ItemId, a.NameAlias