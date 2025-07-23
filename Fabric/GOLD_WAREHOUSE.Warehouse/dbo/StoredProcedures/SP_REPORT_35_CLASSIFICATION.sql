CREATE PROCEDURE [dbo].[SP_REPORT_35_CLASSIFICATION]
AS
BEGIN

Delete Report_35_Classification
insert into Report_35_Classification
select * from SILVER_WAREHOUSE.dbo.Report_35_Classification

END