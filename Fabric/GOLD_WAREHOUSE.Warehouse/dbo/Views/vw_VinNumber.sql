-- Auto Generated (Do not modify) 8E18A6B000E838B245632C1F1B34A1619F3F2CBBFF33B1B2CC1D98C44CDCAE6D
CREATE VIEW [dbo].[vw_VinNumber]
AS
select Distinct i.AMItemMajorGroupId CV_LCV, i.ItemId, l.Name Segment_Desc, a.Type Series, a.ItemName Type_Desc, a.VIN Vin_Number
from ZEFakpol a
		left join ZInventTables  i on i.ItemId = a.ItemNo and i.dataAreaId = a.dataAreaId
		left join DeviceTableMasters j on j.MasterId = a.VIN 
		left join DeviceTable k on k.DeviceId = a.VIN and k.dataAreaId = a.dataAreaId
		left join DeviceClass l on l.ClassId = j.ClassId
Where a.ApprovedDate > '1900-01-01 12:00:00.000'