from asgiref.sync import sync_to_async
import time
import asyncio
import aiohttp
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


async def get_history(item: Item, session: aiohttp.ClientSession, additional: str = 'false', limit: str = '20', offset: str = '0', region: str = 'RU', total_items: int = None, current_count: int = None) -> dict:
    """
    Асинхронно получает историю аукционных цен для заданного предмета.

    Arguments:
        item (Item): Объект предмета для получения истории.
        session (aiohttp.ClientSession): Сессия для выполнения HTTP-запросов.
        additional (str): Флаг для получения дополнительных данных. "true" или "false".
        limit (str): Максимальное количество записей для получения. Максимум 200.
        offset (str): Смещение для пагинации.
        region (str): Регион сервера. Пример: "RU", "EU", "NA". По умолчанию "RU".
        total_items (int): Общее количество предметов для логирования прогресса.
        current_count (int): Текущий номер предмета для логирования прогресса.
    Returns:
        dict: JSON-ответ с историей аукционных цен.
    """
    url = f"https://eapi.stalcraft.net/{region}/auction/{item.item_id}/history"
    params = {
        "additional": str(additional).lower(),
        "limit": str(limit),
        "offset": str(offset),
    }

    prefix = f"[{current_count}/{total_items}] " if current_count and total_items else ""  # Префикс для логов прогресса

    while True:  # Бесконечный цикл для повторных попыток при ошибках
        try:
            async with session.get(url, headers=SC_HEADERS, params=params, timeout=21) as response:
                response_json = await response.json()
                if response.status != 200:
                    log(f'ERROR: {prefix}{item.name} [{item.item_id}]: Ошибка {response.status} при получении истории. Ответ: {response_json}', save=True)
                    await asyncio.sleep(10)
                    continue
                return response_json
        except Exception as e:
            log(f'ERROR: {prefix}{item.name} [{item.item_id}]: Исключение при получении истории: {str(e)}', save=True)
            await asyncio.sleep(20)


@shared_task
def start_get_history():
    """
    Запускает задачу получения истории аукциона для всех предметов.
    Обрабатывает предметы пакетами с параллельными запросами и сохраняет полученные данные.
    После завершения перезапускает саму себя через 1 секунду.

    Лимит на ~200 запросов в минуту.

    1. Определяет параметры пакетной обработки и параллельных запросов.
    2. Получает общее количество предметов и итерируется по ним пакетами.
    3. Для каждого пакета создает асинхронные задачи для получения истории.
    4. Сохраняет полученные данные в базу данных.
    5. Логирует время выполнения задачи.
    6. Перезапускает задачу через 1 секунду после завершения.
    7. Возвращает True по успешному завершению.
    """
    log("START: Задача получения истории аукциона запущена.", save=True)

    time_start = time.time()
    
    parallel_limit = 100  # Количество одновременных запросов
    pause_between_batches = 25  # Пауза между батчами в секундах

    items = list(Item.objects.order_by('id'))  # Список всех предметов
    total_items = len(items)  # Общее количество предметов
    count = 0  # Счетчик обработанных предметов

    async def main():  # Асинхронная функция для обработки пакетов предметов
        nonlocal count  # Используем внешний счетчик
        
        async with aiohttp.ClientSession() as session:  # Создаем сессию для HTTP-запросов
            for offset in range(0, total_items, parallel_limit):  # Итерируем по предметам пакетами
                sub_batch = items[offset:offset + parallel_limit]  # Текущий пакет предметов

                # Создаем задачи для получения истории
                tasks = [get_history(item, session, additional='true', limit='200', current_count=count + idx + 1, total_items=total_items) for idx, item in enumerate(sub_batch)]

                results = await asyncio.gather(*tasks)  # Выполняем задачи параллельно

                save_tasks = []  # Список задач для сохранения истории
                for idx, lots in enumerate(results):  # Обрабатываем результаты
                    item = sub_batch[idx]  # Соответствующий предмет
                    if 'total' in lots and lots.get('total') != 0:  # Проверяем наличие данных
                        # Создаем задачу для сохранения истории продаж
                        save_tasks.append(save_sale_history(item, lots.get('prices'), total_items, count + idx + 1))
                if save_tasks:  # Если есть задачи для сохранения, выполняем их параллельно
                    await asyncio.gather(*save_tasks)

                count += len(sub_batch)  # Обновляем счетчик обработанных предметов
                await asyncio.sleep(pause_between_batches)  # Пауза между пакетами

    asyncio.run(main())  # Запускаем асинхронную функцию

    # Перезапускаем всю задачу через 1 секунд
    start_get_history.apply_async(countdown=1)

    log(f"FINISH: Задача получения истории аукциона выполнена: {str(timedelta(seconds=time.time() - time_start))}\n", save=True)
    return True


