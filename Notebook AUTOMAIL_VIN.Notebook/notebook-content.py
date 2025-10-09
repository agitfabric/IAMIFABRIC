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

# Welcome to your new notebook
# Type here in the cell editor to add code!
# Notebook: Refresh Table in Lakehouse
# Lakehouse: bronze_lakehouse (pastikan terhubung di UI)

# Ganti nama tabel di bawah sesuai kebutuhan
table_name = "AUTOMAIL_VIN_EXPORT"

# Perintah untuk menyegarkan metadata tabel
spark.sql(f"REFRESH TABLE {table_name}")

print(f"Tabel '{table_name}' berhasil direfresh.")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
