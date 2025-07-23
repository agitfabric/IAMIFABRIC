CREATE PROCEDURE SP_INGEST_SERVICEWORKORDER as
drop table SILVER_WAREHOUSE.dbo.service_workOrder

select * into service_workOrder from 
(select * from BRONZE_LAKEHOUSE_PSS.dbo.service_workOrder) a