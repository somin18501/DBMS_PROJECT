from django import forms
from .models import CustomerModel, ProductModel

class Customerforms(forms.ModelForm):
    class Meta:
        model=CustomerModel
        fields="__all__"

class Productforms(forms.ModelForm):
    class Meta:
        model=ProductModel
        fields="__all__"