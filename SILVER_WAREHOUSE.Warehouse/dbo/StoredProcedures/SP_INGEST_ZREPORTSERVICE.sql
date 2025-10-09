create PROCEDURE SP_INGEST_ZREPORTSERVICE AS

delete  from SILVER_WAREHOUSE.dbo.ZReportService

Insert into SILVER_WAREHOUSE.dbo.ZReportService
select * from BRONZE_LAKEHOUSE.dbo.ZReportService