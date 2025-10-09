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

import requests, time

workspace_id = "bc2182b7-de32-40c7-98bc-1b90e3d793a1"
lakehouse_id = "0b1567c1-5e93-438f-8096-f30847f67f99"

token = mssparkutils.credentials.getToken("https://api.fabric.microsoft.com")

headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}

# 1. Ambil sqlEndpointId
url_get = f"https://api.fabric.microsoft.com/v1/workspaces/{workspace_id}/lakehouses/{lakehouse_id}"
resp = requests.get(url_get, headers=headers)
resp.raise_for_status()
lakehouse_info = resp.json()
sql_endpoint_id = lakehouse_info["properties"]["sqlEndpointProperties"]["id"]

print("SQL Endpoint ID:", sql_endpoint_id)

# 2. Trigger refresh metadata
url_refresh = f"https://api.fabric.microsoft.com/v1/workspaces/{workspace_id}/sqlEndpoints/{sql_endpoint_id}/refreshMetadata"
resp2 = requests.post(url_refresh, headers=headers, json={})
resp2.raise_for_status()
print("Trigger refresh status:", resp2.status_code)

# 3. Tunggu beberapa detik agar metadata propagate
print("⏳ Tunggu 180 detik untuk sync metadata...")
time.sleep(180)
print("✅ Metadata seharusnya sudah siap")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
