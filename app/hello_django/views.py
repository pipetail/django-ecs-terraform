from django.http import HttpResponse

def index(request):
    return HttpResponse("Hello world. You're now viewing the index on " + request.META['HTTP_HOST'])
