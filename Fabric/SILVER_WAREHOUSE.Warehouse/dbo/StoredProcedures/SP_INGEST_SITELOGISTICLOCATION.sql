CREATE PROCEDURE SP_INGEST_SITELOGISTICLOCATION AS
TRUNCATE TABLE SILVER_WAREHOUSE.dbo.SiteLogisticLocation
INSERT INTO SILVER_WAREHOUSE.dbo.SiteLogisticLocation
SELECT * From BRONZE_LAKEHOUSE.dbo.SiteLogisticsLocation