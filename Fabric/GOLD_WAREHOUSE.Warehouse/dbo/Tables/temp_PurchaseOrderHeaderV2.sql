CREATE TABLE [dbo].[temp_PurchaseOrderHeaderV2] (

	[AccountingDate] datetime2(6) NULL, 
	[AccountingDistributionTemplateName] varchar(8000) NULL, 
	[AgitExpiredDate] datetime2(6) NULL, 
	[ArePricesIncludingSalesTax] varchar(8000) NULL, 
	[AttentionInformation] varchar(8000) NULL, 
	[BankDocumentType] varchar(8000) NULL, 
	[BuyerGroupId] varchar(8000) NULL, 
	[CashDiscountCode] varchar(8000) NULL, 
	[CashDiscountPercentage] float NULL, 
	[ChargeVendorGroupId] varchar(8000) NULL, 
	[ConfirmedDeliveryDate] datetime2(6) NULL, 
	[ConfirmingPurchaseOrderCode] varchar(8000) NULL, 
	[ConfirmingPurchaseOrderCodeLanguageId] varchar(8000) NULL, 
	[ContactPersonId] varchar(8000) NULL, 
	[CreatedBy1] varchar(8000) NULL, 
	[CreatedDateTime1] datetime2(6) NULL, 
	[CurrencyCode] varchar(8000) NULL, 
	[dataAreaId] varchar(8000) NULL, 
	[DefaultLedgerDimensionDisplayValue] varchar(8000) NULL, 
	[DefaultReceivingSiteId] varchar(8000) NULL, 
	[DefaultReceivingWarehouseId] varchar(8000) NULL, 
	[DeliveryAddressCity] varchar(8000) NULL, 
	[DeliveryAddressCountryRegionId] varchar(8000) NULL, 
	[DeliveryAddressCountryRegionISOCode] varchar(8000) NULL, 
	[DeliveryAddressCountyId] varchar(8000) NULL, 
	[DeliveryAddressDescription] varchar(8000) NULL, 
	[DeliveryAddressDistrictName] varchar(8000) NULL, 
	[DeliveryAddressDunsNumber] varchar(8000) NULL, 
	[DeliveryAddressLatitude] float NULL, 
	[DeliveryAddressLocationId] varchar(8000) NULL, 
	[DeliveryAddressLongitude] float NULL, 
	[DeliveryAddressName] varchar(8000) NULL, 
	[DeliveryAddressPostBox] varchar(8000) NULL, 
	[DeliveryAddressStateId] varchar(8000) NULL, 
	[DeliveryAddressStreet] varchar(8000) NULL, 
	[DeliveryAddressStreetNumber] varchar(8000) NULL, 
	[DeliveryAddressTimeZone] varchar(8000) NULL, 
	[DeliveryAddressZipCode] varchar(8000) NULL, 
	[DeliveryBuildingCompliment] varchar(8000) NULL, 
	[DeliveryCityInKana] varchar(8000) NULL, 
	[DeliveryModeId] varchar(8000) NULL, 
	[DeliveryStreetInKana] varchar(8000) NULL, 
	[DeliveryTermsId] varchar(8000) NULL, 
	[DeviceId] varchar(8000) NULL, 
	[DocumentApprovalStatus] varchar(8000) NULL, 
	[Email] varchar(8000) NULL, 
	[EmploymentContractors] varchar(8000) NULL, 
	[EUSalesListCode] varchar(8000) NULL, 
	[ExpectedCrossDockingDate] datetime2(6) NULL, 
	[ExpectedStoreAvailableSalesDate] datetime2(6) NULL, 
	[ExpectedStoreReceiptDate] datetime2(6) NULL, 
	[FixedDueDate] datetime2(6) NULL, 
	[FormattedDeliveryAddress] varchar(8000) NULL, 
	[FormattedInvoiceAddress] varchar(8000) NULL, 
	[GSTSelfBilledInvoiceApprovalNumber] varchar(8000) NULL, 
	[ImportDeclarationNumber] varchar(8000) NULL, 
	[IntrastatPortId] varchar(8000) NULL, 
	[IntrastatStatisticsProcedureCode] varchar(8000) NULL, 
	[IntrastatTransactionCode] varchar(8000) NULL, 
	[IntrastatTransportModeCode] varchar(8000) NULL, 
	[InventSiteId] varchar(8000) NULL, 
	[InvoiceAddressCity] varchar(8000) NULL, 
	[InvoiceAddressCountryRegionId] varchar(8000) NULL, 
	[InvoiceAddressCounty] varchar(8000) NULL, 
	[InvoiceAddressState] varchar(8000) NULL, 
	[InvoiceAddressStreet] varchar(8000) NULL, 
	[InvoiceAddressStreetNumber] varchar(8000) NULL, 
	[InvoiceAddressZipCode] varchar(8000) NULL, 
	[InvoiceType] varchar(8000) NULL, 
	[InvoiceVendorAccountNumber] varchar(8000) NULL, 
	[IsChangeManagementActive] varchar(8000) NULL, 
	[IsConsolidatedInvoiceTarget] varchar(8000) NULL, 
	[IsDeliveredDirectly] varchar(8000) NULL, 
	[IsDeliveryAddressOrderSpecific] varchar(8000) NULL, 
	[IsDeliveryAddressPrivate] varchar(8000) NULL, 
	[IsOneTimeVendor] varchar(8000) NULL, 
	[LanguageId] varchar(8000) NULL, 
	[LineDiscountVendorGroupCode] varchar(8000) NULL, 
	[MultilineDiscountVendorGroupCode] varchar(8000) NULL, 
	[NumberSequenceGroupId] varchar(8000) NULL, 
	[OrderAccount] varchar(8000) NULL, 
	[OrdererPersonnelNumber] varchar(8000) NULL, 
	[OrderVendorAccountNumber] varchar(8000) NULL, 
	[PaymentScheduleName] varchar(8000) NULL, 
	[PaymentTermsName] varchar(8000) NULL, 
	[PlannedOrders] varchar(8000) NULL, 
	[PriceVendorGroupCode] varchar(8000) NULL, 
	[ProjectId] varchar(8000) NULL, 
	[PurchaseOrderHeaderCharges] varchar(8000) NULL, 
	[PurchaseOrderHeaderCreationMethod] varchar(8000) NULL, 
	[PurchaseOrderLines] varchar(8000) NULL, 
	[PurchaseOrderLinesV2] varchar(8000) NULL, 
	[PurchaseOrderName] varchar(8000) NULL, 
	[PurchaseOrderNumber] varchar(8000) NULL, 
	[PurchaseOrderPoolId] varchar(8000) NULL, 
	[PurchaseOrderStatus] varchar(8000) NULL, 
	[PurchaseRebateVendorGroupId] varchar(8000) NULL, 
	[PurchaseType] varchar(8000) NULL, 
	[PurchId] varchar(8000) NULL, 
	[PurchName] varchar(8000) NULL, 
	[PurchStatus] varchar(8000) NULL, 
	[ReasonCode] varchar(8000) NULL, 
	[ReasonComment] varchar(8000) NULL, 
	[ReplenishmentServiceCategoryId] varchar(8000) NULL, 
	[ReplenishmentWarehouseId] varchar(8000) NULL, 
	[RequestedDeliveryDate] datetime2(6) NULL, 
	[RequesterPersonnelNumber] varchar(8000) NULL, 
	[SalesTaxGroupCode] varchar(8000) NULL, 
	[ShippingCarrierId] varchar(8000) NULL, 
	[ShippingCarrierServiceGroupId] varchar(8000) NULL, 
	[ShippingCarrierServiceId] varchar(8000) NULL, 
	[TaxExemptNumber] varchar(8000) NULL, 
	[TotalDiscountPercentage] float NULL, 
	[TotalDiscountVendorGroupCode] varchar(8000) NULL, 
	[TransportationDocumentLineId] varchar(8000) NULL, 
	[TransportationModeId] varchar(8000) NULL, 
	[TransportationRoutePlanId] varchar(8000) NULL, 
	[TransportationTemplateId] varchar(8000) NULL, 
	[URL] varchar(8000) NULL, 
	[VendorInvoiceDeclarationId] varchar(8000) NULL, 
	[VendorOrderReference] varchar(8000) NULL, 
	[VendorPaymentMethodName] varchar(8000) NULL, 
	[VendorPaymentMethodSpecificationName] varchar(8000) NULL, 
	[VendorPostingProfileId] varchar(8000) NULL, 
	[VendorTransactionSettlementType] varchar(8000) NULL, 
	[ZakatContractNumber] varchar(8000) NULL, 
	[ZBillingSAP] varchar(8000) NULL, 
	[Zgenerate] varchar(8000) NULL, 
	[ZPOUpdated] varchar(8000) NULL, 
	[ZPurchaseType] varchar(8000) NULL, 
	[RecordId] bigint NULL, 
	[Last_update] datetime2(6) NULL
);