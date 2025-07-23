# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "0b1567c1-5e93-438f-8096-f30847f67f99",
# META       "default_lakehouse_name": "BRONZE_LAKEHOUSE",
# META       "default_lakehouse_workspace_id": "bc2182b7-de32-40c7-98bc-1b90e3d793a1",
# META       "known_lakehouses": [
# META         {
# META           "id": "0b1567c1-5e93-438f-8096-f30847f67f99"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()

# 1. List all tables in the current Lakehouse
tables = spark.catalog.listTables()
for table in tables:
    table_name = table.name
    x  = table_name if table.database else table_name
    full_table = f"`{table.database}`.`{x}`"
    count = spark.sql(f"SELECT COUNT(*) as cnt FROM {full_table}").collect()[0]["cnt"]
    
    if count == 0:
        print(f"Inserting dummy row into: {full_table}")
        
        # 3. Get schema of the table
        schema = spark.table(full_table).schema
        
        # 4. Generate dummy row with nulls or placeholder values
        dummy_data = []
        dummy_row = {}
        
        for field in schema.fields:
            # Use zero or placeholder string for known types
            if field.dataType.simpleString() == "string":
                dummy_row[field.name] = "dummy"
            elif "int" in field.dataType.simpleString():
                dummy_row[field.name] = 0
            elif "double" in field.dataType.simpleString():
                dummy_row[field.name] = 0.0
            elif "boolean" in field.dataType.simpleString():
                dummy_row[field.name] = False
            else:
                dummy_row[field.name] = None  # fallback
        
        dummy_data.append(dummy_row)
        
        # 5. Create DataFrame and insert
        dummy_df = spark.createDataFrame(dummy_data, schema)
        dummy_df.write.mode("append").saveAsTable(full_table)

print("✅ Dummy rows inserted into all empty tables.")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

result = spark.sql("SELECT COUNT(*) as cnt FROM ActiveSalesman").collect()
print(result)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

spark.sql("USE SILVER_WAREHOUSE")

df = spark.createDataFrame([], "TableName STRING, SourceSchema STRING, DestinationPath STRING")
df.write.format("delta").saveAsTable("MetadataTable")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession

