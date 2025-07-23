CREATE PROCEDURE [dbo].[SP_CASELOGHISTORY]
AS
BEGIN

Delete CaseLogHistory
insert into CaseLogHistory
select * from SILVER_WAREHOUSE.dbo.CaseLogHistory

END