async def save_sale_history(item: Item, lots: list, total_items: int, current_count: int) -> None:
    """
    Сохраняет историю продаж для заданного предмета.

    Arguments:
        item (Item): Объект предмета.
        lots (list): Список словарей с данными о продажах.
        total_items (int): Общее количество предметов для логирования прогресса.
        current_count (int): Текущий номер предмета для логирования прогресса.
    """
    while True:
        try:
            sale_records_to_create = []
            seen_in_current_batch = set()
            api_times = [parse_datetime(lot["time"]) for lot in lots]
            min_api_time = min(api_times)
            max_api_time = max(api_times)
            existing_records = await sync_to_async(list)(SaleHistory.objects.filter(
                item=item,
                time__gte=min_api_time,
                time__lte=max_api_time
            ).values_list('time', 'price', 'extra_data'))
            existing_set = {
                (time, float(price), json.dumps(extra_data, sort_keys=True))
                for time, price, extra_data in existing_records
            }
            for lot in lots:
                sale_time = parse_datetime(lot["time"])
                price_per_unit = round(lot["price"] / lot["amount"], 2)
                extra_data = lot.get("additional", {})
                record_key = (sale_time, price_per_unit, json.dumps(extra_data, sort_keys=True))
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
            if sale_records_to_create:
                def bulk_create_records():
                    with transaction.atomic():
                        created_count = len(SaleHistory.objects.bulk_create(sale_records_to_create))
                        log(f'INFO: [{current_count}/{total_items}] СОХРАНЕНО {created_count} записей для {item.name} [{item.item_id}]', save=True)
                await sync_to_async(bulk_create_records)()
            break
        except Exception as e:
            log(f'ERROR: [{current_count}/{total_items}] {item.name} [{item.item_id}]: {str(e)}', save=True)
            await asyncio.sleep(20)


