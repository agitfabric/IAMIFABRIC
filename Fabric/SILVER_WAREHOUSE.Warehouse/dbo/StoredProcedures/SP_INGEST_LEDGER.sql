CREATE   PROCEDURE SP_INGEST_LEDGER  as
delete  from Ledger
Where LOWER(Name) in (select LOWER(Name) from BRONZE_LAKEHOUSE.dbo.temp_Ledger)

Insert into Ledger
select * from BRONZE_LAKEHOUSE.dbo.temp_Ledger

UPDATE Ledger
SET 
    Name = LOWER(Name),
    ChartOfAccounts = LOWER(ChartOfAccounts);