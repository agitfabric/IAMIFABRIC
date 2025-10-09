# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
# META }

# PARAMETERS CELL ********************

fileList = "[]"


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Cell eksekusi
import json
from notebookutils import mssparkutils

raw = fileList  # string JSON dari pipeline

try:
    items = json.loads(raw)  # [{"name": "...", "type": "File"}, ...]
except Exception:
    items = []

# sort ascending berdasarkan name
items_sorted = sorted(items, key=lambda x: x.get("name", ""))

# ambil hanya nama filenya
only_names = [x["name"] for x in items_sorted]

# kirim balik ke pipeline sebagai string JSON
mssparkutils.notebook.exit(json.dumps(only_names))


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
