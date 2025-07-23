CREATE PROCEDURE SP_INGEST_ZDATABILLINGVIEW AS

DELETE from SILVER_WAREHOUSE.dbo.ZDataBillingViews where left(convert(varchar,BillingDate,23),10) = 
(select left(convert(varchar,max(BillingDate),23),10) from SILVER_WAREHOUSE.dbo.ZDataBillingViews)

insert into SILVER_WAREHOUSE.dbo.ZDataBillingViews
select * from BRONZE_LAKEHOUSE.dbo.ZDataBillingViews where left(convert(varchar,BillingDate,23),10) >= 
(select left(convert(varchar,max(BillingDate),23),10) from SILVER_WAREHOUSE.dbo.ZDataBillingViews)