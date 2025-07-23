create procedure SP_INGEST_AGITEFAKPOL_PRINT AS


-- Step 1: Update baris yang sudah ada di SILVER dengan data dari BRONZE
UPDATE target
SET 
    target.IdFakpol = source.IdFakpol,
    target.DealerCategory = source.DealerCategory,
    target.KodeOutlet = source.KodeOutlet,
    target.OutletName = source.OutletName,
    target.InvoiceDate = source.InvoiceDate,
    target.InvoiceNo = source.InvoiceNo,
    target.CustomerName = source.CustomerName,
    target.KTP = source.KTP,
    target.TDP = source.TDP,
    target.Alamat = source.Alamat,
    target.City = source.City,
    target.TanggalPengajuanFakpol = source.TanggalPengajuanFakpol,
    target.NoPengajuanFakpol = source.NoPengajuanFakpol,
    target.CreatedDate = source.CreatedDate,
    target.ApprovalDate = source.ApprovalDate,
    target.PrintedDate = source.PrintedDate,
    target.TglFakpol = source.TglFakpol,
    target.NoFakpol = source.NoFakpol,
    target.StatusFakpol = source.StatusFakpol,
    target.NamaFakpol = source.NamaFakpol,
    target.AlamatFakpol = source.AlamatFakpol,
    target.CityFakpol = source.CityFakpol,
    target.KecamatanFakpol = source.KecamatanFakpol,
    target.KelurahanFakpol = source.KelurahanFakpol,
    target.KodePosFakpol = source.KodePosFakpol,
    target.Email = source.Email,
    target.Color = source.Color,
    target.Engine_Number = source.EngineNumber
FROM SILVER_WAREHOUSE.dbo.AGITEFakpol AS target
JOIN BRONZE_LAKEHOUSE.dbo.AGITEFakpol AS source
    ON source.ChassisNumber = target.ChassisNumber;


  -- Step 2: Insert baris baru yang tidak ada di SILVER
INSERT INTO SILVER_WAREHOUSE.dbo.AGITEFakpol (
    ChassisNumber, IdFakpol, DealerCategory, KodeOutlet, OutletName, InvoiceDate, InvoiceNo,
    CustomerName, KTP, TDP, Alamat, City, TanggalPengajuanFakpol, NoPengajuanFakpol,
    CreatedDate, ApprovalDate, PrintedDate, TglFakpol, NoFakpol, StatusFakpol, NamaFakpol,
    AlamatFakpol, CityFakpol, KecamatanFakpol, KelurahanFakpol, KodePosFakpol, Email,
    Color, Engine_Number
)
SELECT 
    source.ChassisNumber, source.IdFakpol, source.DealerCategory, source.KodeOutlet, source.OutletName, 
    source.InvoiceDate, source.InvoiceNo, source.CustomerName, source.KTP, source.TDP, source.Alamat, 
    source.City, source.TanggalPengajuanFakpol, source.NoPengajuanFakpol, source.CreatedDate, 
    source.ApprovalDate, source.PrintedDate, source.TglFakpol, source.NoFakpol, source.StatusFakpol, 
    source.NamaFakpol, source.AlamatFakpol, source.CityFakpol, source.KecamatanFakpol, 
    source.KelurahanFakpol, source.KodePosFakpol, source.Email, source.Color, source.EngineNumber as Engine_Number
FROM BRONZE_LAKEHOUSE.dbo.AGITEFakpol AS source
LEFT JOIN SILVER_WAREHOUSE.dbo.AGITEFakpol AS target
    ON source.ChassisNumber = target.ChassisNumber
WHERE target.ChassisNumber IS NULL;