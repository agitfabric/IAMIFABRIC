CREATE TABLE [dbo].[TargetSales] (

	[ID] varchar(8000) NULL, 
	[BranchCode] int NULL, 
	[SiteCode] varchar(8000) NULL, 
	[Site] varchar(8000) NULL, 
	[MonthPeriod] int NULL, 
	[YearPeriod] int NULL, 
	[FuncAreaId] int NULL, 
	[TargetSales] int NULL, 
	[IsDeleted] int NULL, 
	[CreatedOn] datetime2(6) NULL, 
	[CreatedBy] varchar(8000) NULL, 
	[ModifiedOn] datetime2(6) NULL, 
	[ModifiedBy] varchar(8000) NULL, 
	[IsSentDOS] int NULL, 
	[IsSentMyz] int NULL
);