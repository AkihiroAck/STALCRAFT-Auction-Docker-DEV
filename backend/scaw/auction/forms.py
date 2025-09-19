from django import forms
from .models import SaleHistory

class SaleHistoryCreateForm(forms.ModelForm):
    price = forms.DecimalField(
        label="Цена продажи:",
        max_digits=30,
        decimal_places=2,
        min_value=0.01,
        widget=forms.NumberInput(attrs={
            'step': '0.01',
            'class': 'no-spinner form-control d-inline-block w-auto',
            'style': 'appearance: none; -moz-appearance: textfield;',
            'inputmode': 'decimal',
        })
    )
    class Meta:
        model = SaleHistory
        fields = ['price']
    