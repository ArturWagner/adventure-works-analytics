"""
Tests for DAG structure integrity — adventureworks-etl.

Verifies:
- DAG loads without import errors
- Correct task groups (load_dimensions: 11, load_facts: 2)
- All tasks have retries=2 and retry_delay=timedelta(minutes=5)
"""
from datetime import timedelta

def get_dag():
    """Load DagBag and return the adventureworks-etl DAG."""
    from airflow.models import DagBag

    db = DagBag(dag_folder="dags/", include_examples=False)
    return db, db.dags.get("adventureworks-etl")


def test_dag_loads_without_errors():
    """DAG must be importable with zero import_errors."""
    db, dag = get_dag()
    assert len(db.import_errors) == 0, f"Import errors: {db.import_errors}"
    assert dag is not None, "'adventureworks-etl' DAG not found in DagBag"


def test_dag_schedule_is_daily():
    """DAG schedule must be @daily."""
    _, dag = get_dag()
    assert dag is not None
    # Airflow normalises @daily to a cron expression or keeps the preset
    schedule = dag.schedule_interval or dag.timetable.summary if hasattr(dag, "timetable") else dag.schedule_interval
    assert schedule in ("@daily", "0 0 * * *"), f"Unexpected schedule: {schedule}"


def test_dag_has_correct_task_groups():
    """load_dimensions must have 11 tasks; load_facts must have 2 tasks."""
    _, dag = get_dag()
    assert dag is not None

    task_ids = [t.task_id for t in dag.tasks]
    dim_tasks = [t for t in task_ids if t.startswith("load_dimensions.")]
    fact_tasks = [t for t in task_ids if t.startswith("load_facts.")]

    assert len(dim_tasks) == 22, (
        f"Expected 22 tasks in load_dimensions (11 extract + 11 load), got {len(dim_tasks)}: {dim_tasks}"
    )
    assert len(fact_tasks) == 4, (
        f"Expected 4 tasks in load_facts (2 extract + 2 load), got {len(fact_tasks)}: {fact_tasks}"
    )


def test_all_tasks_have_retries():
    """Every task must have retries=2."""
    _, dag = get_dag()
    assert dag is not None

    for task in dag.tasks:
        assert task.retries == 2, f"Task {task.task_id!r} has retries={task.retries}, expected 2"


def test_all_tasks_have_retry_delay():
    """Every task must have retry_delay=timedelta(minutes=5)."""
    _, dag = get_dag()
    assert dag is not None

    expected = timedelta(minutes=5)
    for task in dag.tasks:
        assert task.retry_delay == expected, (
            f"Task {task.task_id!r} has retry_delay={task.retry_delay}, expected {expected}"
        )


def test_dag_tags():
    """DAG must have 'adventureworks' and 'etl' tags."""
    _, dag = get_dag()
    assert dag is not None
    assert "adventureworks" in dag.tags, f"Missing 'adventureworks' tag; got {dag.tags}"
    assert "etl" in dag.tags, f"Missing 'etl' tag; got {dag.tags}"


def test_config_constants():
    """dags/config.py must export the 4 required constants."""
    from dags.config import BQ_DATASET, GCP_CONN_ID, GCP_PROJECT_ID, MSSQL_CONN_ID

    assert GCP_PROJECT_ID == "unigran-tcc"
    assert BQ_DATASET == "adventureworks"
    assert MSSQL_CONN_ID == "mssql_adventureworks"
    assert GCP_CONN_ID == "google_cloud_default"
