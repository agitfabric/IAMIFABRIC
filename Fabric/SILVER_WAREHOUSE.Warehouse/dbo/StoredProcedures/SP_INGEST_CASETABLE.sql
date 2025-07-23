create procedure SP_INGEST_CASETABLE AS
delete  from SILVER_WAREHOUSE.dbo.CaseTable 
 Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_CaseTable)

Insert into SILVER_WAREHOUSE.dbo.CaseTable
 select * from BRONZE_LAKEHOUSE.dbo.temp_CaseTable