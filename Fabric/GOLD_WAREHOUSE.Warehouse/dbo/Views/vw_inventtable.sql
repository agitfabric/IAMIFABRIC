-- Auto Generated (Do not modify) 74F2A636B756D7697DEF3855F46D60501E61F86DA91F70B865E705F3B74D9977
CREATE VIEW [dbo].[vw_inventtable] as (
select * --count (*) 
from (
SELECT 
	--AMDangerousCode,
	a.AMDeviceBrandId,
	a.AMDeviceClassId,
	a.AMDeviceGroupId,
	a.AMDeviceModelId,
	a.AMItemMajorGroupId,
	a.AMItemMinorGroupId,
	a.dataAreaId,
	a.ItemId,
	a.NameAlias,
	a.Name,
	b.ItemGroupId
FROM
	SILVER_WAREHOUSE.dbo.ZInventTables a
left join SILVER_WAREHOUSE.dbo.InventItemGroupItem b on a.dataAreaId=b.ItemDataAreaId and a.ItemId = b.ItemId 
where b.ItemGroupId= 'FU01'
)x	--and a.AMItemMinorGroupId like '%LT%'
left JOIN 
(select DISTINCT y.ModelId,y.ClassId as classId from SILVER_WAREHOUSE.dbo.DeviceTableMasters y ) c on x.ItemId = c.ModelId 
)