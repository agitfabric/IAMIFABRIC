CREATE PROCEDURE SP_INGEST_MRPDEMANDNORMALIZED as
delete from  SILVER_WAREHOUSE.dbo.MRPDemandNormalized

insert into MRPDemandNormalized  
select * from BRONZE_LAKEHOUSE.dbo.MRPDemandNormalized