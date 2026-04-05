import datetime
import json
import os
import io
import re
import hashlib
from pathlib import Path
from django.db import connection, models
from django.conf import settings
from django.urls import reverse
from django.utils import timezone
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.http import JsonResponse, HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET, require_POST
from django.core.paginator import Paginator
from django.views.generic import CreateView
from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.mixins import LoginRequiredMixin
from PIL import Image
import requests

from scaw.celery import app as celery_app
from .models import SaleHistory, Item
from .forms import SaleHistoryCreateForm
from .constants import RANK_COLORS


DEFAULT_LIMIT = 100
MAX_LIMIT = 50000
ALLOWED_MANUAL_TASKS = {
    'auction.tasks.sync_github_items_daily',
    'auction.tasks.delete_old_sales',
    'auction.tasks.start_get_history',
}
ICON_CATEGORY_RE = re.compile(r'^[a-z0-9_\-/]+$')
ICON_ITEM_ID_RE = re.compile(r'^[a-z0-9_\-]+$', re.IGNORECASE)


def _serialize_item(item):
    return {
        'id': item.id,
        'item_id': item.item_id,
        'name': item.name,
        'category': item.category,
        'color': RANK_COLORS.get(item.color, RANK_COLORS['DEFAULT']),
        'rank': item.color,
        'icon_url': f"https://github.com/EXBO-Studio/stalcraft-database/raw/main/ru/icons/{item.category}/{item.item_id}.png",
    }


def _build_category_tree(items_data):
    tree = {}

    for item in items_data:
        category_parts = item['category'].split('/')
        node = tree

        for part in category_parts:
            node.setdefault(part, {'_children': {}, '_count': 0})
            node[part]['_count'] += 1
            node = node[part]['_children']

    def pack(node):
        packed = []

        for name in sorted(node.keys()):
            data = node[name]
            packed.append({
                'name': name,
                'count': data['_count'],
                'children': pack(data['_children']),
            })

        return packed

    return pack(tree)


def _get_json_body(request):
    try:
        return json.loads(request.body.decode('utf-8') or '{}')
    except (json.JSONDecodeError, UnicodeDecodeError):
        return {}


def _ensure_staff(request):
    if not request.user.is_authenticated:
        return JsonResponse({'detail': 'Authentication required'}, status=401)

    if not request.user.is_staff:
        return JsonResponse({'detail': 'Admin access required'}, status=403)

    return None


def _tail_lines(file_path, lines=200):
    if not os.path.exists(file_path):
        return []

    with open(file_path, 'r', encoding='utf-8', errors='replace') as fp:
        content = fp.readlines()

    return [line.rstrip('\n') for line in content[-lines:]]


