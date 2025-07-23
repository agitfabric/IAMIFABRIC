CREATE TABLE [dbo].[PositionDetails] (

	[AvailableForAssignment] datetime2(6) NULL, 
	[CompensationRegionId] varchar(8000) NULL, 
	[CreatedDateTime1] datetime2(6) NULL, 
	[DepartmentNumber] varchar(8000) NULL, 
	[Description] varchar(8000) NULL, 
	[FullTimeEquivalent] float NULL, 
	[JobId] varchar(8000) NULL, 
	[ModifiedDateTime1] datetime2(6) NULL, 
	[PositionId] varchar(8000) NULL, 
	[PositionTypeId] varchar(8000) NULL, 
	[RecordId] bigint NULL, 
	[TitleId] varchar(8000) NULL, 
	[ValidFrom] datetime2(6) NULL, 
	[ValidTo] datetime2(6) NULL, 
	[DepartmentPublic] bigint NULL, 
	[PositionPublic] bigint NULL, 
	[Last_update] datetime2(6) NULL
);