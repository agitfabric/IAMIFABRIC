CREATE PROCEDURE [dbo].[SP_REPORTFORMAT]
AS
BEGIN

Delete ReportFormat
insert into ReportFormat
select * from SILVER_WAREHOUSE.dbo.REPORTFORMAT

END