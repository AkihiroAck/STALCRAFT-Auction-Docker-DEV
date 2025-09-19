#!/bin/sh
python wait_for_migrations.py
cd /usr/src/app/scaw
exec "$@"