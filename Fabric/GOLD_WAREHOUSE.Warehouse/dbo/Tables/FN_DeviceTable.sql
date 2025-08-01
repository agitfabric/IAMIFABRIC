CREATE TABLE [dbo].[FN_DeviceTable] (

	[Active] varchar(8000) NULL, 
	[AdditionalInfo] varchar(8000) NULL, 
	[AMDeviceTableMaster_AirBagDriver] varchar(8000) NULL, 
	[AMDeviceTableMaster_AirBagPassenger] varchar(8000) NULL, 
	[AMDeviceTableMaster_BodyId] varchar(8000) NULL, 
	[AMDeviceTableMaster_BrandId] varchar(8000) NULL, 
	[AMDeviceTableMaster_ChassisNumber] varchar(8000) NULL, 
	[AMDeviceTableMaster_ClassId] varchar(8000) NULL, 
	[AMDeviceTableMaster_CO2Emissions] int NULL, 
	[AMDeviceTableMaster_DeRegistrationDate] datetime2(6) NULL, 
	[AMDeviceTableMaster_DeRegistrationReasonId] varchar(8000) NULL, 
	[AMDeviceTableMaster_DeviceLocationId] varchar(8000) NULL, 
	[AMDeviceTableMaster_DeviceName] varchar(8000) NULL, 
	[AMDeviceTableMaster_DirectImport] varchar(8000) NULL, 
	[AMDeviceTableMaster_DoorQuantity] int NULL, 
	[AMDeviceTableMaster_DriveTrainId] varchar(8000) NULL, 
	[AMDeviceTableMaster_EngineDisplacement] int NULL, 
	[AMDeviceTableMaster_EngineHP] int NULL, 
	[AMDeviceTableMaster_EngineId] varchar(8000) NULL, 
	[AMDeviceTableMaster_EngineKW] int NULL, 
	[AMDeviceTableMaster_EngineNumber] varchar(8000) NULL, 
	[AMDeviceTableMaster_EngineNumberOfCylinders] int NULL, 
	[AMDeviceTableMaster_EntryCode] varchar(8000) NULL, 
	[AMDeviceTableMaster_EnvironmentClassId] varchar(8000) NULL, 
	[AMDeviceTableMaster_ExteriorId] varchar(8000) NULL, 
	[AMDeviceTableMaster_FaceLift] varchar(8000) NULL, 
	[AMDeviceTableMaster_FuelConsumption] float NULL, 
	[AMDeviceTableMaster_FuelId] varchar(8000) NULL, 
	[AMDeviceTableMaster_GearboxNumber] varchar(8000) NULL, 
	[AMDeviceTableMaster_GroupCodeId] varchar(8000) NULL, 
	[AMDeviceTableMaster_InteriorId] varchar(8000) NULL, 
	[AMDeviceTableMaster_IsVINIndependent] varchar(8000) NULL, 
	[AMDeviceTableMaster_KeyCode] varchar(8000) NULL, 
	[AMDeviceTableMaster_LastInspectionDate] datetime2(6) NULL, 
	[AMDeviceTableMaster_ManufacturingCountryId] varchar(8000) NULL, 
	[AMDeviceTableMaster_MasterNotes] varchar(8000) NULL, 
	[AMDeviceTableMaster_ModelCodeId] varchar(8000) NULL, 
	[AMDeviceTableMaster_ModelConfigurationId] varchar(8000) NULL, 
	[AMDeviceTableMaster_ModelId] varchar(8000) NULL, 
	[AMDeviceTableMaster_ModelNumber] varchar(8000) NULL, 
	[AMDeviceTableMaster_ModelYear] int NULL, 
	[AMDeviceTableMaster_NextInspectionDate] datetime2(6) NULL, 
	[AMDeviceTableMaster_OprModelId] varchar(8000) NULL, 
	[AMDeviceTableMaster_ParentId] varchar(8000) NULL, 
	[AMDeviceTableMaster_PreRegistrationDate] datetime2(6) NULL, 
	[AMDeviceTableMaster_PreRegistrationRequestDate] datetime2(6) NULL, 
	[AMDeviceTableMaster_PrivateNumber] varchar(8000) NULL, 
	[AMDeviceTableMaster_ProductionDate] datetime2(6) NULL, 
	[AMDeviceTableMaster_ProductionMonth] int NULL, 
	[AMDeviceTableMaster_RadioCode] varchar(8000) NULL, 
	[AMDeviceTableMaster_RegistrationDate] datetime2(6) NULL, 
	[AMDeviceTableMaster_RegistrationNumber] varchar(8000) NULL, 
	[AMDeviceTableMaster_RegistrationPlateId] varchar(8000) NULL, 
	[AMDeviceTableMaster_SeatQuantity] int NULL, 
	[AMDeviceTableMaster_TransmissionId] varchar(8000) NULL, 
	[AMDeviceTableMaster_VINSerialNumber] varchar(8000) NULL, 
	[AMDeviceTableMaster_Weight] float NULL, 
	[AssetId] varchar(8000) NULL, 
	[Brokering] varchar(8000) NULL, 
	[ConditionCodeId] varchar(8000) NULL, 
	[ConfirmedDeliveryDate] datetime2(6) NULL, 
	[CreatedDateTime1] datetime2(6) NULL, 
	[dataAreaId] varchar(8000) NULL, 
	[DefaultDimensionDisplayValue] varchar(8000) NULL, 
	[DemoDevice] varchar(8000) NULL, 
	[DemoDeviceExpDate] datetime2(6) NULL, 
	[DeviceCustodian] varchar(8000) NULL, 
	[DeviceGroupId] varchar(8000) NULL, 
	[DeviceId] varchar(8000) NULL, 
	[DeviceMeter] varchar(8000) NULL, 
	[DeviceOrderType] varchar(8000) NULL, 
	[DeviceType] varchar(8000) NULL, 
	[DeviceUsage] varchar(8000) NULL, 
	[DeviceWarrantyTrans] varchar(8000) NULL, 
	[EstimatedArrivalDate] datetime2(6) NULL, 
	[EstimatedDeliveryDate] datetime2(6) NULL, 
	[ExternalDeviceId] varchar(8000) NULL, 
	[FirstEstimatedDeliveryDate] datetime2(6) NULL, 
	[FromDateTime] datetime2(6) NULL, 
	[InsuranceDate] datetime2(6) NULL, 
	[ItemId] varchar(8000) NULL, 
	[LCReference] varchar(8000) NULL, 
	[MajorStatus] varchar(8000) NULL, 
	[MasterId] varchar(8000) NULL, 
	[ModifiedDate] datetime2(6) NULL, 
	[PurchDlvDate] datetime2(6) NULL, 
	[PurchInventRefId] varchar(8000) NULL, 
	[PurchInventRefType] varchar(8000) NULL, 
	[PurchInvoiceDate] datetime2(6) NULL, 
	[PurchInvoiceId] varchar(8000) NULL, 
	[RecordId] bigint NULL, 
	[RequestForInvoice] varchar(8000) NULL, 
	[SalesCustName] varchar(8000) NULL, 
	[SalesInventRefId] varchar(8000) NULL, 
	[SalesInvoiceId] varchar(8000) NULL, 
	[SalesOrderDate] datetime2(6) NULL, 
	[ToDateTime] datetime2(6) NULL, 
	[TransferInventRefId] varchar(8000) NULL, 
	[UnitOrderNumber] varchar(8000) NULL, 
	[UpdateCustodianJour] varchar(8000) NULL, 
	[ValidFrom] datetime2(6) NULL, 
	[VersionId] varchar(8000) NULL, 
	[ZBahanBakar] varchar(8000) NULL, 
	[ZJenis] varchar(8000) NULL, 
	[ZModel] varchar(8000) NULL, 
	[ZSilinder] varchar(8000) NULL, 
	[ZSUT] varchar(8000) NULL, 
	[ZTPT] varchar(8000) NULL, 
	[Last_Update] datetime2(6) NULL
);