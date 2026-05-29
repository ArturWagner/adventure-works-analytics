"""
DAG: adventureworks-etl

Extracts 13 tables from AdventureWorks (SQL Server on-prem via Docker),
applies SQL-based transformations, and loads them into Google BigQuery with
full load (truncate + insert) guaranteeing idempotency.

Architecture:
  Task group load_dimensions (11 tables, parallel):
    For each dimension: PythonOperator(extract) → PythonOperator(load)
  Task group load_facts (2 tables, parallel, after load_dimensions):
    For each fact: PythonOperator(extract) → PythonOperator(load)

Credentials are never hard-coded — always resolved via Airflow Connections.
"""

import logging
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.utils.task_group import TaskGroup

from config import BQ_DATASET, GCP_CONN_ID, GCP_PROJECT_ID, MSSQL_CONN_ID

log = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Task definitions
# ---------------------------------------------------------------------------

DIMENSIONS = [
    "dim_date",
    "dim_customer",
    "dim_product",
    "dim_product_subcategory",
    "dim_product_category",
    "dim_sales_territory",
    "dim_geography",
    "dim_promotion",
    "dim_currency",
    "dim_employee",
    "dim_reseller",
]

FACTS = [
    "fact_internet_sales",
    "fact_reseller_sales",
]

# ---------------------------------------------------------------------------
# Callable functions
# ---------------------------------------------------------------------------


def extract_from_mssql(table_name: str, **context) -> None:
    """
    Extract rows from SQL Server using the transform query in
    /opt/airflow/sql/transforms/<table_name>.sql and push them to XCom.

    Uses pyodbc via the Airflow MsSql Hook connection.
    """
    import pyodbc
    from airflow.hooks.base import BaseHook

    log.info("Extracting table %s from SQL Server", table_name)
    conn_info = BaseHook.get_connection(MSSQL_CONN_ID)
    sql_path = f"/opt/airflow/sql/transforms/{table_name}.sql"

    with open(sql_path, encoding="utf-8") as fh:
        query = fh.read()

    driver = "{ODBC Driver 18 for SQL Server}"
    conn_str = (
        f"DRIVER={driver};"
        f"SERVER={conn_info.host},{conn_info.port or 1433};"
        f"DATABASE={conn_info.schema};"
        f"UID={conn_info.login};"
        f"PWD={conn_info.password};"
        "TrustServerCertificate=yes;"
    )

    def _serialize(val):
        """Convert pyodbc non-JSON types to JSON-safe equivalents."""
        from decimal import Decimal
        import datetime
        if isinstance(val, Decimal):
            return float(val)
        if isinstance(val, (datetime.date, datetime.datetime)):
            return val.isoformat()
        if isinstance(val, bytes):
            return val.hex()
        return val

    with pyodbc.connect(conn_str) as cx:
        cursor = cx.cursor()
        cursor.execute(query)
        columns = [col[0] for col in cursor.description]
        rows = [
            {k: _serialize(v) for k, v in zip(columns, row)}
            for row in cursor.fetchall()
        ]

    log.info("Extracted %d rows from %s", len(rows), table_name)
    context["ti"].xcom_push(key=f"rows_{table_name}", value=rows)


