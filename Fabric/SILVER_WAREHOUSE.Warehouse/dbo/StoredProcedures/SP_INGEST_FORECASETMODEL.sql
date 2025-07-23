CREATE PROCEDURE SP_INGEST_FORECASETMODEL as
drop table SILVER_WAREHOUSE.dbo.ForecastModel

select * into ForecastModel from 
(select * from BRONZE_LAKEHOUSE.dbo.ForecastModel) a