CREATE PROCEDURE SP_INGEST_OPPORTUNITYTABLE as
delete  from OpportunityTable
Where OpportunityId in (select OpportunityId from BRONZE_LAKEHOUSE.dbo.temp_OpportunityTable)

Insert into OpportunityTable
select * from BRONZE_LAKEHOUSE.dbo.temp_OpportunityTable