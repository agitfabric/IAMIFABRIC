CREATE TABLE [dbo].[CaseProjHourPrice] (

	[Amount] float NULL, 
	[CreatedDateTime1] datetime2(6) NULL, 
	[CurrencyCode] varchar(8000) NULL, 
	[CustCode] varchar(8000) NULL, 
	[CustRelation] varchar(8000) NULL, 
	[dataAreaId] varchar(8000) NULL, 
	[FromDate] datetime2(6) NULL, 
	[ModifiedDateTime1] datetime2(6) NULL, 
	[PriceType] varchar(8000) NULL, 
	[ProjCategoryCode] varchar(8000) NULL, 
	[ProjCategoryRelation] varchar(8000) NULL, 
	[ProjCode] varchar(8000) NULL, 
	[ProjRelation] varchar(8000) NULL, 
	[RecordId] bigint NULL, 
	[ResourceCategory] bigint NULL, 
	[ResourceCode] varchar(8000) NULL, 
	[ResourceRelation] varchar(8000) NULL, 
	[ToDate] datetime2(6) NULL, 
	[Last_Update] datetime2(6) NULL
);