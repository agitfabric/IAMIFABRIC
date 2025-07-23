CREATE TABLE [dbo].[ReportTPS] (

	[Outlet] varchar(8000) NULL, 
	[ResourceNumber] varchar(8000) NULL, 
	[Name] varchar(8000) NULL, 
	[Jabatan] varchar(8000) NULL, 
	[Level] varchar(8000) NULL, 
	[AbsensiDate] datetime2(6) NULL, 
	[TanggalAbsensi] varchar(8000) NULL, 
	[DealerName] varchar(8000) NULL, 
	[DealerCode] varchar(8000) NULL, 
	[UnitReturn] int NULL, 
	[Kehadiran] int NULL, 
	[JT] int NULL, 
	[Fr] float NULL, 
	[Act] float NULL, 
	[Jasa] float NULL, 
	[Part] float NULL, 
	[Bahan] float NULL, 
	[UnitServed] int NULL, 
	[OutletName] varchar(8000) NULL
);