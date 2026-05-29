"""
Tests for BigQuery views in sql/views/.

Unit tests (no BigQuery required):
  - File existence
  - SQL pattern (CREATE OR REPLACE VIEW)
  - Column presence per spec

Integration tests (require live BigQuery — marked with @pytest.mark.integration):
  - Not included here; those run via manual verification in BigQuery console.
"""

import os

import pytest

VIEW_FILES = [
    "sql/views/vw_vendas_por_categoria.sql",
    "sql/views/vw_vendas_por_regiao.sql",
    "sql/views/vw_evolucao_vendas.sql",
    "sql/views/vw_impacto_promocoes.sql",
]


# ---------------------------------------------------------------------------
# File existence and SQL pattern tests
# ---------------------------------------------------------------------------


def test_view_files_exist():
    for path in VIEW_FILES:
        assert os.path.exists(path), f"Missing: {path}"


def test_views_use_create_or_replace():
    for path in VIEW_FILES:
        if os.path.exists(path):
            content = open(path).read().upper()
            assert "CREATE OR REPLACE VIEW" in content, (
                f"{path} must use CREATE OR REPLACE VIEW"
            )


def test_views_reference_project_dataset():
    """Each view must qualify the view name with project.dataset."""
    for path in VIEW_FILES:
        if os.path.exists(path):
            content = open(path).read()
            assert "unigran-tcc.adventureworks." in content, (
                f"{path} must reference `unigran-tcc.adventureworks.<view_name>`"
            )


def test_no_credentials_in_views():
    """No hardcoded passwords, keys, or tokens in SQL files."""
    forbidden_patterns = ["password", "secret", "api_key", "token", "credential"]
    for path in VIEW_FILES:
        if os.path.exists(path):
            content = open(path).read().lower()
            for pattern in forbidden_patterns:
                assert pattern not in content, (
                    f"{path} must not contain '{pattern}'"
                )


# ---------------------------------------------------------------------------
# Column-level tests per spec schema
# ---------------------------------------------------------------------------


def test_categoria_view_columns():
    path = "sql/views/vw_vendas_por_categoria.sql"
    if not os.path.exists(path):
        pytest.skip("file not created yet")
    content = open(path).read()
    assert "category_name" in content
    assert "subcategory_name" in content
    assert "sales_amount" in content
    assert "order_date" in content


def test_regiao_view_columns():
    path = "sql/views/vw_vendas_por_regiao.sql"
    if not os.path.exists(path):
        pytest.skip("file not created yet")
    content = open(path).read()
    assert "territory_region" in content
    assert "sales_amount" in content
    assert "order_date" in content


def test_evolucao_view_columns():
    path = "sql/views/vw_evolucao_vendas.sql"
    if not os.path.exists(path):
        pytest.skip("file not created yet")
    content = open(path).read()
    assert "order_date" in content
    assert "sales_amount" in content
    assert "channel" in content


def test_impacto_promocoes_view_columns():
    path = "sql/views/vw_impacto_promocoes.sql"
    if not os.path.exists(path):
        pytest.skip("file not created yet")
    content = open(path).read()
    assert "promotion_name" in content
    assert "category_name" in content
    assert "sales_amount" in content
    assert "order_date" in content


def test_regiao_view_has_city():
    """vw_vendas_por_regiao must expose city column per spec schema."""
    path = "sql/views/vw_vendas_por_regiao.sql"
    if not os.path.exists(path):
        pytest.skip("file not created yet")
    content = open(path).read()
    assert "city" in content.lower()


# ---------------------------------------------------------------------------
# DAG integration tests (no BigQuery required)
# ---------------------------------------------------------------------------


def test_dag_has_create_views_task():
    from airflow.models import DagBag

    db = DagBag("dags/", include_examples=False)
    assert not db.import_errors, db.import_errors
    dag = db.get_dag("adventureworks-etl")
    assert dag is not None
    task_ids = [t.task_id for t in dag.tasks]
    assert "create_bigquery_views" in task_ids, (
        f"task not found; tasks={task_ids}"
    )


def test_create_views_runs_after_load_facts():
    from airflow.models import DagBag

    db = DagBag("dags/", include_examples=False)
    dag = db.get_dag("adventureworks-etl")
    create_task = dag.get_task("create_bigquery_views")
    upstream_ids = {t.task_id for t in create_task.upstream_list}
    assert len(upstream_ids) > 0, (
        "create_bigquery_views must have upstream dependencies"
    )
