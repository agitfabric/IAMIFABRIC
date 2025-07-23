CREATE PROCEDURE SP_INGEST_WORKER AS
Delete a 
FROM SILVER_WAREHOUSE.dbo.Worker a 
Inner join BRONZE_LAKEHOUSE.dbo.temp_Worker b on b.PersonnelNumber = a.PersonnelNumber

 Insert Into SILVER_WAREHOUSE.dbo.Worker
 Select * FROM BRONZE_LAKEHOUSE.dbo.temp_Worker