@shared_task
def delete_old_sales():
    """
    Удаляет старые записи о продажах из истории аукциона.
    Оставляет минимум save_new_count новых записей и удаляет только если старых записей больше save_old_count.

    1. Определяет дату-ограничение для удаления (старше delete_days).
    2. Проходит по каждому предмету и считает количество старых и новых записей.
    3. Если старых записей больше save_old_count и новых записей больше save_new_count,
       удаляет все старые записи, оставляя минимум save_new_count новых.
    4. Логирует количество удаленных записей.
    """
    log("START: Задача удаления старых данных по истории аукциона запущена.", save=True)

    delete_days = 30 * 1  # Удалять записи старше таких дней
    save_new_count = 1000  # Оставлять минимум таких записей на предмет
    save_old_count = 500  # Удалять только если старых записей больше этого числа

    time_start = time.time()  # Засекаем время начала задачи
    older_limit = timezone.now() - timedelta(days=delete_days)  # Дата-ограничение для удаления

    total_deleted = 0  # Счетчик удаленных записей
    
    # Используем транзакцию для целостности данных
    with transaction.atomic():
        # Получаем все id предметов, у которых есть продажи
        item_ids = SaleHistory.objects.values_list('item', flat=True).distinct()

        # Проходим по каждому предмету
        for item_id in item_ids:
            # Получаем QuerySet для данного предмета
            qs = SaleHistory.objects.filter(item_id=item_id)

            # Считаем старые и новые записи
            old_count = qs.filter(time__lt=older_limit).count()  # Старые записи
            new_count = qs.filter(time__gte=older_limit).count()  # Новые записи

            # Удаляем старые записи, если условия выполнены
            if old_count >= save_old_count and new_count >= save_new_count:
                old_sales = qs.filter(time__lt=older_limit)  # QuerySet старых записей
                deleted_count, _ = old_sales.delete()  # Удаляем старые записи
                total_deleted += deleted_count  # Обновляем общий счетчик

                # Логируем результат удаления для данного предмета
                if deleted_count > 0:
                    item_obj = Item.objects.filter(id=item_id).first()  # Получаем объект предмета для логирования
                    log(f"INFO: Удалено {deleted_count} старых записей о продажах для предмета: {item_obj.name if item_obj else item_id}", save=True)

        log(f"INFO: Всего удалено {total_deleted} старых записей о продажах.", save=True)

    log(f"FINISH: Задача удаления старых данных по истории аукциона выполнена: {str(timedelta(seconds=time.time() - time_start))}\n", save=True)
    return True


@shared_task
def sync_github_items_daily():
    """
    Синхронизирует предметы из GitHub репозитория STALCRAFT Database.
    Загружает список предметов, декодирует их и массово создает или обновляет записи в базе данных.

    1. Загружает данные из GitHub репозитория.
    2. Декодирует base64 контент и парсит JSON.
    3. Подготавливает данные для массовой обработки.
    4. Вызывает функцию для массового создания или обновления предметов.
    5. Логирует время выполнения задачи.
    6. Возвращает True по успешному завершению.
    """
    log("START: Задача синхронизации предметов из GitHub запущена.", save=True)

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
                # name_key = item_info['name']['key']  # Удалено
                category = '/'.join(item_path.split('/')[2:-1])
                color = item_info.get('color', 'DEFAULT')

                processed_data.append({
                    'item_id': item_id,
                    'name': name,
                    'category': category,
                    'color': color,

                })

            except Exception as e:
                log(f"ERROR: Ошибка обработки предмета {item_info}: {e}", save=True)
                continue

        # Массовая обработка данных
        create_or_update_items(processed_data)

        log(f"FINISH: Задача синхронизации предметов выполнена: {str(timedelta(seconds=time.time() - time_start))}\n", save=True)
        return True

    except Exception as e:
        log(f"ERROR: Ошибка синхронизации: {e}", save=True)
        return False


def create_or_update_items(items_data: list[dict]) -> None:
    """
    Массово создает или обновляет предметы в базе данных.
    Arguments:
        items_data (list[dict]): Список словарей с данными о предметах.
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
                    category=data['category'],
                    color=data['color']
                ))
                log(f"INFO: ДОБАВЛЕН: {data['name']} ({item_id})", save=True)
            else:
                # Существующий предмет - проверяем изменения
                existing_item = existing_items[item_id]
                needs_update = (
                        existing_item.name != data['name'] or
                        existing_item.category != data['category'] or
                        existing_item.color != data['color']
                )

                if needs_update:
                    existing_item.name = data['name']
                    existing_item.category = data['category']
                    existing_item.color = data['color']
                    to_update.append(existing_item)
                    log(f"INFO: ОБНОВЛЕН: {data['name']} ({item_id})", save=True)

        # Выполняем массовые операции
        if to_create:
            Item.objects.bulk_create(to_create)
        if to_update:
            Item.objects.bulk_update(to_update, ['name', 'category', 'color'])

        log(f"INFO: СОЗДАНО: {len(to_create)}, ОБНОВЛЕНО: {len(to_update)}", save=True)
