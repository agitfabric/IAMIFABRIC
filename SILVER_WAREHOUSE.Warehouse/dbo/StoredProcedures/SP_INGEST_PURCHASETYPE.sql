CREATE PROCEDURE SP_INGEST_PURCHASETYPE
AS
BEGIN
    -- Update existing records
    UPDATE T
SET 
    T.dataAreaId        = S.dataAreaId,
    T.Description       = S.Description,
    T.IsConsignment     = S.IsConsignment,
    T.Pool              = S.Pool,
    T.PurchaseOrderType = S.PurchaseOrderType,
    T.CreatedDate       = S.CreatedDate,
    T.ModifiedDate      = S.ModifiedDate,
    T.Last_update       = GETDATE(),
    T.RecordId          = S.RecordId
FROM PurchaseType AS T
JOIN (
    SELECT DISTINCT
        dataAreaId,
        Description,
        IsConsignment,
        Pool,
        PurchaseOrderType,
        CreatedDate,
        ModifiedDate,
        RecordId,
        Last_update
    FROM bronze_lakehouse.dbo.temp_PurchaseType
) AS S
ON T.RecordId = S.RecordId;


    -- Insert new records
    INSERT INTO PurchaseType (
    dataAreaId,
    Description,
    IsConsignment,
    Pool,
    PurchaseOrderType,
    CreatedDate,
    ModifiedDate,
    RecordId,
    Last_update
)
SELECT 
    S.dataAreaId,
    S.Description,
    S.IsConsignment,
    S.Pool,
    S.PurchaseOrderType,
    S.CreatedDate,
    S.ModifiedDate,
    S.RecordId,
    GETDATE()
FROM (
    SELECT DISTINCT
        dataAreaId,
        Description,
        IsConsignment,
        Pool,
        PurchaseOrderType,
        CreatedDate,
        ModifiedDate,
        RecordId
    FROM bronze_lakehouse.dbo.temp_PurchaseType
) AS S
LEFT JOIN PurchaseType AS T
    ON T.RecordId = S.RecordId
WHERE T.RecordId IS NULL;

END;

--insert into SILVER_WAREHOUSE.dbo.ProductTranslation select * from BRONZE_LAKEHOUSE.dbo.ProductTranslation