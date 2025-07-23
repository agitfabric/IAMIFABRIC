CREATE TABLE [dbo].[KPISalesPeople] (

	[POSITIONID] bigint NULL, 
	[dealer] varchar(8000) NULL, 
	[outlet] varchar(8000) NULL, 
	[kodeoutlet] varchar(8000) NULL, 
	[npk] varchar(8000) NULL, 
	[nama] varchar(8000) NULL, 
	[PersonalTitle] varchar(8000) NULL, 
	[Departemen] varchar(8000) NULL, 
	[title] varchar(8000) NULL, 
	[reporttonama] varchar(8000) NULL, 
	[join_date] datetime2(6) NULL, 
	[until_date] datetime2(6) NULL, 
	[Jenjang] varchar(8000) NULL, 
	[IsActive] int NULL
);