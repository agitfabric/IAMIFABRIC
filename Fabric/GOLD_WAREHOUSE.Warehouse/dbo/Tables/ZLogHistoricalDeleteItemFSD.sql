CREATE TABLE [dbo].[ZLogHistoricalDeleteItemFSD] (

	[ZDeletedBy] varchar(8000) NULL, 
	[ZDeletedDateandTime] datetime2(6) NULL, 
	[ZItemNumber] varchar(8000) NULL, 
	[ZLineNumber] float NULL, 
	[ZNomorWOJournalSOID] varchar(8000) NULL, 
	[ZTypeTransaction] varchar(8000) NULL, 
	[Last_Update] datetime2(6) NULL, 
	[Status] varchar(8000) NULL
);