create procedure SP_INGEST_CASEPROJHOURPRICE as
delete from SILVER_WAREHOUSE.dbo.CaseProjHourPrice 
insert into SILVER_WAREHOUSE.dbo.CaseProjHourPrice
select * from BRONZE_LAKEHOUSE.dbo.CaseProjHourPrice