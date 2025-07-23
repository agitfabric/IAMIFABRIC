CREATE PROCEDURE SP_INGEST_ZSALESORDERLINE as

delete  from SILVER_WAREHOUSE.dbo.ZSalesOrderLine
Where RecordId in
(select RecordId from BRONZE_LAKEHOUSE.dbo.temp_ZSalesOrderLine)

Insert into SILVER_WAREHOUSE.dbo.ZSalesOrderLine
select *, 0 As IsReturn from BRONZE_LAKEHOUSE.dbo.temp_ZSalesOrderLine


---Sp nya udah di buat dan udah di modif 24-06-2025
exec SP_CleansingSOUnit