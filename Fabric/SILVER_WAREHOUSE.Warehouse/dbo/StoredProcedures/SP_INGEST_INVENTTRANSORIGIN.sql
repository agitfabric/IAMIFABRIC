CREATE PROCEDURE SP_INGEST_INVENTTRANSORIGIN as
delete  from InventTrans
Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_InventTransOrigin)

Insert into InventTransOrigin
select * from BRONZE_LAKEHOUSE.dbo.temp_InventTransOrigin