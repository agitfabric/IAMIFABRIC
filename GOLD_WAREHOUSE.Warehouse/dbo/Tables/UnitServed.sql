CREATE TABLE [dbo].[UnitServed] (

	[Outlet] varchar(8000) NULL, 
	[Dealer] varchar(8000) NULL, 
	[Date] datetime2(6) NULL, 
	[Target] smallint NULL, 
	[Actual] smallint NULL, 
	[Achievement] smallint NULL, 
	[Point] smallint NULL
);