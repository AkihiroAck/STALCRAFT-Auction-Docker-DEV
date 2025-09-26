import datetime
from django.db.models import Q
from django.db import connection
from django.urls import reverse
from django.utils import timezone
from django.contrib import messages
from django.http import JsonResponse, HttpResponse
from django.core.paginator import Paginator
from django.views.generic import CreateView
from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.mixins import LoginRequiredMixin

from .models import SaleHistory, Item
from .forms import SaleHistoryCreateForm
from .constants import RANK_COLORS


def item_list_view(request):
    page = request.GET.get('page', 1)
    search = request.GET.get('search', '')
    
    items = Item.objects.all().order_by('id')
    
    if search:
        items = items.filter(
            Q(name__icontains=search) |
            Q(category__icontains=search) |
            Q(item_id__icontains=search)
        ).distinct()
    
    paginator = Paginator(items, 50)
    page_obj = paginator.get_page(page)
    
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        data = {
            'items': [{
                'id': item.id,
                'item_id': item.item_id,
                'name': item.name,
                'category': item.category,
                'color': RANK_COLORS[item.color],
                'url': reverse('item-detail', args=[item.item_id])
            } for item in page_obj],
            'has_next': page_obj.has_next()
        }
        return JsonResponse(data)
    
    return render(request, 'auction/items_list.html', {
        'items': page_obj,
        'search_query': search
    })


def item_detail_view(request, item_id):
    DEFAULT_LIMIT = 100  # Значение по умолчанию для limit
    MAX_LIMIT = 50000  # Максимально допустимое значение для limit
    
    item = get_object_or_404(Item, item_id=item_id)  # Получаем предмет по item_id, если не найдено, возвращаем 404
    
    # Получаем параметр limit из запроса и проверяем его корректность
    # Если параметр limit не указан или некорректен, используем значение по умолчанию
    try:
        # Ограничиваем значение limit до MAX_LIMIT
        limit = min(int(request.GET.get('limit', DEFAULT_LIMIT)), MAX_LIMIT)
    except (TypeError, ValueError):
        limit = DEFAULT_LIMIT
    
    # Получаем историю продаж с лимитом
    sales = SaleHistory.objects.filter(item_id=item.id).order_by('-time')[:limit]

    # Если запрос AJAX - возвращаем JSON
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        # Преобразуем QuerySet в список словарей для JSON
        sales = list(sales.values('id', 'price', 'time', 'extra_data', 'item__name', 'item__color'))
        return JsonResponse({
            'sales': sales,
            'colors': RANK_COLORS,
        })
    
    # Если не AJAX - возвращаем HTML-шаблон
    return render(request, 'auction/item_detail.html', {
        'item': item,
        'max_limit': MAX_LIMIT,
    })


