from django.urls import path
from django.views.generic import RedirectView
from . import views

urlpatterns = [
    path('', RedirectView.as_view(pattern_name='item-list', permanent=True)),

    path('items/', views.item_list_view, name='item-list'),
    path('items/<str:item_id>/', views.item_detail_view, name='item-detail'),
    path('items/<str:item_id>/sale/create/', views.SaleHistoryCreateView.as_view(), name='salehistory-create'),
]
