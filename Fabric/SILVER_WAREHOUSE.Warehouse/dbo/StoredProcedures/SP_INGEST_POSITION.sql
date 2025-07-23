CREATE PROCEDURE SP_INGEST_POSITION as
drop table SILVER_WAREHOUSE.dbo.Position

select * into Position from 
(select * from BRONZE_LAKEHOUSE.dbo.Position) a