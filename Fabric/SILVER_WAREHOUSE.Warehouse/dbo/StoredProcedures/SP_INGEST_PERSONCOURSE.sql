CREATE PROCEDURE SP_INGEST_PERSONCOURSE as
drop table SILVER_WAREHOUSE.dbo.PersonCourse

select * into PersonCourse from 
(select * from BRONZE_LAKEHOUSE.dbo.PersonCourse) a