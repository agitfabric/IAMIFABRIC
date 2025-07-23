create procedure SP_INGEST_DEVICEGROUP as
delete from SILVER_WAREHOUSE.dbo.DeviceGroup 
insert into SILVER_WAREHOUSE.dbo.DeviceGroup
select * from BRONZE_LAKEHOUSE.dbo.DeviceGroup