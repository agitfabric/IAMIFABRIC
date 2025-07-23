-- Auto Generated (Do not modify) 48ADB976DAF830D57BA5367828829F90485B509EED559CCB76310E50F3F90ABD

CREATE VIEW [dbo].[vw_KPI_Breakdown_Detail] AS
SELECT 
    a.KodeBengkel, 
    c.KodeOutlet, 
    a.StatusTicket, 
    a.TglSubmit as 'TanggalSubmit', 
    a.LeadTime, 
    a.NoTicket, 
    a.FieldAdvisor, 
    a.VIN, 
    a.Customer, 
    a.Subject, 
    a.TglUpdate as 'TanggalUpdate', 
    a.Bulan, 
    a.Tahun, 
    a.Model, 
    a.Series, 
    a.Area, 
    a.ReasonReject, 
    a.KategoriProblem, 
    a.TypeSolving, 
    a.Target2Hari, 
    a.Target4Hari, 
    a.Pareto, 
    b.Deskripsi, 
    CAST(RTRIM(a.Bulan) + '/1/' + a.Tahun AS Date) AS Tanggal, 
    CASE WHEN CAST(a.Bulan AS int) <= 6 THEN 'S-1' ELSE 'S-2' END AS Semester
FROM   
    STG_BREAKDOWN_BD a 
LEFT JOIN 
    KPI_Breakdown_Pareto b ON a.Pareto = b.KodePareto
right join 
	Site_mapping c on c.KodeBengkel = a.KodeBengkel;