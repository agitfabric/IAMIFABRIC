-- Auto Generated (Do not modify) BD89159E8110FCED9DCB48A17EB8D999443487D993FE8480E9D1901A3E48B334
CREATE VIEW [dbo].[vw_report_40_ServiceShare_Old] AS
WITH FL AS (
    SELECT 
        DATEPART(YEAR, InvoiceDate) AS InvoiceYear,
        DATEPART(MONTH, InvoiceDate) AS InvoiceMonth,
        MajorGroup,
        InventSiteId,
        SUM(UnitServed_Qty) AS Qty
    FROM Report_44_UnitServed
    GROUP BY 
        DATEPART(YEAR, InvoiceDate),
        DATEPART(MONTH, InvoiceDate),
        MajorGroup,
        InventSiteId
),
get_last_12_month AS (
    SELECT 
        InvoiceYear,
        InvoiceMonth,
        MajorGroup,
        InventSiteId,
        Qty,
        SUM(Qty) OVER (
            PARTITION BY MajorGroup, InventSiteId
            ORDER BY InvoiceYear, InvoiceMonth
            ROWS BETWEEN 11 PRECEDING AND 0 PRECEDING
        ) AS L12M_Qty
    FROM FL
)
SELECT 
    FL.InvoiceYear AS Year,
    FL.InvoiceMonth AS Month,
    FL.MajorGroup,
    FL.InventSiteId,
    FL.Qty,
    GL12M.L12M_Qty 
FROM FL
JOIN get_last_12_month GL12M 
    ON FL.InvoiceYear = GL12M.InvoiceYear 
    AND FL.InvoiceMonth = GL12M.InvoiceMonth 
    AND FL.MajorGroup = GL12M.MajorGroup 
    AND FL.InventSiteId = GL12M.InventSiteId;