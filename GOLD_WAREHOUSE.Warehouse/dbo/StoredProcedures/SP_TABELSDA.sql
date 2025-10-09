CREATE PROCEDURE [dbo].[SP_TABELSDA]
AS
BEGIN

Delete TabelSDA
insert into TabelSDA
select * from SILVER_WAREHOUSE.dbo.TabelSDA

END