CREATE procedure SP_INGEST_DEVICETABLE AS
Delete a
From SILVER_WAREHOUSE.dbo.DeviceTable a
        inner join BRONZE_LAKEHOUSE.dbo.Temp_DeviceTable b on b.dataAreaId = a.dataAreaId and b.DeviceId = a.DeviceId

INSERT INTO DeviceTable
           (Active,AdditionalInfo,Brokering,ConditionCodeId,ConfirmedDeliveryDate
           ,CreatedDateTime1,dataAreaId,DefaultDimensionDisplayValue,DemoDevice
           ,DemoDeviceExpDate,DeviceGroupId,DeviceId,DeviceOrderType
           ,DeviceType,EstimatedArrivalDate,EstimatedDeliveryDate
           ,FirstEstimatedDeliveryDate,FromDateTime,InsuranceDate
           ,InventDim_InventColorId,InventDim_InventSizeId,ItemId
           ,LCReference,MajorStatus,MasterId,PurchDlvDate,PurchInventRefId
           ,PurchInventRefType,PurchInvoiceDate,PurchInvoiceId,RequestForInvoice
           ,SalesCustName,SalesInventRefId,SalesInvoiceId,SalesOrderDate
           ,ToDateTime,TransferInventRefId,UnitOrderNumber,UpdateCustodianJour
           ,ValidFrom,VersionId,ZBahanBakar,ZJenis,ZModel,ZSilinder
           ,ZSUT,ZTPT,AssetId,ModifiedDate,RecordId,Last_update)
Select Active,AdditionalInfo,Brokering,ConditionCodeId,ConfirmedDeliveryDate
           ,CreatedDateTime1,dataAreaId,DefaultDimensionDisplayValue,DemoDevice
           ,DemoDeviceExpDate,DeviceGroupId,DeviceId,DeviceOrderType
           ,DeviceType,EstimatedArrivalDate,EstimatedDeliveryDate
           ,FirstEstimatedDeliveryDate,FromDateTime,InsuranceDate
           ,'','',ItemId
           ,LCReference,MajorStatus,MasterId,PurchDlvDate,PurchInventRefId
           ,PurchInventRefType,PurchInvoiceDate,PurchInvoiceId,RequestForInvoice
           ,SalesCustName,SalesInventRefId,SalesInvoiceId,SalesOrderDate
           ,ToDateTime,TransferInventRefId,UnitOrderNumber,UpdateCustodianJour
           ,ValidFrom,VersionId,ZBahanBakar,ZJenis,ZModel,ZSilinder
           ,ZSUT,ZTPT,AssetId,ModifiedDate,RecordId,Last_Update
From BRONZE_LAKEHOUSE.dbo.Temp_DeviceTable