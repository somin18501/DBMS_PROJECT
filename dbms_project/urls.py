"""dbms_project URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from . import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('',views.HomePage,name="HomePage"),

    path('showCustomer',views.showcust,name="showcust"),
    path('Insertcust',views.Insertcust,name="Insertcust"),
    path('Edit/<int:id>',views.Editcust,name="Editcust"),
    path('Update/<int:id>',views.updatecust,name="updatecust"),
    path('Delete/<int:id>',views.Delcust,name="Delcust"),
    path('Sort',views.sortCustomer,name="sortCustomer"),

    path('showProduct',views.showpro,name="showpro"),
    path('Insertpro',views.Insertpro,name="Insertpro"),
    path('Edit2/<int:id>',views.Editpro,name="Editpro"),
    path('Update2/<int:id>',views.updatepro,name="updatepro"),
    path('Delete2/<int:id>',views.Delpro,name="Delpro"),
    path('Sort2',views.sortProduct,name="sortProduct"),

    path('Set/<int:id>',views.Setalert,name="Setalert"),
    path('Seealert/<int:id>',views.showcustalerts,name="showcustalerts"),
    path('Delete3/<int:id>',views.Delalert,name="Delalert"),
    path('runQuery',views.runQuery,name="runQuery"),
]
