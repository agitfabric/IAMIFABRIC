CREATE PROCEDURE SP_INGEST_ZSALESORDERHEADER AS

delete  from SILVER_WAREHOUSE.dbo.ZSalesOrderHeader
 Where RecordId in
(select RecordId from BRONZE_LAKEHOUSE.dbo.Temp_ZSalesOrderHeader)

Insert into SILVER_WAREHOUSE.dbo.ZSalesOrderHeader
select * from BRONZE_LAKEHOUSE.dbo.Temp_ZSalesOrderHeader