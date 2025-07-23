CREATE PROCEDURE SP_INGEST_ZVENDINVOICEINFOTABLE as
drop table SILVER_WAREHOUSE.dbo.ZVendInvoiceInfoTable

select * into ZVendInvoiceInfoTable from 
(select * from BRONZE_LAKEHOUSE.dbo.ZVendInvoiceInfoTable) a