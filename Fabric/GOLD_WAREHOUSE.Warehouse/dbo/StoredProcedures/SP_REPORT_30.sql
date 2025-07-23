-- Adjusted for Microsoft Fabric Warehouse
CREATE   PROCEDURE SP_REPORT_30
AS
BEGIN
    -- Prevent extra result sets
    SET NOCOUNT ON;

    DECLARE 
        @MaxDate date, 
        @StarDate date;

    -- Define date window
    SELECT 
        @StarDate = DATEADD(DAY, -10, CURRENT_TIMESTAMP),
        @MaxDate  = DATEADD(DAY, -1, CURRENT_TIMESTAMP);

    -- Populate the destination table directly
    INSERT INTO dbo.Report_30
    SELECT
        L.Description AS nama_dealer_billing_sap,
        LEFT(DT.PurchInventRefId, 5) AS kode_dealer_billing_sap,
        CASE 
            WHEN DT.PurchInventRefType = 'Purch' THEN DT.PurchInventRefId 
            ELSE DT.PurchInvoiceId 
        END AS nomor_billing_sap,
        DBV.ZBillingReference AS Reference_Doc,
        DBV.IsCanceled AS ISCANCELED,
        COALESCE(DBV.BillingDate, DT.PurchInvoiceDate) AS tanggal_billing_sap,
        DT.PurchInvoiceDate AS tanggal_terima_atau_tanggal_gr_dealer,
        NULL AS gr_fisik,
        LEFT(DT.PurchInventRefId, 5) AS kode_dealer_gr,
        L.Description AS nama_dealer_gr,
        L.Description AS nama_dealer_posisi_stock_unit,
        CASE 
            WHEN DT.TransferInventRefId IS NULL OR DT.SalesInventRefId IS NULL 
                THEN LEFT(DT.PurchInventRefId, 5) 
            ELSE LEFT(DT.SalesInventRefId, 5) 
        END AS kode_dealer_posisi_stock_unit,
        IV.Name AS outlet,
        IV.ZIAMIArea AS area,
        IT.AMItemMajorGroupId AS major_group,
        IT.AMItemMinorGroupId AS types,
        DM.ClassId AS device_class,
        DBV.ItemName AS model,
        DBV.ItemName AS material_description_sap,
        DBV.VIN AS chassis_number,
        DBV.EngineNumber AS engine_number,
        DBV.ColorCode AS kode_warna,
        DBV.ColorDesc AS color_desc,
        CASE 
            WHEN DT.SalesInvoiceId IS NULL THEN 0 
            ELSE 1 
        END AS Stock_Qty,
        NULL AS reserved,
        DT.SalesInventRefId AS nomer_so,
        DT.SalesOrderDate AS tanggal_so,
        DT.SalesCustName AS nama_customer,
        CASE 
            WHEN DT.SalesInvoiceId IS NULL THEN 'Belum Terjual' 
            ELSE 'Terjual' 
        END AS Status,
        NULL AS last_process,
        NULL AS tanggal_delivery_out_pdc,
        CURRENT_TIMESTAMP AS Last_Update
    FROM 
        [SILVER_WAREHOUSE].[dbo].[ZDataBillingViews] AS DBV
        LEFT JOIN [SILVER_WAREHOUSE].[dbo].[DeviceTable] AS DT 
            ON DBV.PurchaseOrder = DT.PurchInventRefId AND DT.PurchInventRefId != ''
        LEFT JOIN [SILVER_WAREHOUSE].[dbo].[Ledger] AS L 
            ON LEFT(LOWER(DT.PurchInventRefId), 3) = L.Name
        LEFT JOIN [SILVER_WAREHOUSE].[dbo].[ZInventSites] AS IV 
            ON IV.SiteId = LEFT(DT.PurchInventRefId, 5)
        LEFT JOIN [SILVER_WAREHOUSE].[dbo].[ZInventTables] AS IT 
            ON IT.dataAreaId = DT.dataAreaId AND IT.ItemId = DT.ItemId
        LEFT JOIN [SILVER_WAREHOUSE].[dbo].[DeviceModel] AS DM 
            ON DM.ModelId = DT.ItemId
    WHERE 
        CAST(DBV.BillingDate AS DATE) BETWEEN @StarDate AND @MaxDate
        AND DBV.IsCanceled = 'No';
END;