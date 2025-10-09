CREATE TABLE [dbo].[temp_PositionHierarchy] (

	[CreatedDateTime1] datetime2(6) NULL, 
	[HierarchyType] varchar(8000) NULL, 
	[HierarchyTypeName] varchar(8000) NULL, 
	[ModifiedDateTime1] datetime2(6) NULL, 
	[ParentPosition] bigint NULL, 
	[ParentPositionId] varchar(8000) NULL, 
	[Position] bigint NULL, 
	[PositionHierarchyType] bigint NULL, 
	[PositionId] varchar(8000) NULL, 
	[RecordId] bigint NULL, 
	[ValidFrom] datetime2(6) NULL, 
	[ValidTo] datetime2(6) NULL, 
	[Last_Update] datetime2(6) NULL
);