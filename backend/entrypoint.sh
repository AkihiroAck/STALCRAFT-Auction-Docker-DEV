#!/bin/sh
cd ./scaw
python  manage.py makemigrations
python  manage.py migrate
#python  manage.py import_items
python  manage.py runserver 0.0.0.0:8000