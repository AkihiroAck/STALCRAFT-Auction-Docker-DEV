import datetime
import json
import os
from django.db import connection, models
from django.utils import timezone
from django.contrib.auth import authenticate, login, logout
from django.http import JsonResponse, HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET, require_POST
from django.core.paginator import Paginator
from django.shortcuts import get_object_or_404
from django.conf import settings

from scaw.celery import app as celery_app
from .models import SaleHistory, Item
from .constants import RANK_COLORS


DEFAULT_LIMIT = 100
MAX_LIMIT = 2000
ALLOWED_MANUAL_TASKS = {
    'auction.tasks.sync_github_items_daily',
    'auction.tasks.delete_old_sales',
    'auction.tasks.start_get_history',
}


def _serialize_item(item):
    return {
        'id': item.id,
        'item_id': item.item_id,
        'name': item.name,
        'category': item.category,
        'color': RANK_COLORS.get(item.color, RANK_COLORS['DEFAULT']),
        'rank': item.color,
        'has_sales': bool(getattr(item, 'has_sales', False)),
        'icon_url': f"https://github.com/EXBO-Studio/stalcraft-database/raw/main/ru/icons/{item.category}/{item.item_id}.png",
    }


def _with_sales_flag(queryset):
    return queryset.annotate(
        has_sales=models.Exists(
            SaleHistory.objects.filter(item_id=models.OuterRef('pk'))
        )
    )


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

    # Read only the file tail to avoid expensive full-file reads on frequent polling.
    max_bytes = 512 * 1024
    chunk_size = 8192

    with open(file_path, 'rb') as fp:
        fp.seek(0, os.SEEK_END)
        file_size = fp.tell()
        read_size = min(file_size, max_bytes)
        data = b''

        while read_size > 0 and data.count(b'\n') <= lines:
            current_chunk = min(chunk_size, read_size)
            read_size -= current_chunk
            fp.seek(read_size)
            data = fp.read(current_chunk) + data

    content = data.decode('utf-8', errors='replace').splitlines()
    return content[-lines:]


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

    active = {}
    reserved = {}
    scheduled = {}
    registered = {}
    stats = {}
    celery_error = None

    try:
        inspector = celery_app.control.inspect(timeout=1.0)
        active = inspector.active() or {}
        reserved = inspector.reserved() or {}
        scheduled = inspector.scheduled() or {}
        registered = inspector.registered() or {}
        stats = inspector.stats() or {}
    except Exception as exc:
        celery_error = str(exc)

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

    beat_schedule = []
    beat_schedule_raw = celery_app.conf.beat_schedule or {}
    for name, entry in beat_schedule_raw.items():
        beat_schedule.append(
            {
                'name': name,
                'task': entry.get('task'),
                'schedule': str(entry.get('schedule')),
                'args': entry.get('args', []),
                'kwargs': entry.get('kwargs', {}),
            }
        )

    beat_schedule.sort(key=lambda item: item['name'])

    return JsonResponse(
        {
            'workers': workers,
            'running_tasks': running_tasks,
            'pending_tasks': pending_tasks,
            'beat_schedule': beat_schedule,
            'registered_tasks': registered,
            'stats': stats,
            'manual_tasks': sorted(ALLOWED_MANUAL_TASKS),
            'celery_available': celery_error is None,
            'celery_error': celery_error,
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

    items = _with_sales_flag(Item.objects.all()).order_by('name')

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
    items = _with_sales_flag(Item.objects.all()).order_by('name')

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
        _with_sales_flag(Item.objects.filter(name__icontains=query))
        .order_by('name')
        .values('item_id', 'name', 'category', 'color', 'has_sales')[:limit]
    )

    return JsonResponse(
        {
            'items': [
                {
                    'item_id': item['item_id'],
                    'name': item['name'],
                    'category': item['category'],
                    'rank': item['color'],
                    'color': RANK_COLORS.get(item['color'], RANK_COLORS['DEFAULT']),
                    'has_sales': bool(item.get('has_sales', False)),
                }
                for item in items
            ]
        }
    )


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
