# STALCRAFT-Auction-Docker

## Описание проекта

**STALCRAFT-Auction-Docker** — это веб-приложение для управления аукционом, интегрированное с игровым проектом STALCRAFT. Приложение автоматически получает данные о продажах из внешнего API и предоставляет удобный интерфейс для просмотра, поиска и управления этими данными.

### Основной функционал:
- **Синхронизация данных**: Автоматическое получение данных о продажах из API игрового проекта.
- **Просмотр списка предметов**: Удобный интерфейс для просмотра всех доступных предметов.
- **Поиск и фильтрация**: Возможность искать предметы по названию, категории и другим параметрам.
- **История продаж**: Отслеживание истории продаж предметов. Просмотр до 50 000 последних продаж для одного предмета с удобным фильтром по цене и редкости предмета.
- **Интеграция цен в игровой интерфейс**: Пользователь может загрузить файл предметов из игры (`ru.lang`) и получает изменённый файл, где для каждого предмета указана средняя цена за выбранный период. Эти цены будут отображаться рядом с предметами в игре.

---

### Доступные страницы:
- [/auction/items/](www.localhost:8000/auction/items/) - Список всех предметов.

- [/auction/items/<item_id>/](www.localhost:8000/auction/items/9mmq/) - Информация о продажах определённого предмета.

- [/auction/upload-lang/](www.localhost:8000/auction/upload-lang/) - Пользователь загружает файл предметов из игры и получает обратно файл с добавленными средними ценами за выбранный период.

---

## Требования

Для запуска проекта вам понадобятся:
- **Docker** и **Docker Compose**

---

## Установка и запуск

### 1. Клонирование репозитория
Склонируйте репозиторий на ваш локальный компьютер:
```bash
git clone https://github.com/your-repo/STALCRAFT-Auction-Docker.git
cd STALCRAFT-Auction-Docker
```

### 2. Настройка переменных окружения
Скопируйте файл .env и настройте его под ваши нужды:
```
# Django
SECRET_KEY=django-insecure-key
DEBUG = False

# STALCRAFT
STALCRAFT_CLIENT_ID=SECRET_ID
STALCRAFT_CLIENT_SECRET=SECRET_KEY
STALCRAFT_DATABASE_LISTING=https://api.github.com/repos/EXBO-Studio/stalcraft-database/git/blobs/3a471a2d1325d8694405e1eec6af7a27fca96e53

# PostgreSQL
POSTGRES_DATABASE_NAME=POSTGRESQL_DATABASE_NAME
POSTGRES_USERNAME=db_user
POSTGRES_USER_PASSWORD=db_password
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
- `STALCRAFT_DATABASE_LISTING` - api.github для получения [listing.json](https://github.com/EXBO-Studio/stalcraft-database/blob/main/ru/listing.json) (список предметов)

### 3. Запуск с помощью Docker
Для запуска всех сервисов выполните:
```bash
docker-compose build --no-cache
docker-compose up
```

или
```bash
docker-compose build --no-cache && docker-compose up
```

Если нужно запустить на фоне:
```bash
docker-compose build --no-cache && docker-compose up -d
```

После успешного запуска:
- Приложение будет доступно по адресу: www.localhost:8000
- pgAdmin: www.localhost:5050 (логин и пароль указаны в .env)

### 4. Миграции базы данных и collectstatic
Миграции и collectstatic выполняются автоматически с помощью `backend\entrypoint_web.sh`
```bash
python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic --noinput --clear
gunicorn scaw.wsgi:application --bind 0.0.0.0:8000
```

### 5. Celery
Celery запускается автоматически с помощью command в `docker-compose.yml`.
Запускается после миграции.

Celery используется для фоновых задач, таких как: 
- **Синхронизация данных (`sync_github_items_daily`)** - Проверяет наличие новых или обновленных предметов с помощью api запроса `STALCRAFT_DATABASE_LISTING`. Запускается при первом запуске проекта и каждый день 16:00 (UTC+0) и сохраняет их в базу данных.
- **Получение историй последних продаж (`start_get_history`)** - Делает запрос на сервер игры и получает историю последних 200 продаж. Сохраняет в базу данных только новые продажи.

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
  - **Dockerfile** — инструкция сборки Docker-образа для backend.
  - **entrypoint_celery.sh** — скрипт запуска Celery внутри контейнера.
  - **entrypoint_web.sh** — скрипт запуска веб-приложения (Django + Gunicorn).
  - **requirements.txt** — список зависимостей Python-пакетов.
  - **wait_for_migrations.py** — вспомогательный скрипт, который дожидается применения миграций перед запуском Celery (используется в `entrypoint_celery.sh`).
- **docker-compose.yml** — конфигурация для запуска всех сервисов (PostgreSQL, Redis, backend, Celery) через Docker Compose.
- **.env** — файл с переменными окружения (секреты, ключи, настройки БД и др.).

---

## API интеграция
Приложение интегрируется с игровым проектом STALCRAFT через API. Данные о продажах синхронизируются ежедневно с помощью цикличной задачи Celery. Для настройки API используйте переменные STALCRAFT_CLIENT_ID, STALCRAFT_CLIENT_SECRET в .env.

