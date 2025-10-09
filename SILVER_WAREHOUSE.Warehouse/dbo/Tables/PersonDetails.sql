CREATE TABLE [dbo].[PersonDetails] (

	[ExpatriateRulingValidFrom] datetime2(6) NULL, 
	[ExpatriateRulingValidTo] datetime2(6) NULL, 
	[IsDisabledVeteran] varchar(8000) NULL, 
	[IsExpatriateRulingApplicable] varchar(8000) NULL, 
	[MaritalStatus] varchar(8000) NULL, 
	[MilitaryServiceEndDate] datetime2(6) NULL, 
	[MilitaryServiceStartDate] datetime2(6) NULL, 
	[NumberOfDependents] int NULL, 
	[PartyNumber] varchar(8000) NULL, 
	[ValidFrom] datetime2(6) NULL, 
	[ValidTo] datetime2(6) NULL, 
	[VeteranStatusId] varchar(8000) NULL, 
	[PersonPublic] bigint NULL, 
	[Last_update] datetime2(6) NULL
);