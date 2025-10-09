Create procedure SP_INGEST_Report_52_Trans as
delete from SILVER_WAREHOUSE.dbo.Report_52_Trans
insert into SILVER_WAREHOUSE.dbo.Report_52_Trans
select * from BRONZE_LAKEHOUSE.dbo.Report_52_Trans

--select * into SILVER_WAREHOUSE.dbo.Report_52_Trans from BRONZE_LAKEHOUSE.dbo.Report_52_Trans