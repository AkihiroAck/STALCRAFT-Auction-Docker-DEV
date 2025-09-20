import os
from celery import Celery
from celery.schedules import crontab

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'scaw.settings')

app = Celery('scaw')

app.config_from_object('django.conf:settings', namespace='CELERY')

app.autodiscover_tasks()


app.conf.beat_schedule = {
    'sync-github-items-everyday': {
        'task': 'auction.tasks.sync_github_items_daily',
        'schedule': crontab(hour=16, minute=0),
    },
}
