# Generated by Django 5.1.6 on 2025-02-09 16:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gateInfo', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='gate',
            name='id',
            field=models.CharField(primary_key=True, serialize=False),
        ),
    ]
