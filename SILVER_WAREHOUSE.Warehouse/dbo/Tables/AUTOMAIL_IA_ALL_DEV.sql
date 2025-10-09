CREATE TABLE [dbo].[AUTOMAIL_IA_ALL_DEV] (

	[IA_ID] bigint NULL, 
	[IANumber] varchar(50) NULL, 
	[Requester] varchar(50) NULL, 
	[CurrencyAmount] char(3) NULL, 
	[CurrencyRate] decimal(19,4) NULL, 
	[AttachmentPath] varchar(8000) NULL, 
	[Amount] decimal(19,4) NULL, 
	[Notes] varchar(8000) NULL, 
	[CreatedDate] datetime2(3) NULL, 
	[item] varchar(8000) NULL, 
	[qty] int NULL, 
	[price_unit] decimal(19,4) NULL, 
	[cost_estimation] decimal(19,4) NULL, 
	[price_unit_foreign] decimal(19,4) NULL, 
	[cost_estimation_foreign] decimal(19,4) NULL, 
	[IAStatusDesc] varchar(50) NULL
);