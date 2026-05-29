"""
Tests for BigQuery schema DDL files in sql/schema/.

Validates:
- All required files exist
- Files use CREATE TABLE/SCHEMA IF NOT EXISTS (idempotence)
- Column types match spec requirements (NUMERIC for monetary, STRING for currency codes)
- Fact tables are partitioned by order_date (DATE), not order_date_key (INT64)
- dim_currency.currency_key is STRING (3-letter ISO code)
- Correct FK columns per fact table (customer_key vs reseller_key/employee_key)
"""
import os
import re

import pytest

SCHEMA_DIR = "sql/schema"
TRANSFORMS_DIR = "sql/transforms"

DIM_TABLES = [
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

FACT_TABLES = ["fact_internet_sales", "fact_reseller_sales"]


def read_sql(path):
    with open(path) as f:
        return f.read().upper()


class TestDatasetDDL:
    def test_dataset_sql_exists(self):
        assert os.path.exists(f"{SCHEMA_DIR}/dataset.sql")

    def test_dataset_uses_create_schema_if_not_exists(self):
        content = read_sql(f"{SCHEMA_DIR}/dataset.sql")
        assert "CREATE SCHEMA IF NOT EXISTS" in content

    def test_dataset_references_adventureworks(self):
        content = read_sql(f"{SCHEMA_DIR}/dataset.sql")
        assert "ADVENTUREWORKS" in content


class TestDimensionDDL:
    @pytest.mark.parametrize("table", DIM_TABLES)
    def test_dim_file_exists(self, table):
        assert os.path.exists(f"{SCHEMA_DIR}/{table}.sql"), f"Missing: {SCHEMA_DIR}/{table}.sql"

    @pytest.mark.parametrize("table", DIM_TABLES)
    def test_dim_uses_create_table_if_not_exists(self, table):
        content = read_sql(f"{SCHEMA_DIR}/{table}.sql")
        assert "CREATE TABLE IF NOT EXISTS" in content

    @pytest.mark.parametrize("table", DIM_TABLES)
    def test_dim_targets_adventureworks_dataset(self, table):
        content = read_sql(f"{SCHEMA_DIR}/{table}.sql")
        assert f"ADVENTUREWORKS.{table.upper()}" in content

    def test_currency_key_is_string_not_int(self):
        content = read_sql(f"{SCHEMA_DIR}/dim_currency.sql")
        assert re.search(r"CURRENCY_KEY\s+STRING", content)

    def test_dim_product_sell_end_date_is_nullable(self):
        content = read_sql(f"{SCHEMA_DIR}/dim_product.sql")
        assert "SELL_END_DATE" in content
        for line in content.splitlines():
            if "SELL_END_DATE" in line:
                assert "NOT NULL" not in line, "sell_end_date must be nullable"

    def test_monetary_columns_are_numeric(self):
        for table, col in [
            ("dim_sales_territory", "SALES_YTD"),
            ("dim_sales_territory", "SALES_LAST_YEAR"),
            ("dim_employee", "SALES_YTD"),
            ("dim_employee", "SALES_LAST_YEAR"),
            ("dim_employee", "SALES_QUOTA"),
        ]:
            content = read_sql(f"{SCHEMA_DIR}/{table}.sql")
            assert re.search(rf"{col}\s+NUMERIC", content), f"{col} in {table} must be NUMERIC"


class TestFactDDL:
    @pytest.mark.parametrize("table", FACT_TABLES)
    def test_fact_file_exists(self, table):
        assert os.path.exists(f"{SCHEMA_DIR}/{table}.sql"), f"Missing: {SCHEMA_DIR}/{table}.sql"

    @pytest.mark.parametrize("table", FACT_TABLES)
    def test_fact_uses_create_table_if_not_exists(self, table):
        content = read_sql(f"{SCHEMA_DIR}/{table}.sql")
        assert "CREATE TABLE IF NOT EXISTS" in content

    @pytest.mark.parametrize("table", FACT_TABLES)
    def test_fact_partitioned_by_order_date_not_key(self, table):
        content = read_sql(f"{SCHEMA_DIR}/{table}.sql")
        assert "PARTITION BY ORDER_DATE" in content
        assert "PARTITION BY ORDER_DATE_KEY" not in content

    @pytest.mark.parametrize("table", FACT_TABLES)
    def test_fact_currency_key_is_string(self, table):
        content = read_sql(f"{SCHEMA_DIR}/{table}.sql")
        assert re.search(r"CURRENCY_KEY\s+STRING", content)

    @pytest.mark.parametrize("table", FACT_TABLES)
    def test_fact_monetary_columns_are_numeric(self, table):
        content = read_sql(f"{SCHEMA_DIR}/{table}.sql")
        for col in [
            "UNIT_PRICE",
            "EXTENDED_AMOUNT",
            "SALES_AMOUNT",
            "TAX_AMOUNT",
            "FREIGHT",
            "TOTAL_PRODUCT_COST",
        ]:
            assert re.search(rf"{col}\s+NUMERIC", content), f"{col} in {table} must be NUMERIC"

    def test_internet_sales_has_customer_key_not_reseller(self):
        content = read_sql(f"{SCHEMA_DIR}/fact_internet_sales.sql")
        assert "CUSTOMER_KEY" in content
        assert "RESELLER_KEY" not in content
        assert "EMPLOYEE_KEY" not in content

    def test_reseller_sales_has_reseller_and_employee_key(self):
        content = read_sql(f"{SCHEMA_DIR}/fact_reseller_sales.sql")
        assert "RESELLER_KEY" in content
        assert "EMPLOYEE_KEY" in content
        assert "CUSTOMER_KEY" not in content

    def test_internet_sales_has_20_columns(self):
        content = read_sql(f"{SCHEMA_DIR}/fact_internet_sales.sql")
        type_pattern = re.compile(
            r"^\s+\w+\s+(?:INT64|STRING|NUMERIC|DATE|DATETIME|FLOAT64)", re.MULTILINE
        )
        cols = type_pattern.findall(content)
        assert len(cols) == 20, f"Expected 20 columns, found {len(cols)}"
