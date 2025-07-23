CREATE procedure SP_INGEST_DEVICETABLEMASTER AS
DELETE FROM SILVER_WAREHOUSE.dbo.DeviceTableMasters
 WHERE RecordId  IN (SELECT RecordId FROM BRONZE_LAKEHOUSE.dbo.temp_DeviceTableMasters)

INSERT INTO SILVER_WAREHOUSE.dbo.DeviceTableMasters
SELECT * FROM BRONZE_LAKEHOUSE.dbo.temp_DeviceTableMasters Order by ModifiedDate