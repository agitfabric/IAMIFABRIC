CREATE TABLE [dbo].[DirPartyLocation] (

	[AttentionToAddressLine] varchar(8000) NULL, 
	[CreatedDateTime1] datetime2(6) NULL, 
	[DirPartyTable_FK_PartyNumber] varchar(8000) NULL, 
	[IsLocationOwner] varchar(8000) NULL, 
	[IsPostalAddress] varchar(8000) NULL, 
	[IsPrimary] varchar(8000) NULL, 
	[IsPrimaryTaxRegistration] varchar(8000) NULL, 
	[IsPrivate] varchar(8000) NULL, 
	[IsRoleBusiness] varchar(8000) NULL, 
	[IsRoleDelivery] varchar(8000) NULL, 
	[IsRoleHome] varchar(8000) NULL, 
	[IsRoleInvoice] varchar(8000) NULL, 
	[LogisticsLocation_FK_LocationId] varchar(8000) NULL, 
	[ModifiedDateTime1] datetime2(6) NULL, 
	[RecordId] bigint NULL, 
	[Location] bigint NULL, 
	[Party] bigint NULL, 
	[Last_update] datetime2(6) NULL
);