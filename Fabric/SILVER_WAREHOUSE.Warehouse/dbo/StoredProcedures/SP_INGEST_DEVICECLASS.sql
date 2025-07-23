create procedure SP_INGEST_DEVICECLASS AS



DELETE FROM SILVER_WAREHOUSE.dbo.DeviceClass 
WHERE RecordId  IN (SELECT RecordId FROM BRONZE_LAKEHOUSE.dbo.temp_DeviceClass)

INSERT INTO SILVER_WAREHOUSE.dbo.DeviceClass
SELECT * FROM BRONZE_LAKEHOUSE.dbo.temp_DeviceClass Order by ModifiedDateTime1