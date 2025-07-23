CREATE TABLE [dbo].[KPI_SL_Dealer] (

	[Dealer Name] varchar(8000) NULL, 
	[Dates] datetime2(6) NULL, 
	[Series] varchar(8000) NULL, 
	[BeginStock] int NULL, 
	[EndStock] int NULL, 
	[NetEus] int NULL, 
	[StockLevelActual] float NULL, 
	[StockLevelTarget] float NULL
);