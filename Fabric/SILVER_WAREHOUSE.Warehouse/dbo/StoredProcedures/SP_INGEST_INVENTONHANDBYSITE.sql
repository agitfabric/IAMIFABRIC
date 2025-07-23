CREATE PROCEDURE SP_INGEST_INVENTONHANDBYSITE as
drop table SILVER_WAREHOUSE.dbo.InventOnHandBySite

select * into InventOnHandBySite from 
(select * from BRONZE_LAKEHOUSE.dbo.InventOnHandBySite) a