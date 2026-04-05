import os
from celery import Celery
from celery.schedules import crontab

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'scaw.settings')

app = Celery('scaw')

app.config_from_object('django.conf:settings', namespace='CELERY')

app.autodiscover_tasks()

# Настройка периодических задач
app.conf.beat_schedule = {
    'sync-github-items-everyday': {  # Ежедневная синхронизация GitHub-элементов
        'task': 'auction.tasks.sync_github_items_daily',  # Задача для выполнения
        'schedule': crontab(hour=16, minute=0),  # Каждый день в 16:00
    },
    'delete-old-sales-weekly': {  # Еженедельное удаление старых продаж
        'task': 'auction.tasks.delete_old_sales',  # Задача для выполнения
        'schedule': crontab(hour=3, minute=0, day_of_week='mon'),  # Каждый понедельник в 03:00
    },
}
