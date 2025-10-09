# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
# META }

# CELL ********************

# Welcome to your new notebook
# Type here in the cell editor to add code!
df = spark.sql("SHOW TABLES IN silver_warehouse")
for row in df.collect():
    table = f"{row['database']}.{row['tableName']}"
    count = spark.sql(f"SELECT COUNT(*) as cnt FROM {table}").collect()[0]['cnt']
    print(f"{table}: {count}")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
