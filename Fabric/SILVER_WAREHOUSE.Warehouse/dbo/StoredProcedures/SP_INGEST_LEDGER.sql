CREATE PROCEDURE SP_INGEST_LEDGER  as
delete  from Ledger
Where Name in (select Name from BRONZE_LAKEHOUSE.dbo.temp_Ledger)

Insert into Ledger
select * from BRONZE_LAKEHOUSE.dbo.temp_Ledger