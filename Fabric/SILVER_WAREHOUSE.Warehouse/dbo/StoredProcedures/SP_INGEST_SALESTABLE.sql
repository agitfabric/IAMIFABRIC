CREATE PROCEDURE SP_INGEST_SALESTABLE as
drop table SILVER_WAREHOUSE.dbo.SalesTable

select * into SalesTable from 
(select * from BRONZE_LAKEHOUSE.dbo.SalesTable) a