def load_to_bigquery(table_name: str, **context) -> None:
    """
    Load rows pushed to XCom by extract_from_mssql into BigQuery using
    WRITE_TRUNCATE disposition (full load, idempotent).
    """
    from google.cloud import bigquery
    from google.oauth2 import service_account
    from airflow.hooks.base import BaseHook

    rows = context["ti"].xcom_pull(key=f"rows_{table_name}")
    if rows is None:
        log.warning("No rows found in XCom for %s — skipping load", table_name)
        return

    log.info("Loading %d rows into BigQuery table %s.%s", len(rows), BQ_DATASET, table_name)

    conn_info = BaseHook.get_connection(GCP_CONN_ID)
    extra = conn_info.extra_dejson if hasattr(conn_info, "extra_dejson") else {}
    keyfile = extra.get("keyfile_dict") or extra.get("key_path")

    if keyfile and isinstance(keyfile, dict):
        credentials = service_account.Credentials.from_service_account_info(keyfile)
        client = bigquery.Client(project=GCP_PROJECT_ID, credentials=credentials)
    else:
        # Fall back to ADC (e.g. GOOGLE_APPLICATION_CREDENTIALS env var)
        client = bigquery.Client(project=GCP_PROJECT_ID)

    table_ref = f"{GCP_PROJECT_ID}.{BQ_DATASET}.{table_name}"
    job_config = bigquery.LoadJobConfig(
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
        autodetect=True,
    )
    load_job = client.load_table_from_json(rows, table_ref, job_config=job_config)
    load_job.result()  # wait for completion; raises on error

    log.info("Load complete for %s — %d rows", table_name, len(rows))


def create_bigquery_views(**context) -> None:
    """
    Apply CREATE OR REPLACE VIEW for each SQL file in sql/views/.

    Reads every *.sql file from the views directory and executes it against
    BigQuery using the same GCP connection as load_to_bigquery.
    Idempotent — CREATE OR REPLACE VIEW makes it safe to re-run.
    """
    import glob

    from airflow.hooks.base import BaseHook
    from google.cloud import bigquery
    from google.oauth2 import service_account

    conn_info = BaseHook.get_connection(GCP_CONN_ID)
    extra = conn_info.extra_dejson if hasattr(conn_info, "extra_dejson") else {}
    keyfile = extra.get("keyfile_dict") or extra.get("key_path")

    if keyfile and isinstance(keyfile, dict):
        credentials = service_account.Credentials.from_service_account_info(keyfile)
        client = bigquery.Client(project=GCP_PROJECT_ID, credentials=credentials)
    else:
        # Fall back to ADC (e.g. GOOGLE_APPLICATION_CREDENTIALS env var)
        client = bigquery.Client(project=GCP_PROJECT_ID)

    view_files = sorted(glob.glob("/opt/airflow/sql/views/*.sql"))
    if not view_files:
        log.warning("No view files found in /opt/airflow/sql/views/ — nothing to apply")
        return

    log.info("Applying %d BigQuery view(s)", len(view_files))
    for path in view_files:
        with open(path, encoding="utf-8") as fh:
            sql = fh.read()
        job = client.query(sql)
        job.result()  # wait for completion; raises on error
        log.info("Applied view from %s", path)

    log.info("All views applied successfully")


# ---------------------------------------------------------------------------
# Default args (apply to every task)
# ---------------------------------------------------------------------------

default_args = {
    "owner": "airflow",
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}

# ---------------------------------------------------------------------------
# DAG definition
# ---------------------------------------------------------------------------

with DAG(
    dag_id="adventureworks-etl",
    default_args=default_args,
    schedule="@daily",
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=["adventureworks", "etl"],
) as dag:

    with TaskGroup("load_dimensions") as load_dimensions:
        for _dim in DIMENSIONS:
            _extract = PythonOperator(
                task_id=f"extract_{_dim}",
                python_callable=extract_from_mssql,
                op_kwargs={"table_name": _dim},
            )
            _load = PythonOperator(
                task_id=f"load_{_dim}",
                python_callable=load_to_bigquery,
                op_kwargs={"table_name": _dim},
            )
            _extract >> _load

    with TaskGroup("load_facts") as load_facts:
        for _fact in FACTS:
            _extract = PythonOperator(
                task_id=f"extract_{_fact}",
                python_callable=extract_from_mssql,
                op_kwargs={"table_name": _fact},
            )
            _load = PythonOperator(
                task_id=f"load_{_fact}",
                python_callable=load_to_bigquery,
                op_kwargs={"table_name": _fact},
            )
            _extract >> _load

    create_views = PythonOperator(
        task_id="create_bigquery_views",
        python_callable=create_bigquery_views,
    )

    load_dimensions >> load_facts >> create_views
