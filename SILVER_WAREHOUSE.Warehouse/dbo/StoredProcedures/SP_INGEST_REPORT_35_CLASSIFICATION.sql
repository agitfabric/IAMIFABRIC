CREATE PROCEDURE SP_INGEST_REPORT_35_CLASSIFICATION as
drop table SILVER_WAREHOUSE.dbo.Report_35_Classification

select * into Report_35_Classification from 
(select * from BRONZE_LAKEHOUSE.dbo.Report_35_Classification) a