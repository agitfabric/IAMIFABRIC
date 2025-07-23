CREATE TABLE [dbo].[KPI_SL_OUTLET_POINT_20240827] (

	[Yearmonth] int NULL, 
	[year] varchar(8000) NULL, 
	[month] varchar(8000) NULL, 
	[kode_outlet] varchar(8000) NULL, 
	[Series] varchar(8000) NULL, 
	[begin_stock] int NULL, 
	[net_eus] int NULL, 
	[endstock] int NULL, 
	[eus] int NULL, 
	[eus_1] int NULL, 
	[eus_2] int NULL, 
	[stock_level_actual] float NULL, 
	[stock_level_target] float NULL, 
	[stock_level_point] int NULL, 
	[last_update] datetime2(6) NULL, 
	[Achievement] float NULL, 
	[kode_dealer] varchar(8000) NULL
);