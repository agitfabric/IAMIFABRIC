CREATE TABLE [dbo].[temp_ZIntegrasiInvoiceTable] (

	[INVOICEID] varchar(8000) NULL, 
	[INVOICEDATE] datetime2(6) NULL, 
	[SOLDTO] varchar(8000) NULL, 
	[SHIPTO] varchar(8000) NULL, 
	[SITEID] varchar(8000) NULL, 
	[PURCHASEORDER] varchar(8000) NULL, 
	[DELIVERYNOTEID] varchar(8000) NULL, 
	[DISCOUNTTOP] float NULL, 
	[DPP] float NULL, 
	[PPN] float NULL, 
	[TOTAL] float NULL, 
	[ORIGINALINVOICE] varchar(8000) NULL, 
	[ISPOSTED] varchar(8000) NULL, 
	[ISREPLACE] varchar(8000) NULL, 
	[DATETIME] datetime2(6) NULL, 
	[DATAAREAID] varchar(8000) NULL
);