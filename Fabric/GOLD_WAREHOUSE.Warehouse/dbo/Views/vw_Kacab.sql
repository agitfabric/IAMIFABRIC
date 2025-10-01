-- Auto Generated (Do not modify) 14780E32086A3CAC13B12B672C698DB92378E07353A02265FC1CCB244CA28290
CREATE VIEW [dbo].[vw_Kacab]
AS

SELECT DISTINCT w.Name, pwa.PersonnelNumber
FROM SILVER_WAREHOUSE.dbo.PositionWorkerAssignment pwa
LEFT JOIN SILVER_WAREHOUSE.dbo.PositionHierarchy g 
    ON g.Position  = pwa.Position 
    AND DATEADD(HOUR, 7, GETDATE()) BETWEEN g.ValidFrom AND g.ValidTo
LEFT JOIN SILVER_WAREHOUSE.dbo.PositionWorkerAssignment h 
    ON h.Position  = g.ParentPosition 
    AND DATEADD(HOUR, 7, GETDATE()) BETWEEN h.ValidFrom AND h.ValidTo 
    AND h.IsPrimaryPosition COLLATE Latin1_General_CI_AS = 'Yes' COLLATE Latin1_General_CI_AS
LEFT JOIN SILVER_WAREHOUSE.dbo.Worker w ON h.Worker = w.RecordId
LEFT JOIN SILVER_WAREHOUSE.dbo.PositionDetails pda 
    ON pda.PositionPublic  = h.Position 
    AND DATEADD(HOUR, 7, GETDATE()) BETWEEN pda.ValidFrom AND pda.ValidTo
WHERE DATEADD(HOUR, 7, GETDATE()) BETWEEN pwa.ValidFrom AND pwa.ValidTo 
AND w.Name IS NOT NULL
AND pwa.IsPrimaryPosition COLLATE Latin1_General_CI_AS = 'Yes' COLLATE Latin1_General_CI_AS;