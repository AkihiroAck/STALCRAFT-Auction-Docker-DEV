import time
import requests
import os
import json
import base64
from dotenv import load_dotenv
from celery import shared_task
from auction.models import SaleHistory, Item
from django.utils.dateparse import parse_datetime
from datetime import timedelta
from django.utils import timezone
from django.db import transaction
from auction.logger import log



load_dotenv()

STALCRAFT_CLIENT_ID = os.getenv('STALCRAFT_CLIENT_ID')
STALCRAFT_CLIENT_SECRET = os.getenv('STALCRAFT_CLIENT_SECRET')
STALCRAFT_DATABASE_LISTING = os.getenv('STALCRAFT_DATABASE_LISTING')

SC_HEADERS = {
    'Content-Type': 'application/json',
    'Client-Id': STALCRAFT_CLIENT_ID,
    'Client-Secret': STALCRAFT_CLIENT_SECRET,
}


def get_history(item, additional: str = 'false', limit: str = '20', offset: str = '0', region: str = 'RU') -> dict:
    """
    Получает историю аукционных цен по указанному предмету для заданного региона.

    Формирует запрос к API Stalcraft, подставляя в URL параметры пути: регион и идентификатор предмета.
    Остальные параметры передаются как query-параметры.

    пример удачного ответа с limit = 1:
    {'total': 5861, 'prices': [{'amount': 1, 'price': 1500000, 'time': '2025-06-14T11:30:12Z', 'additional': {}}}

    
    :param item:
        Item - Объект предмета из БД.
    :param additional: str, по умолчанию "false"
        Флаг для включения дополнительной информации о лотах. Принимает строковые значения "true" или "false".
    :param limit: str, по умолчанию "20"
        Количество возвращаемых цен. Минимальное значение 0, максимальное 200.
    :param offset: str, по умолчанию "0"
        Количество записей, которые нужно пропустить в начале списка.
    :param region: str, по умолчанию "RU"
        Регион, для которого нужно получить историю. Пример: "RU", "EU", "NA".
    :return: dict
        Ответ API, преобразованный из JSON-формата в словарь Python.
    """
    
    while True:  # Цикл для повторной попытки в случае ошибки
        try:
            url = f"https://eapi.stalcraft.net/{region}/auction/{item.item_id}/history"
            params = {
                "additional": str(additional).lower(),
                "limit": str(limit),
                "offset": str(offset),
            }

            response = requests.get(url, headers=SC_HEADERS, params=params, timeout=21)
            response_json = response.json()

            if response.status_code != 200:  # Если не успешный статус ответа
                log(f'ERROR: (response.status_code != 200) {item.name} [{item.item_id}]: {response_json}', save=True)
                time.sleep(5)
                continue  # Повторить запрос

            return response_json
        except requests.exceptions.RequestException as e:
            log(f'ERROR: (requests) {item.name} [{item.item_id}]: {str(e)}', save=True)
            time.sleep(20)
        except Exception as e:
            log(f'ERROR: {item.name} [{item.item_id}]: {str(e)}', save=True)
            time.sleep(20)


@shared_task
def start_get_history():
    """
    Задача для получения истории продаж предметов из аукциона.
    """
    
    time_start = time.time()

    batch_size=1000
    
    total_items = Item.objects.count()  # Получаем общее количество предметов

    count = 0
    
    # Обрабатываем пакетами
    for offset in range(0, total_items, batch_size):
        
        # Получаем текущий пакет предметов
        items = Item.objects.order_by('id')[offset:offset + batch_size]
        
        for item in items:
            count += 1
            while True:
                try:
                    lots = get_history(item, additional='true', limit='200')
                    
                    if 'total' in lots and lots.get('total') != 0:
                        save_sale_history(item, lots.get('prices'), total_items, count)
                    
                    # time.sleep(0.8)  # Задержка между запросами к API (по умолчанию 0.8)

                    break
                except Exception as e:
                    log(f"ERROR: {item.name} [{item.item_id}]: {str(e)}", save=True)
                    time.sleep(20)
    
    # Перезапускаем всю задачу через 1 секунд
    start_get_history.apply_async(countdown=1)
    
    return f"FINISH: Задача выполнена: {str(timedelta(seconds=time.time() - time_start))}\n"


