CREATE PROCEDURE SP_INGEST_SPAREPART_INVOICESO AS
TRUNCATE TABLE SILVER_WAREHOUSE.dbo.sparepart_invoiceSO
insert into SILVER_WAREHOUSE.dbo.sparepart_invoiceSO
select * from BRONZE_LAKEHOUSE_PSS.dbo.sparepart_invoiceSO

--select * into SILVER_WAREHOUSE.dbo.sparepart_invoiceSO from BRONZE_LAKEHOUSE_PSS.dbo.sparepart_invoiceSO