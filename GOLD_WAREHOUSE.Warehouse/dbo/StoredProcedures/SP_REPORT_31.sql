-- =============================================
-- Title   : SP_Report_31 (Fabric-compatible)
-- Pattern : Cursor -> WHILE loop + #TempYearMonth
-- Exclude : YearMonth sumber dari InventTrans tanpa 'kzu'
-- =============================================

CREATE            PROCEDURE [dbo].[SP_REPORT_31]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @GetMaxRunningDate date,
        @GetCurrentDate    date,
        @LoopYearMonth     char(6),
        @StarDate          date,
        @MaxDate           date;

    -- Anchor tanggal dari Report_31 (tetap sesuai SP asli)
    SELECT 
        @GetMaxRunningDate = ISNULL(CAST(MAX([SO/PKB_Date]) AS date), '2019-09-01'),
        @GetCurrentDate    = CAST(GETDATE() AS date)
    FROM GOLD_WAREHOUSE.dbo.Report_31;

    -- Siapkan daftar YearMonth yang akan diproses (ganti cursor ⇒ #temp + WHILE)
   IF OBJECT_ID('tempdb..#TempYearMonth_SP_REPORT_31') IS NOT NULL
     DROP TABLE #TempYearMonth_SP_REPORT_31;

    WITH YearMonths AS (
        SELECT DISTINCT LEFT(CONVERT(CHAR(8), DatePhysical, 112), 6) AS YearMonth
        FROM SILVER_WAREHOUSE.dbo.InventTrans
        WHERE LOWER(dataAreaId) <> 'kzu'
          AND CAST(DatePhysical AS date) BETWEEN @GetMaxRunningDate AND @GetCurrentDate
    )
    SELECT * INTO #TempYearMonth_SP_REPORT_31 FROM YearMonths;

    -- Loop YearMonth satu per satu (ascending)
    WHILE EXISTS (SELECT 1 FROM #TempYearMonth_SP_REPORT_31)
    BEGIN
        SELECT TOP (1) @LoopYearMonth = YearMonth
        FROM #TempYearMonth_SP_REPORT_31
        ORDER BY YearMonth ASC;

        -- Window 12 bulan persis seperti rumus di SP asli
        SET @StarDate = DATEADD(MONTH, 1, DATEADD(YEAR, -1, CAST(@LoopYearMonth + '01' AS date)));
        SET @MaxDate  = DATEADD(DAY, -1, DATEADD(MONTH, 1, CAST(@LoopYearMonth + '01' AS date)));

        -- Replace data Report_31 untuk window ini
        DELETE FROM GOLD_WAREHOUSE.dbo.Report_31
        WHERE CAST([SO/PKB_Date] AS date) BETWEEN @StarDate AND @MaxDate;

        INSERT INTO GOLD_WAREHOUSE.dbo.Report_31
        SELECT  
            c.CustAccount                                     AS customer_id,
            b.InvoiceId,
            h.Name                                            AS nama_customer,
            b.SalesId                                         AS [SO/PKB_No],    -- SO No
            c.ZCreatedDateTime                                AS [SO/PKB_Date],  -- SO date
            d.InventRefId                                     AS PO_No,
            g.CreatedDateTime1                                AS PO_Date,
            zt.AMItemMinorGroupId                             AS Series,
            k.ItemGroupId,
            d.ItemNumber                                      AS part_number,
            d.Name                                            AS part_name,
            d.SalesQty                                        AS Qty_order,
            b.Qty                                             AS Qty_Supply,
            b.InvoiceDate                                     AS invoice_date,
            c.Payment                                         AS nTOP,
            b.DiscPercent                                     AS persen_diskon,
            b.LineAmountMST                                   AS Amount,
            ABS(f.CostAmountPosted + f.CostAmountAdjustment)  AS COGS,
            b.LineAmountMST - ABS(f.CostAmountPosted + f.CostAmountAdjustment) AS GP,
            CASE WHEN UPPER(z2.ZCustPartType) IN ('BMI', 'PARTSHOP') THEN 'Indirect' ELSE 'Direct' END AS Tipe, 
            z2.ZCustType                                      AS Category,
            e.ZIAMIArea                                       AS Area,
            c.dataAreaId                                      AS Dealer,
            e.ZDealerAfterSales                               AS nama_dealer,
            c.InventSiteId                                    AS Outlet,
            e.Name                                            AS nama_outlet,
            GETDATE(),
             po.MaskedName ,
            z2.ZCustPartType                                  AS CustPartType,
            z2.ZIsPartShop                                    AS ZIsPartShop
        FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans b 
        INNER JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderHeader c
            ON LOWER(c.SalesId) = LOWER(b.SalesId)
           AND UPPER(c.SalesOrderPoolId) IN ('SP','SV')
           and LOWER(c.SalesOrderStatus) = 'invoiced'
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderLine d
            ON LOWER(d.SalesOrderNumber) = LOWER(b.SalesId)
           AND LOWER(d.LineNum)          = LOWER(b.LineNum)
           AND LOWER(b.ItemId)           = LOWER(d.ItemNumber) 
        INNER JOIN SILVER_WAREHOUSE.dbo.InventTransOrigin f1
            ON LOWER(f1.InventTransId) = LOWER(b.InventTransId)
           AND LOWER(f1.ItemId)        = LOWER(b.ItemId)
        LEFT JOIN (
            SELECT dataAreaId, InventTransOrigin, ItemId, InvoiceId,
                   SUM(CostAmountPosted)      AS CostAmountPosted,
                   SUM(CostAmountAdjustment)  AS CostAmountAdjustment
            FROM SILVER_WAREHOUSE.dbo.InventTrans
            GROUP BY dataAreaId, InventTransOrigin, ItemId, InvoiceId
        ) f
            ON LOWER(f.InventTransOrigin) = LOWER(f1.RecId1)
           AND LOWER(f.InvoiceId)         = LOWER(b.InvoiceId)
           AND LOWER(f.ItemId)            = LOWER(b.ItemId) 
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables zt 
            ON LOWER(zt.ItemId)     = LOWER(b.ItemId) 
           AND LOWER(zt.dataAreaId) = LOWER(b.dataAreaId) 
        LEFT JOIN SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2 g
            ON LOWER(g.PurchaseOrderNumber) = LOWER(d.InventRefId)
           AND LOWER(g.dataAreaId)          = LOWER(d.dataAreaId)
           AND LOWER(g.ItemNumber)          = LOWER(d.ItemNumber)
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZCustomers z2
            ON LOWER(z2.AccountNum) = LOWER(c.CustAccount) 
           AND LOWER(z2.dataAreaId) = LOWER(c.dataAreaId) 
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable h 
            ON LOWER(h.RecordId) = LOWER(z2.Party) 
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites e 
            ON LOWER(e.SiteId) = LOWER(c.InventSiteId) 
        INNER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem k
            ON LOWER(k.ItemDataAreaId) = LOWER(b.dataAreaId) 
           AND LOWER(k.ItemId)        = LOWER(b.ItemId) 
           AND UPPER(k.ItemGroupId)   IN ('SP01','SP02')
        CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(h.Name) as po 
        WHERE CAST(c.ZCreatedDateTime AS date) BETWEEN @StarDate AND @MaxDate

        UNION ALL

        SELECT
            a.CustAccount                                    AS customer_id,
            c.ProjInvoiceId                                  AS InvoiceId,
            f.SalesName                                      AS nama_customer,
            a.CaseId                                         AS [SO/PKB_No],
            a.CreatedDateTime1                               AS [SO/PKB_Date],
            ''                                               AS PO_no,
            NULL                                             AS PO_date,
            d.AMItemMinorGroupId                             AS Series,
            c.CategoryId                                     AS ItemGroupId,
            c.ItemId                                         AS part_number,
            d.NameAlias                                      AS part_name,
            c.Qty                                            AS Qty_order,
            c.Qty                                            AS Qty_Supply,
            c.InvoiceDate                                    AS invoice_date,
            f.Payment                                        AS nTop,
            c.LinePercent                                    AS persen_diskon,
            c.LineAmount                                     AS amount,
            ABS(h.CostAmountPosted + h.CostAmountAdjustment) AS COGS,
            CASE 
                WHEN c.Qty < 0 
                    THEN c.LineAmount + ABS(h.CostAmountPosted + h.CostAmountAdjustment)
                ELSE c.LineAmount - ABS(h.CostAmountPosted + h.CostAmountAdjustment)
            END                                              AS GP,
            'Direct'                                         AS Tipe,
            z2.ZCustType                                     AS Category,
            e.ZIAMIArea                                      AS Area,
            a.dataAreaId                                     AS dealer,
            e.ZDealerAfterSales                              AS nama_dealer,
            a.ZInventSiteId                                  AS outlet,
            e.Name                                           AS nama_outlet,
            GETDATE(),
            po.MaskedName,
            z2.ZCustPartType                                 AS CustPartType,
            z2.ZIsPartShop                                   AS ZIsPartShop
        FROM SILVER_WAREHOUSE.dbo.ProjInvoiceItem c 
        INNER JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderHeader f
            ON LOWER(f.ProjId) = LOWER(c.ProjId)
           AND UPPER(f.SalesOrderPoolId) = 'SV'
           AND LOWER(f.SalesOrderStatus) = 'invoiced'
        LEFT JOIN SILVER_WAREHOUSE.dbo.CaseTable a 
            ON LOWER(a.CaseId) = LOWER(c.ProjId)
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables d 
            ON LOWER(d.ItemId) = LOWER(c.ItemId) 
           AND LOWER(d.dataAreaId) = LOWER(c.dataAreaId) 	
        LEFT JOIN SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2 f1
            ON LOWER(f1.ProjectId)  = LOWER(c.ProjId)  
           AND LOWER(f1.dataAreaId) = LOWER(c.dataAreaId) 
           AND LOWER(f1.ItemNumber) = LOWER(c.ItemId)
        LEFT JOIN SILVER_WAREHOUSE.dbo.InventTransOrigin g 
            ON LOWER(g.InventTransId) = LOWER(c.InventTransId) 
        LEFT JOIN (
            SELECT dataAreaId, InventTransOrigin, ItemId, InvoiceId,
                   SUM(CostAmountPosted)      AS CostAmountPosted,
                   SUM(CostAmountAdjustment)  AS CostAmountAdjustment
            FROM SILVER_WAREHOUSE.dbo.InventTrans
            GROUP BY dataAreaId, InventTransOrigin, ItemId, InvoiceId
        ) h
            ON LOWER(h.InventTransOrigin) = LOWER(g.RecId1)
           AND LOWER(h.InvoiceId)         = LOWER(c.ProjInvoiceId)
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZCustomers z2 
            ON LOWER(z2.AccountNum) = LOWER(a.CustAccount) 
           AND LOWER(z2.dataAreaId) = LOWER(a.dataAreaId)
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable k 
            ON LOWER(k.RecordId) = LOWER(z2.Party) 
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites e 
            ON LOWER(e.SiteId) = LOWER(a.ZInventSiteId) 
        INNER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem l
            ON LOWER(l.ItemDataAreaId) = LOWER(c.dataAreaId) 
           AND LOWER(l.ItemId)        = LOWER(c.ItemId) 
           AND UPPER(l.ItemGroupId)   IN ('SP01','SP02') 
        CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(f.SalesName) as po
        WHERE CAST(a.CreatedDateTime1 AS date) BETWEEN @StarDate AND @MaxDate;

        -- YearMonth ini selesai
        DELETE FROM #TempYearMonth_SP_REPORT_31 WHERE YearMonth = @LoopYearMonth;
    END

    DROP TABLE #TempYearMonth_SP_REPORT_31;
END;