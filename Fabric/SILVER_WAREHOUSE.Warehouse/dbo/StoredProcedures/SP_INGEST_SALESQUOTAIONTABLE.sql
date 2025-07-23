CREATE PROCEDURE SP_INGEST_SALESQUOTAIONTABLE AS
delete from SILVER_WAREHOUSE.dbo.SalesQuotationTable
Where SalesQuotationNumber in
(select SalesQuotationNumber from BRONZE_LAKEHOUSE.dbo.temp_SalesQuotationTable Group by SalesQuotationNumber)
 
 Insert into SILVER_WAREHOUSE.dbo.SalesQuotationTable
 select * from BRONZE_LAKEHOUSE.dbo.temp_SalesQuotationTable