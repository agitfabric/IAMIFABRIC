CREATE PROCEDURE SP_INGEST_ZVENDINVOICETRANS as

delete  from SILVER_WAREHOUSE.dbo.ZVendInvoiceTrans
 Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_ZVendInvoiceTrans)

Insert into SILVER_WAREHOUSE.dbo.ZVendInvoiceTrans 
select * from BRONZE_LAKEHOUSE.dbo.temp_ZVendInvoiceTrans Order by ModifiedDateTime1