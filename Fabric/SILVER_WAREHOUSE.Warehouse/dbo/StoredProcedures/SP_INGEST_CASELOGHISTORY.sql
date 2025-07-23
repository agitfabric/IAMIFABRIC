CREATE PROCEDURE SP_INGEST_CASELOGHISTORY as
drop table SILVER_WAREHOUSE.dbo.CaseLogHistory

select * into CaseLogHistory from 
(select * from BRONZE_LAKEHOUSE.dbo.CaseLogHistory) a