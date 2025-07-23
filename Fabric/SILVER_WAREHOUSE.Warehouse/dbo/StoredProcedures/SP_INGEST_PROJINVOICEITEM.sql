CREATE PROCEDURE SP_INGEST_PROJINVOICEITEM as
delete from SILVER_WAREHOUSE.dbo.ProjInvoiceItem 
 Where RecordId in
(select RecordId from BRONZE_LAKEHOUSE.dbo.temp_ProjInvoiceItem)

Insert into SILVER_WAREHOUSE.dbo.ProjInvoiceItem
 select * from BRONZE_LAKEHOUSE.dbo.temp_ProjInvoiceItem

 --SELECT * INTO SILVER_WAREHOUSE.dbo.ProjInvoiceItem  from BRONZE_LAKEHOUSE.dbo.ProjInvoiceItem