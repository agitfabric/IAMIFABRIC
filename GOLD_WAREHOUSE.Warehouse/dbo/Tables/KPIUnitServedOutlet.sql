CREATE TABLE [dbo].[KPIUnitServedOutlet] (

	[Outlet] varchar(8000) NULL, 
	[Date] datetime2(6) NULL, 
	[Target] int NULL, 
	[Actual] int NULL, 
	[Achievement] decimal(5,2) NULL, 
	[Point] int NULL, 
	[Series] varchar(8000) NULL
);