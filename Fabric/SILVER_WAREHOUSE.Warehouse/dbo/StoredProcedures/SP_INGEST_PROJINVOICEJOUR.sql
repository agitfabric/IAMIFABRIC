CREATE PROCEDURE SP_INGEST_PROJINVOICEJOUR as

 delete  from SILVER_WAREHOUSE.dbo.ProjInvoiceJour
 Where RecordId in
(select RecordId from BRONZE_LAKEHOUSE.dbo.temp_ProjInvoiceJour)

Insert into SILVER_WAREHOUSE.dbo.ProjInvoiceJour
select * from BRONZE_LAKEHOUSE.dbo.temp_ProjInvoiceJour

--SELECT * INTO SILVER_WAREHOUSE.dbo.ProjInvoiceJour  from BRONZE_LAKEHOUSE.dbo.ProjInvoiceJour