import json
import pathlib
import datetime

import airflow
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
import os

img_name = os.getenv("AIRFLOW__KUBERNETES__WORKER_CONTAINER_REPOSITORY")
img_tag = os.getenv("AIRFLOW__KUBERNETES__WORKER_CONTAINER_TAG")
img = "%s:%s" % (img_name, img_tag)


def _failure_alert():
    print("failed")


dag = DAG(
    dag_id="process_etl_linear",
    start_date=airflow.utils.dates.days_ago(10),
    schedule_interval=datetime.timedelta(hours=6),
    default_args={"on_failure_callback": _failure_alert},
    description='Example Dag to show ETL with linear tasks',
    concurrency=5,
    tags=[
        "team=data-platform",
        "domain=data-platform",
        "capability=jobs",
        "owner=@user5",
        "name=linear-etl"
    ]
)

upload_input_to_s3 = BashOperator(
    task_id="upload_input_to_s3",
    bash_command="echo upload to s3",
    dag=dag,
)


def _convert_to_parquet():
    print("convert raw to parquet")


convert_to_parquet = PythonOperator(
    task_id="convert_to_parquet",
    python_callable=_convert_to_parquet,
    dag=dag,
)


def _load_into_database():
    print("save data to a table")


load_into_database = PythonOperator(
    task_id="load_into_database",
    python_callable=_load_into_database,
    dag=dag,
    executor_config={"KubernetesExecutor": {"image": img}},
)

summary = BashOperator(
    task_id="summary",
    bash_command='echo "Finished processing input file"',
    dag=dag,
    executor_config={"KubernetesExecutor": {"image": img}},
)

upload_input_to_s3 >> convert_to_parquet >> load_into_database >> summary
