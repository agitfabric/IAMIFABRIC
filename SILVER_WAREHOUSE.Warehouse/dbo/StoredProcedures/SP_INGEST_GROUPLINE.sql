CREATE PROCEDURE SP_INGEST_GROUPLINE as
drop table SILVER_WAREHOUSE.dbo.GroupLine

select * into GroupLine from 
(select * from BRONZE_LAKEHOUSE.dbo.GroupLine) a