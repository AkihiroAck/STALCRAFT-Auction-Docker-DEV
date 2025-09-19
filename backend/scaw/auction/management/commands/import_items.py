import json
import os
import time
from datetime import datetime, timedelta
from django.core.management.base import BaseCommand
from django.db import transaction
from auction.models import Item

class Command(BaseCommand):
    help = """Эта команда выполняет массовую миграцию данных в модели Django, используя пакетную обработку для повышения производительности.
    Добавляет или обновляет объекты модели `Item` на основе данных из файла `items_data.json`.
    Файл должен находиться в той же директории, что и этот скрипт."""

    def handle(self, *args, **options):
        # 1. Загрузка и обработка items_data.json
        items_data = self.load_items_data()
        
        # Если ошибка при загрузке
        if items_data is None:
            return
        
        # 2. Массовое создание/обновление Items
        self.create_or_update_items(items_data)


    def load_items_data(self):
        """
        Загружает данные из файла items_data.json.
        Пробует сначала кодировку utf-8, затем cp1251, если первая не сработала.
        
        Файл должен находиться в той же директории, что и этот скрипт.

        
        :return: Список словарей с данными для создания/обновления Item или None в случае ошибки.
        """
        script_dir = os.path.dirname(os.path.abspath(__file__))  # Получаем директорию скрипта
        json_file_path = os.path.join(script_dir, 'items_data.json')  # Формируем полный путь к файлу
        
        try:
            with open(json_file_path, 'r', encoding='utf-8') as f:  # Пробуем открыть файл с кодировкой utf-8 в режиме чтения
                return json.load(f)  # Загружаем данные из JSON файла
        except UnicodeDecodeError:  # Если возникла ошибка кодировки при чтении файла
            try:
                with open(json_file_path, 'r', encoding='cp1251') as f:  # Пробуем открыть файл с кодировкой cp1251 в режиме чтения
                    return json.load(f)  # Загружаем данные из JSON файла
            except Exception as e:
                self.stderr.write(f"[{datetime.now().strftime('%H:%M:%S')}] Ошибка загрузки JSON (пробовали utf-8 и cp1251): {str(e)}")
                return None
        except Exception as e:
            self.stderr.write(f"[{datetime.now().strftime('%H:%M:%S')}] Ошибка загрузки JSON: {str(e)}")
            return None


    def create_or_update_items(self, items_data):
        """
        Обрабатывает данные items_data и массово создает/обновляет объекты Item.
        Создает новые объекты, если они не существуют, или обновляет существующие,
        если изменились их поля `name` или `category`.
        

        :param items_data: Список словарей с данными для создания/обновления Item.
        :type items_data: list[dict]
        :return: None
        """

        time_start = time.time()  # Время начало работы функции

        # Используем транзакцию для обеспечения целостности данных
        with transaction.atomic():
            # Создаем items_map словарь для быстрого доступа к данным по item_id
            items_map = {
                item['item_id']: item  # Используем item_id как ключ для быстрого доступа
                for item in items_data  # Проходим по всем элементам в items_data
                if 'item_id' in item  # Проверяем, что item_id присутствует в каждом элементе
            }
            
            # Проверяем существующие записи в базе данных
            existing = Item.objects.in_bulk(field_name='item_id')
            
            # Создаем новые объекты Item если их нет в базе данных
            to_create = []
            for item_id, data in items_map.items():  # Проходим по всем item_id в items_map
                if item_id not in existing:  # Если item_id не существует в базе данных
                    # Создаем новый объект Item с полями item_id, name и category
                    new_item = Item(
                        item_id=item_id,  # Создаем новый объект Item с полем item_id
                        name=data.get('name'),  # Получаем значение name из data
                        category=data.get('category')  # Получаем значение category из data
                    )
                    to_create.append(new_item)

                    self.stdout.write(f"Создание нового Item с item_id={item_id}:"
                                    f"\nname='{data.get('name')}',"
                                    f"\ncategory='{data.get('category')}'")
            
            # Обновляем существующие объекты Item если изменились поля name или category
            to_update = []  # Список для обновления существующих объектов
            for item_id, data in items_map.items():  # Проходим по всем item_id в items_map
                if item_id in existing:  # Если item_id уже существует в базе данных
                    item = existing[item_id]  # Получаем существующий объект Item
                    if (item.name != data.get('name') or item.category != data.get('category')):  # Если поля name или category изменились
                        self.stdout.write(f"Обновление Item с item_id={item_id}:")
                        if item.name != data.get('name'):  # Если поле name изменилось
                            self.stdout.write(f" - Изменение name: '{item.name}' -> '{data.get('name')}'")
                        if item.category != data.get('category'):  # Если поле category изменилось
                            self.stdout.write(f" - Изменение category: '{item.category}' -> '{data.get('category')}'")
                        
                        item.name = data.get('name', '')  # Обновляем поле name
                        item.category = data.get('category', '')  # Обновляем поле category

                        to_update.append(item)  # Добавляем объект в список для обновления
            
            # Пакетная обработка: массовое создание и обновление
            if to_create:  # Если есть новые объекты для создания
                Item.objects.bulk_create(to_create)
            if to_update:  # Если есть объекты для обновления
                Item.objects.bulk_update(to_update, ['name', 'category'])
            
            self.stdout.write(f"\n[{datetime.now().strftime('%H:%M:%S')}] Успешно обработано {len(items_data)} элементов."
                            f"\n\nСоздано: {len(to_create)} | Обновлено: {len(to_update)}"
                            f"\nВремя выполнения: {str(timedelta(seconds=time.time() - time_start))}\n")
