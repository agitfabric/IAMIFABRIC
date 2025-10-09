CREATE PROCEDURE SP_INGEST_POSITIONWORKERASSIGNMENT as
DELETE FROM SILVER_WAREHOUSE.dbo.PositionWorkerAssignment
 WHERE RecordId  IN (SELECT RecordId FROM BRONZE_LAKEHOUSE.dbo.temp_PositionWorkerAssignment )

INSERT INTO PositionWorkerAssignment
SELECT * FROM BRONZE_LAKEHOUSE.dbo.temp_PositionWorkerAssignment Order by ModifiedDateTime1

--SELECT * INTO SILVER_WAREHOUSE.dbo.PositionWorkerAssignment from BRONZE_LAKEHOUSE.dbo.PositionWorkerAssignment