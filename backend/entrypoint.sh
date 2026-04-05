#!/bin/sh
cd ./scaw
python manage.py makemigrations
python manage.py migrate

# Первоначальное заполнение базы данных, для работы демо-версии
# ITEM_COUNT=$(PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USERNAME -d $POSTGRES_DATABASE_NAME -t -c "SELECT COUNT(*) FROM public.auction_item" | tr -d ' ')
# SALEHISTORY_COUNT=$(PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USERNAME -d $POSTGRES_DATABASE_NAME -t -c "SELECT COUNT(*) FROM public.auction_salehistory" | tr -d ' ')

# if [ "$SALEHISTORY_COUNT" -eq "0" ] && [ "$ITEM_COUNT" -eq "0" ]; then
#     PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USERNAME -d $POSTGRES_DATABASE_NAME -f ../auction_item.sql
#     PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USERNAME -d $POSTGRES_DATABASE_NAME -f ../auction_salehistory.sql
# fi

# Создать суперпользователя, если он не существует
python manage.py shell <<'PY'
import os
from django.contrib.auth import get_user_model

User = get_user_model()
username = os.environ.get('DJANGO_SUPERUSER_USERNAME')
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD')

if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username=username, password=password)
PY

# Запускаем celery worker в фоне
celery -A scaw worker -l INFO &
WORKER_PID=$! # Сохраняем PID этого процесса

# Запускаем celery beat в фоне
celery -A scaw beat -l INFO &
BEAT_PID=$! # Сохраняем PID этого процесса

# python manage.py collectstatic --noinput
# python manage.py collectstatic --noinput --clear
python manage.py runserver 0.0.0.0:8000
# gunicorn scaw.wsgi:application --bind 0.0.0.0:8000


# Когда контейнер завершается, убиваем оба процесса по их PID
trap "kill $WORKER_PID $BEAT_PID" EXIT