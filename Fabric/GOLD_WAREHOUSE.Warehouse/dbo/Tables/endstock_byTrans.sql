CREATE TABLE [dbo].[endstock_byTrans] (

	[Date] datetime2(6) NULL, 
	[kode_dealer] varchar(8000) NULL, 
	[ReferenceCategory] varchar(8000) NULL, 
	[VIN] varchar(8000) NULL, 
	[Segment_description] varchar(8000) NULL, 
	[Item_id] varchar(8000) NULL, 
	[StatusReceipt] varchar(8000) NULL, 
	[StatusIssue] varchar(8000) NULL, 
	[InventDimension1] varchar(8000) NULL, 
	[InventSiteId] varchar(8000) NULL
);