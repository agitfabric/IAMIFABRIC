CREATE PROCEDURE SP_INGEST_ZGOODRECEIPTFAKPOL AS

DELETE FROM SILVER_WAREHOUSE.dbo.ZGoodReceiptFakpol
WHERE PengajuanFakpolNo  IN (SELECT PengajuanFakpolNo FROM BRONZE_LAKEHOUSE.dbo.temp_ZGoodReceiptFakpol GROUP BY PengajuanFakpolNo )

INSERT INTO SILVER_WAREHOUSE.dbo.ZGoodReceiptFakpol
SELECT * FROM BRONZE_LAKEHOUSE.dbo.temp_ZGoodReceiptFakpol