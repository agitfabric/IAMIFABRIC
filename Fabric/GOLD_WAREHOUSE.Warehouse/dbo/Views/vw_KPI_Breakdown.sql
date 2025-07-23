-- Auto Generated (Do not modify) 43641EB721F62FA647D16D3BF5856D6E9464BE930C79261258C1B4A2BA405A99

CREATE VIEW [dbo].[vw_KPI_Breakdown]
AS
Select x.KodeBengkel, x.KodeOutlet, x.Bulan, x.Tahun, x.Tanggal,
		TicketTIR_Logbook, 
		CASE 
        WHEN Bulan % 3 = 1 THEN TicketTIR_Logbook
        ELSE SUM(TicketTIR_Logbook) OVER (
            PARTITION BY KodeOutlet, KodeBengkel, Tahun, (Bulan - 1) / 3
            ORDER BY Bulan
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
    END AS TicketTIR_Logbook_QTD,
	x.TIRBreakdown,
	CASE 
        WHEN Bulan % 3 = 1 THEN TIRBreakdown
        ELSE SUM(TIRBreakdown) OVER (
            PARTITION BY KodeOutlet, KodeBengkel, Tahun, (Bulan - 1) / 3
            ORDER BY Bulan
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
    END AS TIRBreakdown_QTD,
	x.Target2Hari,
	CASE 
        WHEN Bulan % 3 = 1 THEN Target2Hari
        ELSE SUM(Target2Hari) OVER (
            PARTITION BY KodeOutlet, KodeBengkel, Tahun, (Bulan - 1) / 3
            ORDER BY Bulan
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
    END AS Target2Hari_QTD,
	x.Target4Hari, 
	CASE 
        WHEN Bulan % 3 = 1 THEN Target4Hari
        ELSE SUM(Target4Hari) OVER (
            PARTITION BY KodeOutlet, KodeBengkel, Tahun, (Bulan - 1) / 3
            ORDER BY Bulan
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
    END AS Target4Hari_QTD,
	x.Target2_4Hari,
	CASE 
        WHEN Bulan % 3 = 1 THEN Target2_4Hari
        ELSE SUM(Target2_4Hari) OVER (
            PARTITION BY KodeOutlet, KodeBengkel, Tahun, (Bulan - 1) / 3
            ORDER BY Bulan
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
    END AS Target2_4Hari_QTD
From
(
select a.KodeBengkel, h.KodeOutlet, a.Tahun, a.Bulan, CAST(RTRIM(a.Bulan) + '/' + '1' + '/' + a.Tahun AS Date) as Tanggal, 
	   CASE WHEN CAST(a.Bulan AS int) <= 6 THEN 'S-1' ELSE 'S-2' END AS Semester,  
	   Case when CAST(a.Bulan AS int) in ('1','2','3') then 'Q1'
			when CAST(a.Bulan AS int) in ('4','5','6') then 'Q2'
			when CAST(a.Bulan AS int) in ('7','8','9') then 'Q3'
			when CAST(a.Bulan AS int) in ('10','11','12') then 'Q4' end as Quarter,
	   sum(a.JumlahTicket) as TicketTIR_Logbook, 
	   Isnull(b.TIRBreakdown_BD,0) as TIRBreakdown,
	   Isnull(c.Target2Hari_BD,0) as Target2Hari, 
	   Isnull(e.Target4Hari_BD,0) as Target4Hari, 
	   Isnull(g.Target2_4Hari_BD,0) as Target2_4Hari

from vw_KPI_Breakdown_Ticket a
--TIR Breakdown
Left Join (SELECT KodeBengkel, Tahun, Bulan, COUNT(*) AS TIRBreakdown_BD
                 FROM    dbo.STG_BREAKDOWN_BD 
                 GROUP BY KodeBengkel, Tahun, Bulan) b on b.KodeBengkel = a.KodeBengkel and b.Tahun+b.Bulan = a.Tahun+a.Bulan
--Target 2 Hari 
Left join (SELECT KodeBengkel, Tahun, Bulan, COUNT(*) AS Target2Hari_BD
                 FROM    dbo.STG_BREAKDOWN_BD  
                 WHERE Target2Hari = '< 2 days' GROUP BY KodeBengkel, Tahun, Bulan) c on c.KodeBengkel = a.KodeBengkel and c.Tahun+c.Bulan = a.Tahun+a.Bulan

--Target  4 Hari
Left join (SELECT KodeBengkel, Tahun, Bulan, COUNT(*) AS Target4Hari_BD
                 FROM    dbo.STG_BREAKDOWN_BD  
                 WHERE Target4Hari = '> 4 days' GROUP BY KodeBengkel, Tahun, Bulan) e on e.KodeBengkel = a.KodeBengkel and e.Tahun+e.Bulan = a.Tahun+a.Bulan

--Target 2 - 4 Hari
Left join (SELECT KodeBengkel, Tahun, Bulan, COUNT(*) AS Target2_4Hari_BD
                 FROM    dbo.STG_BREAKDOWN_BD  
                 WHERE  Target2Hari = '> 2 days' and Target4Hari = '< 4 days' 
				 GROUP BY KodeBengkel, Tahun, Bulan) g on g.KodeBengkel = a.KodeBengkel and g.Tahun+g.Bulan = a.Tahun+a.Bulan
Left Join Site_mapping h on h.KodeBengkel = a.KodeBengkel
inner join vw_zInventSite i on i.OutletCode = h.KodeOutlet and i.DealerCategory != 'AI' 
		and OutletCode not in ('AST03','AUT02','ASC01','ASC03','AUT04')

where h.KodeOutlet is not NULL
Group by a.KodeBengkel, h.KodeOutlet, a.Tahun, a.Bulan,
		b.TIRBreakdown_BD, c.Target2Hari_BD, e.Target4Hari_BD, g.Target2_4Hari_BD
)x