CREATE PROCEDURE SP_INGEST_INVENTTRANS  as
delete  from InventTrans
Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_InventTrans)

Insert into InventTrans
select * from BRONZE_LAKEHOUSE.dbo.temp_InventTrans