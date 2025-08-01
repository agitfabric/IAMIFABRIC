CREATE TABLE [dbo].[ZLogisticsEntityPostalAddress] (

	[Address] varchar(8000) NULL, 
	[BuildingCompliment] varchar(8000) NULL, 
	[City] varchar(8000) NULL, 
	[CountryCurrencyCode] varchar(8000) NULL, 
	[CountryRegionId] varchar(8000) NULL, 
	[County] varchar(8000) NULL, 
	[District] bigint NULL, 
	[Entity] bigint NULL, 
	[EntityLocation] bigint NULL, 
	[EntityType] varchar(8000) NULL, 
	[IsPrimary] varchar(8000) NULL, 
	[Latitude] float NULL, 
	[Location] bigint NULL, 
	[LocationName] varchar(8000) NULL, 
	[Longitude] float NULL, 
	[PostalAddress] bigint NULL, 
	[PostBox] varchar(8000) NULL, 
	[State] varchar(8000) NULL, 
	[Street] varchar(8000) NULL, 
	[StreetNumber] varchar(8000) NULL, 
	[TimeZone] varchar(8000) NULL, 
	[ValidFrom] datetime2(6) NULL, 
	[ValidTo] datetime2(6) NULL, 
	[ZipCode] varchar(8000) NULL, 
	[Last_update] datetime2(6) NULL
);