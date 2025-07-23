CREATE PROCEDURE SP_INGEST_MRPDEMANDNORMALIZED as
drop table SILVER_WAREHOUSE.dbo.MRPDemandNormalized

select * into MRPDemandNormalized from 
(select * from BRONZE_LAKEHOUSE.dbo.MRPDemandNormalized) a