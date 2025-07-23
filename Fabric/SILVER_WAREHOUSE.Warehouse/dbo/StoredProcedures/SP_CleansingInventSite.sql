CREATE PROCEDURE [dbo].[SP_CleansingInventSite]
AS
BEGIN

	SET NOCOUNT ON;

    Update a
	set a.ZIAMIArea = b.ZIAMIArea
	From ZInventSites a
		inner join (select distinct AreaCode, ZIAMIArea
					from ZInventSites	
					where dataAreaId != 'kzu' and ZIAMIArea != 'None') b on b.AreaCode = a.AreaCode
	Where a.dataAreaId != 'kzu' and a.ZIAMIArea = 'None'

	Update a
	Set a.Group_Dealer = b.Group_Dealer
	From ZInventSites a
		inner join (select a.dataAreaId, AreaCode, Group_Dealer
						from ZInventSites a
						where dataAreaId != 'kzu' and Group_Dealer is not NULL
						Group by a.dataAreaId, AreaCode, Group_Dealer)b on b.dataAreaId = a.dataAreaId and b.AreaCode = a.AreaCode
	Where a.dataAreaId != 'kzu' and a.Group_Dealer is NULL
END