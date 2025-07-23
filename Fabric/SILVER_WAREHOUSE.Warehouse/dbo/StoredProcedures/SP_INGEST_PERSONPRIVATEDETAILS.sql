CREATE PROCEDURE SP_INGEST_PERSONPRIVATEDETAILS as
delete  from PersonPrivateDetails
Where RecordId in (select RecordId from BRONZE_LAKEHOUSE.dbo.temp_PersonPrivateDetails)

Insert into PersonPrivateDetails
select * from BRONZE_LAKEHOUSE.dbo.temp_PersonPrivateDetails