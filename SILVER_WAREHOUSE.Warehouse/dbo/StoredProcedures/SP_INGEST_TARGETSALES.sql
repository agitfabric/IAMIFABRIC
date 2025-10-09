CREATE PROCEDURE SP_INGEST_TARGETSALES AS

declare @startdate int
select @startdate = YEAR(GETDATE())
select @startdate

delete from SILVER_WAREHOUSE.dbo.TargetSales where YearPeriod = @startdate
insert into SILVER_WAREHOUSE.dbo.TargetSales
select * from BRONZE_LAKEHOUSE_154_NONSAP.dbo.TargetSales