CREATE     PROCEDURE [dbo].[SP_REPORT_35_MRPDEMANDNORMALIZED]
AS
BEGIN
SELECT DISTINCT DataAreaIdHeader INTO #TempDataAreaID1
FROM bronze_lakehouse.dbo.temp_MRPDemandNormalized;

DECLARE @DataAreaID CHAR(3);
DECLARE @Year INT, @Month INT;

WHILE EXISTS (SELECT TOP 1 1 FROM #TempDataAreaID1)
BEGIN
    -- Ambil satu DataAreaIdHeader
    SELECT TOP 1 @DataAreaID = DataAreaIdHeader FROM #TempDataAreaID1 ORDER BY DataAreaIdHeader;

    -- Ambil tahun dan bulan terkecil untuk area tsb
    SELECT @Year = MIN(ZDemandYear)
    FROM bronze_lakehouse.dbo.temp_MRPDemandNormalized
    WHERE DataAreaIdHeader = @DataAreaID;

    SELECT @Month = MIN(MonthsInNumb)
    FROM bronze_lakehouse.dbo.temp_MRPDemandNormalized
    WHERE DataAreaIdHeader = @DataAreaID AND ZDemandYear = @Year;

    -- Hapus data lama pada table utama
    DELETE FROM silver_warehouse.dbo.MRPDemandNormalized
    WHERE DataAreaIdHeader = @DataAreaID
      AND ZDemandYear = @Year
      AND MonthsInNumb >= @Month;

    -- Insert data baru
    INSERT INTO silver_warehouse.dbo.MRPDemandNormalized
    SELECT * FROM bronze_lakehouse.dbo.temp_MRPDemandNormalized
    WHERE DataAreaIdHeader = @DataAreaID;

    -- Bersihkan data sementara
    --DELETE FROM bronze_lakehouse.dbo.temp_MRPDemandNormalized
    --WHERE DataAreaIdHeader = @DataAreaID;

    -- Hapus dataAreaId dari daftar
    DELETE FROM #TempDataAreaID1
    WHERE DataAreaIdHeader = @DataAreaID;
END

-- Cleanup
DROP TABLE #TempDataAreaID1;
END