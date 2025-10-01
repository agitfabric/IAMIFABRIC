-- Auto Generated (Do not modify) C6331BA8847F8265BA040C005DCD55D498316B489FF60654DE73C0047C3724B2
CREATE    VIEW [dbo].[vw_DeviceModel_PSS]
AS

SELECT DISTINCT d.ModelId AS ItemID, d.Name AS Item_Name, it.AMItemMajorGroupId AS MajorGroup, it.AMItemMinorGroupId AS MinorGroup, it.ZSeriesType AS Tipe_Series, d.ClassId AS Segment_Desc
FROM            SILVER_WAREHOUSE.dbo.DeviceModel AS d INNER JOIN
                         SILVER_WAREHOUSE.dbo.ZInventTables AS it ON d.ModelId = it.ItemId
WHERE        (it.dataAreaId = 'zir') AND (d.Stopped = 'No')