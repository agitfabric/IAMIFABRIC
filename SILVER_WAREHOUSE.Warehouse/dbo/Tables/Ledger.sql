CREATE TABLE [dbo].[Ledger] (

	[AccountingCurrency] varchar(8000) NULL, 
	[BudgetExchangeRateType] varchar(8000) NULL, 
	[ChartOfAccounts] varchar(8000) NULL, 
	[ChartOfAccountsRecId] bigint NULL, 
	[Description] varchar(8000) NULL, 
	[ExchangeRateType] varchar(8000) NULL, 
	[FiscalCalendar] varchar(8000) NULL, 
	[IsBudgetControlEnabled] varchar(8000) NULL, 
	[LedgerRecId] bigint NULL, 
	[LegalEntityId] varchar(8000) NULL, 
	[MainAccountIdFinancialGain] varchar(8000) NULL, 
	[MainAccountIdFinancialLoss] varchar(8000) NULL, 
	[MainAccountIdRealizedGain] varchar(8000) NULL, 
	[MainAccountIdRealizedLoss] varchar(8000) NULL, 
	[MainAccountIdUnrealizedGain] varchar(8000) NULL, 
	[MainAccountIdUnrealizedLoss] varchar(8000) NULL, 
	[ModifiedDate] datetime2(6) NULL, 
	[Name] varchar(8000) NULL, 
	[ReportingCurrency] varchar(8000) NULL, 
	[ReportingCurrencyExchangeRateType] varchar(8000) NULL, 
	[Last_update] datetime2(6) NULL
);