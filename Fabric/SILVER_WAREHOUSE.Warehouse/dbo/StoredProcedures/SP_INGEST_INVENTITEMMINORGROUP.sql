CREATE PROCEDURE SP_INGEST_INVENTITEMMINORGROUP as
drop table SILVER_WAREHOUSE.dbo.InventItemMinorGroup

select * into InventItemMinorGroup from 
(select * from BRONZE_LAKEHOUSE.dbo.InventItemMinorGroup) a