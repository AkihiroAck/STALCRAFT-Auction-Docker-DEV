import os
import sys
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator


PROJECT_ROOT = "/opt/app/backend/scaw"
if PROJECT_ROOT not in sys.path:
    sys.path.append(PROJECT_ROOT)

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "scaw.settings")

import django

django.setup()

from auction.tasks import delete_old_sales, start_get_history, sync_github_items_daily


def _run_sync_github() -> None:
    sync_github_items_daily()


def _run_start_get_history() -> None:
    start_get_history()


def _run_delete_old_sales() -> None:
    delete_old_sales()


# DAG для начальной синхронизации с GitHub (запускается автоматически при первом развертывании)
with DAG(
    dag_id="auction_sync_github_startup",
    start_date=datetime(2024, 1, 1),
    schedule="@once",
    catchup=False,
    max_active_runs=1,
    tags=["auction", "bootstrap"],
    default_view="graph",
) as dag_sync_startup:
    sync_task = PythonOperator(
        task_id="sync_github_items_startup",
        python_callable=_run_sync_github,
        pool="auction_pool",
        pool_slots=1,
        priority_weight=100,  # Самый высокий приоритет для первоначальной загрузки
    )
    
    # После первой синхронизации запустить непрерывное получение истории
    trigger_history = TriggerDagRunOperator(
        task_id="trigger_continuous_history",
        trigger_dag_id="auction_history_continuous",
        wait_for_completion=False,
        pool="auction_pool",
        pool_slots=1,
        priority_weight=100,
    )
    
    sync_task >> trigger_history


# DAG для непрерывного получения истории продаж (самозапускающийся)
with DAG(
    dag_id="auction_history_continuous",
    start_date=datetime(2024, 1, 1),
    schedule=None,  # Запускается только через триггер, не по расписанию
    catchup=False,
    max_active_runs=1,  # Только один run одновременно
    tags=["auction", "history"],
    default_view="graph",
) as dag_history:
    fetch_task = PythonOperator(
        task_id="fetch_and_save_sale_history",
        python_callable=_run_start_get_history,
        pool="auction_pool",
        pool_slots=1,
        priority_weight=1,  # Низкий приоритет - уступает другим задачам
        execution_timeout=timedelta(minutes=33),  # Прерывает задачу если выполняется дольше 33 минут
        retries=0,  # Не перезапускать при таймауте
    )
    
    # Триггер для перезапуска самого себя после завершения
    trigger_self = TriggerDagRunOperator(
        task_id="trigger_next_run",
        trigger_dag_id="auction_history_continuous",
        wait_for_completion=False,  # Не ждать завершения, сразу встать в очередь
        pool="auction_pool",
        pool_slots=1,
        priority_weight=1,  # Низкий приоритет
    )
    
    fetch_task >> trigger_self


# DAG для ежедневной синхронизации с GitHub
with DAG(
    dag_id="auction_sync_github_daily",
    start_date=datetime(2024, 1, 1),
    schedule="0 16 * * *",
    catchup=False,
    max_active_runs=1,
    tags=["auction", "sync"],
    default_view="graph",
) as dag_sync_daily:
    PythonOperator(
        task_id="sync_github_items_daily",
        python_callable=_run_sync_github,
        pool="auction_pool",
        pool_slots=1,
        priority_weight=10,  # Высокий приоритет - вытесняет history
    )


# DAG для еженедельного удаления старых записей о продажах
with DAG(
    dag_id="auction_delete_old_sales_weekly",
    start_date=datetime(2024, 1, 1),
    schedule="0 3 * * 1",
    catchup=False,
    max_active_runs=1,
    tags=["auction", "cleanup"],
    default_view="graph",
) as dag_delete_weekly:
    PythonOperator(
        task_id="delete_old_sales_weekly",
        python_callable=_run_delete_old_sales,
        pool="auction_pool",
        pool_slots=1,
        priority_weight=10,  # Высокий приоритет - вытесняет history
    )
