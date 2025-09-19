import os
from celery import Celery
# В первую очередь мы импортируем библиотеку для взаимодействия с операционной системой и саму библиотеку Celery.


# Второй строчкой мы связываем настройки Django с настройками Celery через переменную окружения.
from celery.schedules import crontab

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'scaw.settings')


# Далее мы создаем экземпляр приложения Celery и устанавливаем для него файл конфигурации.
app = Celery('scaw')


# Мы также указываем пространство имен, чтобы Celery сам находил все необходимые
# настройки в общем конфигурационном файле settings.py.
# Он их будет искать по шаблону «CELERY_***».
app.config_from_object('django.conf:settings', namespace='CELERY')


# Последней строчкой мы указываем Celery автоматически искать задания в файлах tasks.py каждого приложения проекта.
app.autodiscover_tasks()


# Добавление периодических заданий
# app.conf.beat_schedule = {
#     'delete_old_sales': {  # Задача для удаления старых продаж
#         'task': 'auction.tasks.delete_old_sales',
#         'schedule': crontab(minute='0', hour='0'),  # Запускать задачу каждый день в 4 часа утра
#     },
# }
