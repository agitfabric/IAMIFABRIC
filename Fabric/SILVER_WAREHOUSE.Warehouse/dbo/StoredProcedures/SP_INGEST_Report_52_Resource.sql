Create procedure SP_INGEST_Report_52_Resource as
delete from SILVER_WAREHOUSE.dbo.Report_52_Resource
insert into SILVER_WAREHOUSE.dbo.Report_52_Resource
select * from BRONZE_LAKEHOUSE.dbo.Report_52_Resource

--select * into SILVER_WAREHOUSE.dbo.Report_52_Resource from BRONZE_LAKEHOUSE.dbo.Report_52_Resource