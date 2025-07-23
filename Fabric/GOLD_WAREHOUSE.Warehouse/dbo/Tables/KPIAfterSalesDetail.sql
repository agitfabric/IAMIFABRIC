CREATE TABLE [dbo].[KPIAfterSalesDetail] (

	[DATE] date NULL, 
	[YEAR] varchar(8000) NULL, 
	[MONTH] varchar(8000) NULL, 
	[Outlet] varchar(8000) NULL, 
	[KodeOutlet] varchar(8000) NULL, 
	[Dealer] varchar(8000) NULL, 
	[KodeDealer] varchar(8000) NULL, 
	[Jabatan] varchar(8000) NULL, 
	[Level] varchar(8000) NULL, 
	[Fit] int NULL, 
	[NotFit] int NULL, 
	[Actual] int NULL, 
	[Standard] int NULL, 
	[PowerMax] int NULL, 
	[Achievement] decimal(5,2) NULL, 
	[Point] int NULL
);