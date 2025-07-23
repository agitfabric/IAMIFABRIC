create procedure SP_INGEST_CUSTINVOICEJOUR AS

 delete  from SILVER_WAREHOUSE.dbo.CustInvoiceJour
 Where InvoiceId in
(select InvoiceId from BRONZE_LAKEHOUSE.dbo.temp_CustInvoiceJour Group by InvoiceId)

Insert into SILVER_WAREHOUSE.dbo.CustInvoiceJour
select * from BRONZE_LAKEHOUSE.dbo.temp_CustInvoiceJour