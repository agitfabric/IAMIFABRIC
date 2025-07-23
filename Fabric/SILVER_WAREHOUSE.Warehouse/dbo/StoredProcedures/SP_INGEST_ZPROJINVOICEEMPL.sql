CREATE PROCEDURE SP_INGEST_ZPROJINVOICEEMPL AS


delete  from SILVER_WAREHOUSE.dbo.ZProjInvoiceEmpl
 Where RecordId in
(select RecordId from BRONZE_LAKEHOUSE.dbo.temp_ZProjInvoiceEmpl)

Insert into SILVER_WAREHOUSE.dbo.ZProjInvoiceEmpl
select * from BRONZE_LAKEHOUSE.dbo.temp_ZProjInvoiceEmpl