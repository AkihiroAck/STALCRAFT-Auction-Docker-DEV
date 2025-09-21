#!/bin/sh
cd ./scaw
python manage.py makemigrations
python manage.py migrate
# python manage.py collectstatic --noinput
# python manage.py collectstatic --noinput --clear
python manage.py runserver 0.0.0.0:8000
# gunicorn scaw.wsgi:application --bind 0.0.0.0:8000