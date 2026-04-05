from celery.signals import worker_ready
from auction.tasks import start_get_history, sync_github_items_daily


# Запускает задачу при запуске Celery
@worker_ready.connect
def start_task_on_worker_ready(sender, **kwargs):
    sync_github_items_daily.apply_async()
    start_get_history.apply_async()
    