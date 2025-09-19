from celery.signals import worker_ready
from auction.tasks import start_get_history


# Запускает задачу при запуске Celery
@worker_ready.connect
def start_task_on_worker_ready(sender, **kwargs):
    start_get_history.apply_async()
    