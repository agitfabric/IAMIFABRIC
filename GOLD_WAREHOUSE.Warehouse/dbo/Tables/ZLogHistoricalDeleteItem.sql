CREATE TABLE [dbo].[ZLogHistoricalDeleteItem] (

	[dataAreaId] varchar(8000) NULL, 
	[ZDeletedBy] varchar(8000) NULL, 
	[ZDeletedByEmail] varchar(8000) NULL, 
	[ZDeletedDateandTime] datetime2(6) NULL, 
	[ZItemNumber] varchar(8000) NULL, 
	[ZLineNumber] float NULL, 
	[ZLogHistoricalDeleteItemDataAreaId] varchar(8000) NULL, 
	[ZLogHistoricalDeleteItemRecId] bigint NULL, 
	[ZNomorWOJournalSOID] varchar(8000) NULL, 
	[ZRecordId] bigint NULL, 
	[ZTypeTransaction] varchar(8000) NULL, 
	[Last_Update] datetime2(6) NULL, 
	[Status] varchar(8000) NULL
);