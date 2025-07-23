CREATE PROCEDURE SP_INGEST_PURCHASEORDERLINEV2 as

delete  from SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2
Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_PurchaseOrderLineV2)

Insert into SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2
select * from BRONZE_LAKEHOUSE.dbo.temp_PurchaseOrderLineV2 order by ModifiedDateTime1

--SELECT * INTO SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2   from BRONZE_LAKEHOUSE.dbo.PurchaseOrderLineV2