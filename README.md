# STALCRAFT-Auction-Docker

## Оглавление
1. [Описание проекта](#описание-проекта)
2. [Функционал](#функционал)
3. [Доступные страницы](#доступные-страницы)
4. [Требования](#требования)
5. [Установка и запуск](#установка-и-запуск)
   1. [Клонирование репозитория](#1-клонирование-репозитория)
   2. [Настройка переменных окружения](#2-настройка-переменных-окружения)
   3. [Запуск с помощью Docker](#3-запуск-с-помощью-docker)
   4. [Миграции базы данных и collectstatic](#4-миграции-базы-данных-и-collectstatic)
   5. [Celery](#5-celery)
6. [Остановка проекта](#остановка-проекта)
7. [Структура проекта](#структура-проекта)
8. [API интеграция](#api-интеграция)

---

## Описание проекта

**STALCRAFT-Auction-Docker** — это веб-приложение для управления аукционом, интегрированное с игровым проектом STALCRAFT.  
Проект разделен на два независимых слоя:
- **Backend (Django)**: API + сбор и хранение данных.
- **Frontend (React + Vite)**: современный интерфейс для работы с предметами и графиками.

---

### Функционал:
- **Синхронизация данных**: Автоматическое получение данных о продажах из API игрового проекта.
- **Просмотр списка предметов**: Удобный интерфейс для просмотра всех доступных предметов.
- **Поиск и фильтрация**: Возможность искать предметы по названию, категории и другим параметрам.
- **История продаж**: Отслеживание истории продаж предметов. Просмотр до 5 000 последних продаж для одного предмета с удобным фильтром по цене и редкости предмета.
- **Сжатие ответов**: Включено gzip-сжатие API-ответов (Django `GZipMiddleware`) и brotli/gzip для статических файлов через WhiteNoise.
- **Интеграция цен в игровой интерфейс**: Пользователь может загрузить файл предметов из игры (`ru.lang`) и получает изменённый файл, где для каждого предмета указана средняя цена за выбранный период. Эти цены будут отображаться рядом с предметами в игре.

---

### Доступные страницы:
- [http://localhost:5173/items](http://localhost:5173/items) - React-страница списка предметов с поиском, категориями и подкатегориями.
- [http://localhost:5173/items/<item_id>](http://localhost:5173/items/9mmq) - React-страница графика истории продаж предмета.
- [http://localhost:5173/upload-lang](http://localhost:5173/upload-lang) - Загрузка ru.lang и получение файла со средними ценами.
- [http://localhost:5173/admin-panel](http://localhost:5173/admin-panel) - Админ-панель мониторинга Celery (запуск, остановка, активные задачи, live-логи).

---

## Требования

Для запуска проекта вам понадобятся:
- [**Docker**](https://www.docker.com/get-started/)

---

## Установка и запуск

### 1. Клонирование репозитория
Склонируйте репозиторий на ваш локальный компьютер:
```bash
git clone https://github.com/AkihiroAck/STALCRAFT-Auction-Docker.git
cd STALCRAFT-Auction-Docker
```

### 2. Настройка переменных окружения
Создайте файл `.env` в корневой папке (рядом с `docker-compose.yml`) и настройте его под ваши нужды:
```
# Django
SECRET_KEY=django-insecure-key
DEBUG = False

DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_PASSWORD=1234

# STALCRAFT
STALCRAFT_CLIENT_ID=SECRET_ID
STALCRAFT_CLIENT_SECRET=SECRET_KEY
STALCRAFT_DATABASE_LISTING=https://raw.githubusercontent.com/EXBO-Studio/stalcraft-database/main/ru/listing.json

# PostgreSQL
POSTGRES_DATABASE_NAME=POSTGRESQL_DATABASE_NAME
POSTGRES_USERNAME=db_user
POSTGRES_PASSWORD=db_password
POSTGRES_HOST=db
POSTGRES_PORT=5432

# pgAdmin
PGADMIN_EMAIL=admin@admin.com
PGADMIN_PASSWORD=1234

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_DB=0
```

Примечание:
- `STALCRAFT_CLIENT_ID` и `STALCRAFT_CLIENT_SECRET` - Получаются от разработчиков игры. Нужны для получения историй продаж (`start_get_history`).
- `STALCRAFT_DATABASE_LISTING` - URL до [listing.json](https://github.com/EXBO-Studio/stalcraft-database/blob/main/ru/listing.json) (список предметов). Рекомендуется `raw .../main/ru/listing.json`, чтобы всегда получать актуальные категории и пути.

### 3. Запуск с помощью Docker
Для запуска всех сервисов выполните:
```bash
docker-compose build
docker-compose up
```

После успешного запуска:
- Frontend будет доступен по адресу: [localhost:5173](http://localhost:5173)
- Backend API будет доступен по адресу: [localhost:8000/auction/api](http://localhost:8000/auction/api/items/)
- pgAdmin: [localhost:5050](http://localhost:5050) (логин и пароль указаны в `.env`)

Примечание для разработки фронта:
- Изменения в файлах `frontend/src/*` применяются автоматически в Docker (hot-reload) без пересборки образа.
- Если контейнер `frontend` запущен, достаточно просто сохранить файл — страница обновится сама.

Доступ в админ-панель:
- Выполняется через Django-пользователя с правами `is_staff`/`superuser`.
- Учетная запись создается из переменных `DJANGO_SUPERUSER_USERNAME` и `DJANGO_SUPERUSER_PASSWORD` при старте backend.

Мониторинг Celery в админ-панели:
- Отображает workers, активные/ожидающие задачи, список доступных задач для ручного запуска.
- Поддерживает остановку активной задачи (`revoke terminate`).
- Логи показываются в реальном времени (polling каждые 2 секунды) для `app`, `worker`, `beat`.

### 4. Миграции базы данных и collectstatic
Миграции и collectstatic выполняются автоматически с помощью [`backend/entrypoint_web.sh`](backend/entrypoint_web.sh)
```bash
python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic --noinput
gunicorn scaw.wsgi:application --bind 0.0.0.0:8000
```

### 5. Celery
Celery запускается автоматически с помощью `command` в `docker-compose.yml`.
Запускается после миграции. Проверка миграции происходит в [`backend/entrypoint_celery.sh`](backend/entrypoint_celery.sh) с помощью [`backend/wait_for_migrations.py`](backend/wait_for_migrations.py)

Celery используется для фоновых задач, таких как: 
- **Синхронизация данных (`sync_github_items_daily`)** - Проверяет наличие новых или обновленных предметов с помощью api запроса `STALCRAFT_DATABASE_LISTING`. Запускается при первом запуске проекта и каждый день 16:00 (UTC+0) и сохраняет их в базу данных.
- **Получение историй последних продаж (`start_get_history`)** - Делает запрос на сервер игры и получает историю последних 200 продаж. Сохраняет в базу данных только новые продажи. Запускается при запуске проекта и повторяется после завершения цикла.

---

## Остановка проекта
Для остановки выберите один из вариантов:

1. Для остановки всех контейнеров выполните:
```bash
docker-compose stop
```

2. Для остановки и удаления всех контейнеров выполните:
```bash
docker-compose down
```

3. Для остановки и удаления всех контейнеров и volume выполните:  
```bash
docker-compose down -v
```

---

## Структура проекта
- **backend/** — исходный код серверной части.
  - **scaw/** — корневая Django-папка проекта.
    - **auction/** — приложение для работы с аукционом (модели, вьюхи, логика).
    - **scaw/** — настройки Django (urls.py, settings.py, wsgi.py и др.).
    - **static/** — статические файлы проекта (CSS, JS, изображения).
    - **templates/** — HTML-шаблоны для отображения страниц.
    - **manage.py** — основной скрипт для управления Django (миграции, запуск сервера, команды).
  - **auction_item.sql** — Backup с начальными данными предметов, используется для первичного наполнения базы при первом запуске.
  - **auction_salehistory.sql** — Backup историей продаж предметов, используется для первичного наполнения базы при первом запуске.
  - **Dockerfile** — инструкция сборки Docker-образа для backend.
  - **entrypoint_celery.sh** — скрипт запуска Celery внутри контейнера.
  - **entrypoint_web.sh** — скрипт запуска веб-приложения (Django + Gunicorn).
  - **requirements.txt** — список зависимостей Python-пакетов.
- **frontend/** — отдельный React-клиент.
  - **src/pages/** — страницы списка предметов, графика и загрузки ru.lang.
  - **src/components/** — переиспользуемые UI-компоненты (категории, поиск).
  - **src/api.js** — клиент для работы с Django API.
- **docker-compose.yml** — конфигурация для запуска всех сервисов (PostgreSQL, Redis, backend, Celery) через Docker Compose.
- **.env** — файл с переменными окружения (секреты, ключи, настройки БД и др.).

---

## API интеграция
Приложение интегрируется с игровым проектом STALCRAFT через API. Данные о продажах синхронизируются ежедневно с помощью цикличной задачи Celery. Для настройки API используйте переменные `STALCRAFT_CLIENT_ID`, `STALCRAFT_CLIENT_SECRET` в `.env`. Без них от функции в Celery `start_get_history` вы получите ошибку - `{'title': 'Unauthorized', 'status': 401, 'details': {}}`

---

## Производительность API продаж

- Максимальный лимит API продаж ограничен до `5000` (backend и frontend).
- Для API-ответов включено gzip-сжатие через Django middleware.
- Для статических файлов включена поддержка gzip/brotli через WhiteNoise.
- Для reverse proxy подготовлен пример конфига с gzip+brotli: `deploy/nginx/api-proxy.conf`.

### Индексация SaleHistory

- Добавлен индекс для быстрого чтения последних продаж по предмету: `(item_id, time DESC)`.
- Миграция: `backend/scaw/auction/migrations/0001_salehistory_item_time_index.py`.
