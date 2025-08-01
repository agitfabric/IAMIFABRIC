CREATE TABLE [dbo].[temp_DeviceTableMasters] (

	[AirBagDriver] varchar(8000) NULL, 
	[AirBagPassenger] varchar(8000) NULL, 
	[BodyId] varchar(8000) NULL, 
	[BrandId] varchar(8000) NULL, 
	[ChassisNumber] varchar(8000) NULL, 
	[ClassId] varchar(8000) NULL, 
	[CO2Emissions] int NULL, 
	[DeRegistrationDate] datetime2(6) NULL, 
	[DeRegistrationReasonId] varchar(8000) NULL, 
	[DeviceLocationId] varchar(8000) NULL, 
	[DeviceName] varchar(8000) NULL, 
	[DirectImport] varchar(8000) NULL, 
	[DoorQuantity] int NULL, 
	[DriveTrainId] varchar(8000) NULL, 
	[EngineDisplacement] int NULL, 
	[EngineHP] int NULL, 
	[EngineId] varchar(8000) NULL, 
	[EngineKW] int NULL, 
	[EngineNumber] varchar(8000) NULL, 
	[EngineNumberOfCylinders] int NULL, 
	[EntryCode] varchar(8000) NULL, 
	[EnvironmentClassId] varchar(8000) NULL, 
	[ExteriorId] varchar(8000) NULL, 
	[FaceLift] varchar(8000) NULL, 
	[FuelConsumption] float NULL, 
	[FuelId] varchar(8000) NULL, 
	[GearboxNumber] varchar(8000) NULL, 
	[GroupCodeId] varchar(8000) NULL, 
	[InteriorId] varchar(8000) NULL, 
	[IsVINIndependent] varchar(8000) NULL, 
	[KeyCode] varchar(8000) NULL, 
	[LastInspectionDate] datetime2(6) NULL, 
	[ManufacturingCountryId] varchar(8000) NULL, 
	[MasterId] varchar(8000) NULL, 
	[MasterNotes] varchar(8000) NULL, 
	[ModelCodeId] varchar(8000) NULL, 
	[ModelConfigurationId] varchar(8000) NULL, 
	[ModelId] varchar(8000) NULL, 
	[ModelNumber] varchar(8000) NULL, 
	[ModelYear] int NULL, 
	[NextInspectionDate] datetime2(6) NULL, 
	[OprModelId] varchar(8000) NULL, 
	[ParentId] varchar(8000) NULL, 
	[PreRegistrationDate] datetime2(6) NULL, 
	[PreRegistrationRequestDate] datetime2(6) NULL, 
	[PrivateNumber] varchar(8000) NULL, 
	[ProductionDate] datetime2(6) NULL, 
	[ProductionMonth] int NULL, 
	[RadioCode] varchar(8000) NULL, 
	[RegistrationDate] datetime2(6) NULL, 
	[RegistrationNumber] varchar(8000) NULL, 
	[RegistrationPlateId] varchar(8000) NULL, 
	[SeatQuantity] int NULL, 
	[TransmissionId] varchar(8000) NULL, 
	[VINManufacturer] varchar(8000) NULL, 
	[VINModelAttributes] varchar(8000) NULL, 
	[VINModelYear] varchar(8000) NULL, 
	[VINPlantCode] varchar(8000) NULL, 
	[VINSerialNumber] varchar(8000) NULL, 
	[Weight] float NULL, 
	[CreatedDate] datetime2(6) NULL, 
	[ModifiedDate] datetime2(6) NULL, 
	[RecordId] bigint NULL, 
	[Last_update] datetime2(6) NULL
);