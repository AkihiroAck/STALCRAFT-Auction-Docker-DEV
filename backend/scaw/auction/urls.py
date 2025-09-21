from django.urls import path
from django.views.generic import RedirectView
from . import views


urlpatterns = [
    path('', RedirectView.as_view(pattern_name='item-list', permanent=True)),

    path('items/', views.item_list_view, name='item-list'),
    path('items/<str:item_id>/', views.item_detail_view, name='item-detail'),
    # path('items/<str:item_id>/sale/create/', views.SaleHistoryCreateView.as_view(), name='salehistory-create'),
    path('process-lang/', views.process_lang_file, name='process_lang'),
    path('upload-lang/', views.upload_lang_page, name='upload_lang'),
]
