CREATE PROCEDURE SP_INGEST_PENJUALANHEADERBASE as
delete  from PenjualanHeaderBase
Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_PenjualanHeaderBase)

Insert into PenjualanHeaderBase
select * from BRONZE_LAKEHOUSE.dbo.temp_PenjualanHeaderBase