def save_sale_history(item, lots, total_items, current_count):
    """
    Сохраняет данные о продажах в базу данных.
    Проверяет уникальность по time, price И extra_data.
    
    :param item: Item - Объект предмета
    :param lots: list - Список лотов
    :param total_items: int - Общее количество предметов
    :param current_count: int - Номер данного предмета
    """
    
    while True:
        try:
            sale_records_to_create = []  # Список для хранения записей, которые нужно создать
            seen_in_current_batch = set()  # Для отслеживания дубликатов внутри текущего batches
            
            # Определяем временной диапазон данных от API
            api_times = [parse_datetime(lot["time"]) for lot in lots]
            min_api_time = min(api_times)
            max_api_time = max(api_times)
            
            # Загружаем существующие записи из БД только для этого диапазона
            existing_records = SaleHistory.objects.filter(
                item=item,
                time__gte=min_api_time,
                time__lte=max_api_time
            ).values_list('time', 'price', 'extra_data')
                        
            # Создаем множество для проверки
            existing_set = {
                (time, float(price), json.dumps(extra_data, sort_keys=True))
                for time, price, extra_data in existing_records
            }

            # Фильтруем лоты: оставляем только новые
            for lot in lots:
                sale_time = parse_datetime(lot["time"])
                price_per_unit = round(lot["price"] / lot["amount"], 2)
                extra_data = lot.get("additional", {})
                
                # Ключ для проверки
                record_key = (sale_time, price_per_unit, json.dumps(extra_data, sort_keys=True))
                
                # Пропускаем дубликаты
                if record_key in seen_in_current_batch or record_key in existing_set:
                    continue
                
                seen_in_current_batch.add(record_key)
                
                sale_records_to_create.append(
                    SaleHistory(
                        item=item,
                        time=sale_time,
                        price=price_per_unit,
                        extra_data=extra_data
                    )
                )
    
            # Если есть записи для сохранения, делаем bulk_create
            if sale_records_to_create:
                with transaction.atomic():
                    created_count = len(SaleHistory.objects.bulk_create(
                        sale_records_to_create,
                        # ignore_conflicts=True  # На случай, если дубликаты появились параллельно, сохранить все кроме дубликатов без вызова ошибки
                    ))
                    log(f'INFO: [{current_count}/{total_items}] СОХРАНЕНО {created_count} записей для {item.name} [{item.item_id}]', save=True)
                
            break  # Выходим из цикла, если успешно обработали лот

        except Exception as e:
            log(f'ERROR: [{current_count}/{total_items}] {item.name} [{item.item_id}]: {str(e)}', save=True)
            time.sleep(20)


@shared_task
def delete_old_sales():
    """Удаляет старые записи о продажах, старше 2 лет."""

    time_start = time.time()
    older_limit = timezone.now() - timedelta(days=365 * 2)
    
    with transaction.atomic():
        old_sales = SaleHistory.objects.filter(time__lt=older_limit)
        deleted_count, _ = old_sales.delete()
        log(f"INFO: Удалено {deleted_count} старых записей о продажах.", save=True)
        return f"FINISH: Задача удаления старых данных по истории аукциона выполнена: {str(timedelta(seconds=time.time() - time_start))}\n"


@shared_task
def sync_github_items_daily():
    """Ежедневная синхронизация предметов из GitHub с массовой обработкой"""

    time_start = time.time()

    try:
        url = STALCRAFT_DATABASE_LISTING
        response = requests.get(url)

        if response.status_code != 200:
            log(f"ERROR: Ошибка запроса: {response.status_code}", save=True)
            return False

        data = response.json()

        # Декодируем base64 контент
        content = base64.b64decode(data['content']).decode('utf-8')
        items_data = json.loads(content)

        # Подготавливаем данные для массовой обработки
        processed_data = []
        for item_info in items_data:
            try:
                item_path = item_info['data']

                item_id = item_path.split('/')[-1].replace('.json', '')
                name = item_info['name']['lines']['ru']
                name_key = item_info['name']['key']
                category = '/'.join(item_path.split('/')[2:-1])
                color = item_info.get('color', 'DEFAULT')

                processed_data.append({
                    'item_id': item_id,
                    'name': name,
                    'name_key': name_key,
                    'category': category,
                    'color': color,

                })

            except Exception as e:
                log(f"ERROR: Ошибка обработки предмета {item_info}: {e}", save=True)
                continue

        # Массовая обработка данных
        create_or_update_items(processed_data)

        return f"FINISH: Задача выполнена: {str(timedelta(seconds=time.time() - time_start))}\n"

    except Exception as e:
        log(f"ERROR: Ошибка синхронизации: {e}", save=True)
        return False


def create_or_update_items(items_data):
    """
    Массово создает/обновляет объекты Item
    """
    with transaction.atomic():
        # Создаем словарь для быстрого доступа к данным по item_id
        items_map = {
            item['item_id']: item
            for item in items_data
            if 'item_id' in item
        }

        # Получаем существующие записи
        existing_items = Item.objects.in_bulk(field_name='item_id')

        # Подготавливаем списки для массовых операций
        to_create = []
        to_update = []

        # Обрабатываем каждый элемент
        for item_id, data in items_map.items():
            if item_id not in existing_items:
                # Новый предмет
                to_create.append(Item(
                    item_id=item_id,
                    name=data['name'],
                    name_key=data['name_key'],
                    category=data['category'],
                    color=data['color']
                ))
                log(f"INFO: ДОБАВЛЕН: {data['name']} ({item_id})", save=True)
            else:
                # Существующий предмет - проверяем изменения
                existing_item = existing_items[item_id]
                needs_update = (
                        existing_item.name != data['name'] or
                        existing_item.name_key != data['name_key'] or
                        existing_item.category != data['category'] or
                        existing_item.color != data['color']
                )

                if needs_update:
                    existing_item.name = data['name']
                    existing_item.name_key = data['name_key']
                    existing_item.category = data['category']
                    existing_item.color = data['color']
                    to_update.append(existing_item)
                    log(f"INFO: ОБНОВЛЕН: {data['name']} ({item_id})", save=True)

        # Выполняем массовые операции
        if to_create:
            Item.objects.bulk_create(to_create)
        if to_update:
            Item.objects.bulk_update(to_update, ['name', 'name_key', 'category', 'color'])

        log(f"INFO: СОЗДАНО: {len(to_create)}, ОБНОВЛЕНО: {len(to_update)}", save=True)
