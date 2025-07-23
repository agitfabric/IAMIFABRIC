CREATE PROCEDURE [dbo].[SP_SALESJENJANG]
AS
BEGIN

Delete SalesJenjang
insert into SalesJenjang
select * from SILVER_WAREHOUSE.dbo.SALESJENJANG

END