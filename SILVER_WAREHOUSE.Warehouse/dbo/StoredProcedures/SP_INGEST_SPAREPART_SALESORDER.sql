CREATE PROCEDURE SP_INGEST_SPAREPART_SALESORDER AS
TRUNCATE TABLE SILVER_WAREHOUSE.dbo.sparepart_salesOrder
insert into SILVER_WAREHOUSE.dbo.sparepart_salesOrder
select * from BRONZE_LAKEHOUSE_PSS.dbo.sparepart_salesOrder

--select * into SILVER_WAREHOUSE.dbo.sparepart_salesOrder from BRONZE_LAKEHOUSE_PSS.dbo.sparepart_salesOrder