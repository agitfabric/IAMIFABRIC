CREATE TABLE [dbo].[temp_Report_32] (

	[Vendor_ID] varchar(8000) NULL, 
	[Vendor_Name] varchar(8000) NULL, 
	[PO_Date] datetime2(6) NULL, 
	[PO_Number] varchar(8000) NULL, 
	[dealer] varchar(8000) NULL, 
	[nama_dealer] varchar(8000) NULL, 
	[Outlet] varchar(8000) NULL, 
	[nama_Outlet] varchar(8000) NULL, 
	[StatusPO] varchar(8000) NULL, 
	[Part_Number] varchar(8000) NULL, 
	[Description] varchar(8000) NULL, 
	[Qty_PO] float NULL, 
	[InvoiceId] varchar(8000) NULL, 
	[Origpurchid] varchar(8000) NULL, 
	[PurchaseLineLineNumber] bigint NULL, 
	[Qty_Invoice_GR] float NULL, 
	[Invoice_Date] datetime2(6) NULL, 
	[GR_Date] datetime2(6) NULL, 
	[Type_Order] varchar(8000) NULL, 
	[Area] varchar(8000) NULL, 
	[Last_update] datetime2(6) NULL
);