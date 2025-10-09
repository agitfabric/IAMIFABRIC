CREATE PROCEDURE SP_INGEST_SERVICE_INVOICEWO as
drop table SILVER_WAREHOUSE.dbo.service_invoiceWO

select * into service_invoiceWO from 
(select * from BRONZE_LAKEHOUSE_PSS.dbo.service_invoiceWO) a