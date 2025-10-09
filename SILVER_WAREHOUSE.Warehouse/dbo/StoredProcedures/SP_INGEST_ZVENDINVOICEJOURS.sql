CREATE PROCEDURE SP_INGEST_ZVENDINVOICEJOURS AS


delete  from SILVER_WAREHOUSE.dbo.ZVendInvoiceJours 
Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_ZVendInvoiceJours)

Insert Into SILVER_WAREHOUSE.dbo.ZVendInvoiceJours
select * from BRONZE_LAKEHOUSE.dbo.temp_ZVendInvoiceJours order by ModifiedDateTime1