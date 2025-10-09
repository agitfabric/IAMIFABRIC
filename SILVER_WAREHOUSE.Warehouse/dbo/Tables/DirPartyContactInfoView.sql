CREATE TABLE [dbo].[DirPartyContactInfoView] (

	[CountryRegionCode] varchar(8000) NULL, 
	[ElectronicAddress] bigint NULL, 
	[IsInstantMessage] varchar(8000) NULL, 
	[IsLocationOwner] varchar(8000) NULL, 
	[IsMobilePhone] varchar(8000) NULL, 
	[IsPrimary] varchar(8000) NULL, 
	[IsPrivate] varchar(8000) NULL, 
	[Location] bigint NULL, 
	[LocationId] varchar(8000) NULL, 
	[LocationName] varchar(8000) NULL, 
	[Locator] varchar(8000) NULL, 
	[LocatorExtension] varchar(8000) NULL, 
	[Party] bigint NULL, 
	[PartyLocation] bigint NULL, 
	[PrivateForParty] bigint NULL, 
	[Type] varchar(8000) NULL, 
	[TypeIcon] int NULL, 
	[ValidFrom] datetime2(6) NULL, 
	[ValidTo] datetime2(6) NULL, 
	[Last_update] datetime2(6) NULL
);