@require_GET
def api_item_icon_thumb(request, category, item_id):
    if not ICON_CATEGORY_RE.match(category) or not ICON_ITEM_ID_RE.match(item_id):
        return HttpResponse(status=400)

    try:
        size = int(request.GET.get('size', 56))
    except (TypeError, ValueError):
        size = 56

    size = min(max(size, 16), 256)

    cache_dir = Path(settings.BASE_DIR) / 'icon_cache'
    thumb_dir = cache_dir / 'thumbs'
    source_dir = cache_dir / 'source'
    thumb_dir.mkdir(parents=True, exist_ok=True)
    source_dir.mkdir(parents=True, exist_ok=True)

    source_key = hashlib.sha1(f'{category}|{item_id}'.encode('utf-8')).hexdigest()
    thumb_key = hashlib.sha1(f'{category}|{item_id}|{size}'.encode('utf-8')).hexdigest()
    source_file = source_dir / f'{source_key}.png'
    missing_marker = source_dir / f'{source_key}.missing'
    cache_file = thumb_dir / f'{thumb_key}.webp'

    cache_headers = {
        'Cache-Control': 'public, max-age=2592000, immutable, stale-while-revalidate=86400',
        'Vary': 'Accept',
        'ETag': thumb_key,
    }

    if cache_file.exists():
        with cache_file.open('rb') as fp:
            return HttpResponse(fp.read(), content_type='image/webp', headers=cache_headers)

    # Do not hammer upstream for icons that are known missing.
    missing_ttl_seconds = 6 * 60 * 60
    if missing_marker.exists():
        marker_age = datetime.datetime.now().timestamp() - missing_marker.stat().st_mtime
        if marker_age < missing_ttl_seconds:
            return HttpResponse(
                status=404,
                headers={'Cache-Control': 'public, max-age=300, stale-while-revalidate=300'},
            )

    source_url = f'https://github.com/EXBO-Studio/stalcraft-database/raw/main/ru/icons/{category}/{item_id}.png'

    try:
        if source_file.exists():
            source_bytes = source_file.read_bytes()
        else:
            source_response = requests.get(source_url, timeout=12)
            if source_response.status_code == 404:
                missing_marker.touch(exist_ok=True)
                return HttpResponse(
                    status=404,
                    headers={'Cache-Control': 'public, max-age=300, stale-while-revalidate=300'},
                )
            if source_response.status_code != 200:
                return HttpResponse(status=502)

            source_bytes = source_response.content
            source_file.write_bytes(source_bytes)
            if missing_marker.exists():
                missing_marker.unlink(missing_ok=True)

        with Image.open(io.BytesIO(source_bytes)) as img:
            img = img.convert('RGBA')
            img.thumbnail((size, size), Image.Resampling.LANCZOS)

            out = io.BytesIO()
            img.save(out, format='WEBP', quality=64, method=6)
            data = out.getvalue()

        with cache_file.open('wb') as fp:
            fp.write(data)

        return HttpResponse(data, content_type='image/webp', headers=cache_headers)
    except Exception:
        return HttpResponse(status=500)


@require_GET
def api_auth_me(request):
    user = request.user

    if not user.is_authenticated:
        return JsonResponse(
            {
                'authenticated': False,
                'is_staff': False,
                'is_superuser': False,
                'username': None,
            }
        )

    return JsonResponse(
        {
            'authenticated': True,
            'is_staff': user.is_staff,
            'is_superuser': user.is_superuser,
            'username': user.username,
        }
    )


@csrf_exempt
@require_POST
def api_auth_login(request):
    body = _get_json_body(request)
    username = body.get('username', '').strip()
    password = body.get('password', '')

    user = authenticate(request, username=username, password=password)
    if user is None:
        return JsonResponse({'detail': 'Invalid username or password'}, status=400)

    if not user.is_staff:
        return JsonResponse({'detail': 'Admin access required'}, status=403)

    login(request, user)

    return JsonResponse(
        {
            'ok': True,
            'username': user.username,
            'is_staff': user.is_staff,
            'is_superuser': user.is_superuser,
        }
    )


@csrf_exempt
@require_POST
def api_auth_logout(request):
    logout(request)
    return JsonResponse({'ok': True})


@require_GET
def api_admin_celery_overview(request):
    denied = _ensure_staff(request)
    if denied:
        return denied

    inspector = celery_app.control.inspect(timeout=1.0)

    active = inspector.active() or {}
    reserved = inspector.reserved() or {}
    scheduled = inspector.scheduled() or {}
    registered = inspector.registered() or {}
    stats = inspector.stats() or {}

    workers = sorted(set(active.keys()) | set(reserved.keys()) | set(scheduled.keys()) | set(stats.keys()))

    running_tasks = []
    for worker_name, worker_tasks in active.items():
        for task in worker_tasks:
            running_tasks.append(
                {
                    'worker': worker_name,
                    'id': task.get('id'),
                    'name': task.get('name'),
                    'args': task.get('args'),
                    'kwargs': task.get('kwargs'),
                    'time_start': task.get('time_start'),
                }
            )

    pending_tasks = []
    for worker_name, worker_tasks in reserved.items():
        for task in worker_tasks:
            pending_tasks.append(
                {
                    'worker': worker_name,
                    'id': task.get('id'),
                    'name': task.get('name'),
                    'args': task.get('args'),
                    'kwargs': task.get('kwargs'),
                    'state': 'reserved',
                }
            )

    for worker_name, worker_tasks in scheduled.items():
        for task in worker_tasks:
            request_data = task.get('request', {})
            pending_tasks.append(
                {
                    'worker': worker_name,
                    'id': request_data.get('id'),
                    'name': request_data.get('name'),
                    'args': request_data.get('args'),
                    'kwargs': request_data.get('kwargs'),
                    'eta': task.get('eta'),
                    'state': 'scheduled',
                }
            )

    return JsonResponse(
        {
            'workers': workers,
            'running_tasks': running_tasks,
            'pending_tasks': pending_tasks,
            'registered_tasks': registered,
            'stats': stats,
            'manual_tasks': sorted(ALLOWED_MANUAL_TASKS),
        }
    )


