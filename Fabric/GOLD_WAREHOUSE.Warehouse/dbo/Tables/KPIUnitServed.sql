CREATE TABLE [dbo].[KPIUnitServed] (

	[Outlet] varchar(8000) NULL, 
	[Dealer] varchar(8000) NULL, 
	[Date] datetime2(6) NULL, 
	[Target] int NULL, 
	[Actual] int NULL, 
	[Achievement] decimal(5,2) NULL, 
	[Point] int NULL
);