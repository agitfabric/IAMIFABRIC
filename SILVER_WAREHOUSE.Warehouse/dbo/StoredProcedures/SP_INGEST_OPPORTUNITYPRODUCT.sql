CREATE PROCEDURE SP_INGEST_OPPORTUNITYPRODUCT  as
delete  from OpportunityProduct
Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_OpportunityProduct)

Insert into OpportunityProduct
select * from BRONZE_LAKEHOUSE.dbo.temp_OpportunityProduct