# 1. Create a DataFrame with your metadata entries
data = [
  ("AddressCity", "dbo", "/Tables/AddressCity"),
("AddressState", "dbo", "/Tables/AddressState"),
("temp_AMInventDemandTrans", "dbo", "/Tables/temp_AMInventDemandTrans"),
("CaseProjHourPrice", "dbo", "/Tables/CaseProjHourPrice"),
("temp_CaseTable", "dbo", "/Tables/temp_CaseTable"),
("temp_CustInvoiceJour", "dbo", "/Tables/temp_CustInvoiceJour"),
("temp_DeviceClass", "dbo", "/Tables/temp_DeviceClass"),
("DeviceGroup", "dbo", "/Tables/DeviceGroup"),
("temp_DeviceModel", "dbo", "/Tables/temp_DeviceModel"),
("Temp_DeviceTable", "dbo", "/Tables/Temp_DeviceTable"),
("temp_DeviceTableMasters", "dbo", "/Tables/temp_DeviceTableMasters"),
("temp_Dim", "dbo", "/Tables/temp_Dim"),
("DirPartyContactInfoView", "dbo", "/Tables/DirPartyContactInfoView"),
("temp_DirPartyLocation", "dbo", "/Tables/temp_DirPartyLocation"),
("temp_DirPartyPostalAddressView", "dbo", "/Tables/temp_DirPartyPostalAddressView"),
("temp_DirPartyTable", "dbo", "/Tables/temp_DirPartyTable"),
("temp_DirPersonBaseEntity", "dbo", "/Tables/temp_DirPersonBaseEntity"),
("temp_ZEmployment", "dbo", "/Tables/temp_ZEmployment"),
("temp_HcmWorkerPrimaryPositionAssignmentView", "dbo", "/Tables/temp_HcmWorkerPrimaryPositionAssignmentView"),
("temp_InventItemGroupItem", "dbo", "/Tables/temp_InventItemGroupItem"),
("InventItemMinorGroup", "dbo", "/Tables/InventItemMinorGroup"),
("Temp_InventJournalTable", "dbo", "/Tables/Temp_InventJournalTable"),
("temp_InventJournalTrans", "dbo", "/Tables/temp_InventJournalTrans"),
("InventOnHandBySite", "dbo", "/Tables/InventOnHandBySite"),
("temp_InventSum", "dbo", "/Tables/temp_InventSum"),
("temp_InventTrans", "dbo", "/Tables/temp_InventTrans"),
("temp_InventTransOrigin", "dbo", "/Tables/temp_InventTransOrigin"),
("temp_Ledger", "dbo", "/Tables/temp_Ledger"),
("LogisticsElectronicAddress", "dbo", "/Tables/LogisticsElectronicAddress"),
("MRPDemandNormalized", "dbo", "/Tables/MRPDemandNormalized"),
("NameAffix", "dbo", "/Tables/NameAffix"),
("temp_OpportunityProduct", "dbo", "/Tables/temp_OpportunityProduct"),
("temp_OpportunityTable", "dbo", "/Tables/temp_OpportunityTable"),
("temp_PenjualanHeaderBase", "dbo", "/Tables/temp_PenjualanHeaderBase"),
("temp_PenjualanLine", "dbo", "/Tables/temp_PenjualanLine"),
("PersonDetails", "dbo", "/Tables/PersonDetails"),
("temp_PersonPrivateDetails", "dbo", "/Tables/temp_PersonPrivateDetails"),
("Position", "dbo", "/Tables/Position"),
("temp_PositionDetails", "dbo", "/Tables/temp_PositionDetails"),
("temp_PositionHierarchy", "dbo", "/Tables/temp_PositionHierarchy"),
("temp_PositionWorkerAssignment", "dbo", "/Tables/temp_PositionWorkerAssignment"),
("temp_ProductTranslation", "dbo", "/Tables/temp_ProductTranslation"),
("temp_ProjInvoiceItem", "dbo", "/Tables/temp_ProjInvoiceItem"),
("temp_ProjInvoiceJour", "dbo", "/Tables/temp_ProjInvoiceJour"),
("PurchaseOrderHeaderV2", "dbo", "/Tables/PurchaseOrderHeaderV2"),
("temp_PurchaseOrderLineV2", "dbo", "/Tables/temp_PurchaseOrderLineV2"),
("temp_PurchaseType", "dbo", "/Tables/temp_PurchaseType"),
("temp_SalesQuotationLine", "dbo", "/Tables/temp_SalesQuotationLine"),
("WRKCTRTABLE", "dbo", "/Tables/WRKCTRTABLE"),
("temp_ZCaseTimeSheetTrans", "dbo", "/Tables/temp_ZCaseTimeSheetTrans"),
("temp_SalesQuotationTable", "dbo", "/Tables/temp_SalesQuotationTable"),
("SiteLogisticsLocation", "dbo", "/Tables/SiteLogisticsLocation"),
("temp_smmBusRelTable", "dbo", "/Tables/temp_smmBusRelTable"),
("smmQuotationCompetitors", "dbo", "/Tables/smmQuotationCompetitors"),
("temp_TabelSDA", "dbo", "/Tables/temp_TabelSDA"),
("temp_VendTable", "dbo", "/Tables/temp_VendTable"),
("temp_Worker", "dbo", "/Tables/temp_Worker"),
("ZClaimDASLine", "dbo", "/Tables/ZClaimDASLine"),
("temp_ZCustInvoiceTrans", "dbo", "/Tables/temp_ZCustInvoiceTrans"),
("temp_ZCustomers", "dbo", "/Tables/temp_ZCustomers"),
("ZDataBillingViews", "dbo", "/Tables/ZDataBillingViews"),
("ZEkspedisi", "dbo", "/Tables/ZEkspedisi"),
("temp_ZGoodIssueBPKB", "dbo", "/Tables/temp_ZGoodIssueBPKB"),
("temp_ZGoodIssueSTNK", "dbo", "/Tables/temp_ZGoodIssueSTNK"),
("temp_ZGoodReceiptBPKB", "dbo", "/Tables/temp_ZGoodReceiptBPKB"),
("temp_ZGoodReceiptFakpol", "dbo", "/Tables/temp_ZGoodReceiptFakpol"),
("temp_ZGoodReceiptSTNK", "dbo", "/Tables/temp_ZGoodReceiptSTNK"),
("ZHcmTitle", "dbo", "/Tables/ZHcmTitle"),
("temp_ZHcmWorkerTitle", "dbo", "/Tables/temp_ZHcmWorkerTitle"),
("temp_ZInqAbsensiMekanikLine", "dbo", "/Tables/temp_ZInqAbsensiMekanikLine"),
("temp_ZInventSites", "dbo", "/Tables/temp_ZInventSites"),
("temp_ZInventTables", "dbo", "/Tables/temp_ZInventTables"),
("ZLogisticsEntityPostalAddress", "dbo", "/Tables/ZLogisticsEntityPostalAddress"),
("ZMRPABCClassification", "dbo", "/Tables/ZMRPABCClassification"),
("temp_ZProjInvoiceEmpl", "dbo", "/Tables/temp_ZProjInvoiceEmpl"),
("ZReportService", "dbo", "/Tables/ZReportService"),
("ZReportServiceSA", "dbo", "/Tables/ZReportServiceSA"),
("GroupLine", "dbo", "/Tables/GroupLine"),
("ZSalesGroupTable", "dbo", "/Tables/ZSalesGroupTable"),
("Temp_ZSalesOrderHeader", "dbo", "/Tables/Temp_ZSalesOrderHeader"),
("temp_ZSalesOrderLine", "dbo", "/Tables/temp_ZSalesOrderLine"),
("temp_ZVendInvoiceJours", "dbo", "/Tables/temp_ZVendInvoiceJours"),
("temp_ZVendInvoiceTrans", "dbo", "/Tables/temp_ZVendInvoiceTrans"),
("CaseLogHistory", "dbo", "/Tables/CaseLogHistory"),
("TargetUnitServed", "dbo", "/Tables/TargetUnitServed"),
("ZAISITES", "dbo", "/Tables/ZAISITES"),
("ReportFormat", "dbo", "/Tables/ReportFormat"),
("SalesJenjang", "dbo", "/Tables/SalesJenjang"),
("Report_35_Classification", "dbo", "/Tables/Report_35_Classification"),
("ZVendInvoiceInfoTable", "dbo", "/Tables/ZVendInvoiceInfoTable"),
("ForecastModel", "dbo", "/Tables/ForecastModel"),
("WorkerBankAccount", "dbo", "/Tables/WorkerBankAccount")
]

columns = ["TableName", "SourceSchema", "DestinationPath"]

df = spark.createDataFrame(data, schema=columns)

# 2. Append to the Delta table 'MetadataTable'
df.write.format("delta").mode("append").saveAsTable("MetadataTable")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
