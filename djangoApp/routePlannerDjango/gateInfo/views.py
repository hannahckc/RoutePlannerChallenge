from django.http import JsonResponse
from .models import Gate

# Create your views here.
from django.http import HttpResponse

def get_gates(request):
    all_gates = Gate.objects.all()
    print(f"Total gates found: {all_gates.count()}")
    print(f"Type: {type(all_gates)}" )   
    gate = Gate.objects.get(id="ARC")


    
    # Convert products to a list of dictionaries (JSON serializable)
    product_data = list(all_gates.values('id', 'name'))
   #mydata = Gate.objects.values_list('connections')
    #print(mydata)


    # Return data as JSON
    return JsonResponse(product_data, safe=False)

