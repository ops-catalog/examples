import json
import pathlib

import airflow
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.exceptions import AirflowSkipException
from airflow.operators.latest_only import LatestOnlyOperator
from airflow.operators.python_operator import PythonOperator, BranchPythonOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.operators.dummy import DummyOperator

dag = DAG(
    dag_id="load-balance",
    start_date=airflow.utils.dates.days_ago(2),
    schedule_interval="@daily",
    description='Loads EOD Balance data and triggers other dags',
    tags=[
        "team=accountants",
        "domain=accounts",
        "capability=onlinebanking",
        "owner=@user1",
        "name=load-balance"
    ]
)

start_balance_job = BashOperator(
    task_id="start-balance",
    bash_command="echo load balance",
    dag=dag,
)


def _choose_business_date(execution_date):
    day_of_week = execution_date.weekday()
    if day_of_week == 5 or day_of_week == 6:
        raise AirflowSkipException()


run_after_business_dates = PythonOperator(
    task_id='run-after-business-dates',
    provide_context=True,
    python_callable=_choose_business_date
)

download_eod_file = BashOperator(
    task_id="read-eod-file",
    bash_command="echo read eod file",
    dag=dag,
)

write_to_table = BashOperator(
    task_id="write-to-table",
    bash_command="echo write to online store",
    dag=dag,
)

save_in_data_lake = BashOperator(
    task_id='save-in-data-lake',
    bash_command='echo save to data lake',
    dag=dag,
)

trigger_dependencies = TriggerDagRunOperator(
    task_id='trigger-transaction-load-job',
    trigger_dag_id='load-transaction',
    dag=dag
)

down_stream_check = LatestOnlyOperator(
    task_id="send-latest-only-to-downstream",
    dag=dag
)

send_to_downstream = BashOperator(
    task_id='send-to-downstream',
    bash_command="echo send to downstream",
    dag=dag,
)

join_before_close = DummyOperator(
    task_id='join_tasks',
    trigger_rule='none_failed'
)


def _send_metrics(**context):
    print("send metrics")


send_metrics = PythonOperator(
    task_id='send-run-metrics',
    provide_context=True,
    python_callable=_send_metrics
)

save_in_data_lake >> [trigger_dependencies, down_stream_check]
down_stream_check >> send_to_downstream
start_balance_job >> run_after_business_dates >> download_eod_file >> write_to_table >> save_in_data_lake
[send_to_downstream, trigger_dependencies] >> join_before_close >> send_metrics
