-- Auto Generated (Do not modify) E53814C5B5CE63063CCDD4466F5A86CAB8BAC5FB23D4D364CE5570078C113E1B
CREATE view [dbo].[vw_Manpower]
as
SELECT
	SUM(ManPower) ManPower
   ,Jenjang
   ,DealerName
   ,OutletName
FROM vw_Report_52_Resource
GROUP BY Jenjang
		,DealerName
		,OutletName