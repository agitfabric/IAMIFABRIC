CREATE PROCEDURE SP_INGEST_AGITEFAKPOL_APPROVAL as

delete  from SILVER_WAREHOUSE.dbo.AGITEFakpol 
where ApprovalDate in (select ApprovalDate from BRONZE_LAKEHOUSE.dbo.AGITEFakpol)

insert into SILVER_WAREHOUSE.dbo.AGITEFakpol
select * from BRONZE_LAKEHOUSE.dbo.AGITEFakpol
where ApprovalDate is not null