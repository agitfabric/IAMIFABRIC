-- Auto Generated (Do not modify) 42A38A9C875222B4424859917589193ADD1807A5B2E9E65CE1E1F659CA595EB8

CREATE VIEW [dbo].[vw_KPI_Breakdown_Ticket] AS

SELECT c.KodeBengkel, c.Bulan, c.Tahun, ISNULL(d.JumlahTicket, 0) AS JumlahTicket
FROM   (SELECT b.KodeBengkel, a.Bulan, a.Tahun
             FROM    (SELECT Tahun, Bulan
                           FROM    dbo.STG_BREAKDOWN_TICKET
                           GROUP BY Tahun, Bulan) AS a CROSS JOIN
                               (SELECT KodeBengkel
                               FROM    dbo.STG_BREAKDOWN_TICKET AS KPI_Breakdown_Ticket_2
                               GROUP BY KodeBengkel) AS b) AS c LEFT OUTER JOIN
                 (SELECT KodeBengkel, Bulan, Tahun, COUNT(*) AS JumlahTicket
                 FROM    dbo.STG_BREAKDOWN_TICKET AS KPI_Breakdown_Ticket_1
                 GROUP BY KodeBengkel, Bulan, Tahun) AS d ON d.KodeBengkel = c.KodeBengkel AND d.Tahun = c.Tahun AND d.Bulan = c.Bulan