@csrf_exempt
@require_POST
def api_admin_celery_start_task(request):
    denied = _ensure_staff(request)
    if denied:
        return denied

    body = _get_json_body(request)
    task_name = body.get('task_name')
    args = body.get('args', [])
    kwargs = body.get('kwargs', {})

    if task_name not in ALLOWED_MANUAL_TASKS:
        return JsonResponse({'detail': 'Task is not allowed for manual start'}, status=400)

    if not isinstance(args, list) or not isinstance(kwargs, dict):
        return JsonResponse({'detail': 'Invalid args or kwargs payload'}, status=400)

    result = celery_app.send_task(task_name, args=args, kwargs=kwargs)

    return JsonResponse({'ok': True, 'task_id': result.id, 'task_name': task_name})


@csrf_exempt
@require_POST
def api_admin_celery_stop_task(request):
    denied = _ensure_staff(request)
    if denied:
        return denied

    body = _get_json_body(request)
    task_id = body.get('task_id')
    terminate = bool(body.get('terminate', True))
    signal_name = body.get('signal', 'SIGTERM')

    if not task_id:
        return JsonResponse({'detail': 'task_id is required'}, status=400)

    celery_app.control.revoke(task_id, terminate=terminate, signal=signal_name)

    return JsonResponse({'ok': True, 'task_id': task_id, 'terminate': terminate})


@require_GET
def api_admin_celery_logs(request):
    denied = _ensure_staff(request)
    if denied:
        return denied

    source = request.GET.get('source', 'app')
    try:
        lines = int(request.GET.get('lines', 250))
    except (TypeError, ValueError):
        lines = 250

    lines = min(max(lines, 20), 2000)

    log_map = {
        'app': os.path.join(settings.BASE_DIR, 'logs.log'),
        'worker': os.getenv('CELERY_WORKER_LOG_FILE', '/tmp/celery_worker.log'),
        'beat': os.getenv('CELERY_BEAT_LOG_FILE', '/tmp/celery_beat.log'),
    }

    selected_path = log_map.get(source)
    if not selected_path:
        return JsonResponse({'detail': 'Unknown log source'}, status=400)

    content = _tail_lines(selected_path, lines=lines)

    return JsonResponse(
        {
            'source': source,
            'path': selected_path,
            'lines': content,
            'exists': os.path.exists(selected_path),
        }
    )


@require_GET
def api_items(request):
    search = request.GET.get('search', '').strip()
    category_prefix = request.GET.get('category', '').strip()
    page = request.GET.get('page', 1)
    try:
        page_size = int(request.GET.get('page_size', 120))
    except (TypeError, ValueError):
        page_size = 120

    page_size = min(max(page_size, 1), 500)

    items = Item.objects.all().order_by('name')

    if search:
        items = items.filter(
            models.Q(name__icontains=search)
            | models.Q(category__icontains=search)
            | models.Q(item_id__icontains=search)
        ).distinct()

    if category_prefix:
        items = items.filter(category__startswith=category_prefix)

    paginator = Paginator(items, page_size)
    page_obj = paginator.get_page(page)

    return JsonResponse(
        {
            'items': [_serialize_item(item) for item in page_obj],
            'has_next': page_obj.has_next(),
            'page': page_obj.number,
            'page_size': page_size,
            'total': paginator.count,
        }
    )


