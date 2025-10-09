CREATE TABLE [dbo].[LogisticsElectronicAddress] (

	[CountryRegionCode] varchar(8000) NULL, 
	[Description] varchar(8000) NULL, 
	[IsInstantMessage] varchar(8000) NULL, 
	[IsMobilePhone] varchar(8000) NULL, 
	[IsPrimary] varchar(8000) NULL, 
	[IsPrivate] varchar(8000) NULL, 
	[Location] bigint NULL, 
	[Locator] varchar(8000) NULL, 
	[LocatorExtension] varchar(8000) NULL, 
	[PrivateForParty] bigint NULL, 
	[RecordId] bigint NULL, 
	[Type] varchar(8000) NULL, 
	[Last_update] datetime2(6) NULL
);