def process_lang_file(request):
    """
    Обработка загруженного ru.lang файла:
    - берём все name_key из файла
    - ищем Item по этим ключам
    - считаем среднюю цену за последние N месяцев (через SQL)
    - если продаж нет, используем последнюю доступную цену до указанного периода
    - возвращаем новый файл с добавленными строками
    """
    if request.method != "POST" or "file" not in request.FILES:
        return HttpResponse("Загрузите файл методом POST с полем 'file'", status=400)

    # Сколько месяцев брать (по умолчанию 1, максимум 3)
    months = int(request.POST.get("months", 1))
    months = max(1, min(3, months))
    date_from = timezone.now() - datetime.timedelta(days=30 * months)

    file = request.FILES["file"]
    lines = file.read().decode("utf-8").splitlines()
    output_lines = lines.copy()
    output_lines.append("")  # пустая строка-разделитель

    # все ключи вида item.wpn.xxx.name
    keys = [line.split("=", 1)[0] for line in lines if "=" in line]

    # загрузка Items одним запросом
    items = Item.objects.filter(name_key__in=keys).values("id", "name_key")
    items_map = {i["id"]: i["name_key"] for i in items}
    if not items_map:
        return HttpResponse("В файле нет предметов из базы", status=400)

    # --- основной запрос: средняя цена за N месяцев ---
    query_avg = """
        WITH filtered AS (
            SELECT sh.item_id, sh.price
            FROM auction_salehistory sh
            JOIN auction_item i ON sh.item_id = i.id
            WHERE sh.item_id = ANY(%s)
              AND sh.time >= %s
              AND i.category NOT LIKE 'artefact%%'
        ),
        bounds AS (
            SELECT item_id,
                   percentile_cont(0.25) WITHIN GROUP (ORDER BY price) AS q1,
                   percentile_cont(0.75) WITHIN GROUP (ORDER BY price) AS q3
            FROM filtered
            GROUP BY item_id
        )
        SELECT f.item_id, AVG(f.price) AS avg_price
        FROM filtered f
        JOIN bounds b ON f.item_id = b.item_id
        WHERE f.price BETWEEN (b.q1 - 4 * (b.q3 - b.q1))
                          AND (b.q3 + 4 * (b.q3 - b.q1))
        GROUP BY f.item_id;
    """

    with connection.cursor() as cursor:
        cursor.execute(query_avg, [list(items_map.keys()), date_from])
        rows = cursor.fetchall()

    prices_map = {item_id: avg for item_id, avg in rows}

    # --- fallback: последняя продажа до периода ---
    missing_ids = [i for i in items_map.keys() if i not in prices_map]
    if missing_ids:
        query_last = """
            SELECT DISTINCT ON (sh.item_id) sh.item_id, sh.price
            FROM auction_salehistory sh
            JOIN auction_item i ON sh.item_id = i.id
            WHERE sh.item_id = ANY(%s)
              AND sh.time < %s
              AND i.category NOT LIKE 'artefact%%'
            ORDER BY sh.item_id, sh.time DESC;
        """
        with connection.cursor() as cursor:
            cursor.execute(query_last, [missing_ids, date_from])
            rows = cursor.fetchall()
        for item_id, price in rows:
            prices_map[item_id] = price  # последняя цена

    # --- сборка выходного файла ---
    for line in lines:
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        item_id = next((id_ for id_, k in items_map.items() if k == key), None)
        if not item_id:
            continue
        avg_price = prices_map.get(item_id)
        if avg_price:
            formatted_price = f"{int(avg_price):,}".replace(",", " ")
            output_lines.append(f"{key}={value}\\n{formatted_price} руб.")

    response = HttpResponse("\n".join(output_lines), content_type="text/plain; charset=utf-8")
    response["Content-Disposition"] = 'attachment; filename="ru.lang"'
    return response


def upload_lang_page(request):
    return render(request, "auction/upload_lang.html")


# class SaleHistoryCreateView(CreateView):
#     model = SaleHistory
#     form_class = SaleHistoryCreateForm
#     template_name = 'auction/salehistory_create.html'

#     def dispatch(self, request, *args, **kwargs):
#         item_id = self.kwargs['item_id']
#         if item_id != 'sezonnyi_propusk':
#             messages.error(request, "Создание записей разрешено только для 'sezonnyi_propusk'")
#             return redirect('item-detail', item_id=item_id)
#         return super().dispatch(request, *args, **kwargs)

#     def get_initial(self):
#         """Автоматически определяем item из URL"""
#         initial = super().get_initial()
#         item_id = self.kwargs['item_id']
#         initial['item'] = get_object_or_404(Item, item_id=item_id)
#         return initial

#     def form_valid(self, form):
#         # Устанавливает item из URL
#         item_id = self.kwargs['item_id']
#         form.instance.item = get_object_or_404(Item, item_id=item_id)
        
#         # Устанавливает автоматические поля
#         form.instance.time = timezone.now().replace(microsecond=0)
#         form.instance.extra_data = {}
        
#         try:
#             response = super().form_valid(form)
#             messages.success(self.request, 'Запись о продаже успешно создана!')
#             return response
#         except Exception as e:
#             messages.error(self.request, f'Ошибка при создании записи: {str(e)}')
#             return self.form_invalid(form)


#     def get_success_url(self):
#         return reverse('item-detail', kwargs={'item_id': self.object.item.item_id})