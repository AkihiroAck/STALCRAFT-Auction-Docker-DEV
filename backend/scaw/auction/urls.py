from django.urls import path
from django.views.generic import RedirectView
from . import views


urlpatterns = [
    path('', RedirectView.as_view(pattern_name='item-list', permanent=True)),

    path('api/auth/me/', views.api_auth_me, name='api-auth-me'),
    path('api/auth/login/', views.api_auth_login, name='api-auth-login'),
    path('api/auth/logout/', views.api_auth_logout, name='api-auth-logout'),

    path('api/items/', views.api_items, name='api-items'),
    path('api/items/all/', views.api_items_all, name='api-items-all'),
    path('api/items/suggest/', views.api_item_suggest, name='api-item-suggest'),
    path('api/items/<str:item_id>/', views.api_item_detail, name='api-item-detail'),
    path('api/items/<str:item_id>/sales/', views.api_item_sales, name='api-item-sales'),
    path('api/process-lang/', views.api_process_lang_file, name='api_process_lang'),
    path('api/admin/celery/overview/', views.api_admin_celery_overview, name='api-admin-celery-overview'),
    path('api/admin/celery/tasks/start/', views.api_admin_celery_start_task, name='api-admin-celery-start-task'),
    path('api/admin/celery/tasks/stop/', views.api_admin_celery_stop_task, name='api-admin-celery-stop-task'),
    path('api/admin/celery/logs/', views.api_admin_celery_logs, name='api-admin-celery-logs'),

    path('items/', views.item_list_view, name='item-list'),
    path('items/<str:item_id>/', views.item_detail_view, name='item-detail'),
    path('items/<str:item_id>/sale/create/', views.SaleHistoryCreateView.as_view(), name='salehistory-create'),
    path('process-lang/', views.process_lang_file, name='process_lang'),
    path('upload-lang/', views.upload_lang_page, name='upload_lang'),
]
