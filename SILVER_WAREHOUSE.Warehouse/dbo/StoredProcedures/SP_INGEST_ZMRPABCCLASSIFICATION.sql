create PROCEDURE SP_INGEST_ZMRPABCCLASSIFICATION AS


delete  from SILVER_WAREHOUSE.dbo.ZMRPABCClassification

Insert into SILVER_WAREHOUSE.dbo.ZMRPABCClassification
select * from BRONZE_LAKEHOUSE.dbo.ZMRPABCClassification