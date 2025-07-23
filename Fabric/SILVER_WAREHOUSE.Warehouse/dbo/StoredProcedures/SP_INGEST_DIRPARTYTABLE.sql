CREATE procedure SP_INGEST_DIRPARTYTABLE AS
Delete a
 FROM SILVER_WAREHOUSE.dbo.DirPartyTable a
 inner join BRONZE_LAKEHOUSE.dbo.temp_DirPartyTable b on b.RecordId = a.RecordId

 Insert Into SILVER_WAREHOUSE.dbo.DirPartyTable
  Select * From BRONZE_LAKEHOUSE.dbo.temp_DirPartyTable