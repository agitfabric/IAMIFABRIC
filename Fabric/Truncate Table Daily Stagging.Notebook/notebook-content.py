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

# List of tables
tables = [
    "temp_Worker",
    "ZSalesGroupLine",
    "temp_ZCustomers",
    "ZLogisticsEntityPostalAddress",
    "temp_ZVendInvoiceJours",
    "ZEkspedisi",
    "temp_AMInventDemandTrans",
    "temp_DeviceClass",
    "temp_DeviceModel",
    "Temp_DeviceTable",
    "temp_DeviceTableMasters",
    "temp_Dim",
    "temp_DirPartyLocation",
    "temp_DirPartyPostalAddressView",
    "temp_DirPartyTable",
    "temp_DirPersonBaseEntity",
    "temp_ZEmployment",
    "temp_HcmWorkerPrimaryPositionAssignmentView",
    "temp_InventItemGroupItem",
    "InventItemMinorGroup",
    "temp_InventSum",
    "temp_InventTrans",
    "temp_InventTransOrigin",
    "temp_Ledger",
    "temp_PenjualanHeaderBase",
    "temp_PenjualanLine",
    "temp_PersonPrivateDetails",
    "temp_PositionDetails",
    "temp_PositionHierarchy",
    "temp_PositionWorkerAssignment",
    "temp_ProductTranslation",
    "PurchaseOrderHeaderV2",
    "temp_PurchaseOrderLineV2",
    "temp_ZCaseTimeSheetTrans",
    "temp_smmBusRelTable",
    "temp_VendTable",
    "temp_ZHcmWorkerTitle",
    "temp_ZInqAbsensiMekanikLine",
    "temp_ZInventSites",
    "temp_ZInventTables",
    "ZMRPABCClassification",
    "temp_ZVendInvoiceTrans",
    "AddressCity",
    "AddressState",
    "DeviceGroup",
    "DirPartyContactInfoView",
    "InventOnHandBySite",
    "LogisticsElectronicAddress",
    "NameAffix",
    "PersonDetails",
    "Position",
    "SiteLogisticsLocation",
    "ZClaimDASLine",
    "ZDataBillingViews",
    "ZHcmTitle",
    "GroupLine",
    "ZSalesGroupTable"
]

# Loop to truncate all tables
for table in tables:
    try:
        spark.sql(f"TRUNCATE TABLE {table}")
        print(f"✅ Cleared: {table}")
    except Exception as e:
        print(f"⚠️ Failed on {table}: {e}")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
