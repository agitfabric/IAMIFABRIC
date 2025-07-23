CREATE PROCEDURE SP_INGEST_END_STOCK_IAMI_SSIS as 
drop table SILVER_WAREHOUSE.dbo.End_Stock_IAMI_SSIS

select * into End_Stock_IAMI_SSIS from (
select * from BRONZE_LAKEHOUSE.dbo.End_Stock_IAMI_SSIS) a