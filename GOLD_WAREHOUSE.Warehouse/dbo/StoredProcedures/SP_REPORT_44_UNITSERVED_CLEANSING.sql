CREATE PROCEDURE [dbo].[SP_REPORT_44_UNITSERVED_CLEANSING]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


-- Buat temp table isi ProjId yang duplikat
SELECT ProjId
INTO #TempProjId
FROM Report_44_UnitServed
GROUP BY ProjId
HAVING COUNT(*) > 1;

-- Variabel loop
DECLARE @LoopProjID CHAR(20), @MaxInvoiceID CHAR(20);

WHILE EXISTS (SELECT TOP 1 1 FROM #TempProjId)
BEGIN
    SELECT TOP 1 @LoopProjID = ProjId FROM #TempProjId ORDER BY ProjId;

    SELECT @MaxInvoiceID = MAX(InvoiceID) 
    FROM Report_44_UnitServed 
    WHERE ProjId = @LoopProjID;

    DELETE FROM Report_44_UnitServed 
    WHERE ProjId = @LoopProjID 
      AND InvoiceID != @MaxInvoiceID;

    DELETE FROM #TempProjId WHERE ProjId = @LoopProjID;
END

-- Cleanup
DROP TABLE #TempProjId

END