CREATE PROCEDURE SP_INGEST_LOGISTICSELECTRONICADDRESS as
drop table SILVER_WAREHOUSE.dbo.LogisticsElectronicAddress

select * into LogisticsElectronicAddress from 
(select * from BRONZE_LAKEHOUSE.dbo.LogisticsElectronicAddress) a