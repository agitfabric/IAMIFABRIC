CREATE procedure SP_INGEST_DEVICEMODEL AS

DELETE FROM SILVER_WAREHOUSE.dbo.DeviceModel 
WHERE RecordId  IN (SELECT RecordId FROM BRONZE_LAKEHOUSE.dbo.temp_DeviceModel)

INSERT INTO SILVER_WAREHOUSE.dbo.DeviceModel
SELECT * FROM BRONZE_LAKEHOUSE.dbo.temp_DeviceModel Order by ModifiedDateTime1

DELETE FROM SILVER_WAREHOUSE.dbo.DeviceModel where Stopped != 'No' ;

WITH CTE_Duplikat AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ModelId ORDER BY (SELECT NULL)) AS rn
    FROM SILVER_WAREHOUSE.dbo.DeviceModel
)
delete from CTE_Duplikat where rn > 1