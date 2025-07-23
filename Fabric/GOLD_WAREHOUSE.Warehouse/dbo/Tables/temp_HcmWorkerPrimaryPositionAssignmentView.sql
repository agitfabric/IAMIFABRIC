CREATE TABLE [dbo].[temp_HcmWorkerPrimaryPositionAssignmentView] (

	[IsPrimaryPosition] varchar(8000) NULL, 
	[Position] bigint NULL, 
	[PositionWorkerAssignment] bigint NULL, 
	[ValidFrom] datetime2(6) NULL, 
	[ValidTo] datetime2(6) NULL, 
	[Worker] bigint NULL, 
	[CreatedDateTime1] datetime2(6) NULL, 
	[ModifiedDateTime1] datetime2(6) NULL, 
	[RecordId] bigint NULL, 
	[Last_update] datetime2(6) NULL
);