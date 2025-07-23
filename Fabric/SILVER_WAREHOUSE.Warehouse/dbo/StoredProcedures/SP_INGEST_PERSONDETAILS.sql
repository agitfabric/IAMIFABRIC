CREATE PROCEDURE SP_INGEST_PERSONDETAILS as
drop table SILVER_WAREHOUSE.dbo.PersonDetails

select * into PersonDetails from 
(select * from BRONZE_LAKEHOUSE.dbo.PersonDetails) a