create PROCEDURE SP_INGEST_ZCASETIMESHEETTRANS AS


delete from SILVER_WAREHOUSE.dbo.ZCaseTimeSheetTrans where RecordId in 
(select RecordId from BRONZE_LAKEHOUSE.dbo.temp_ZCaseTimeSheetTrans)

Insert Into SILVER_WAREHOUSE.dbo.ZCaseTimeSheetTrans 
select * from BRONZE_LAKEHOUSE.dbo.temp_ZCaseTimeSheetTrans