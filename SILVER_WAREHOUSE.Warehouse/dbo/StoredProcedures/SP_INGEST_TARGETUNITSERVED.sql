CREATE PROCEDURE SP_INGEST_TARGETUNITSERVED as
drop table SILVER_WAREHOUSE.dbo.TargetUnitServed

select * into TargetUnitServed from 
(select * from BRONZE_LAKEHOUSE.dbo.TargetUnitServed) a