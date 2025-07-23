CREATE TABLE [dbo].[Report_52_SPVSalesman] (

	[OUTLET] varchar(8000) NULL, 
	[NAME] varchar(8000) NULL, 
	[SALESGROUPID] varchar(8000) NULL, 
	[SPVNAME] varchar(8000) NULL, 
	[USERIDSALESMAN] varchar(8000) NULL, 
	[SALESMAN] varchar(8000) NULL, 
	[Jumlah] int NOT NULL, 
	[RunningDate] char(6) NULL, 
	[JoinDate] datetime2(6) NULL, 
	[Jenjang] varchar(13) NOT NULL, 
	[LastSales] varchar(10) NOT NULL, 
	[Idle] int NOT NULL
);