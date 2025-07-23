Create procedure SP_INGEST_Report_53_BM as
delete from SILVER_WAREHOUSE.dbo.Report_53_BM 
insert into SILVER_WAREHOUSE.dbo.Report_53_BM
select * from BRONZE_LAKEHOUSE.dbo.Report_53_BM

--select * into SILVER_WAREHOUSE.dbo.Report_53_BM from BRONZE_LAKEHOUSE.dbo.Report_53_BM