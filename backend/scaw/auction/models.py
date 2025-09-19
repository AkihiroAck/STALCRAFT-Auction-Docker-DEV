from django.db import models


class Item(models.Model):
    item_id = models.CharField(max_length=100, unique=True)  # Уникальный ID предмета
    name = models.CharField(max_length=255)  # Название
    name_key = models.CharField(max_length=255)  # Переменное
    category = models.CharField(max_length=255)  # Категория
    color = models.CharField(max_length=255)  # Цвет
    
    def __str__(self):
        return self.name


class SaleHistory(models.Model):
    item = models.ForeignKey(Item, on_delete=models.PROTECT, related_name='sales')  # Связь с предметом
    time = models.DateTimeField()  # Время продажи
    price = models.DecimalField(max_digits=30, decimal_places=2)  # Цена за единицу
    extra_data = models.JSONField(default=dict, blank=True)  # Доп. инфо
    
    class Meta:
        indexes = [
            models.Index(fields=['item', 'time', 'price']),
        ]
        constraints = [
            models.UniqueConstraint(
                fields=['item', 'time', 'price', 'extra_data'],
                name='unique_sale_record'
            )
        ]
    
    def __str__(self):
        return f"{self.item.name}: ({self.time}) - {self.price} за шт."
