CREATE TABLE [dbo].[KPI_SL_Detail] (

	[Outlet Code] varchar(8000) NULL, 
	[Dates] datetime2(6) NULL, 
	[Series] varchar(8000) NULL, 
	[Wholesale] int NULL, 
	[TransferIn] int NULL, 
	[TransferOut] int NULL, 
	[BeginStock] int NULL, 
	[EndStock] int NULL, 
	[EUS] int NULL
);