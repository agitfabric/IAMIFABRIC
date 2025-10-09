CREATE PROCEDURE [dbo].[SP_REPORT_52_SALESMAN]
AS
BEGIN

    DECLARE @Year char(4), @month char(2);
    
    SELECT @Year  = LEFT(CONVERT(char, DATEADD(HOUR,7,GETDATE())-1,112),4), 
           @month = SUBSTRING(CONVERT(char, DATEADD(HOUR,7,GETDATE())-1,112),5,2);

    DELETE Report_52_SPVSalesman 
    WHERE RunningDate COLLATE Latin1_General_CI_AS = (@Year+@month) COLLATE Latin1_General_CI_AS;

    INSERT INTO Report_52_SPVSalesman 
    SELECT 
        d.ZInventSiteId as Outlet, 
        e.Name as NAME, 
        a.SalesGroupId as SALESGROUPID, 
        b.Description as SPVNAME, 
        a.UserIdSalesman as USERIDSALESMAN, 
        a.Description as SALESMAN, 
        1 as Jumlah, 
        @Year+@month as RunningDate, 
        d.WorkerAssignmentStart as JoinDate,
        CASE
            WHEN DATEDIFF(month, CAST(d.WorkerAssignmentStart as Date), CAST(@Year+@month+'01' as Date)) <= 12 THEN 'Sales Trainee' 
            WHEN DATEDIFF(month, CAST(d.WorkerAssignmentStart as Date), CAST(@Year+@month+'01' as Date)) > 12 
                 AND DATEDIFF(month, CAST(d.WorkerAssignmentStart as Date), CAST(@Year+@month+'01' as Date)) <=24 THEN 'Junior Sales'
            WHEN DATEDIFF(month, CAST(d.WorkerAssignmentStart as Date), CAST(@Year+@month+'01' as Date)) > 25 
                 AND DATEDIFF(month, CAST(d.WorkerAssignmentStart as Date), CAST(@Year+@month+'01' as Date)) <=36 THEN 'Sales'
            WHEN DATEDIFF(month, CAST(d.WorkerAssignmentStart as Date), CAST(@Year+@month+'01' as Date)) > 36 THEN 'Senior Sales' 
            ELSE 'Sales' 
        END as Jenjang, 
        '1900-01-01' as LastSales, 
        0 as Idle
    FROM SILVER_WAREHOUSE.dbo.ZSalesGroupLine a 
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZSalesGroupTable b 
            ON a.SalesGroupId COLLATE Latin1_General_CI_AS = b.SalesGroupId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.Worker c 
            ON a.UserIdSalesman COLLATE Latin1_General_CI_AS = c.PersonnelNumber COLLATE Latin1_General_CI_AS
        LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.Position d 
            ON d.WorkerPersonnelNumber COLLATE Latin1_General_CI_AS = c.PersonnelNumber COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites e 
            ON d.ZInventSiteId COLLATE Latin1_General_CI_AS = e.SiteId COLLATE Latin1_General_CI_AS
    WHERE a.DataAreaId COLLATE Latin1_General_CI_AS <> 'kzu'  
      AND d.ZInventSiteId IS NOT NULL 
      AND e.Name IS NOT NULL 
      AND b.Description IS NOT NULL;

    UPDATE Report_52_SPVSalesman
    SET 
        LastSales = ISNULL(
            CASE 
                WHEN FirstDateOutlet < JoinDate 
                    THEN ISNULL(c.LastSales, a.JoinDate) 
                ELSE ISNULL(c.LastSales, b.FirstDateOutlet) 
            END, '1900-01-01'),
        Idle = ISNULL(
            CASE 
                WHEN FirstDateOutlet < JoinDate 
                    THEN DATEDIFF(month, ISNULL(c.LastSales, a.JoinDate), CAST(@Year+@month+'01' AS DATE)) 
                ELSE DATEDIFF(month, ISNULL(c.LastSales, b.FirstDateOutlet), CAST(@Year+@month+'01' AS DATE)) 
            END, 0)
    FROM Report_52_SPVSalesman a
        LEFT JOIN (
            SELECT MIN(DATEADD(DAY, 1, EOMONTH(DatePhysical))) AS FirstDateOutlet, 
                   b.InventSiteId
            FROM SILVER_WAREHOUSE.dbo.InventTrans a
                LEFT JOIN SILVER_WAREHOUSE.dbo.Dim b 
                    ON b.inventDimId COLLATE Latin1_General_CI_AS = a.inventDimId COLLATE Latin1_General_CI_AS
            WHERE CAST(DatePhysical AS DATE) > '1900-01-01'
            GROUP BY b.InventSiteId
        ) b 
            ON b.InventSiteId COLLATE Latin1_General_CI_AS = a.Outlet COLLATE Latin1_General_CI_AS
        LEFT JOIN (
            SELECT CAST(MAX(a.InvoiceDate) AS DATE) AS LastSales, 
                   ZSalesman
            FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
                LEFT JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem b 
                    ON b.ItemId COLLATE Latin1_General_CI_AS = a.ItemId COLLATE Latin1_General_CI_AS 
                   AND b.ItemDataAreaId COLLATE Latin1_General_CI_AS = a.dataAreaId COLLATE Latin1_General_CI_AS
                LEFT JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderHeader c 
                    ON c.SalesId COLLATE Latin1_General_CI_AS = a.SalesId COLLATE Latin1_General_CI_AS
            WHERE a.dataAreaId COLLATE Latin1_General_CI_AS <> 'kzu'  
              AND c.ZSalesType COLLATE Latin1_General_CI_AS = 'FU' 
              AND b.ItemGroupId COLLATE Latin1_General_CI_AS = 'FU01'
              AND LEFT(CONVERT(CHAR, a.InvoiceDate, 112), 6) <= @Year+@month
            GROUP BY ZSalesman
        ) c 
            ON c.ZSalesman COLLATE Latin1_General_CI_AS = a.USERIDSALESMAN COLLATE Latin1_General_CI_AS
    WHERE RunningDate COLLATE Latin1_General_CI_AS = (@Year+@month) COLLATE Latin1_General_CI_AS;

    SELECT MAX(RunningDate) as LastRunningDate 
    FROM Report_52_SPVSalesman;

END