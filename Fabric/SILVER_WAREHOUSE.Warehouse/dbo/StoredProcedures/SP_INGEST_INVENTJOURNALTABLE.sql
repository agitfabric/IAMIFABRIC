CREATE PROCEDURE SP_INGEST_INVENTJOURNALTABLE as
delete  from InventJournalTable
Where RecordID in (select RecordID from BRONZE_LAKEHOUSE.dbo.Temp_InventJournalTable)

Insert into InventJournalTable
select * from BRONZE_LAKEHOUSE.dbo.Temp_InventJournalTable