CREATE TABLE [dbo].[KPI_SL_DAILY_ENDSTOCK_20240827] (

	[DatePhysical] date NULL, 
	[Kode_Dealer] varchar(8000) NULL, 
	[Nama_Dealer] varchar(8000) NULL, 
	[Kode_Outlet] varchar(8000) NULL, 
	[Nama_Outlet] varchar(8000) NULL, 
	[Series] varchar(8000) NULL, 
	[Wholesale] int NULL, 
	[EUS] int NULL, 
	[TransferIn] int NULL, 
	[TransferOut] int NULL, 
	[Transactions] int NULL, 
	[BeginStock] int NULL, 
	[Endstock] int NULL, 
	[Last_update] datetime2(6) NULL
);