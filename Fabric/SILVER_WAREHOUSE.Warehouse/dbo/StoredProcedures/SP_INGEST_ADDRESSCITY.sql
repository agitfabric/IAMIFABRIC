create procedure SP_INGEST_ADDRESSCITY as
delete from SILVER_WAREHOUSE.dbo.AddressCity 
insert into SILVER_WAREHOUSE.dbo.AddressCity
select * from BRONZE_LAKEHOUSE.dbo.AddressCity