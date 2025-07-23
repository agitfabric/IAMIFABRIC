CREATE PROCEDURE SP_INGEST_WORKERBANKACCOUNT as
drop table SILVER_WAREHOUSE.dbo.WorkerBankAccount

select * into WorkerBankAccount from 
(select * from BRONZE_LAKEHOUSE.dbo.WorkerBankAccount) a