-- Auto Generated (Do not modify) 14780E32086A3CAC13B12B672C698DB92378E07353A02265FC1CCB244CA28290
CREATE   VIEW [dbo].[vw_Kacab]    
AS  

			select distinct w.Name, pwa.PersonnelNumber--, pda.TitleId, pwa.RecordId, g.RecordId, h.VALIDFROM, h.VALIDTO, h.RecordId, w.RecordId, pda.RecordId
			FROM SILVER_WAREHOUSE.dbo.PositionWorkerAssignment pwa	
				left join SILVER_WAREHOUSE.dbo.PositionHierarchy g on g.Position = pwa.Position and GETDATE() between g.ValidFrom AND g.ValidTo 
				left join SILVER_WAREHOUSE.dbo.PositionWorkerAssignment h on h.Position = g.ParentPosition and GETDATE() between h.ValidFrom AND h.ValidTo AND h.IsPrimaryPosition='Yes'
				left join SILVER_WAREHOUSE.dbo.Worker w on h.Worker = w.RecordId
				left join SILVER_WAREHOUSE.dbo.PositionDetails pda on pda.PositionPublic=h.Position and GETDATE() between pda.ValidFrom AND pda.ValidTo 
			where GETDATE() between pwa.ValidFrom AND pwa.ValidTo and w.Name is not null-- and pda.TitleId='Sales Supervisor'
			and pwa.IsPrimaryPosition='Yes'