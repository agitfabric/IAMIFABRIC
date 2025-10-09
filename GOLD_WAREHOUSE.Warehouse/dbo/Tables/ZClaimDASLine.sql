CREATE TABLE [dbo].[ZClaimDASLine] (

	[Amount] float NULL, 
	[ClaimId] varchar(8000) NULL, 
	[dataAreaId] varchar(8000) NULL, 
	[Item] varchar(8000) NULL, 
	[Number] int NULL, 
	[Qty] float NULL, 
	[RecordId] bigint NULL, 
	[TotalAmount] float NULL, 
	[Last_update] datetime2(6) NULL
);