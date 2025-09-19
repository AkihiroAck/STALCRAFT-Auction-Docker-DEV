from django.db.models import Q
from django.urls import reverse
from django.utils import timezone
from django.contrib import messages
from django.http import JsonResponse
from .forms import SaleHistoryCreateForm
from django.core.paginator import Paginator
from django.views.generic import CreateView
from django.shortcuts import render, get_object_or_404, redirect

from .models import SaleHistory, Item
from .constants import RANK_COLORS

from django.contrib.auth.mixins import LoginRequiredMixin


class SaleHistoryCreateView(CreateView):
    model = SaleHistory
    form_class = SaleHistoryCreateForm
    template_name = 'auction/salehistory_create.html'

    def dispatch(self, request, *args, **kwargs):
        item_id = self.kwargs['item_id']
        if item_id != 'sezonnyi_propusk':
            messages.error(request, "Создание записей разрешено только для 'sezonnyi_propusk'")
            return redirect('item-detail', item_id=item_id)
        return super().dispatch(request, *args, **kwargs)

    def get_initial(self):
        """Автоматически определяем item из URL"""
        initial = super().get_initial()
        item_id = self.kwargs['item_id']
        initial['item'] = get_object_or_404(Item, item_id=item_id)
        return initial

    def form_valid(self, form):
        # Устанавливаем item из URL параметра
        item_id = self.kwargs['item_id']
        form.instance.item = get_object_or_404(Item, item_id=item_id)
        
        # Устанавливаем автоматические поля
        form.instance.time = timezone.now().replace(microsecond=0)
        form.instance.extra_data = {}
        
        try:
            response = super().form_valid(form)
            messages.success(self.request, 'Запись о продаже успешно создана!')
            return response
        except Exception as e:
            messages.error(self.request, f'Ошибка при создании записи: {str(e)}')
            return self.form_invalid(form)


    def get_success_url(self):
        return reverse('item-detail', kwargs={'item_id': self.object.item.item_id})


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
        from django.urls import reverse
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
    MAX_LIMIT_CHECK = True  # Флаг для защиты от слишком больших запросов
    
    item = get_object_or_404(Item, item_id=item_id)  # Получаем предмет по item_id, если не найдено, возвращаем 404
    
    # Защита от слишком больших запросов
    # Проверяем, нужно ли ограничивать количество записей
    MAX_LIMIT = 50000 if MAX_LIMIT_CHECK else SaleHistory.objects.filter(item_id=item.id).order_by('-time').count()
    
    # Получаем параметр limit из запроса и проверяем его корректность
    # Если параметр limit не указан или некорректен, используем значение по умолчанию
    try:
        if MAX_LIMIT_CHECK:  # Если включена проверка максимального лимита
            # Ограничиваем значение limit до MAX_LIMIT
            # Если параметр limit указан, но больше MAX_LIMIT или некорректен, используем MAX_LIMIT
            limit = min(int(request.GET.get('limit', DEFAULT_LIMIT)), MAX_LIMIT)  
        else:
            # Если проверка максимального лимита отключена, 
            # просто используем значение по умолчанию или параметр limit из запроса
            limit = int(request.GET.get('limit', DEFAULT_LIMIT))
    except (TypeError, ValueError):  # Если параметр не указан или некорректен, используем значение по умолчанию
        limit = DEFAULT_LIMIT  # Значение по умолчанию для limit
    
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
