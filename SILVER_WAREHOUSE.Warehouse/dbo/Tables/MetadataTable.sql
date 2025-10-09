CREATE TABLE [dbo].[MetadataTable] (

	[TableName] varchar(255) NOT NULL, 
	[SourceSchema] varchar(255) NOT NULL, 
	[DestinationPath] varchar(1000) NOT NULL, 
	[ScheduleCategory] varchar(50) NULL
);