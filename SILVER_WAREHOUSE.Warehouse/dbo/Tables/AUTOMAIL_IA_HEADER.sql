CREATE TABLE [dbo].[AUTOMAIL_IA_HEADER] (

	[IA_ID] bigint NULL, 
	[IANumber] varchar(8000) NULL, 
	[Requester] varchar(8000) NULL, 
	[CurrencyAmount] varchar(8000) NULL, 
	[CurrencyRate] decimal(19,4) NULL, 
	[AttachmentPath] varchar(8000) NULL, 
	[Amount] decimal(19,4) NULL, 
	[Notes] varchar(8000) NULL, 
	[CreatedDate] datetime2(6) NULL
);