CREATE TABLE [dbo].[KPI_Retention_Fleet_20241223] (

	[Tanggal] date NULL, 
	[InvoiceID] varchar(8000) NULL, 
	[Code_Outlet] varchar(8000) NULL, 
	[CodeMapping] varchar(8000) NULL, 
	[Nama_Mapping] varchar(8000) NULL, 
	[P] float NULL, 
	[N] float NULL, 
	[F] float NULL, 
	[Target_Revenue] float NULL, 
	[Revenue_Bengkel] float NULL, 
	[Revenue_SO_Parts] float NULL, 
	[Jumlah_Fakpol_S1] int NULL, 
	[Jumlah_Fakpol_S2] int NULL, 
	[Jumlah_Fakpol] int NULL, 
	[UnitServed] int NULL
);