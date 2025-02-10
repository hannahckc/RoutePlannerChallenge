from django.db import models

# Create your models here.
class Gate(models.Model):
    id = models.CharField(primary_key=True)
    name = models.CharField()
    connections = models.JSONField() 

    class Meta:
        db_table = 'gate' 
    
