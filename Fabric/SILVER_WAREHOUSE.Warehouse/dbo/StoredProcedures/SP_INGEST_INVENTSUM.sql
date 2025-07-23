CREATE PROCEDURE SP_INGEST_INVENTSUM as
delete  from InventSum
Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_InventSum)

Insert into InventSum
select * from BRONZE_LAKEHOUSE.dbo.temp_InventSum