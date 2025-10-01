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

# daftar tabel yang mau di-refresh
tables = [
"ZTempFakpol",
"dataUnitBegBal",
"TargetUnitServed"
]

# loop untuk refresh
for table_name in tables:
    spark.sql(f"REFRESH TABLE bronze_lakehouse.{table_name}")
    print(f"Table '{table_name}' berhasil di-refresh.")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
