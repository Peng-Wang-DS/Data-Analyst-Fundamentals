import os
import subprocess
import pandas as pd

# --------------------------------------------------
# CONFIG (ABSOLUTE PATHS ONLY)
# --------------------------------------------------
CONTAINER_NAME = "sqlserver2022"

CSV_HOST_DIR = (
    "/Users/pengwang/Desktop/Space0/Work/9bin/"
    "Data-Analyst-Fundamentals/sql/"
    "stackoverflow_exercise/bq_exports/stackoverflow"
)

CSV_CONTAINER_DIR = "/var/opt/mssql/data/stackoverflow"

DB_NAME = "StackOverflowPractice"

SQLCMD = [
    "sqlcmd",
    "-S", "localhost,1433",
    "-U", "sa",
    "-P", "StrongPassw0rd!",
    "-C"
]

# --------------------------------------------------
# SAFETY CHECK
# --------------------------------------------------
if not os.path.isdir(CSV_HOST_DIR):
    raise FileNotFoundError(f"CSV directory not found: {CSV_HOST_DIR}")

# --------------------------------------------------
# 1. ENSURE CONTAINER DIRECTORY EXISTS
# --------------------------------------------------
print("Preparing SQL Server container directory...")

subprocess.run(
    ["docker", "exec", CONTAINER_NAME, "mkdir", "-p", CSV_CONTAINER_DIR],
    check=True
)

# --------------------------------------------------
# 2. COPY CSV FILES ONE BY ONE (IMPORTANT FIX)
# --------------------------------------------------
csv_files = [f for f in os.listdir(CSV_HOST_DIR) if f.endswith(".csv")]

print(f"Copying {len(csv_files)} CSV files into container...")

for csv_file in csv_files:
    host_path = os.path.join(CSV_HOST_DIR, csv_file)
    container_path = f"{CONTAINER_NAME}:{CSV_CONTAINER_DIR}/{csv_file}"

    print(f"  → Copying {csv_file}")

    subprocess.run(
        ["docker", "cp", host_path, container_path],
        check=True
    )

print("All CSVs copied successfully.")

# --------------------------------------------------
# 3. CREATE DATABASE
# --------------------------------------------------
print("Creating database if not exists...")

subprocess.run(
    SQLCMD + [
        "-Q",
        f"""
        IF DB_ID('{DB_NAME}') IS NULL
            CREATE DATABASE {DB_NAME};
        """
    ],
    check=True
)

# --------------------------------------------------
# 4. CREATE TABLES + BULK INSERT
# --------------------------------------------------
print("Creating tables and loading data...")

for csv_file in csv_files:
    table = csv_file.replace(".csv", "") + "_raw"
    csv_path_container = f"{CSV_CONTAINER_DIR}/{csv_file}"
    csv_path_host = os.path.join(CSV_HOST_DIR, csv_file)

    print(f"Loading {csv_file} → {table}")

    # Read header only
    df = pd.read_csv(csv_path_host, nrows=0)

    columns_sql = ",\n    ".join(
        f"[{col}] VARCHAR(MAX)" for col in df.columns
    )

    create_table_sql = f"""
    USE {DB_NAME};

    IF OBJECT_ID('dbo.{table}') IS NOT NULL
        DROP TABLE dbo.{table};

    CREATE TABLE dbo.{table} (
        {columns_sql}
    );
    """

    subprocess.run(
        SQLCMD + ["-Q", create_table_sql],
        check=True
    )

    bulk_insert_sql = f"""
    USE {DB_NAME};

    BULK INSERT dbo.{table}
    FROM '{csv_path_container}'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        TABLOCK
    );
    """

    subprocess.run(
        SQLCMD + ["-Q", bulk_insert_sql],
        check=True
    )

print("All Stack Overflow CSVs loaded successfully.")
