create PROCEDURE SP_INGEST_ZSALESGROUPTABLE AS

delete  from SILVER_WAREHOUSE.dbo.ZSalesGroupTable

Insert into SILVER_WAREHOUSE.dbo.ZSalesGroupTable
select * from BRONZE_LAKEHOUSE.dbo.ZSalesGroupTable