# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
# META }

# CELL ********************

df = spark.read.format("sqlserver").load("temp_Worker")
df = df.withColumnRenamed("WorkerTaxCodeParameters", "WorkerTaxCode_Parameters")
df.write.format("delta").save("Tables/temp_Worker")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
