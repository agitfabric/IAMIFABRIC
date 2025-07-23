CREATE PROCEDURE SP_INGEST_SITE_MAPPING AS
TRUNCATE TABLE SILVER_WAREHOUSE.dbo.site_mapping
insert into SILVER_WAREHOUSE.dbo.site_mapping
select * from BRONZE_LAKEHOUSE_PSS.dbo.site_mapping

--select * into SILVER_WAREHOUSE.dbo.site_mapping from BRONZE_LAKEHOUSE_PSS.dbo.site_mapping