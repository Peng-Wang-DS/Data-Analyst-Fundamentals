# %%
from google.cloud import bigquery
from google.cloud import bigquery_storage_v1
import pyarrow.parquet as pq
import os
import time

# --------------------------------------------------
# Configuration
# --------------------------------------------------
PROJECT_ID = "ambient-scion-419818"          # billing project
SOURCE_PROJECT = "bigquery-public-data"      # data project
DATASET_ID = "stackoverflow"

OUTPUT_DIR = "bq_exports/stackoverflow_parquet"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# --------------------------------------------------
# Clients
# --------------------------------------------------
bq_client = bigquery.Client(project=PROJECT_ID)
bqs_client = bigquery_storage_v1.BigQueryReadClient()

# --------------------------------------------------
# List tables
# --------------------------------------------------
dataset_ref = bq_client.dataset(DATASET_ID, project=SOURCE_PROJECT)
tables = list(bq_client.list_tables(dataset_ref))

print(f"Found {len(tables)} tables")

# --------------------------------------------------
# Export function (Storage API)
# --------------------------------------------------


def export_table(table_item):
    table_id = table_item.table_id

    table_path = (
        f"projects/{SOURCE_PROJECT}/"
        f"datasets/{DATASET_ID}/"
        f"tables/{table_id}"
    )

    output_file = os.path.join(OUTPUT_DIR, f"{table_id}.parquet")

    print(f"[START] {table_id}")
    start = time.time()

    read_session = bigquery_storage_v1.types.ReadSession(
        table=table_path,
        data_format=bigquery_storage_v1.types.DataFormat.ARROW
    )

    session = bqs_client.create_read_session(
        parent=f"projects/{PROJECT_ID}",
        read_session=read_session,
        max_stream_count=1
    )

    writer = None
    rows = 0

    for stream in session.streams:
        reader = bqs_client.read_rows(stream.name)

        for batch in reader.rows().to_arrow():
            if writer is None:
                writer = pq.ParquetWriter(output_file, batch.schema)

            writer.write_table(batch)
            rows += batch.num_rows

    if writer:
        writer.close()

    elapsed = int(time.time() - start)
    print(f"[DONE ] {table_id} | rows={rows:,} | time={elapsed}s")


# --------------------------------------------------
# Run (sequential = safest)
# --------------------------------------------------
for t in tables:
    export_table(t)

print("All tables exported (Parquet, no GCS).")
# %%
