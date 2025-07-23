CREATE PROCEDURE SP_INGEST_NAMEAFFIX as
drop table SILVER_WAREHOUSE.dbo.NameAffix

select * into NameAffix from 
(select * from BRONZE_LAKEHOUSE.dbo.NameAffix) a