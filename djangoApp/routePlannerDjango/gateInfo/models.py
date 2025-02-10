from django.db import models

# Create your models here.
class Gate(models.Model):
    id = models.CharField(primary_key=True, max_length=3)
    name = models.CharField(max_length=50)
    connections = models.JSONField() 

    class Meta:
        db_table = 'gate' 
    
