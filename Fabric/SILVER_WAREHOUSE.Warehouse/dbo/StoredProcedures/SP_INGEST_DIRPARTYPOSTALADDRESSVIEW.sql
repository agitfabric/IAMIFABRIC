CREATE procedure SP_INGEST_DIRPARTYPOSTALADDRESSVIEW AS
DELETE FROM SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView
WHERE RecordId  in (SELECT RecordId FROM BRONZE_LAKEHOUSE.dbo.temp_DirPartyPostalAddressView)


INSERT INTO SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView
SELECT * FROM BRONZE_LAKEHOUSE.dbo.temp_DirPartyPostalAddressView Order by ModifiedDate