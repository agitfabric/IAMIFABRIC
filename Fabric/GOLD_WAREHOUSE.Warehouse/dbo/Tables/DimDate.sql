CREATE TABLE [dbo].[DimDate] (

	[DWDateKey] date NULL, 
	[DayDate] int NULL, 
	[DayOfWeekName] varchar(8000) NULL, 
	[WeekNumber] int NULL, 
	[MonthNumber] int NULL, 
	[MonthName] varchar(8000) NULL, 
	[MonthShortName] varchar(8000) NULL, 
	[Year] int NULL, 
	[QuarterNumber] varchar(8000) NULL, 
	[QuarterName] varchar(8000) NULL
);