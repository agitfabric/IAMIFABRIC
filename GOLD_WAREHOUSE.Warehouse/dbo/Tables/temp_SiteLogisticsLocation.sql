CREATE TABLE [dbo].[temp_SiteLogisticsLocation] (

	[AttentionToAddressLine] varchar(8000) NULL, 
	[InventSite_FK_SiteId] varchar(8000) NULL, 
	[IsDefault] varchar(8000) NULL, 
	[IsPostalAddress] varchar(8000) NULL, 
	[IsPrimary] varchar(8000) NULL, 
	[IsPrivate] varchar(8000) NULL, 
	[Location] bigint NULL, 
	[LogisticsLocation_FK_LocationId] varchar(8000) NULL, 
	[RecordId] bigint NULL, 
	[Site] bigint NULL
);