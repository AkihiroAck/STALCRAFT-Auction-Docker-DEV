#!/bin/bash
set -e

# Ожидание готовности PostgreSQL
if [ "$1" = "webserver" ] || [ "$1" = "scheduler" ]; then
    echo "Waiting for PostgreSQL..."
    until pg_isready -h db -p 5432 -U ${POSTGRES_USERNAME}; do
        echo "PostgreSQL is unavailable - sleeping"
        sleep 1
    done
    echo "PostgreSQL is up"
fi

# Создание пула (только для scheduler, idempotent операция)
if [ "$1" = "scheduler" ]; then
    echo "Ensuring auction_pool exists..."
    airflow pools list 2>/dev/null | grep -q "auction_pool" || {
        echo "Creating auction_pool with 1 slot..."
        airflow pools set auction_pool 1 "Pool for sequential auction tasks execution"
        echo "auction_pool created successfully"
    }
fi

# Запуск Airflow
exec airflow "$@"
