CREATE TABLE [dbo].[InventItemMinorGroup] (

	[dataAreaId] varchar(8000) NULL, 
	[ItemGroupId] varchar(8000) NULL, 
	[ItemTemplateId] varchar(8000) NULL, 
	[MajorGroupId] varchar(8000) NULL, 
	[MinorGroupId] varchar(8000) NULL, 
	[Name] varchar(8000) NULL, 
	[ZPriceUnitType] varchar(8000) NULL, 
	[ZSeriesAllocation] varchar(8000) NULL, 
	[ZSeriesTargetPenjualan] varchar(8000) NULL, 
	[ZSeriesTargetPenjualanValue] int NULL, 
	[Last_update] datetime2(6) NULL
);