CREATE TABLE [dbo].[temp_PositionWorkerAssignment] (

	[AssignmentReasonCode] bigint NULL, 
	[CreatedDateTime1] datetime2(6) NULL, 
	[IsPrimaryPosition] varchar(8000) NULL, 
	[ModifiedDateTime1] datetime2(6) NULL, 
	[PersonnelNumber] varchar(8000) NULL, 
	[Position] bigint NULL, 
	[PositionId] varchar(8000) NULL, 
	[ReasonCode] bigint NULL, 
	[ReasonCodeId] varchar(8000) NULL, 
	[RecordId] bigint NULL, 
	[ValidFrom] datetime2(6) NULL, 
	[ValidTo] datetime2(6) NULL, 
	[Worker] bigint NULL, 
	[ZSalesmanType] varchar(8000) NULL, 
	[ZSalesType] varchar(8000) NULL, 
	[Last_Update] datetime2(6) NULL
);