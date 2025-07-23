CREATE PROCEDURE SP_INGEST_TABELSDA
AS
BEGIN
    -- Step 1: Update existing records
    UPDATE target
    SET
        target.SupportDealerID = source.SupportDealerID,
        target.SDANumber = source.SDANumber,
        target.BranchCode = source.BranchCode,
        target.SiteCode = source.SiteCode,
        target.CreatedDate = source.CreatedDate,
        target.UpdatedDate = source.UpdatedDate,
        target.SDADate = source.SDADate,
        target.IsDeleted = source.IsDeleted,
        target.CreatedBy = source.CreatedBy,
        target.CreatedOn = source.CreatedOn,
        target.UpdatedBy = source.UpdatedBy,
        target.UpdatedOn = source.UpdatedOn,
        target.Last_update = GETDATE()
    FROM SILVER_WAREHOUSE.dbo.TabelSDA AS target
    JOIN (
        SELECT DISTINCT *
        FROM BRONZE_LAKEHOUSE_154_NONSAP.dbo.TabelSDA
    ) AS source
    ON source.SDANumber = target.SDANumber;

    -- Step 2: Insert new records
    INSERT INTO SILVER_WAREHOUSE.dbo.TabelSDA (
        SupportDealerID,
        SDANumber,
        BranchCode,
        SiteCode,
        CreatedDate,
        UpdatedDate,
        SDADate,
        IsDeleted,
        CreatedBy,
        CreatedOn,
        UpdatedBy,
        UpdatedOn,
        Last_update
    )
    SELECT
        source.SupportDealerID,
        source.SDANumber,
        source.BranchCode,
        source.SiteCode,
        source.CreatedDate,
        source.UpdatedDate,
        source.SDADate,
        source.IsDeleted,
        source.CreatedBy,
        source.CreatedOn,
        source.UpdatedBy,
        source.UpdatedOn,
        GETDATE()
    FROM (
        SELECT DISTINCT *
        FROM BRONZE_LAKEHOUSE_154_NONSAP.dbo.TabelSDA
    ) AS source
    LEFT JOIN SILVER_WAREHOUSE.dbo.TabelSDA AS target
        ON source.SDANumber = target.SDANumber
    WHERE target.SDANumber IS NULL;

   
END;