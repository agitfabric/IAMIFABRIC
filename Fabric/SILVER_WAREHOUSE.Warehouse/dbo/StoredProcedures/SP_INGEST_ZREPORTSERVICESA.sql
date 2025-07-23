create PROCEDURE SP_INGEST_ZREPORTSERVICESA AS

delete  from SILVER_WAREHOUSE.dbo.ZReportServiceSA

Insert into SILVER_WAREHOUSE.dbo.ZReportServiceSA
select * from BRONZE_LAKEHOUSE.dbo.ZReportServiceSA