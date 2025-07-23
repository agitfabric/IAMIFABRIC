CREATE PROCEDURE SP_INGEST_SALESJENJANG as
drop table SILVER_WAREHOUSE.dbo.SalesJenjang

select * into SalesJenjang from 
(select * from BRONZE_LAKEHOUSE.dbo.SalesJenjang) a