CREATE     PROCEDURE [dbo].[SP_REPORT_35_MRPDEMAND]

AS
BEGIN
	SELECT DISTINCT dataAreaId INTO #TempDataAreaIDReport35
FROM bronze_lakehouse.dbo.temp_MRPDemand;

DECLARE @DataAreaID CHAR(3);
DECLARE @Year INT, @Month INT;

WHILE EXISTS (SELECT TOP 1 1 FROM #TempDataAreaIDReport35)
BEGIN
    -- Ambil satu DataAreaId untuk diproses
    SELECT TOP 1 @DataAreaID = dataAreaId FROM #TempDataAreaIDReport35 ORDER BY DataAreaId;

    -- Ambil tahun dan bulan paling kecil untuk dataAreaId tersebut
    SELECT @Year = MIN(ZDemandYear) 
    FROM bronze_lakehouse.dbo.temp_MRPDemand 
    WHERE dataAreaId = @DataAreaID;

    SELECT @Month = MIN(MonthsInNumb) 
    FROM bronze_lakehouse.dbo.temp_MRPDemand 
    WHERE dataAreaId = @DataAreaID AND ZDemandYear = @Year;

    -- Hapus data lama di target table
    DELETE FROM silver_warehouse.dbo.MRPDemand 
    WHERE dataAreaId = @DataAreaID AND ZDemandYear = @Year AND MonthsInNumb >= @Month;

    -- Insert data baru dari temp table
    INSERT INTO silver_warehouse.dbo.MRPDemand
    SELECT * FROM bronze_lakehouse.dbo.temp_MRPDemand 
    WHERE dataAreaId = @DataAreaID;

    -- Hapus data yang sudah dipindahkan dari temp table
    --DELETE FROM bronze_lakehouse.dbo.temp_MRPDemand 
    --WHERE dataAreaId = @DataAreaID;

    -- Hapus yang sudah diproses dari temp list
    DELETE FROM #TempDataAreaIDReport35
    WHERE DataAreaId = @DataAreaID;
END

-- Cleanup
DROP TABLE #TempDataAreaIDReport35;
END