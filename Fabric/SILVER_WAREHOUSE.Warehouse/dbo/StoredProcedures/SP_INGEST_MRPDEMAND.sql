CREATE PROCEDURE SP_INGEST_MRPDEMAND as 
drop table SILVER_WAREHOUSE.dbo.MRPDemand

select * into MRPDemand from (
select * from BRONZE_LAKEHOUSE.dbo.MRPDemand) a