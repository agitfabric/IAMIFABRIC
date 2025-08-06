CREATE PROCEDURE [dbo].[SP_SPVSALESMAN_DAILY]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @Salesman CHAR(25), 
        @RunningDate CHAR(6), 
        @lastSales DATE, 
        @Outlet CHAR(5), 
        @FirstDateOutlet DATE, 
        @JoinDate DATE;

-- Set running period
SET @RunningDate = '202206';  -- << bisa diganti ke dynamic jika perlu >>

-- Siapkan list Salesman ke temp table
SELECT USERIDSALESMAN INTO #TempSalesman
FROM Report_52_SPVSalesman
WHERE RunningDate = @RunningDate;

-- Looping per Salesman
WHILE EXISTS (SELECT TOP 1 1 FROM #TempSalesman)
BEGIN
    SELECT TOP 1 @Salesman = USERIDSALESMAN FROM #TempSalesman;

    -- Ambil last invoice untuk salesman
    SELECT @lastSales = CAST(MAX(a.InvoiceDate) AS DATE)
    FROM dbo.ZCustInvoiceTrans a
    LEFT JOIN dbo.InventItemGroupItem b ON b.ItemId = a.ItemId AND b.ItemDataAreaId = a.dataAreaId 
    LEFT JOIN dbo.SalesTable c ON c.SalesId = a.SalesId  
    WHERE a.dataAreaId <> 'KZU'
      AND b.ItemGroupId = 'FU01'
      AND c.ZSalesman = @Salesman
      AND LEFT(CONVERT(CHAR(8), a.InvoiceDate, 112), 6) <= @RunningDate;

    -- Ambil data outlet & join date dari report
    SELECT @Outlet = OUTLET, @JoinDate = JoinDate
    FROM Report_52_SPVSalesman
    WHERE RunningDate = @RunningDate AND USERIDSALESMAN = @Salesman;

    -- Ambil first sales di outlet
    SELECT @FirstDateOutlet = MIN(CAST(ZCreatedDateTime AS DATE))
    FROM ZSalesOrderHeader
    WHERE CAST(ZCreatedDateTime AS DATE) > '1900-01-01' AND InventSiteId = @Outlet;

    -- Update data tergantung kondisi join date vs outlet start
    IF @FirstDateOutlet < @JoinDate
    BEGIN
        UPDATE Report_52_SPVSalesman
        SET LastSales = ISNULL(@lastSales, @JoinDate),
            Idle = DATEDIFF(MONTH, ISNULL(@lastSales, @JoinDate), @RunningDate + '01')
        WHERE USERIDSALESMAN = @Salesman AND RunningDate = @RunningDate;
    END
    ELSE
    BEGIN
        UPDATE Report_52_SPVSalesman
        SET LastSales = ISNULL(@lastSales, @FirstDateOutlet),
            Idle = DATEDIFF(MONTH, ISNULL(@lastSales, @FirstDateOutlet), @RunningDate + '01')
        WHERE USERIDSALESMAN = @Salesman AND RunningDate = @RunningDate;
    END

    -- Remove dari temp
  DELETE FROM #TempSalesman WHERE USERIDSALESMAN = @Salesman;
END

-- Cleanup
DROP TABLE #TempSalesman

END