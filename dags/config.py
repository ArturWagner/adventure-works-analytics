"""
Configuration constants for the adventureworks-etl DAG.

All values are project-level constants — no credentials here.
Credentials are injected via Airflow Connections (UI or env vars).
"""

GCP_PROJECT_ID = "unigran-tcc"
BQ_DATASET = "adventureworks"
MSSQL_CONN_ID = "mssql_adventureworks"
GCP_CONN_ID = "google_cloud_default"
