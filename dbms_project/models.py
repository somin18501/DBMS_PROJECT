from django.db import models

class CustomerModel(models.Model):
    cust_id=models.BigIntegerField(primary_key=True)
    cust_name=models.CharField(max_length=30)
    cust_pass=models.CharField(max_length=8,null=False)
    dob=models.DateField()
    pin_code=models.IntegerField()
    email=models.CharField(max_length=255)
    phone_num=models.BigIntegerField()
    class Meta:
        db_table="Customer"

class ProductModel(models.Model):
    pro_id=models.BigIntegerField(primary_key=True)
    pro_name=models.CharField(max_length=255,null=False)
    price=models.IntegerField(null=False)
    dept_name=models.CharField(max_length=255,null=False)
    brand_name=models.CharField(max_length=255,null=False)
    plat_name=models.CharField(max_length=255,null=False)
    disc_rate=models.IntegerField()
    ratings=models.DecimalField(max_digits=2,decimal_places=1)
    class Meta:
        db_table="product"

class AlertModel(models.Model):
    a_id=models.AutoField(primary_key=True)
    pro_id=models.BigIntegerField(null=False)
    cust_id=models.BigIntegerField(null=False)
    price_drop=models.IntegerField(null=False)
    class Meta:
        db_table="alerts"
