CREATE PROCEDURE SP_INGEST_SALESQUOTATIONLINE as

delete  from SILVER_WAREHOUSE.dbo.SalesQuotationLine
 Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_SalesQuotationLine)

Insert into SILVER_WAREHOUSE.dbo.SalesQuotationLine
select * from BRONZE_LAKEHOUSE.dbo.temp_SalesQuotationLine

--SELECT * INTO SILVER_WAREHOUSE.dbo.SalesQuotationLine  from BRONZE_LAKEHOUSE.dbo.SalesQuotationLine