import json
import pathlib

import airflow
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.exceptions import AirflowSkipException
from airflow.operators.latest_only import LatestOnlyOperator
from airflow.operators.python_operator import PythonOperator, BranchPythonOperator

dag = DAG(
    dag_id="load-transaction",
    start_date=airflow.utils.dates.days_ago(2),
    schedule_interval=None,
    description='Loads Transaction Data',
    tags=[
        "team=bookkeepers",
        "domain=transaction",
        "capability=onlinebanking",
        "owner=@user2",
        "name=load-transaction"
    ]
)

start_transaction_job = BashOperator(
    task_id="start-transaction",
    bash_command="echo start transaction",
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

down_stream_check = LatestOnlyOperator(
    task_id="send-latest-only-to-downstream",
    dag=dag
)

send_to_downstream = BashOperator(
    task_id='send-to-downstream',
    bash_command="echo send to downstream",
    dag=dag,
)

(start_transaction_job >> run_after_business_dates >> download_eod_file >> write_to_table >> save_in_data_lake
 >> down_stream_check >> send_to_downstream)
