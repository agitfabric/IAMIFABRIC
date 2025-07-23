CREATE PROCEDURE SP_INGEST_INVENTJOURNALTRANS as
delete  from InventJournalTrans
Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_InventJournalTrans)

Insert into InventJournalTrans
select * from BRONZE_LAKEHOUSE.dbo.temp_InventJournalTrans