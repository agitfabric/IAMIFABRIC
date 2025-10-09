CREATE PROCEDURE SP_INGEST_PENJUALANLINE as
delete  from PenjualanLine
Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_PenjualanLine)

Insert into PenjualanLine
select * from BRONZE_LAKEHOUSE.dbo.temp_PenjualanLine