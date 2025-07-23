# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "333fa733-104e-4995-8bb6-8802070b85fb",
# META       "default_lakehouse_name": "BRONZE_LAKEHOUSE_154_NONSAP",
# META       "default_lakehouse_workspace_id": "bc2182b7-de32-40c7-98bc-1b90e3d793a1",
# META       "known_lakehouses": [
# META         {
# META           "id": "333fa733-104e-4995-8bb6-8802070b85fb"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

# Welcome to your new notebook
# Type here in the cell editor to add code!


df = spark.sql("SELECT * FROM BRONZE_LAKEHOUSE_154_NONSAP.TargetSales LIMIT 1")
display(df)
df.limit(0).write.mode("overwrite").saveAsTable("BRONZE_LAKEHOUSE_154_NONSAP.TargetSales")
display(df)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
