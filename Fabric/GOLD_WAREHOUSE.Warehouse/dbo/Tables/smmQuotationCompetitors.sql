CREATE TABLE [dbo].[smmQuotationCompetitors] (

	[dataAreaId] varchar(8000) NULL, 
	[Party] bigint NULL, 
	[QuotationWinner] varchar(8000) NULL, 
	[RecordId] bigint NULL, 
	[RefRecId] bigint NULL, 
	[RefTableId] int NULL, 
	[ZCustTypeVehicle] varchar(8000) NULL, 
	[ZQty] int NULL, 
	[ZVehicleType] varchar(8000) NULL, 
	[Last_update] datetime2(6) NULL
);