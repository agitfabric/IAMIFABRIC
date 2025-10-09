CREATE PROCEDURE SP_INGEST_REPORTFORMAT as
drop table SILVER_WAREHOUSE.dbo.ReportFormat

select * into ReportFormat from 
(select * from BRONZE_LAKEHOUSE.dbo.ReportFormat) a