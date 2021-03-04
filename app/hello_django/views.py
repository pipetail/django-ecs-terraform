from django.http import HttpResponse
import os

def index(request):
    return HttpResponse("Hello world. You're now viewing the index on " + request.META['HTTP_HOST'] + " in ENVIRONMENT=" + os.environ['ENVIRONMENT'])
