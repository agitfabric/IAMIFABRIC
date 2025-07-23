create PROCEDURE SP_INGEST_ADDRESSSTATE as
delete from SILVER_WAREHOUSE.dbo.AddressState 
insert into SILVER_WAREHOUSE.dbo.AddressState
select * from BRONZE_LAKEHOUSE.dbo.AddressState