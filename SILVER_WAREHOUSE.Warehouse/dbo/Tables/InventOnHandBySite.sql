CREATE TABLE [dbo].[InventOnHandBySite] (

	[AvailOrdered] float NULL, 
	[AvailPhysical] float NULL, 
	[configId] varchar(8000) NULL, 
	[InventColorId] varchar(8000) NULL, 
	[InventSiteId] varchar(8000) NULL, 
	[InventSizeId] varchar(8000) NULL, 
	[InventStyleId] varchar(8000) NULL, 
	[IsCWItem] varchar(8000) NULL, 
	[IsWHSItem] varchar(8000) NULL, 
	[ItemId] varchar(8000) NULL, 
	[OnOrder] float NULL, 
	[OrderedSum] float NULL, 
	[PhysicalInvent] float NULL, 
	[ReservOrdered] float NULL, 
	[ReservPhysical] float NULL, 
	[TotalAvailable] float NULL, 
	[Last_update] datetime2(6) NULL
);