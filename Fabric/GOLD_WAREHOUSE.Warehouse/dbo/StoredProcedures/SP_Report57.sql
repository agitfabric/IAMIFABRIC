CREATE PROCEDURE [dbo].[SP_Report57] 
AS
BEGIN

    TRUNCATE TABLE Report_57;

    INSERT INTO Report_57
    SELECT 
        p.PositionId POSITION, 
        pa.PositionId PARENTPOSITION,
        CASE 
            WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Sumbagut' THEN 'Sumatera bagian utara'
            WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Sumbagsel' THEN 'Sumatera bagian selatan'
            WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'JKT'      THEN 'DKI Jakarta'
            WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Jabar'    THEN 'Jawa Barat'
            WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Jateng'   THEN 'Jawa Tengah'
            WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Jatim'    THEN 'Jawa Timur'
            WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Kalimantan' THEN 'Kalimantan'
            WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Sul_IBT'  THEN 'Sulawesi & IBT'
            ELSE e.ZIAMIArea 
        END Area,
        e.DealerName dealer, 
        e.OutletName outlet,
        e.OutletCode kodeoutlet,
        a.PersonnelNumber npk,
        a.Name nama,
        a.ZDepartment dept,
        p.Description jabatan,
        pa.WorkerPersonnelNumber reportnpk, 
        pa.WorkerName reportnama, 
        pa.TitleId reportjabatan,
        p.WorkerAssignmentStart assignstart, 
        p.WorkerAssignmentEnd assignend
    FROM SILVER_WAREHOUSE.dbo.Worker a
        LEFT JOIN SILVER_WAREHOUSE.dbo.Position p 
            ON a.PersonnelNumber COLLATE Latin1_General_CI_AS = p.WorkerPersonnelNumber COLLATE Latin1_General_CI_AS
           AND DATEADD(HOUR,7,GETDATE()) BETWEEN p.WorkerAssignmentStart AND p.WorkerAssignmentEnd
        LEFT JOIN vw_zInventSite e 
            ON e.OutletCode COLLATE Latin1_General_CI_AS = p.ZInventSiteId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.Position pa 
            ON pa.PositionId COLLATE Latin1_General_CI_AS = p.ReportsToPositionid COLLATE Latin1_General_CI_AS
    WHERE DATEADD(HOUR,7,GETDATE()) BETWEEN p.WorkerAssignmentStart AND p.WorkerAssignmentEnd
      AND a.ZOutlet COLLATE Latin1_General_CI_AS NOT LIKE '%KZU%';

END