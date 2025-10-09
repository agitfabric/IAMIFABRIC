CREATE PROCEDURE SP_INGEST_PURCHASEORDERHEADERV2 as

delete  from SILVER_WAREHOUSE.dbo.PurchaseOrderHeaderV2
Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_PurchaseOrderHeaderV2)

Insert into SILVER_WAREHOUSE.dbo.PurchaseOrderHeaderV2
select * from BRONZE_LAKEHOUSE.dbo.temp_PurchaseOrderHeaderV2 order by CreatedDateTime1

--SELECT * INTO SILVER_WAREHOUSE.dbo.PurchaseOrderHeaderV2  from BRONZE_LAKEHOUSE.dbo.PurchaseOrderHeaderV2