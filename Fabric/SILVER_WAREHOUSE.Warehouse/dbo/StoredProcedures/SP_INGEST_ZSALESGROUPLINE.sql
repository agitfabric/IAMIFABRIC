create PROCEDURE SP_INGEST_ZSALESGROUPLINE AS

delete  from SILVER_WAREHOUSE.dbo.ZSalesGroupLine

Insert into SILVER_WAREHOUSE.dbo.ZSalesGroupLine
select * from BRONZE_LAKEHOUSE.dbo.ZSalesGroupLine