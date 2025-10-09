CREATE   PROCEDURE SP_INGEST_INVENTTRANSORIGIN as
delete  from InventTransOrigin
Where RecId1 in (select RecId1 from BRONZE_LAKEHOUSE.dbo.temp_InventTransOrigin)

Insert into InventTransOrigin
select * from BRONZE_LAKEHOUSE.dbo.temp_InventTransOrigin