@require_GET
def api_items_all(request):
    items = Item.objects.all().order_by('name')

    return JsonResponse(
        {
            'items': [_serialize_item(item) for item in items],
            'categories': _build_category_tree(items.values('category')),
        }
    )


@require_GET
def api_item_suggest(request):
    query = request.GET.get('q', '').strip()
    try:
        limit = int(request.GET.get('limit', 8))
    except (TypeError, ValueError):
        limit = 8

    limit = min(max(limit, 1), 20)

    if not query:
        return JsonResponse({'items': []})

    items = (
        Item.objects.filter(name__icontains=query)
        .order_by('name')
        .values('item_id', 'name', 'category')[:limit]
    )

    return JsonResponse({'items': list(items)})


@require_GET
def api_item_detail(request, item_id):
    item = get_object_or_404(Item, item_id=item_id)

    return JsonResponse(
        {
            'item': _serialize_item(item),
            'max_limit': MAX_LIMIT,
        }
    )


@require_GET
def api_item_sales(request, item_id):
    item = get_object_or_404(Item, item_id=item_id)

    try:
        limit = min(int(request.GET.get('limit', DEFAULT_LIMIT)), MAX_LIMIT)
    except (TypeError, ValueError):
        limit = DEFAULT_LIMIT

    limit = max(2, limit)

    sales = (
        SaleHistory.objects.filter(item_id=item.id)
        .order_by('-time')
        .values('id', 'price', 'time', 'extra_data', 'item__name', 'item__color')[:limit]
    )

    return JsonResponse(
        {
            'sales': list(sales),
            'colors': RANK_COLORS,
        }
    )


@csrf_exempt
def api_process_lang_file(request):
    return process_lang_file(request)


def item_list_view(request):
    """
    Просмотр списка предметов с поиском и пагинацией.
    Поддерживает параметр search для поиска по name, category, item_id.
    Поддерживает параметр page для пагинации (50 предметов на страницу).
    Если запрос AJAX - возвращает JSON, иначе рендерит HTML-шаблон.
    """
    page = request.GET.get('page', 1)
    search = request.GET.get('search', '')
    
    items = Item.objects.all().order_by('id')
    
    if search:
        items = items.filter(
            models.Q(name__icontains=search) |
            models.Q(category__icontains=search) |
            models.Q(item_id__icontains=search)
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
    
    return render(request, 'auction/items_list.html')


def item_detail_view(request, item_id):
    """
    Просмотр деталей предмета и его истории продаж.
    Поддерживает параметр limit для ограничения количества записей в истории.
    Если запрос AJAX - возвращает JSON, иначе рендерит HTML-шаблон.
    """
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
    - берём все названия из файла
    - ищем Item по этим названиям
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

    # все названия предметов из файла
    names = [line.split("=", 1)[1] for line in lines if "=" in line]

    # загрузка Items одним запросом
    items = Item.objects.filter(name__in=names).values("id", "name")
    name_to_id = {i["name"]: i["id"] for i in items}
    if not name_to_id:
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
        cursor.execute(query_avg, [list(name_to_id.values()), date_from])
        rows = cursor.fetchall()

    prices_map = {item_id: avg for item_id, avg in rows}

    # --- fallback: последняя продажа до периода ---
    missing_ids = [i for i in name_to_id.values() if i not in prices_map]
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
        item_id = name_to_id.get(value)
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


class SaleHistoryCreateView(CreateView, LoginRequiredMixin):
    """
    Представление для создания записи о продаже.
    """
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
        # Устанавливает item из URL
        item_id = self.kwargs['item_id']
        form.instance.item = get_object_or_404(Item, item_id=item_id)
        
        # Устанавливает автоматические поля
        form.instance.time = timezone.now().replace(microsecond=0)
        form.instance.extra_data = {}
        
        try:
            response = super().form_valid(form)
            messages.success(self.request, 'Запись о продаже успешно создана!')
            return response
        except Exception as e:
            messages.error(self.request, f'Ошибка при создании записи: {str(e)}')
            return self.form_invalid(form)
